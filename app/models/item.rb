class Item < ApplicationRecord
  mount_uploader :image, ImageUploader # 이미지 첨부를 위해 이 부분 추가

  paginates_per 8 # pagenation

  belongs_to :user, optional: true # 회원 탈퇴해도 상품 남기기
  belongs_to :category, optional: true # 카테고리 없어져도 상품은 남기기

  has_many :line_items, dependent: :nullify # 상품 삭제되도 주문목록에는 남겨야함
  has_many :comments, dependent: :destroy # 상품 삭제되면 더이상 댓글 필요 없음

  def self.generate_items
    image_path = '/public/image/'
    image_files = ['image1.jpg','image2.jpg','image3.jpg','image4.jpg','image5.jpg']
    15.times.each do |i|
      image = File.open(("#{Rails.root}" + image_path + image_files.shuffle.first))
      self.create(title: "#{i}번째 상품", 
        description: "#{i}번째 상품의 spec은 이렇고 저렇고 ...",
        price: rand(1...1000000),
        image: image,
        category_id: Category.ids.shuffle.first,
        user_id: User.ids.shuffle.first
      )
    end
  end
end
