# frozen_string_literal: true

# maps email lifecycle to mailgun API
class MailgunClient
  def initialize(http_client: init_faraday_client)
    self.http_client = http_client
  end

  def create(email_params)
    http_client.post(email_create_path, email_params)
  end

  private

  attr_accessor :http_client

  def email_create_path
    "/v3/#{ENV['MAILGUN_DOMAIN_NAME']}/messages"
  end

  def init_faraday_client
    Faraday.new(url: ENV['MAILGUN_API_BASE_URL']) do |conn|
      conn.basic_auth('api', ENV['MAILGUN_API_KEY'])
    end
  end
end
