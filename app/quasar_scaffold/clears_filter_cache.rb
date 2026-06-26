module ClearsFilterCache
  extend ActiveSupport::Concern

  included do
    after_commit :clear_quasar_scaffold_filter_cache
  end

  private

  def clear_quasar_scaffold_filter_cache
    table = self.class.table_name
    Rails.cache.delete("quasar_scaffold/filter_count/#{table}")
    Rails.cache.delete("quasar_scaffold/filter_options/#{table}/name")
  end
end
