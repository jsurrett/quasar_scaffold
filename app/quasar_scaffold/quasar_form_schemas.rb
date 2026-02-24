module QuasarFormSchemas
  def references_select_choices(records:, label_column: :name)
    records.map { |record| { label: record.public_send(label_column), value: record.id } }
  end

  def references_select_schema(label:, records:, label_column: :name, **args)
    select_schema(
      label:,
      options: references_select_choices(records:, label_column:),
      **args
    )
  end

  def enum_select_schema(column_name, label: nil, **args)
    label ||= I18n.t("activerecord.attributes.#{model_name}.#{column_name}")

    select_schema(
      label:,
      options: model.defined_enums[column_name].keys.map { |key|
        { label: I18n.t(:"enums.#{key}"), value: key }
      },
      **args
    )
  end

  def polymorphic_type_schema(column:, label: nil, **args)
    label ||= I18n.t("activerecord.attributes.#{model_name}.#{column.name}")
    types = Object.const_get("#{model}::#{column.name.pluralize.upcase}")

    select_schema(
      label:,
      options: types.map { |type|
        { label: I18n.t("activerecord.models.#{type.underscore}.one"), value: type }
      },
      **args
    )
  end

  def belongs_to_schema(column:, label: nil, label_column: :name, **args)
    label ||= I18n.t("activerecord.attributes.#{model_name}.#{column.name}")
    parent_model_name = column.name.to_s.delete_suffix('_id')
    parent_record = record.public_send(parent_model_name.to_sym)
    lazy_select_schema(
      label:,
      resourceName: parent_model_name.tableize,
      options: belongs_to_options(parent_record:, label_column:),
      labelField: label_column,
      valueField: :id,
      **args
    )
  end

  def belongs_to_polymorphic_schema(column:, label: nil, label_column: :name, **args)
    label ||= I18n.t("activerecord.attributes.#{model_name}.#{column.name}")
    parent_model_name = column.name.to_s.delete_suffix('_id')
    parent_record = record.public_send(parent_model_name.to_sym)

    {
      component: 'PolymorphicSelector',
      label:,
      modelName: parent_record&.name,
      options: belongs_to_options(parent_record:, label_column:),
      labelField: label_column,
      valueField: :id,
      **args,
    }
  end

  def belongs_to_options(parent_record:, label_column:)
    if parent_record
      [{
        label: parent_record&.public_send(label_column),
        value: parent_record&.id,
      }]
    else
      []
    end
  end

  def select_schema(label:, options:, **args)
    {
      component: 'QSelect',
      label:,
      options:,
      'emit-value': true,
      'map-options': true,
      **args,
    }
  end

  def lazy_select_schema(**args)
    {
      component: 'ResourceLazySelect',
      **args,
    }
  end

  def select_multiple_schema(label:, options:, **args)
    select_schema(
      label:,
      options:,
      multiple: true,
      'use-chips': true,
      **args
    )
  end

  def input_schema(label, **args)
    {
      component: 'QInput',
      label:,
      **args,
    }
  end

  def number_input_schema(label, **args)
    {
      component: 'QInput',
      type: :number,
      label:,
      **args,
    }
  end

  def phone_input_schema(label, **args)
    {
      component: 'QInput',
      type: :tel,
      label:,
      **args,
    }
  end

  def email_input_schema(label, **args)
    {
      component: 'QInput',
      type: :email,
      label:,
      **args,
    }
  end

  def text_editor_schema(label, **args)
    {
      component: 'TextEditor',
      label:,
      **args,
    }
  end

  def toggle_schema(label, **args)
    {
      component: 'QToggle',
      label:,
      **args,
    }
  end

  def checkbox_schema(label, **args)
    {
      component: 'QCheckbox',
      label:,
      **args,
    }
  end

  def date_picker_schema(label, **args)
    {
      component: 'DatePicker',
      label:,
      **args,
    }
  end

  def date_time_picker_schema(label, **args)
    {
      component: 'DateTimePicker',
      label:,
      **args,
    }
  end
end
