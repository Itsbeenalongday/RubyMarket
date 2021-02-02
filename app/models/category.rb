class Category < ApplicationRecord
  has_many :items, dependent: :nullify
  
  def self.generate_categories
    %w( 가전/디지털 
        생활/식품
        스포츠/레저
        문구/오피스
    ).each_with_index do |category, position|
      self.create(title: category, position: position)
    end
  end
end
