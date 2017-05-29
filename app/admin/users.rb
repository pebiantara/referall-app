# Export to CSV with the referrer_id
ActiveAdmin.register User do

  before_filter :skip_sidebar!, :only => :index
  
  csv do
    column :id
    column :email
    column :referral_code
    column :referrer_id
    column :created_at
    column :updated_at
  end

  actions :index, :show, :destroy

  index do
    selectable_column
    column :id
    column :email
    column 'Referrals Count' do |user|
      user.referrals.count
    end
    column :referral_code
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :email
      row :referral_code
      row :referrals_count do
      	user.referrals.count
      end
      row :referrer
      row :created_at
    end
    active_admin_comments
  end

end