class Array
  def sorted_by?
    each_cons(2).all? { |a, b| ((yield a) <=> (yield b)) <= 0 }
  end

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
