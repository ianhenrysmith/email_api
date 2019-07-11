# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmailController, type: :controller do
  let(:mock_mailgun_client) { double('client', create: true) }
  let(:mock_mandrill_client) { double('client', create: true) }

  let(:params) do
    {
      to: 'you@example.com',
      to_name: 'you',
      from: 'me@example.com',
      from_name: 'me',
      subject: 'hiya',
      body: '<p>wave</p>'
    }
  end

  let(:processed_params) do
    raw_params = params
    raw_params[:body] = 'wave'
    raw_params
  end

  before do
    allow_any_instance_of(described_class)
      .to receive(:mailgun_email_client)
      .and_return(mock_mailgun_client)

    allow_any_instance_of(described_class)
      .to receive(:mandrill_email_client)
      .and_return(mock_mandrill_client)
  end

  describe 'POST create' do
    it 'sends an email via the mailgun email client' do
      post :create, params: params

      expect(mock_mailgun_client)
        .to have_received(:create)
        .with(processed_params)
    end

    context 'switching email providers' do
      before do
        ENV['EMAIL_PROVIDER'] = 'mandrill'
      end

      after do
        ENV['EMAIL_PROVIDER'] = 'mailgun'
      end

      it 'sends an email via the mandrill email client' do
        post :create, params: params

        expect(mock_mandrill_client)
          .to have_received(:create)
          .with(processed_params)
      end
    end

    it 'returns created status' do
      post :create, params: params

      expect(response.status).to eql(204)
    end

    it 'returns error messages' do
      params[:to] = 'borf'
      post :create, params: params

      expect(response.status).to eql(400)

      body = JSON.parse(response.body)

      expect(body['error']).to eql('invalid email: borf')
    end
  end
end
