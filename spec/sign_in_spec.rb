require 'pry'


describe("Sign in page", :js => true) do

  it("greets the user") do
    visit("/home")
    # binding.pry
    expect(page).to have_content("Welcome to Critique-It!")
  end

  context 'on /' do
    before(:each) do
      visit('/')
    end

    it("asks the user to sign in") do
        expect(page).to have_content("Please sign in.")
    end

    it("requests the users email and password") do
      fill_in "user_email", with: "freejacque@gmail.com"
      fill_in "user_password", with: "password"
      click_on 'submit'
      expect(page).to have_content("Welcome to Critique-It!")
    end

    it("has a link to sign up for an account") do
      expect(page).to have_content("If you don’t have an account")
      click_on 'sign up'
      expect(page).to have_content("profile pic url")
    end

    it("allows the user to sign in using a google account") do
      expect(page).to have_content("sign in using your google account")
    end

    it("allows the user to sign in using a google account") do
      click_on 'google account'
      fill_in "Email", with: "jwillchem@gmail.com"
      fill_in "Passwd", with: "@Oulu1213"
      click_on 'signIn'
      click_on 'submit_approve_access'
      # other code
      expect(page).to have_content("Welcome to Critique-It!")
    end
  end #context

end #describe
