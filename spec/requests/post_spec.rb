require 'rails_helper'

REDIRECT_HTTP_STATUS_CODE = 302.freeze

RSpec.describe "Posts", type: :request do
  let!(:user) { create(:user) }

  context "Get requests" do
    let!(:post) { create(:post) }

    describe "GET post" do
      let(:params) { { query: "test" } }

      it "index post" do
        sign_in user
        get posts_path
        expect(response).to have_http_status(:success)
      end

      it "new post" do
        sign_in user
        get new_post_path
        expect(response).to have_http_status(:success)
      end

      it "show post" do
        get "/posts/#{post.id}", params: { id: "1", user_id: 2 }
        expect(response).to have_http_status(:redirect)
      end

      it 'return current_useer all posts' do
        FactoryBot.create(:post, title: 'First', body: 'text', author: 'Jamesis')
        FactoryBot.create(:post, title: 'Second', body: 'second text', author: 'Vincert')
        get posts_all_posts_path
        expect(response).to have_http_status(:success)
      end

      it "edit post" do
        get edit_post_path(post.id), params: { id: "1"}
        expect(response.status).to eq(302)
      end

      it "search word in post title" do
        sign_in user
        get search_path(params)
        expect(response.body).to include("test")
        expect(response).to have_http_status(:success)
      end
    end
  end

  context "Post/PATCH requests" do

    describe "Post #create" do
      it "create a new post" do
        sign_in user
        post "/posts", params: { post: { title: "New post", body: "some text" } }
        expect(response).to redirect_to posts_path
        expect(response).to have_http_status(302)
      end

      it "should render new template if not all parametrs were specified" do
        sign_in user
        post "/posts", params: { post: { title: "", body: ""}}
        expect(response).to render_template(:new)
      end

      describe "PATCH requests" do

        let!(:post) { create(:post) }

        it "should redirect to new post path after update" do
          sign_in user
          patch post_path(post.id), params: { post: { title: "New post2", body: "some text3"}}
          expect(response).to redirect_to posts_path
        end

        it "should render edit if not all parametrs were specified" do
          sign_in user
          patch post_path(post.id), params: { post: { title: "", body: "" } }
          expect(response).to render_template(:edit)
        end
      end
    end

    context "DELETE request" do

      describe "DELETE #destroy" do

        let!(:post) { create(:post) }

        it "should redirect to posts if user delete post" do
          sign_in user
          delete "/posts/#{post.id}", params: { id: 1 }
          expect(response).to redirect_to posts_path
        end
      end
    end
  end
end