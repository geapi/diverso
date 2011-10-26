module ObjectCreationMethods

  def counter
    @counter ||= 0
    @counter += 1
    @counter
  end

  def apply(record, options)
    options.each do |key, value|
      record.send("#{key}=", value.is_a?(Proc) ? value.call : value)
    end
  end

  def new_product(options = {})
    Product.new do |product|
      product.name = "product-#{counter}"
      product.id = counter
      apply(product, options)
    end
  end

  def create_product(options = {})
    new_product(options).tap(&:save!)
  end
end