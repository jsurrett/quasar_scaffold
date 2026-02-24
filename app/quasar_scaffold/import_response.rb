class ImportResponse
  extend Memoist
  include BaseResponse

  attr_reader :params, :current_ability

  def initialize(current_ability)
    @params = params
    @current_ability = current_ability
  end

  private

  def execute
    csv_records.each_with_index do |record, index|
      import_record(record, index)
    end
  rescue StandardError => e
    errors << e.message
  end

  def import_record(csv_record, index)
    id = csv_record[:id]
    if id.present?
      model_record = model.find(id)
      model_record.update!(
        attributes_for_update(csv_record)
      )
    else
      model.create!(attributes_for_create(csv_record))
    end
  rescue StandardError => e
    errors << "#{index}: #{e.message}"
  end

  def attributes_for_create(csv)
    csv.permit(model_columns)
  end

  def attributes_for_update(csv)
    csv.permit(model_columns)
  end

  def csv_records
    params.fetch(:records)
  end

  def success_hash
    {}
  end
end
