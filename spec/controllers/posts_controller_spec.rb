require 'rails_helper'

describe PostsController do
  let!(:user) {User.create!(username: "mikey", email: "test@email.com", password: "password")}
  let!(:published_post) {Post.create!(author_id: user.id, title: "Harry Potter 20", text: "Wacky Wizards", published?: true)}
  let!(:unpublished_post) {Post.create!(author_id: user.id, title: "Harry Potter 20", text: "Wacky Wizards", published?: false)}  
  let!(:posts) {Post.all}
  
  describe 'GET posts#index' do
    it 'renders posts#index' do
      get :index
      expect(response).to render_template'index'      
    end

    it 'assigns @post to all published posts sorted by vote amount' do
      get :index
      expect(assigns(:posts).select {|post| post.published?}.sort_by{|post| post.votes.count}.reverse).to include(published_post)
    end
  end

  describe 'Creating a new post' do
    let!(:user) {User.create!(username: "mikey", email: "email.com", password: "password")}
    it 'renders posts#new on GET posts/new' do
      get :new
      expect(response).to render_template 'new'
    end

    it 'redirects to post#show if valid posting' do
      session[:user_id] = user.id
      post :create, {params: {posts: {title: "Harry Potter 20", text: "Wacky Wizards"}}}
      expect(response).to redirect_to "/posts/#{posts.last.id}"
    end

    it 'renders new if post was invalid' do
      session[:user_id] = user.id
      post :create, {params: {posts: {title: "Harry Potter 20"}}}
      expect(response).to render_template(:new)
    end
  end

  describe "Edit a post" do
    it "renders a edit template" do
      get :edit, {params: {id: 1}}
      expect(response).to render_template(:edit)
    end
  end

  describe "Update a post" do
    it 'redirects to post#show if vaild update' do
      put :update, params: {:id => published_post.id, :posts => {author_id: user.id, title: "harry potter turns 21", text:"Wacky", published?: true}}
    
      expect(response).to redirect_to(post_path)
    end

    it 'renders posts#edit if invaild update' do
      put :update, params: {:id => published_post.id, :posts => {author_id: user.id, title: ""}}
      expect(response).to render_template 'posts/edit'
    end
  end

  describe "destroy a post" do
    it "redirects to / "do
      delete :destroy, {params: {id: published_post.id}}
      expect(response).to redirect_to "/"
    end
   end

end