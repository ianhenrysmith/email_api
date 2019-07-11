# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Email API', type: :request do
  let(:params) do
    {
      to: 'me@example.com',
      to_name: 'you',
      from: 'also_me@example.com',
      from_name: 'everyone',
      subject: 'hiya',
      body: '<p>wave</p>'
    }
  end

  it 'sends an email' do
    post '/email', params: params

    expect(response).to be_successful
  end
end
