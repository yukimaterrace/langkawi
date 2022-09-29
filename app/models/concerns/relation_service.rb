module RelationService

  def relation_response(relation)
    position_status = position_status(relation)
    {
      user: counter_user(relation),
      position_status: position_status,
      next_statuses: permitted_transition_statuses(position_status)
    }.merge(relation.extract_id_date)
  end

  def position_status(relation)
    if relation.user_from_id == @user.id then
      "#{relation.status}_me"
    else
      "#{relation.status}_you"
    end
  end

  def permitted_transition_statuses(position_status)
    case position_status.to_sym
    when :pending_me then
      [:withdraw]
    when :pending_you then
      [:accepted, :declined]
    when :withdraw_me then
      [:pending]
    when :accepted_me then
      [:disconnected]
    when :accepted_you then
      [:refused]
    else
      []
    end
  end

  private

  def counter_user(relation)
    if relation.user_from_id == @user.id then
      relation.user_to
    else
      relation.user_from
    end
  end

  def position_statuses
    statues_with("me").zip(statues_with "you").flatten
  end

  def statues_with(suffix)
    Relation.statuses.map(&:first).map { |s| "#{s}_#{suffix}"}
  end
end
