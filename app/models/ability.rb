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
        unless user.admin?
          can :read, :all
          can [:update, :update_wallet], User, id: user.id
          can [:update, :destroy], [Comment, Rating], user_id: user.id
          can :newcomment, Course
          can :manage, CartItem
          can :create, Order
          can [:following, :followers], User
          if user.lecture?
            can :manage, [Course, Lesson]
          end
          can [:new, :create,:update], Credit
          can [:new, :create,:update], Transaction
          can [:new, :create,:update], Paying
          can [:new, :create], EWallet
        end
    end
  end
end
