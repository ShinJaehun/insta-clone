class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :like]
  # before_action :authenticate_user!, except: [:index, :show]
  # before_action :check_user, only: [:edit, :update, :destroy]
  before_action :authenticate_user!

  load_and_authorize_resource
  
  # GET /posts
  # GET /posts.json
  def index
    # params에 content라는 키 값이 존재한다면...
    if params.has_key?(:content)
      # params에서 content 내용으로 검색해서 포함하는 posts를 불러오기
      # params 앞 뒤로 %를 넣은 이유는 그 앞쪽과 뒷쪽 
      # 일이삼사오
      # 이삼사, 삼사오 모두 검색
      # % 없이는 일이삼사오 만 검색함
      # like는 비슷한 것을 검색, % 는 DB SQL과 관련 있는 내용...
      @posts = Post.where('content like ?', "%#{params[:content]}%")
    else 
      # @posts = Post.all
      # 마지막에 자기 자신이 쓴 글 까지 추가하기 위해서 push했음
      @posts = Post.where(user_id: current_user.followees.ids.push(current_user.id))
    end
    # rails active record query로 검색
    # all : 여러개의 결과
    # @posts = Post.all
    # find(1), find(:id) : 단 하나의 결과
    # @post = Post.find(1)
    # find([1,2]) : 여려개의 결과(id가 1과 2에 해당하는 내용)
    # @post = Post.find([1,2])
    # where() : 여러개
    # where.not() : 여러개, 반대의 결과
    # order() : 여러개를 가져와서 정렬
    # @post = Post.all.order(created_at: :desc)
    # first : 한 개, 첫번째 자료만 가져오기...
    # @post = Post.first
    # @post = Post.order(created_at: :desc).first # 가장 최신의 것만 가지고 오
    # @posts = Post.order(created_at: :desc).first(2) # 가장 최신의 것부터 2개 가지고 오기
    # last : 한 개, 마지막 자료만 가져오기...
    # @post = Post.last
    # limit(n) : 제한적으로 가지고 오기... (하나 또는 여러 개)
    # @posts = Post.limit(2)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    # if @post.user_id == current_user.id
    
  end

  # POST /posts
  # POST /posts.json
  def create
    # @post = Post.new(post_params)
    # @post.user_id = current_user.id
    @post = current_user.posts.new(post_params)
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def mypage
    # @posts = current_user.posts
    @posts = current_user.feed
  end
  
  # POST 'posts/:id/like'
  def like
    @post.toggle_like(current_user)
    redirect_back(fallback_location: root_path)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:image, :content)
    end

    # def check_user
    #       redirect_to root_path, notice: '권한이 없습니다.' and return unless @post.user == current_user
    # end
end
