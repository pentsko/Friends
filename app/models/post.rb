class Post < ApplicationRecord
	validates :title, presence: true, length: {minimum: 3}
	validates :body, presence: true, length: {minimum: 2}
	validates :author, presence: true, length: {minimum: 2}
end