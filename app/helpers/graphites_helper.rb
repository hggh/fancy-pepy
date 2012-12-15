module GraphitesHelper
  def tag_graphites_path(tag)
    graphites_path + "/tag/" + tag
  end
end
