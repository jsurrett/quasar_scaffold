module BelongsToModule
  extend Memoist

  def belongs_to?
    belongs_to['name'].present?
  end

  def parent_record_class
    belongs_to['name'].classify.constantize
  end

  def parent_record
    parent_record_class.find_by(id: belongs_to['id'])
  end

  def belongs_to_key
    params.keys.find { |key| key.match(/._id$/).present? }
  end

  def belongs_to_name
    belongs_to_key&.gsub('_id', '')
  end

  def belongs_to
    return params_belongs_to if use_params_belongs_to?

    {
      'name' => belongs_to_name,
      'id' => params[belongs_to_key] || 0,
    }
  end
  memoize :belongs_to

  def params_belongs_to
    JSON.parse(params[:belongs_to])
  end
  memoize :params_belongs_to

  def use_params_belongs_to?
    params[:belongs_to].present? &&
      params_belongs_to['name'].present?
  end
end
