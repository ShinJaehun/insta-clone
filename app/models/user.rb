class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :posts
  
  has_many :likes
  has_many :like_posts, through: :likes, source: :post
  
  has_many :followee_follows, foreign_key: :follower_id, class_name: "Follow"
  #followee를 찾을 때 자기 자신이 follower
  has_many :followees, through: :followee_follows, source: :followee
  
  has_many :follower_follows, foreign_key: :followee_id, class_name: "Follow"
  #누가 나를 follow하는데 그 사람들의 ID가 키
  has_many :followers, through: :follower_follows, source: :follower
  
    
  validates :name, presence: true
  
  #유저가 생성된 다음에 권한을 부여하는 콜백 함수를 만들어준다.
  after_create :default_user
  
  def default_user
    self.add_role(:newuser) if self.roles.blank?
  end
  
  def toggle_follow(user)
    if self.followers.include?(user)
      self.followers.delete(user)
    else
      self.followers.push(user)
    end
  end
  
  def feed
    Post.where("user_id = ?", id)
  end
end
