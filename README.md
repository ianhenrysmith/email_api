## README
This is a Rails API App that sends emails

![ralph wiggum sending mail](https://i.giphy.com/media/iz30qSwSKKCnC/giphy.gif)

## Setup
#### System dependencies
* You should have Ruby `2.6.2` installed. If your Ruby version management tool supports `.ruby-version`, you may have been prompted to install this version on your system. I use [RVM](https://rvm.io/).
* [Rubygems](https://rubygems.org/pages/download)
* [Bundler](https://bundler.io/)
* You will need to be able to set environment variables from `.env` and `.env.local` files so that you can send emails. I use [Direnv](https://direnv.net/). The environment variables you will need to set are: `EMAIL_PROVIDER`, `MAILGUN_API_BASE_URL`, `MAILGUN_API_KEY` and `MAILGUN_DOMAIN_NAME`.

#### Configuration
Run the following commands in your terminal to run the app:
1. `bundle install`
1. `rake db:setup`
1. `rake db:migrate`
1. `bin/rails server`

#### Testing
This app has a behavioral RSpec test suite
* To run the RSpec test suite, run `rake rspec` from this directory within your terminal.
* During development, you can run `guard` to run the RSpec test suite whenever you change a file.

## APIs
The app has the following APIs:

`/email`
  * send an email via `POST` with the following params: `to`, `to_name`, `from`, `from_name`, `subject`, `body`

## Reflection

I think I was able to satisfy the requirements of the project: make an API that processes email params and sends them via its configured email provider.

Things I would spend more time on:
* I have some hacks in my specs that are counter to `RSpec` conventions, like doing `params[param] = 'invalid-email'` instead of using more context blocks.
* Would be nice to make a mandrill API client.
* I'm not 100% sure that I was actually able to make sending emails work correctly via Mailgun. Would like more time to debug that.
* I'd like to add HTTP fixtures (probably with the `vcr` gem) so that I can mock out interactions with Mailgun/Mandrill for tests.
* This app depends on setting up a database, which totally isn't necessary. It doesn't persist anything. Would like to remove that dependency.
* It'd be neat for the app to be able to detect email provider outages on its own and switch over accordingly. Maybe could also have an API for doing that.
