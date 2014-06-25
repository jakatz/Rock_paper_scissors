module RPS::UserSignIn
  def run(input)
    user = RPS.orm.get_user(input[:username])

    if user.nil?
      return {:success? => false, :error => "User doesn't exist by that username"}
    end

    check_password = user.authenticate(input[:password])
    if !check_password
      return { :success? => false, :error => "User's password doesn't match the password in the database"}
    end

    {:success? => true, :user => user}
  end
end
    # 1. get user instance from orm
    # 2. check if password being used matches
    # 3. return user object if password matches

    # send back hash that includes
    #   :success?
    #   :error (only present if not successful), includes
    #     string with error
