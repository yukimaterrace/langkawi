class SessionHolder
  @@session = {}

  def self.get(token)
    @@session[token]
  end

  def self.put(token, user_id)
    @@session[token] = user_id
  end
end
