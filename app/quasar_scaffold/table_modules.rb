module TableModules
  def table_module_name
    self.class.module_parent
  end

  def model
    table_module_name.to_s.singularize.constantize
  end

  def model_name
    model.to_s.underscore
  end

  def model_columns
    model.column_names.map(&:to_sym) - excluded_columns
  end

  def excluded_columns
    BaseResponse::EXCLUDED_COLUMNS
  end
end
