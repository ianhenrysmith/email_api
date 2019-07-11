# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmailParams do
  let(:email_params) do
    {
      to: 'you@example.com',
      to_name: 'you',
      from: 'me@example.com',
      from_name: 'me',
      subject: 'hiya',
      body: '<p>wave</p>'
    }
  end
  let(:http_client) { double('http_client', post: true) }

  describe '#validate_params!' do
    EmailParams::REQUIRED_PARAMS.each do |param|
      it "requires #{param} param" do
        params = email_params
        params[param] = ''

        expect { described_class.new(params).validate_params! }
          .to raise_error { ArgumentError }
      end
    end

    EmailParams::EMAIL_PARAMS.each do |param|
      it "validates #{param} email address" do
        params = email_params
        params[param] = 'invalid-email'

        expect { described_class.new(params).validate_params! }
          .to raise_error { ArgumentError }
      end
    end

    it 'sanitizes html tags' do
      expect(described_class.new(email_params).validate_params![:body])
        .to eql('wave')
    end

    it 'returns email params' do
      expect(described_class.new(email_params).validate_params!)
        .to eql(
          to: 'you@example.com',
          to_name: 'you',
          from: 'me@example.com',
          from_name: 'me',
          subject: 'hiya',
          body: 'wave'
        )
    end
  end
end
