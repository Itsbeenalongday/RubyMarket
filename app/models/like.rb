class Like < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :likable, polymorphic: true
end
