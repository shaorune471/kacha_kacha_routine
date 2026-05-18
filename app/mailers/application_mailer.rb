class ApplicationMailer < ActionMailer::Base
  default from: ENV["CONTACT_MAIL_ADDRESS"]
  layout "mailer"
end
