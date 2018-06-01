class Post < ApplicationRecord
    mount_uploader :image, ImageUploader
    
    validates :image, presence: true
    validates :content, presence: true
    validates :user_id, presence: true
    
    belongs_to :user

    has_many :likes
    has_many :like_users, through: :likes, source: :user
    
    # @post.toggle_like(current_user)
    def toggle_like(user)
        # like_users 중에 내가 포함되어 있다면
        if self.like_users.include?(user)
            self.like_users.delete(user)
        else
            # self.like_users << user
            self.like_users.push(user)
        end
    end
    
end