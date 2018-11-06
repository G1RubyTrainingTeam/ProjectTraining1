class Ability
  include CanCan::Ability

  def initialize(user, controller_namespace)
    user ||= User.new
    case controller_namespace
      when "Admin"
        if user.admin?
          can :manage, :all
          cannot :destroy, User do |user|
            user.admin?
          end
        end
      else
        can :read, :all
        can :update, User, id: user.id
        can [:update, :destroy], [Comment, Rating], user_id: user.id
        if user.lecture
          can :manage, [Course, Lesson]
        end
    end
  end
end
