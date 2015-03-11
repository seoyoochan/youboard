Rails.application.routes.draw do


  scope :subscriptions, as: :subscriptions do
    post "/:type/:id" => "subscriptions#create"
    delete "/:type/:id" => "subscriptions#destroy"
  end

  resources :friendships
  scope :attachments do
    post "download/:file" => "attachments#download", as: :download
    post "file_locale" => "attachments#file_locale", as: :file_locale
    post "file_add" => "attachments#file_add", as: :file_add
    post "file_upload" => "attachments#file_upload", as: :file_upload
    post "error_messages" => "attachments#error_messages", as: :file_error_messages
    delete "destroy/:file" => "attachments#destroy", as: :file_delete
  end

  scope :friendships do
    post "request/:id" => "friendships#send_request", as: :send_friend_request
    delete "cancel/:id" => "friendships#cancel", as: :cancel_friend_request
    put "accept/:id" => "friendships#accept", as: :accept_friend_request
    delete "unfriend/:id" => "friendships#unfriend", as: :unfriend
    put "block/:id" => "friendships#block", as: :block
    delete "unblock/:id" => "friendships#unblock", as: :unblock
  end


  resources :archives, only: [:create, :index]
  delete "archive" => "archives#destroy", as: :destroy_archive
  post "archive_insert" => "archives#insert", as: :insert_archive

  resources :posts, except: :index do
    resources :comments, except: [:index] do
      post "/vote" => "votes#vote"
      delete "/unvote" => "votes#unvote"
      resources :reports, only: [:create, :destroy]
    end

  end

  get 'comments/:comment_id', to: 'comments#show', as: :show_comment

  get 'comments/(:parent_id)/new', to: 'comments#new', as: :new_comment
  post 'comments/(:parent_id)', to: 'comments#create'

  resources :boards

  scope :pages do
    get "recipe" => "pages#recipe"
  end

  get "recipe" => "pages#recipe"

  get "topics" => "topics#filter"

  root "pages#home"

  devise_for :user, path: "",
             path_names: { sign_in: "login", sign_out: "logout", sign_up: "join", password: "find_password" },
             controllers: {
                 :sessions => "users/sessions",
                 :registrations => "users/registrations",
                 :confirmations => "devise/confirmations",
                 :omniauth_callbacks => "users/omniauth_callbacks"
             }

  devise_scope :user do
    get "settings" => "users/registrations#edit", as: :settings
    get "find_password" => "devise/passwords#new", as: :find_password
    get "forgot_password" => "devise/passwords#new", as: :forgot_password
    get "resend" => "devise/confirmations#new", as: :resend
    post "auth/facebook" => "users/omniauth_callbacks#all"
    post "auth/linkedin" => "users/omniauth_callbacks#all"
    post "auth/google_oauth2" => "users/omniauth_callbacks#all"
    post "auth/twitter" => "users/omniauth_callbacks#all"
    post "auth/github" => "users/omniauth_callbacks#all"
  end

  scope ":username" do
    get "" => "pages#profile", as: :user_profile
    get "/posts" => "posts#index", as: :user_posts
    get "/posts/:id" => "posts#show"
  end

  scope ":username/boards" do
    get "" => "boards#user_boards", as: :user_boards
    get "/:id" => "boards#user_board", as: :user_board
    get "/:id/posts" => "boards#user_board", as: :user_board_posts
  end

  scope ":username/boards/:id/posts/:post_id" do
    resources :reports, only: [:create, :destroy]
    get "/edit" => "posts#edit", as: :user_board_post_edit
    get "" => "boards#user_board_post", as: :user_board_post
    post "/scrap" => "scraps#create", as: :scrap
    delete "/scrap" => "scraps#destroy", as: :scrap_destroy
    post "/vote" => "votes#vote", as: :post_vote
    delete "/unvote" => "votes#unvote", as: :post_unvote
  end

  resources :conversations do
    resources :messages
  end


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
