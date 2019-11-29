class Array
  def sorted_by?
    each_cons(2).all? { |a, b| ((yield a) <=> (yield b)) <= 0 }
  end

  def limit(offset)
    offset > 0 ? self.last(offset) : self.first(offset.abs)
  end

  def round_shift(element, step)
    new_element = [self.min, (element - step), self.max].median
    actual_step = element - new_element

    [new_element, actual_step]
  end

  def median
    return nil if self.empty?

    sorted = self.sort
    len = self.length

    (sorted[(len - 1) / 2] + sorted[len / 2]) / 2
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
