class Array
  def find_by(key, val)
    self.where(key, val).first
  end

  def where(key, val = nil, &block)
    self.select do |element|
      key_eval = element.send(key)

      block_given? ? block.call(key_eval) : (key_eval == val)
    end
  end
end
