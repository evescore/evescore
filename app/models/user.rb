# frozen_string_literal: true

class User
  include MongoidSetup
  include ProfileStats
  field :characters_count, type: Integer, default: 0
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  ## Database authenticatable
  field :email,              type: String, default: ''
  field :encrypted_password, type: String, default: ''

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
  field :confirmation_token,   type: String
  field :confirmed_at,         type: Time
  field :confirmation_sent_at, type: Time
  field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  has_many :characters
  has_many :wallet_records
  has_many :kills

  def self.update_counter_caches
    all.each do |user|
      user.characters_count = user.characters.count
      user.save
    end
  end

  def character_api
    ESI::CharacterApi.new
  end

  def import_character(omniauth_payload)
    character_id = omniauth_payload['extra']['raw_info']['CharacterID']
    api_character = character_api.get_characters_character_id(character_id)
    credentials = omniauth_payload['credentials']
    character = characters.where(id: character_id, name: api_character.name, corporation_id: api_character.corporation_id, alliance_id: api_character.alliance_id).first_or_create
    character.update_tokens(credentials)
  end
end
