require "test_helper"

class WorkoutsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      email: "test@example.com",
      password: "password",
      jti: SecureRandom.uuid
    )
    
    @workout = Workout.create!(
      name: "Test Workout",
      body_part: "chest",
      difficulty: "beginner",
      duration: 30,
      equipment_required: "dumbbells",
      instructions: "Test instructions"
    )
    
    # Generate JWT token for authentication
    payload = { sub: @user.id, jti: @user.jti }
    @token = JsonWebToken.encode(payload)
  end

  test "should upload image to workout" do
    # Create a test image file
    image = fixture_file_upload(test_image_path, "image/jpeg")
    
    patch workout_url(@workout), params: { image: image }, headers: auth_headers
    
    assert_response :success
    
    response_body = JSON.parse(response.body)
    assert_equal "Image uploaded successfully", response_body["message"]
    assert response_body["workout"]["image_url"].present?
    
    # Verify the image is actually attached
    @workout.reload
    assert @workout.image.attached?
  end

  test "should return error when no image provided" do
    patch workout_url(@workout), headers: auth_headers
    
    assert_response :bad_request
    response_body = JSON.parse(response.body)
    assert_equal "No image provided", response_body["error"]
  end

  test "should validate image size" do
    # Create a large file (simulate > 5MB)
    large_image = create_large_test_file
    
    patch workout_url(@workout), params: { image: large_image }, headers: auth_headers
    
    assert_response :unprocessable_entity
    response_body = JSON.parse(response.body)
    assert_includes response_body["error"], "is too large"
  end

  private

  def auth_headers
    { "Authorization" => "Bearer #{@token}" }
  end

  def test_image_path
    Rails.root.join("test", "fixtures", "files", "test.jpg")
  end

  def create_large_test_file
    # Create a temporary large file for testing
    file = Tempfile.new(["large_test", ".jpg"])
    
    # Write JPEG header and then fill with data to make it 6MB
    file.write("\xFF\xD8\xFF\xE0") # JPEG header
    file.write("a" * (6.megabytes - 4)) # Fill rest with data
    file.rewind
    
    fixture_file_upload(file.path, "image/jpeg")
  end
end
