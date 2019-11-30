class Integer
  def length
    Math.log10(self).to_i + 1
  end
end
