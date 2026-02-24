class IndexSerializerFactory
  def self.create_class(module_const, klass_name)
    model_class = module_const.to_s.classify.constantize
    belongs_to_models = model_class.reflect_on_all_associations(:belongs_to).map(&:name)

    c = Class.new(BaseSerializer) do
      attributes(
        *(model_class.column_names.map(&:to_sym) - BaseResponse::EXCLUDED_COLUMNS),
        *belongs_to_models
      )

      belongs_to_models.each do |model|
        define_method model do
          object.public_send(model)&.name
        end
      end
    end

    module_const.const_set(klass_name, c)
  end
end
