class Organization
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  field :approved, type: Boolean, default: false

  field :name
  slug :name, history: true
  field :description
  field :url
  field :payload
  field :documentation
  field :oc_urn
  field :oc_template, type: Boolean, default: false
  field :oc_sync, type: Boolean, default: false
  field :oc_location
  field :fetch_type
  field :fetch_metadata

  def approve!
    update!(approved: true)
    OrganizationMailer.account_approved(self).deliver_now
  end

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    if !approved?
      :not_approved
    else
      super # Use whatever other message
    end
  end

  def self.import(file)
    spreadsheet = Roo::Spreadsheet.open(file.path)
    header = spreadsheet.row(1)
    payload = Hash.new
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      payload[row["Ime polja"]] = {
        "attr_type": DataType.find_by(name: row["Podatkovni tip"]).data,
        "attr_description": row["Opis polja"],
        "attr_value": row["Podatek"]
      }
    end
    update!(payload: payload)
  end
end
