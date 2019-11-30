class String
  def remove_color
    self.gsub(/\e\[([;\d]+)?m/, '')
  end
end
