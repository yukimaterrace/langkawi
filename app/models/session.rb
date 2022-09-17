class Session < ApplicationRecord

  def self.put(uuid, user_id)
    session = Session.find_by(user_id: user_id)
    if session.present? then
      Session.update(session.id, :uuid => uuid, :expiration => expiration)
    else
      Session.create(:uuid => uuid, :user_id => user_id, :expiration => expiration)
    end
  end

  def self.get(uuid)
    session = Session.find_by(uuid: uuid)
    if session.present? && session.expiration.after?(Time.current) then
      session.user_id
    else
      nil
    end
  end

  private

  def self.expiration
    Time.current.since(1.day)
  end
end
