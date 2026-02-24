class FilteredRecords
  extend Memoist
  include ActiveRecord::Sanitization::ClassMethods

  attr_reader :collection, :filters, :search_attributes, :search_filter

  def initialize(collection:, search_attributes:, search_filter:, filters: nil)
    @collection = collection
    @filters = filters && JSON.parse(filters)
    @search_attributes = search_attributes
    @search_filter = (search_filter || '').squish
  end

  def get
    searched_collection = collection
    searched_collection = searched_collection.where(filters_with_content) if filters_with_content.present?
    searched_collection = searched_collection.where([like_query, { like_term: }]) if search_filter.present?

    searched_collection
  end

  private

  def filters_with_content
    return if filters.blank?

    filters.compact_blank
  end
  memoize :filters_with_content

  def like_term
    "%#{sanitize_sql_like(search_filter)}%"
  end

  def like_query
    search_attributes.map { |attribute|
      "#{attribute} LIKE :like_term"
    }.join(' OR ')
  end
end
