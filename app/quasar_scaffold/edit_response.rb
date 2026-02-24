class EditResponse
  extend Memoist
  include BaseResponse
  include BelongsToModule
  include QuasarFormSchemas

  attr_reader :params, :current_ability, :id

  def initialize(params, current_ability = {})
    @params = params
    @id = params.fetch(:id)
    @current_ability = current_ability
  end

  private

  def success_hash
    {
      model: serializer.new.serialize(record),
      schemas: final_schemas,
    }
  end

  def child_record
    attributes = { "#{belongs_to['name'].singularize}_id" => belongs_to['id'] }

    if id == 'null'
      model.new(attributes)
    else
      model
        .accessible_by(current_ability)
        .where(attributes)
        .find(id)
    end
  end

  def main_record
    if id == 'null'
      model.new
    else
      model.accessible_by(current_ability).find(id)
    end
  end

  def record
    if belongs_to? && parent_record_class != model
      child_record
    else
      main_record
    end
  end

  def serializer
    self.class.module_parent::IndexSerializer
  end

  def schema
    SchemaBuilder.new(model:, record:, current_ability:).schema
  end

  def schemas
    [{ label: 'Default', skipTitle: true, schema:, columnCount: column_count }]
  end

  def column_count
    1
  end

  def schema_with_ids(schema_section)
    schema_section.each_with_object({}) do |(key, value), hash|
      hash[key] = include_id_key(key:, value:)
      hash
    end
  end

  def include_id_key(key:, value:)
    if value.key?(:id)
      value
    else
      value.merge(id: key.to_s.camelcase(:lower))
    end
  end

  def final_schemas
    schemas.map { |schema_section|
      schema_section.merge(schema: schema_with_ids(schema_section[:schema]))
    }
  end
end
