class Service < ActiveRecord::Base
  belongs_to :department
  belongs_to :account
  has_many :prescribed_tests
  has_many :prescriptions, :through => :prescribed_tests

  acts_as_tree :order => "name"
end
