class UserSerializer 
  def self.creation(user)
    {
      data: {
        type: "users",
        id: "#{user.id}",
        attributes: {
          email: "#{user.email}",
          api_key: "#{user.api_key}"
        }
      }
    }
  end
end