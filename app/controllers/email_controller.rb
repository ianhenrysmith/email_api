# frozen_string_literal: true

# controller for sending email via configured provider
class EmailController < ApplicationController
  def create
    email_client.create(email_params)
  rescue ArgumentError => e
    render json: {
      error: e.message.to_s
    }, status: :bad_request
  end

  private

  def email_params
    @email_params ||= EmailParams.new(
      params.permit(:to, :to_name, :from, :from_name, :subject, :body)
    ).validate_params!
  end

  def email_client
    send(:"#{ENV['EMAIL_PROVIDER']}_email_client")
  end

  def mailgun_email_client
    @mailgun_email_client ||= MailgunClient.new
  end

  def mandrill_email_client
    # will implement later
  end
end
