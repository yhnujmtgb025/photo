class UserMailerPreview < ActionMailer::Preview
    def welcome_email
        # Set up a temporary order for the preview
        user = User.new(first_name: "Toan")
    
        UserMailer.with(user: user).welcome_email
      end
end