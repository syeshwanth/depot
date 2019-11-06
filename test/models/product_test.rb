require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test "product attributes not empty" do
    p = Product.new
    assert p.invalid?
    assert p.errors[:title].any?
    assert p.errors[:description].any?
    assert p.errors[:image_url].any?
    assert p.errors[:price].any?
  end

  test "product price is valid" do
    p = Product.new(
      title: 'New Product',
      description: 'Something',
      image_url: 'blah.png'
    )
    p.price = -1
    assert p.invalid?
    p.price = 0
    assert p.invalid?
    p.price = 0.0001
    assert p.invalid?
    p.price = 0.02
    assert p.valid?
  end

  test "image url is valid" do
    p = Product.new(
      title: 'New Product',
      description: 'Something',
      image_url: 'blah.png',
      price: 1
    )
    valid_urls = %w{ a.gif b.png c.jpg }
    valid_urls.each do |url|
      p.image_url = url
      assert p.valid?
    end
    invalid_urls = %w{ x.docx y.xlsx z.rb }
    invalid_urls.each do |url|
      p.image_url = url
      assert p.invalid?
    end
  end

  test "unique product titles" do
    p = Product.new(
      title: products(:ruby).title,
      description: 'blahblah',
      image_url: 'something.jpg',
      price: 12
    )

    assert p.invalid?
    assert_equal ['has already been taken'], p.errors[:title]
  end
end
