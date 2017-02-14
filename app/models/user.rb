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
      'html' => 'Travel Gift <br>Group C',
      'class' => 'two',
      'image' =>  ActionController::Base.helpers.asset_path(
        'refer/cream-tooltip@2x.gif')
    },
    {
      'count' => 10,
      'html' => 'Travel Gift <br>Group B',
      'class' => 'three',
      'image' => ActionController::Base.helpers.asset_path(
        'refer/truman@2x.gif')
    },
    {
      'count' => 15,
      'html' => 'Travel Gift A + <br> 15 Entries into the Miami Vacation',
      'class' => 'four',
      'image' => ActionController::Base.helpers.asset_path(
        'refer/winston@2x.jpg')
    },
    {
      'count' => 20,
      'html' => 'Luggage Scale + <br>20 entries into Miami vacation',
      'class' => 'five',
      'image' => ActionController::Base.helpers.asset_path(
        'refer/blade-explain@2x.jpg')
    },
    {
      'count' => 35,
      'html' => '1-year free membership +<br> 1st Class airline tickets + Sleeping Mask',
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
