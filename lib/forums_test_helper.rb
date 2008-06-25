module ForumsTestHelper

  def valid_forum_attributes
    forums(:one).attributes
  end
  
  def valid_forum_topic_attributes
    forum_topics(:one).attributes
  end
  
  def valid_forum_post_attributes
    forum_posts(:one).attributes
  end

end