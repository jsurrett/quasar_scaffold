class DatatableOptionsResponse
  extend Memoist
  include BaseResponse

  TIMESTAMP_FIELDS = %i[created_at updated_at].freeze
  NON_DEFAULT_COLUMNS = (%i[id] + TIMESTAMP_FIELDS).freeze
  EXCLUDED_COLUMNS = [].freeze

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

  def filters
    {}
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
