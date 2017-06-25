class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :hardware_checkouts, dependent: :destroy
  has_many :hardware_items, through: :hardware_checkouts
  has_one :event_application, dependent: :destroy
  has_one :mentorship_requests, dependent: :destroy

  # Use type checkers
  def is_attendee?
  	user_type == 'attendee'
  end

  def is_admin?
  	user_type == 'admin'
  end

  def is_mentor?
  	user_type == 'mentor'
  end

  def is_organizer?
    user_type == 'organizer'
  end

  def full_name
    names = []
    names << first_name if first_name
    names << last_name if last_name
    names.join ' '
  end

  def has_applied?
    EventApplication.where(user_id: self.id).any?
  end

  def has_mentorship_requests?
    MentorshipRequest.where(user_id: self.id).any?
  end

  def is_accepted?
    if has_applied?
      EventApplication.where(user_id: self.id).application_status == 'accepted'
    end
  end

end
