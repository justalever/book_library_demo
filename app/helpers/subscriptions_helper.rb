module SubscriptionsHelper

  def subscribed(user)
    user_signed_in? && user.subscribed?
  end
end
