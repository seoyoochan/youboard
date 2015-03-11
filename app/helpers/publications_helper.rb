module PublicationsHelper

  def do_publication
    publications_list
    @publication_list = make_list(@publication)
  end

  def make_list(mylist=nil)
    new_item = nil
    new_array = Array.new
    mylist.each_with_index { |item, index|
      new_item = [item, index]
      new_array.push(new_item)
    }
    new_array
  end

  def compare(list1=nil, list2=nil)
    list1.each_with_index { |item, index|
      puts "[#{index}]: #{item}"
    }
    list2.each_with_index { |item, index|
      puts "[#{index}]: #{item}"
    }
  end

  def get_publication
    publications_list
    @publication[self.publication]
  end

  def publications_list
    @publication = I18n.t("publications.list")
  end

end