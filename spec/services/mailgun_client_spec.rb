# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MailgunClient do
  subject { described_class.new(http_client: http_client) }
  let(:email_params) { { subject: 'kind email' } }
  let(:http_client) { double('http_client', post: true) }

  describe '#create' do
    it 'creates a POST request' do
      subject.create(email_params)

      expect(http_client).to have_received(:post).with(
        "/v3/#{ENV['MAILGUN_DOMAIN_NAME']}/messages",
        email_params
      )
    end
  end
end
