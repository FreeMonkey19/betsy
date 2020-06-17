class Product < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :reviews
  has_and_belongs_to_many :categories


  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }

  def average_rating 
    length = self.reviews.length

    return 0 if length == 0 
      
    total_rating = self.reviews.sum { |review| review.rating }
    
    return (total_rating / length).round(1)
  end

  def self.spotlight(products)
    if !products.empty?
      return products.last
    end
  end

  def self.top_rated(products)
    if !products.empty?
      top_rated = products.sort_by { |product| product.average_rating}.reverse
      return top_rated[0..5]
    end
  end

  after_initialize :set_defaults
  
  def set_defaults
    self.product_status ||= "active"
  end
  
end
