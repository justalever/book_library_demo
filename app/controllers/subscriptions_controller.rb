class SubscriptionsController < ApplicationController
  layout "subscribe"
  before_action :authenticate_user!, except: [:new, :create]

  def new
  end

  def create
    Stripe.api_key = Rails.application.credentials.stripe_api_key

    params.each do |key,value|
  Rails.logger.warn "Param #{key}: #{value}"
end

    plan_id = params[:plan_id]
    plan = Stripe::Plan.retrieve(plan_id)
    token = params[:stripeToken]

    product = Stripe::Product.retrieve(Rails.application.credentials.book_library)

    customer = if current_user.stripe_id?
                 Stripe::Customer.retrieve(current_user.stripe_id)
               else
                 Stripe::Customer.create(email: current_user.email, source: token)
               end

    subscription = customer.subscriptions.create(plan: plan.id)

    options = {
      stripe_id: customer.id,
      stripe_subscription_id: subscription.id,
      subscribed: true
    }

    options.merge!(
      card_last4: params[:card_last4],
      card_exp_month: params[:card_exp_month],
      card_exp_year: params[:card_exp_year],
      card_type: params[:card_type]
    ) if params[:card_last4]

    current_user.update(options)
    current_user.save
    redirect_to root_path, notice: "🎉 Your subscription was set up successfully!"
  end

  def destroy
    customer = Stripe::Customer.retrieve(current_user.stripe_id)
    customer.subscriptions.retrieve(current_user.stripe_subscription_id).delete
    current_user.update(stripe_subscription_id: nil)

    redirect_to root_path, notice: "Your subscription has been cancelled."
  end


end
