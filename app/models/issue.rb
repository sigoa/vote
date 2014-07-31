class Issue < ActiveRecord::Base
  has_paper_trail

  enum position: [:for, :against]

  belongs_to :author, class_name: 'User'
  has_many :theses

  validates :author, presence: true
  validates :title, presence: true

  acts_as_votable
  acts_as_ordered_taggable
end
