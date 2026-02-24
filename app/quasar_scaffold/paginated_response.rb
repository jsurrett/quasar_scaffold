# frozen_string_literal: true

require 'pagy/extras/array'

class PaginatedResponse
  include Pagy::Backend
  extend Memoist

  PagyObject = Struct.new(:count)

  attr_reader(
    :collection,
    :extra_params,
    :belongs_to,
    :serializer,
    :fields,
    :pagination
  )

  def initialize(collection:, serializer:, belongs_to: {}, fields: nil, pagination: {})
    @serializer = serializer
    @fields = fields
    @belongs_to = belongs_to
    @pagination = pagination
    @collection = collection
  end

  def response
    if list_all_items?
      pagy = PagyObject.new(items_count)
      records = collection
    elsif collection.is_a?(Array)
      pagy, records = pagy_array(
        collection,
        page: pagination.fetch(:page, 1),
        items: items_per_page
      )
    else
      pagy, records = pagy(
        collection,
        page: pagination.fetch(:page, 1),
        items: items_per_page
      )
    end
    Oj.dump(
      'belongs_to' => belongs_to,
      'pagination' => pagination.merge(rows_number: pagy.count).transform_keys(&:to_s),
      'records' => records_hash(records)
    )
  end

  private

  def records_hash(records)
    records.each_with_object({}) do |record, hash|
      hash["id#{record.id}"] = serializer_instance.serialize(record)
    end
  end

  def serializer_instance
    fields.present? ? serializer.new(only: fields.map(&:to_sym)) : serializer.new
  end

  def items_count
    collection.count
  end

  def items_per_page
    list_all_items? ? items_count : options_items_per_page
  end

  def options_items_per_page
    pagination.fetch(:rows_per_page)
  end

  def list_all_items?
    options_items_per_page.zero?
  end
end
