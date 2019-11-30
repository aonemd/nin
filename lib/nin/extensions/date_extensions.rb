class Date
  def self.parse_or_return(unparsed_date)
    return unparsed_date unless unparsed_date.is_a?(String)

    Date.parse(unparsed_date)
  end

  def humanize
    case self
    when Date.today.prev_day
      'yesterday'
    when Date.today
      'today'
    when Date.today.succ
      'tomorrow'
    else
      self.to_s
    end
  end
end
