FactoryGirl.define do
  factory :user do
    login "MyString"
    hashed_password "MyString"
    salt "MyString"
  end
end
