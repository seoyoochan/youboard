class Report < ActiveRecord::Base
  resourcify
  belongs_to :reportable, polymorphic: true
end
