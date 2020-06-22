class ProjectMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.project_mailer.user_added_to_project.subject
  #
  def user_added_to_project
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
