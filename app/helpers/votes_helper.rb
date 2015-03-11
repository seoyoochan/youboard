module VotesHelper
  def votes_count
    Vote.where(voteable_id: self.id, voteable_type: self.class.name).size
  end
end