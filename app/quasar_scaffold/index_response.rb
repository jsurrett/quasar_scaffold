class IndexResponse
  extend Memoist
  include BaseResponse
  include BelongsToModule

  attr_reader(
    :params,
    :current_ability,
    :pagination,
    :selected_ids,
    :search_filter
  )

  PAGINATION_OPTIONS = {
    sort_by: nil,
    descending: false,
    page: 1,
    rows_per_page: 20,
    rows_number: nil,
  }.freeze

  def initialize(params, current_ability = {})
    @params = params
    @current_ability = current_ability
    @pagination = PAGINATION_OPTIONS.merge(
      JSON.parse(params[:pagination] || '{}').transform_keys(&:to_sym)
    )
    @selected_ids = params[:selected_ids]&.split(',')
    @search_filter = params.fetch(:search, '')
  end

  def ordered_records
    return filtered_records if pagination[:sort_by].blank?

    sort_by_method || filtered_records.unscope(:order).order(order_options)
  end
  memoize :ordered_records

  def filtered_records
    FilteredRecords.new(
      collection:,
      filters: params[:selected_filters],
      search_attributes: searchable_attributes,
      search_filter:
    ).get
  end
  memoize :filtered_records

  private

  def searchable_attributes
    model::SEARCHABLE_ATTRIBUTES.presence || model.column_names
  end

  def collection
    collection_records = selected_ids.present? ? records.where(id: selected_ids) : records
    collection_records.accessible_by(current_ability).index_response_joins
  end

  def records
    if belongs_to?
      parent_record&.public_send(table_module_name.to_s.tableize) || model.none
    else
      model.all
    end
  end

  def sort_key
    @sort_key ||= pagination[:sort_by].underscore.gsub(/([a-z])(\d)/, '\1_\2').to_sym
  end

  '5,214'.gsub(/(\d+)(,)(\d+)/, '\1.\3')

  def sort_by_method
    return unless model::SORT_FIELDS_BY_METHOD.key?(sort_key)

    sorted_array = filtered_records.sort_by do |record|
      record.public_send(sort_key) || blank_values_for(model::SORT_FIELDS_BY_METHOD[sort_key])
    end

    pagination[:descending] ? sorted_array.reverse : sorted_array
  end

  def blank_values_for(type)
    case type
    when :number
      0
    when :string
      ''
    when :boolean
      false
    when :date
      Date.new(0)
    when :datetime
      DateTime.new(0)
    when :time
      Time.zone.local(0)
    end
  end

  def order_options
    keys = model::SORT_FIELD_MAP.include?(sort_key) ? model::SORT_FIELD_MAP[sort_key] : [sort_key]

    keys.index_with do |_sub_key|
      pagination[:descending] ? :desc : :asc
    end
  end

  def success_hash
    PaginatedResponse.new(
      collection: ordered_records,
      serializer:,
      fields: params[:fields],
      belongs_to:,
      pagination:
    ).response
  end

  def serializer
    self.class.module_parent::IndexSerializer
  end
end
