class DatatableOptionsResponse
  extend Memoist
  include BaseResponse

  TIMESTAMP_FIELDS = %i[created_at updated_at].freeze
  NON_DEFAULT_COLUMNS = (%i[id] + TIMESTAMP_FIELDS).freeze
  EXCLUDED_COLUMNS = [].freeze
  LAZY_FILTER_THRESHOLD = 50

  def initialize(ability:, user:)
    @ability = ability
    @user = user
  end

  private

  attr_reader :ability, :user

  def model_columns
    model.column_names.map(&:to_sym) - EXCLUDED_COLUMNS
  end

  def virtual_columns
    []
  end

  def columns
    model_columns + virtual_columns
  end

  def columns_objects
    columns.each_with_object({}) do |column, columns_hash|
      column = column.to_s.delete_suffix('_id').to_sym if belongs_to_column_names.include?(column)

      columns_hash[column] = column_object(column)
    end
  end

  def localized_text(column)
    I18n.t("activerecord.attributes.#{model.name.underscore}.#{column}")
  end

  def column_groups
    {
      all: all_columns_keys,
      default: default_columns_keys,
    }
  end

  def all_columns_keys
    # places the timestamps at the end regardless if other columns are added later
    columns_objects.keys - TIMESTAMP_FIELDS + TIMESTAMP_FIELDS
  end

  def default_columns_keys
    columns_objects.keys - NON_DEFAULT_COLUMNS
  end

  def enum_options
    model.defined_enums.transform_values do |value|
      value.keys.each_with_object({}) do |key, hash|
        hash[key] = I18n.t(:"enums.#{key}")
        hash
      end
    end || {}
  end

  def belongs_to_column_names
    model.reflect_on_all_associations(:belongs_to).map { |column| :"#{column.name}_id" }
  end
  memoize :belongs_to_column_names

  def other_select_options
    {}
  end

  def select_options
    enum_options.merge(other_select_options)
  end

  def belongs_to_filter(association, label_method: :name, lazy: nil)
    filter_name = I18n.t("activerecord.attributes.#{model.name.underscore}.#{association}")
    klass = model.reflect_on_association(association).klass
    use_lazy = lazy.nil? ? exceeds_lazy_threshold?(klass) : lazy

    if use_lazy
      {
        name: filter_name,
        resource: association.to_s.pluralize.camelcase(:lower),
        labelField: label_method.to_s.camelcase(:lower),
        valueField: 'id',
      }
    else
      {
        name: filter_name,
        options: cached_filter_options(klass, label_method),
      }
    end
  end

  def exceeds_lazy_threshold?(klass)
    count = Rails.cache.fetch("quasar_scaffold/filter_count/#{klass.table_name}", expires_in: 1.day) {
      klass.count
    }
    count > self.class::LAZY_FILTER_THRESHOLD
  end

  def cached_filter_options(klass, label_method)
    Rails.cache.fetch("quasar_scaffold/filter_options/#{klass.table_name}/#{label_method}", expires_in: 1.day) {
      klass.all.map { |record| { value: record.id, label: record.send(label_method) } }
    }
  end

  def enum_filter(field)
    {
      name: I18n.t("activerecord.attributes.#{model.name.underscore}.#{field}"),
      options: model.send(field.to_s.pluralize).map { |key, value|
        { value: value, label: I18n.t("enums.#{key}") }
      },
    }
  end

  def enum_filters
    model.defined_enums.keys.each_with_object({}) do |field, hash|
      hash[field.to_sym] = enum_filter(field)
    end
  end

  def belongs_to_filters
    model.reflect_on_all_associations(:belongs_to).each_with_object({}) do |reflection, hash|
      hash[:"#{reflection.name}_id"] = belongs_to_filter(reflection.name)
    end
  end

  def filters
    enum_filters.merge(belongs_to_filters).filter { |_key, value|
      value[:resource].present? || value[:options]&.any?
    }
  end

  def success_hash
    {
      model_name: model.name,
      columns: columns_objects,
      filters:,
      groups: column_groups,
      select_options:,
      boolean_columns:,
      html_columns:,
    }
  end

  def html_columns
    model.columns.select { |column| column.type == :text }.map { |column|
      column.name.camelcase(:lower)
    }
  end

  def boolean_columns
    model.columns.select { |column| column.type == :boolean }.map { |column|
      column.name.camelcase(:lower)
    }
  end

  def column_object(column)
    camelcase_column = column.to_s.camelcase(:lower)
    {
      name: camelcase_column,
      label: localized_text(column),
      field: camelcase_column,
      sortable: non_sortable_columns.exclude?(column),
      align: 'left',
    }
  end

  def non_sortable_columns
    []
  end
end
