module ForumsTestHelper

  def valid_forum_attributes
    forums(:one).attributes
  end

  def unvalid_forum_attributes
    {:name=>''}
  end

  def unvalid_forum_topic_attributes
    {:title=>''}
  end

  def unvalid_forum_post_attributes
    {:body=>''}
  end

  def valid_forum_topic_attributes
    forum_topics(:one).attributes
  end

  def valid_forum_post_attributes
    d = forum_posts(:one).attributes.clone
    d.delete 'owner_id'
    d.delete 'topic_id'
    d
  end

end