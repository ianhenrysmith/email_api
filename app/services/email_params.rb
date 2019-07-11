# frozen_string_literal: true

# class for taking in and validating/processing controller params
class EmailParams
  REQUIRED_PARAMS = %i[to to_name from from_name subject body].freeze
  EMAIL_PARAMS = %i[to from].freeze
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

  def initialize(params)
    self.params = params
  end

  def validate_params!
    validate_required_params!
    validate_emails!

    processed_params
  end

  private

  attr_accessor :params

  def validate_required_params!
    REQUIRED_PARAMS.each do |required_param|
      next if params[required_param].present?

      raise ArgumentError, "param missing: #{required_param}"
    end
  end

  def validate_emails!
    EMAIL_PARAMS.each do |email_param|
      email = params[email_param]
      next if email.match?(EMAIL_REGEX)

      raise ArgumentError, "invalid email: #{email}"
    end
  end

  def processed_params
    {
      to: params[:to],
      to_name: params[:to_name],
      from: params[:from],
      from_name: params[:from_name],
      subject: params[:subject],
      body: processed_body
    }
  end

  def processed_body
    Nokogiri::HTML(params[:body]).text
  end
end
