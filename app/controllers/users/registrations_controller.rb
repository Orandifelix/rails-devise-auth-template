class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionFix
  respond_to :json

    def create
    # Generate a unique JTI (JSON Web Token Identifier) for the user
    jti = SecureRandom.uuid

    # Create a new user with the generated jti value
    @user = User.new(user_params.merge(jti: jti))

    if @user.save
      # Handle successful user creation
      # ...
    else
      # Handle errors in user creation
      # ...
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password)
  end

  def respond_with(resource, _opts = {})
    if request.method == "POST" && resource.persisted?
      render json: {
        status: {code: 200, message: "Signed up sucessfully."},
        data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
      }, status: :ok
    elsif request.method == "DELETE"
      render json: {
        status: { code: 200, message: "Account deleted successfully."}
      }, status: :ok
    else
      render json: {
        status: {code: 422, message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"}
      }, status: :unprocessable_entity
    end
  end
end