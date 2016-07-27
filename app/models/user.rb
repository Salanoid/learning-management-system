class User
  include Mongoid::Document
  authenticates_with_sorcery!
  ALLOWED_ROLES = ['student', 'instructor']

  field :fname, type: String
  field :mname, type: String
  field :lname, type: String
  field :gender, type: String, default: "male"
  field :role, type: String, default: "student"

   validates_presence_of :email
   validates_presence_of :fname
   validates_presence_of :password, on: :create
   validates_presence_of :password_confirmation, on: :create
   validates_uniqueness_of :email
   validates :password, confirmation: true, on: :create
   validates_confirmation_of :password, on: :create
   validate :role_allowed

   def role_allowed
     if !ALLOWED_ROLES.include?(role)
       errors.add(:role, "not is not allowed")
     end
   end

   def fullname
     self.fname.titleize + " " + self.lname.titleize
   end

  has_and_belongs_to_many :instructor_of, inverse_of: :instructor, class_name: 'Group'
  has_and_belongs_to_many :student_of, inverse_of: :student, class_name: 'Group'
  has_many :requests
  has_many :video_repositories
  has_many :files, class_name: "Document"

  def self.addGroup(user, token)
    group = Group.find_by_token(token)
    user = User.find(user)
    user.student_of << group
    group.student << user
  end

end