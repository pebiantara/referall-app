require 'users_helper'
require 'mailchimp'


class User < ActiveRecord::Base
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :registerable

  belongs_to :referrer, class_name: 'User', foreign_key: 'referrer_id'
  has_many :referrals, class_name: 'User', foreign_key: 'referrer_id'

  # validates :email, presence: true, uniqueness: true, format: {
  #   with: /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/i,
  #   message: 'Invalid email format.'
  # }

  validates_presence_of :name, :city
  
  validates :referral_code, uniqueness: true

  before_create :create_referral_code
  after_create :send_welcome_email

  REFERRAL_STEPS = [
    {
      'count' => 5,
      'html' => '1,500 Travel Points + $5 Starbucks Card',
      'class' => 'two',
      'image' =>  ActionController::Base.helpers.asset_path(
        'assets/new-refer/starbucks.png')
    },
    {
      'count' => 10,
      'html' => '2,500 Travel Points + $10 iTunes Card',
      'class' => 'three',
      'image' => ActionController::Base.helpers.asset_path(
        'assets/new-refer/itunes.png')
    },
    {
      'count' => 15,
      'html' => '3,500 Travel Points + 15 Entries into Jamaica Vacation + $25 Visa Gift Card',
      'class' => 'four',
      'image' => ActionController::Base.helpers.asset_path(
        'assets/new-refer/visa.jpg')
    },
    {
      'count' => 20,
      'html' => "50% off membership for 1-year + 20 entries into Jamaica vacation + $50 Visa Gift Card",
      'class' => 'five',
      'image' => ActionController::Base.helpers.asset_path(
        'assets/new-refer/amazon.jpg')
    },
    {
      'count' => 35,
      'html' => '1-year free membership + 50 entries into Jamaica vacation + 2 R/T Airline tickets to Washington, DC',
      'class' => 'six',
      'image' => ActionController::Base.helpers.asset_path(
        'assets/new-refer/airline-ticket.jpg')
    }
  ]

  private

  def create_referral_code
    self.referral_code = UsersHelper.unused_referral_code
  end

  def create_email_in_mailchimp(email)
    begin 
    mailchimp = Mailchimp::API.new('1c7a7329d017d4eabefd803e11164ae5-us15')
    m = mailchimp.lists.subscribe('df4afa6724', { email: email}, '', '', false)
    puts m
    rescue Mailchimp::ListAlreadySubscribedError
      puts "Mailchimp::ListAlreadySubscribedError"
    rescue 
      puts "error from mailchimp"
    end
  end

  def send_welcome_email
    #UserMailer.delay.signup_email(self)
    create_email_in_mailchimp(self.email)
  end
end
