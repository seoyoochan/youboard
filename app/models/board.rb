class Board < ActiveRecord::Base
  include PublicationsHelper
  include VotesHelper


  resourcify
  acts_as_voteable

  belongs_to :user
  belongs_to :report
  has_many :posts, dependent: :destroy

  def self.taglist
    board_topics
    make_list(@board_topics)
  end

  def self.make_list(mylist=nil)
    new_item = nil
    new_array = Array.new
    mylist.each_with_index { |item, index|
      new_item = [item, index]
      new_array.push(new_item)
    }
    new_array
  end

  def self.compare(list1=nil, list2=nil)
    list1.each_with_index { |item, index|
      puts "[#{index}]: #{item}"
    }
    list2.each_with_index { |item, index|
      puts "[#{index}]: #{item}"
    }
  end

  def self.board_topics
    @board_topics = I18n.t("topics.list")
  end

  def board_topics
    @board_topics = I18n.t("topics.list")
  end

  def get_board_topic
    board_topics
    @board_topics[self.topic]
  end

end
