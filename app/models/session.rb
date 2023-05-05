# frozen_string_literal: true

class Session < ApplicationRecord
  def self.put(uuid, user_id)
    session = Session.find_by(user_id:)
    if session.present?
      Session.update(session.id, uuid:, expiration:)
    else
      Session.create(uuid:, user_id:, expiration:)
    end
  end

  def self.get(uuid)
    session = Session.find_by(uuid:)
    return unless session.present? && session.expiration.after?(Time.current)

    session.user_id
  end

  def self.expiration
    Time.current.since(1.day)
  end
end
