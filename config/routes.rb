Rails.application.routes.draw do
  get 'password_resets/new' =>"password_resets#new"
  post 'password_resets/new' =>"password_resets#edit"
  get 'password_resets/edit' =>'password_resets#edit'
  post 'password_resets/edit' =>'password_resets#edit'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'homes#index'

  resources :courses do
    member do
      get :select
      get :quit

      #设置课程的开课与否定义的两个方法
      get :open
      get :close
      #课程地点信息以及课程简介
      get :show_describtion
      get :course_introduction
      #老师修改课程信息
      get :update_introduction
    end
    collection do
      get :list
      get :show_owned
      get :select_by_time
      get :list_by_selected

      get :excel
      get :download_timetable

    end
  end

  resources :grades do
    collection do
       get :download_chose_student
    end

  end
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  
  get 'sessions/login' => 'sessions#new'
  post 'sessions/login' => 'sessions#create'
  delete 'sessions/logout' => 'sessions#destroy'
  get '/auth/:provider/callback' => 'sessions#create_oauth'
  get '/auth/failure' => 'sessions#failure'


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
