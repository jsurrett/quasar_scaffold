class BaseSerializer < Panko::Serializer
  extend Memoist

  private

  def format_date(date)
    date&.strftime('%FT%T')
  end

  def local_hours_minutes(time)
    return if time.blank?

    time.localtime.strftime('%H:%M')
  end
end
