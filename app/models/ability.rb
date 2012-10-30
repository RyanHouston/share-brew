class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    can :read, Recipe
    can :create, Recipe unless user.new_record?
    can [:update, :destroy], Recipe, user_id: user.id

    # Admins can do all the things
    can :manage, :all if user.admin?
  end
end
