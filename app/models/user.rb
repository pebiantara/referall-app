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
        'refer/cream-tooltip@2x.gif')
    },
    {
      'count' => 10,
      'html' => 'Universal Travel Charger',
      'class' => 'three',
      'image' => ActionController::Base.helpers.asset_path(
        'refer/truman@2x.gif')
    },
    {
      'count' => 15,
      'html' => 'Exclusive Luggage Tag + <br>15 Entries for Miami Travel Award',
      'class' => 'four',
      'image' => ActionController::Base.helpers.asset_path(
        'refer/winston@2x.jpg')
    },
    {
      'count' => 20,
      'html' => 'Digital Luggage Scale + <br>20 Entries into Miami Travel Award',
      'class' => 'five',
      'image' => ActionController::Base.helpers.asset_path(
        'refer/blade-explain@2x.jpg')
    },
    {
      'count' => 35,
      'html' => 'Padded Sleeping Mask + <br>1st Class Airline Ticket for Two',
      'class' => 'six',
      'image' => ActionController::Base.helpers.asset_path(
        'refer/image011.jpg')
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
