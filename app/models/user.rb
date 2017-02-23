require 'users_helper'

class User < ActiveRecord::Base
  belongs_to :referrer, class_name: 'User', foreign_key: 'referrer_id'
  has_many :referrals, class_name: 'User', foreign_key: 'referrer_id'

  validates :email, presence: true, uniqueness: true, format: {
    with: /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/i,
    message: 'Invalid email format.'
  }
  validates :referral_code, uniqueness: true

  before_create :create_referral_code
  after_create :send_welcome_email

  REFERRAL_STEPS = [
    {
      'count' => 5,
      'html' => 'Travel Themed Bottle Opener',
      'class' => 'two',
      'image' =>  ActionController::Base.helpers.asset_path(
        'assets/refer/truman@2x.gif')
    },
    {
      'count' => 10,
      'html' => 'Universal Travel Charger',
      'class' => 'three',
      'image' => ActionController::Base.helpers.asset_path(
        'assets/refer/prize-5.gif')
    },
    {
      'count' => 15,
      'html' => 'Luggage Tag + <br>15 Entries for Miami Travel Award',
      'class' => 'four',
      'image' => ActionController::Base.helpers.asset_path(
        'assets/refer/Luggage Tag - 15 Referrals.jpg')
    },
    {
      'count' => 20,
      'html' => 'Digital Luggage Scale + <br>20 Entries into Miami Travel Award',
      'class' => 'five',
      'image' => ActionController::Base.helpers.asset_path(
        'assets/refer/Digital Luggage Scale - 20 Referrlas.jpg')
    },
    {
      'count' => 35,
      'html' => 'Amenity Kit + <br>1st Class Airline Ticket for Two',
      'class' => 'six',
      'image' => ActionController::Base.helpers.asset_path(
        'assets/refer/Amenity Kit - 35 Referrals.jpg')
    }
  ]

  private

  def create_referral_code
    self.referral_code = UsersHelper.unused_referral_code
  end

  def send_welcome_email
    UserMailer.delay.signup_email(self)
  end
end
