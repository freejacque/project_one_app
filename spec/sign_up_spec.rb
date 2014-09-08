require 'pry'

xdescribe("Sign up page", :js => true) do

 # context 'on /sign_up' do
 #    before(:each) do
 #      visit('/sign_up')
 #    end

    it("allows a user to sign up for an account") do
      visit('/sign_up')
      fill_in "user_id", with: "test_user"
      fill_in "user_email", with: "test_user@email.com"
      fill_in "user_password", with: "password2"
      fill_in "profile_pic_url", with: "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcS8PMu35VVtQppvEXCmQm2L814fOyquAaLfUgJKQcPIIbfjOMB4"
      # binding.pry
      click_on 'submit'
      expect(page).to have_content("Your user id is: test_user and your password is: password2. Please sign in.")
    end

    xit("pushes user information into redis") do
      user = $redis.get("users:#{0}")
      @users = JSON.parse(user)
      expect(@user_1[:user_id]).to eq("test_user")
    end
  # end
end #describe
