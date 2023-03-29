# What is it, what is it for
  ## The Purpose of the Rails Router
      + Connecting URLs to Code: 
          - When your Rails application receives an incoming request for, it asks the router to match it to a controller action, then this request dispatch to Controller of who action.
      
      + Generating Paths and URLs from Code:
          vd :
            routes :  get '/patients/:id', to: 'patients#show', as: 'patient'
            controller : @patient = Patient.find(params[:id])
            view : <%= link_to 'Patient Record', patient_path(@patient) %>

      + Configuring the Rails Router
          vd : config/routes.rb  
  ## Resource Routing: the Rails Default
    - Resource routing allows you to quickly declare all of the common routes for a given resourceful controller. 
    -  A single call to "resources" can declare all of the necessary routes for your index, show, new, edit, create, update, and destroy actions.
   
   ### Resources on the Web
      - Browsers request pages from Rails by making a request for a URL using a specific HTTP method, such as GET, POST, PATCH, PUT, and DELETE. Each method is a request to perform an operation on the resource. A resource route maps a number of related requests to actions in a single controller.
   
   ### CRUD, Verbs, and Actions
      -  a resourceful route provides a mapping between HTTP verbs and URLs to controller actions,
      each action also maps to a specific CRUD operation in a database. 
   
   ### Path and URL Helpers
      expose a number of helpers to the controllers 
        - photos_path returns /photos
        - photo_path(:id) returns /photos/:id (for instance, photo_path(10) returns /photos/10)
        - new_photo_path returns /photos/new
        - edit_photo_path(:id) returns /photos/:id/edit (for instance, edit_photo_path(10) returns /photos/- 10/edit)
   
   ### Defining Multiple Resources at the Same Time
        vd : resources :photos, :books, :videos

   ### Singular Resources
        vd : get 'profile', to: 'users#show'  (rather than /profile/:id    -> show action)
        
        not # :   get 'profile', action: :show, controller: 'users'

        resource :geocoder
        resolve('Geocoder') { [:geocoder] }

      - A singular resourceful route generates these helpers:
          new_geocoder_path returns /geocoder/new
          edit_geocoder_path returns /geocoder/edit
          geocoder_path returns /geocoder
    
   ### Creating Paths and URLs from Objects
          resources :magazines do
            resources :ads
          end

        - magazine_ad_path: 
            <%= link_to 'Ad details', magazine_ad_path(@magazine, @ad) %>
        
        - url_for:
            <%= link_to 'Ad details', url_for([@magazine, @ad]) %>
        or 
            <%= link_to 'Ad details', [@magazine, @ad] %>
        or 
            <%= link_to 'Magazine details', @magazine %>
        
        - diff action : 
            <%= link_to 'Edit Ad', [:edit, @magazine, @ad] %>

   ### Adding More RESTful Actions
      
      ** Adding Member Routes: To add a member route, just add a "member" block into the resource block:
              resources :photos do
                member do
                  get 'preview'
                end
              end
        -> GET , /photos/1/preview, 
        - with the resource id value passed in params[:id]
        - create helper : preview_photo_url and preview_photo_path

          resources :photos do
            get 'preview', on: :member
          end
        -> params[:photo_id] instead of params[:id]
        -> photo_preview_url and photo_preview_path.

      ** Adding Collection Routes : To add a route to the collection, use a "collection" block:
            resources :photos do
              collection do
                get 'search'
              end
            end
      ->GET,  /photos/search, enable route to the search action of PhotosController.
      -> create helper : search_photos_url and search_photos_path

      @@ Note :  Symbols infer controller actions while strings infer paths.

      
      *** Adding Routes for Additional New Actions : To add an alternate new action using the :on shortcut
          resources :comments do
            get 'preview', on: :new
          end
          -> GET : /comments/new/preview
          -> create helper : preview_new_comment_url and preview_new_comment_path 
  ## Restricting the Routes Created
        + resources :photos, only: [:index, :show]
        -> a GET request to /photos would succeed, but a POST request to /photos (which would ordinarily be routed to the create action) will fail.

        + resources :photos, except: :destroy
        -> In this case, Rails will create all of the normal routes except the route for destroy (a DELETE request to /photos/:id).
  ## Listing Existing Routes
       
     + load routes of itself: http://localhost:3000/rails/info/routes or rails routes

     + include :  The route name (if any)
                The HTTP verb used (if the route doesn't respond to all verbs)
                The URL pattern to match
                The routing parameters for the route
    
      + format table : rails routes --expanded

      + search through your routes with the grep option: -g
          rails routes -g new_comment
          rails routes -g POST
          rails routes -g admin

      + If you only want to see the routes that map to a specific controller, there's the -c option.

          rails routes -c users
          rails routes -c admin/users
          rails routes -c Comments
          rails routes -c Articles::CommentsController
  ## Non-resourceful actions
   ### Bound Parameters
      get 'photos(/:id)', to: 'photos#display'
      display
   ### Dynamic Segments
      get 'photos/:id/:user_id', to: 'photos#show'
      PhotosController. params[:id] will be "1", and params[:user_id] will be "2"
   ### Static Segments
      - not prepending a colon to a segment:
        + get 'photos/:id/with_user/:user_id', to: 'photos#show'
        + params would be { controller: 'photos', action: 'show', id: '1', user_id: '2' 
   ### The Query String
      - The params will also include any parameters from the query string.
        vd : get 'photos/:id', to: 'photos#show'
             /photos/1?user_id=2
             params will be { controller: 'photos', action: 'show', id: '1', user_id: '2' }  
   ### Naming Routes
      - You can specify a name for any route using the :as option:
      vd : get 'exit', to: 'sessions#destroy', as: :logout
      
      - create "logout_path" and "logout_url" as named route helpers in your application. Calling "logout_path" will return /exit

      -  to override routing methods defined by resources 
        vd : get ':username', to: 'users#show', as: :user
             resources :users

      - params[:username] will contain the username for the user
    
   ### HTTP Verb Constraints
      - use the get, post, put, patch, and delete methods to constrain a route to a particular verb 
        vd:  match 'photos', to: 'photos#show', via: [:get, :post]
             match 'photos', to: 'photos#show', via: :all
  ## Nested Resources

      vd : class Magazine < ApplicationRecord
              has_many :ads
            end

            class Ad < ApplicationRecord
              belongs_to :magazine
            end
            resources :magazines do
              resources :ads
            end
   ### Limits to Nesting

        vd : resources :publishers do
              resources :magazines do
                resources :photos
              end
            end
        => /publishers/1/magazines/2/photos/3

   ### Shallow Nesting

        vd: resources :articles do
              resources :comments, only: [:index, :new, :create]
            end
            resources :comments, only: [:show, :edit, :update, :destroy]

        resources :articles do
          resources :comments, shallow: true
        end

        resources :articles, shallow: true do
          resources :comments
          resources :quotes
          resources :drafts
        end

        shallow do
          resources :articles do
            resources :comments
            resources :quotes
            resources :drafts
          end
        end

   ### Controller Namespaces and Routing
        namespace :admin do
          resources :articles, :comments
        end
      vd : /admin/articles => admin/articles#index => 	admin_articles_path

      - If instead you want to route /articles (without the prefix /admin) to Admin::ArticlesController, you can specify the module with a scope block:
          vd : scope module: 'admin' do
                resources :articles, :comments
              end
      - This can also be done for a single route:
          vd : resources :articles, module: 'admin'

      - If instead you want to route /admin/articles to ArticlesController (without the Admin:: module prefix), you can specify the path with a scope block:

          vd : scope '/admin' do
                resources :articles, :comments
              end
      - This can also be done for a single route:

          vd : resources :articles, path: '/admin/articles'  
  ## Using root
      - You can specify what Rails should route '/' to with the root method:
          vd : root to: 'pages#main'
                root 'pages#main' # shortcut for the above
      - You can also use root inside namespaces and scopes as well. 
          vd : namespace :admin do
                root to: "admin#index"
              end

              root to: "home#index"
