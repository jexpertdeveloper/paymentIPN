class PaymentController < ApplicationController
	include PayPal::SDK::AdaptivePayments
	def index
		@api = PayPal::SDK::AdaptivePayments.new

		@pay = @api.build_pay({
			:actionType => "PAY",
			:cancelUrl => payment_pay_url,
			:currencyCode => "USD",
			:feesPayer => "SENDER",
			:ipnNotificationUrl => payment_ipn_notify_url, #request.base_url + "/payment_notifications",
			:receiverList => {
			:receiver => [{
			  :amount => 1.0,
			  :email => "bruno19850511-facilitator@yahoo.com" }] },
			:returnUrl => payment_pay_url })

		@response = @api.pay(@pay)
		if @response.success? && @response.payment_exec_status != "ERROR"
			@response.payKey
			@ok = 'ok'
			# redirect_to ("https://www.sandbox.paypal.com/webscr?cmd=_ap-payment&paykey=#{@response.payKey}")
			redirect_to @api.payment_url(@response)  # Url to complete payment
		else
			@response.error[0].message
			@ok = "error"
		end
	end


	def pay
		puts "oK"
	end

	def ipn_notify
		# debugger
      if PayPal::SDK::Core::API::IPN.valid?(request.raw_post)
        # logger.info("IPN message: VERIFIED")
        render :text => "VERIFIED"
      else
        # logger.info("IPN message: INVALID")
        render :text => "INVALID"
      end

      redirect_to welcome_index_url
    end

end
