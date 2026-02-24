class SchemaBuilder
  include QuasarFormSchemas
  extend Memoist

  EXCLUDED_COLUMNS = %i[created_at updated_at id].freeze

  def initialize(model:, record:, current_ability:, column_names: nil)
    @model = model
    @column_names = column_names || (special_columns + normal_columns - EXCLUDED_COLUMNS.map(&:to_s))
    @model_name = model.to_s.underscore
    @record = record
    @current_ability = current_ability
  end

  def schema
    column_names.index_with do |column_name|
      column_schema(columns_hash[column_name])
    end
  end

  private

  attr_reader :model, :model_name, :column_names, :record, :current_ability

  delegate :columns_hash, to: :model

  def normal_columns
    model.columns.map(&:name) - special_columns
  end
  memoize :normal_columns

  def special_columns
    belongs_to_column_names +
      polymorphic_column_names +
      enums_column_names
  end

  def enums_column_names
    model.defined_enums.keys
  end
  memoize :enums_column_names

  def belongs_to_column_names
    model
      .reflect_on_all_associations(:belongs_to)
      .reject { |column| column.options[:polymorphic] }
      .map { |column| "#{column.name}_id" }
  end
  memoize :belongs_to_column_names

  def polymorphic_relations
    model
      .reflect_on_all_associations(:belongs_to)
      .select { |column| column.options[:polymorphic] }
  end
  memoize :polymorphic_relations

  def polymorphic_column_names
    polymorphic_relations.each_with_object([]) do |column, array|
      array << "#{column.name}_type"
      array << "#{column.name}_id"

      array
    end
  end
  memoize :polymorphic_column_names

  def polymorphic_id_column_names
    polymorphic_relations.map { |column| "#{column.name}_id" }
  end
  memoize :polymorphic_id_column_names

  def polymorphic_type_column_names
    polymorphic_relations.map { |column| "#{column.name}_type" }
  end
  memoize :polymorphic_type_column_names

  def column_schema(column)
    return special_column_schema(column) if special_columns.include?(column.name)

    label = I18n.t("activerecord.attributes.#{model_name}.#{column.name}")

    case column.type
    when :integer, :decimal
      number_input_schema(label)
    when :boolean
      checkbox_schema(label)
    when :date
      date_picker_schema(label)
    when :datetime
      date_time_picker_schema(label)
    when :text
      text_editor_schema(label)
    else # when string or something else
      input_schema(label)
    end
  end

  def special_column_schema(column)
    if enums_column_names.include?(column.name)
      enum_select_schema(column.name, label: I18n.t("activerecord.attributes.#{model_name}.#{column.name}"))
    elsif polymorphic_type_column_names.include?(column.name)
      polymorphic_type_schema(column:, label: I18n.t("activerecord.attributes.#{model_name}.#{column.name}"))
    elsif polymorphic_id_column_names.include?(column.name)
      belongs_to_polymorphic_schema(
        column:,
        label: I18n.t("activerecord.attributes.#{model_name}.#{column.name.delete_suffix('_id')}")
      )
    else # belongs_to_column_names.include?(column.name)
      belongs_to_schema(
        column:,
        label: I18n.t("activerecord.attributes.#{model_name}.#{column.name.delete_suffix('_id')}")
      )
    end
  end
end
