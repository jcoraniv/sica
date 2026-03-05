class MeetingPolicy < Struct.new(:user, :meeting)
  def notify?
    user&.admin?
  end
end
