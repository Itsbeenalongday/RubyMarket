class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :comments, dependent: :nullify # 회원탈퇴 하더라도 댓글 남기기
  has_many :orders, dependent: :nullify # 회원탈퇴 하더라도 주문 남기기 
  has_many :items, dependent: :nullify # 회원탈퇴 하더라도 상품 남기기

  def self.generate_users
    User.destroy_all
    emails = ['dbtjdals1771@ajou.ac.kr', 'tjdals1771@gmail.com', 'codingmachine1771@gmail.com']
    3.times.each do |i|
      self.create(email: emails[i], password: '123456', name: ['김','최','유'][i]+'성민')
    end
  end
end
