# Define controller with naming convention
  + What Does a Controller Do?
   - Nhận request từ client và xử lí chúng có thể tương tác với DB thông qua model và trả kết quả ra
  + Controller Naming Convention
   - Khuyến khích hơn những từ cuối cùng là số nhiều
   - Cho phép sử dụng default route generators mà ko cần qualify cho mỗi :path hoặc :controller
   - Giữ tên helper route để sử dụng xuyên suốt app 

  + Methods and Actions
   - Class controller kế thừa từ ApplicationController nên cũng có những method giống bất kỳ lớp nào.
   - Khi nhận request thì route nó chỉ định controller và action được chạy, sau đó Rails nó tạo ra một instance của controller và chạy method như là tên của action.
    - Only public methods are callable as actions.
  
  +  Parameters
    - There are two kinds of parameters possible in a web application:
      + The first are parameters that are sent as part of the URL, called query string parameters. 
      + The query string is everything after "?" in the URL, usually referred to as POST data. 
      This information usually comes from an HTML form which has been filled in by the user. It's called POST data because it can only be sent as part of an HTTP POST request
      + vailable in the params hash in your controller:
    
    ## Hash and Array Parameters
      - "params hash" is not limited to one-dimensional keys and values. It can contain nested arrays and hashes.
      vd :
          <input type="text" name="client[phone]" value="12345" />
          <input type="text" name="client[address][postcode]" value="12345" />
          <input type="text" name="client[address][city]" value="Carrot City" />
        => params[:client] ... {"phone" => "12345", "address" => { "postcode" => "12345", "city" => "Carrot City" } }
        => nested hash in params[:client][:address]
      or
         GET /clients?ids[]=1&ids[]=2&ids[]=3
        => params[:ids] = ["1", "2", "3"]
    
    ## JSON parameters
      
      vd: JSON -> { "company": { "name": "acme", "address": "123 Carrot Street" } }
            => params[:company] as { "name" => "acme", "address" => "123 Carrot Street" }
      
      - config.wrap_parameters:  
          + you can safely omit the root element in the JSON parameter. In this case, the parameters will be cloned and wrapped with a key chosen based on your controller's name.
            vd : { "name": "acme", "address": "123 Carrot Street" }

          + assuming that you're sending the data to CompaniesController, it would then be wrapped within the :company key.
            vd : { name: "acme", address: "123 Carrot Street", company: { name: "acme", address: "123 Carrot Street" } }
    
    ## Routing Parameters

        vd: get '/clients/:status', to: 'clients#index', foo: 'bar'
      => /clients/active, params[:status]<=>"active", params[:foo] <=> "bar",if it were passed in the query string. params[:action] as "index" and params[:controller] as "clients"
    
    ## default_url_options

    ## Strong Parameters
      - help prevent accidentally allowing users to update sensitive model attributes.

# SESSION
  + ActionDispatch::Session::CookieStore 
  + ActionDispatch::Session::CacheStore 
  + ActionDispatch::Session::ActiveRecordStore
  + ActionDispatch::Session::MemCacheStore 

  * Be sure to restart your server when you modify this file.
      - Rails.application.config.session_store :cookie_store, key: '_your_app_session'
      - Rails.application.config.session_store :cookie_store, key: '_your_app_session', domain: ".example.com"

      + Rails sets up (for the CookieStore) a "secret key" used for signing the session data in config/credentials.yml.enc. This can be changed with bin/rails credentials:edit.

  ## Accessing the Session
    - In your controller, you can access the session through the session instance method.
    
    * Note : Sessions are lazily loaded. If you don't access sessions in your action's code, they will not be loaded.

    * Session values are stored using key/value pairs like a hash:
          vd :  def current_user
                  @_current_user ||= session[:current_user_id] &&
                  User.find_by(id: session[:current_user_id])
                end
    * To store something in the session, just assign it to the key like a hash:
          vd : session[:current_user_id] = user.id
    
    * To remove something from the session, delete the key/value pair:
          vd : session.delete(:current_user_id)

    * To reset the entire session, use reset_session.
          vd : reset_session()

# Cookies
  + Rails provides easy access to cookies via the cookies method
      vd : cookies[:commenter_name]
  + delete cookies :
      vd: cookies.delete(:key)
  + Rails also provides a signed cookie jar and an encrypted cookie jar for storing sensitive data. The signed cookie jar appends a cryptographic signature on the cookie values to protect their integrity. The encrypted cookie jar encrypts the values in addition to signing them

  + These special cookie jars use a serializer to serialize the assigned values into strings and deserializes them into Ruby objects on read
      vd: Rails.application.config.action_dispatch.cookies_serializer = :json

# Filters
  + Filters are methods that are run "before", "after" or "around" a controller action.

  + Filters are inherited, so if you set a filter on ApplicationController, it will be run on every controller in your application.

  + "before" filters are registered via before_action. They may halt the request cycle
  
  + . If a "before" filter renders or redirects, the action will not run. If there are additional filters scheduled to run after that filter, they are also cancelled.

  + skip_before_action :require_login, only: [:new, :create]

  ## After Filters and Around Filters
    + "after" filters are registered via after_action. "after" filters cannot stop the action from running. Please note that "after" filters are executed only after a successful action

    + "around" filters are registered via around_action. They are responsible for running their associated actions by yielding, similar to how Rack middlewares work.
      - You can choose not to yield and build the response yourself, in which case the action will not be run.
        vd: 
            def wrap_in_transaction
              ActiveRecord::Base.transaction do
                begin
                  yield
                ensure
                  raise ActiveRecord::Rollback
                end
              end
            end
    
    +  Other Ways to Use Filters:
       - The first is to use a block directly with the *_action methods. The block receives the controller as an argument. The require_login filter from above could be rewritten to use a block:
        vd: class ApplicationController < ActionController::Base
              before_action do |controller|
                unless controller.send(:logged_in?)
                  flash[:error] = "You must be logged in to access this section"
                  redirect_to new_login_url
                end
              end
            end
        
        * Note : Note that the filter, in this case, uses "send" because the "logged_in?" method is private, and the filter does not run in the scope of the controller. This is not the recommended way to implement this particular filter, but in simpler cases, it might be useful.

       - Specifically for around_action, the block also yields in the action:
          vd : around_action { |_controller, action| time(&action) }
      
       - The second way is to use a class (actually, any object that responds to the right methods will do) to handle the filtering. This is useful in cases that are more complex and cannot be implemented in a readable and reusable way using the two other methods.

        vd:  class ApplicationController < ActionController::Base
                before_action LoginFilter
              end

              class LoginFilter
                def self.before(controller)
                  unless controller.send(:logged_in?)
                    controller.flash[:error] = "You must be logged in to access this section"
                    controller.redirect_to controller.new_login_url
                  end
                end
              end


# Layout and rendering
  + Overview: How the Pieces Fit Together

  + Creating Responses
    - có 3 cách : 
       + Call "render" to create a full response to send back to the browser
       + Call "redirect_to" to send an HTTP redirect status code to the browser
       + Call "head" to create a response consisting solely of HTTP headers to send back to the browser

  + Rendering by Default: Convention Over Configuration in Action
    - By default, controllers in Rails automatically render views with names that correspond to valid routes.

  + Using render
    - You can render the default view for a Rails template, or a specific template, or a file, or inline code, or nothing at all. You can render text, JSON, or XML. You can specify the content type or HTTP status of the rendered response as well.

    - If you want to see the exact results of a call to "render" without needing to inspect it in a browser, you can call "render_to_string". This method takes exactly the same options as "render", but it returns a string instead of sending a response back to the browser.

  + Rendering an Action's View
    - If you want to "render" the view that corresponds to a different template within the same controller, you can use "render" with the name of the view:
      vd : def update
              @book = Book.find(params[:id])
              if @book.update(book_params)
                redirect_to(@book)
              else
                render "edit"   <!--or  render :edit, status: :unprocessable_entity -->
              end
            end


  + Rendering an Action's Template from Another Controller

      vd : if you're running code in an AdminProductsController that lives in app/controllers/admin, you can render the results of an action to a template in app/views/products.

      => render "products/show" <!-- render template: "products/show" -->   


  + Rendering an Arbitrary File

  + Wrapping it up

      Cái nào bạn sử dụng thực sự là một vấn đề về phong cách và quy ước, nhưng quy tắc của ngón tay cái là sử dụng cái đơn giản nhất có ý nghĩa đối với mã bạn đang viết

  + Using redirect_to
      - The "redirect_to" method does something completely different: it tells the browser to send a new request for a different URL.

        vd : redirect_to photos_url
  
      - You can use "redirect_back" to return the user to the page they just came from. This location is pulled from the HTTP_REFERER header which is not guaranteed to be set by the browser, so you must provide the fallback_location to use in this case.

          vd : redirect_back(fallback_location: root_path)

  + Getting a Different Redirect Status Code
      - Rails uses HTTP status code 302, a temporary redirect, when you call redirect_to. If you'd like to use a different status code, perhaps 301, a permanent redirect, you can use the ":status" option:
        vd: redirect_to photos_path, status: 301

  + The Difference Between render and redirect_to
    -  Redirect_to : Your code stops running and waits for a new request from the browser. It just happens that you've told the browser what request it should make next, by sending back an HTTP 302 status code.

  ## Specify Layout
    + Options for render (  The :layout Option)
      - You can use the :layout option to tell Rails to use a specific file as the layout for the current action:
          vd: render layout: "special_layout"
      - You can also tell Rails to render with no layout at all:
          vd : render layout: false
    
    ### Finding Layouts
      + Specifying Layouts for Controllers:
           vd: 
              class ProductsController < ApplicationController
                  layout "inventory"
                  #...
              end

          - With this declaration, all of the views rendered by the "ProductsController" will use "app/views/layouts/inventory.html.erb" as their layout. 

          - To assign a specific layout for the entire application, use a layout declaration in your ApplicationController class:

            vd : class ApplicationController < ActionController::Base
                    layout "main"
                  end
          => With this declaration, all of the views in the entire application will use "app/views/layouts/main.html.erb"
      
      + Choosing Layouts at Runtime
          vd : 
              class ProductsController < ApplicationController
                  layout :products_layout

                  def show
                    @product = Product.find(params[:id])
                  end

                  private
                    def products_layout
                      @current_user.special? ? "special" : "products"
                    end

                end
      
      + Conditional Layouts:
          vd : 
            class ProductsController < ApplicationController
              layout "product", except: [:index, :rss]
            end
      
      + Layout Inheritance





# Trong file js.erb bất kỳ, ta có thể gọi 1 partial không? Nếu được hãy cho ví dụ về cách gọi đó?
# Trong thư mục view/users 2 file: new.html.erb, new.js.erb. Khi nào thì những file này sẽ được gọi?

# get /preview.json
# check_box("article", "is_read")

# Để tạo 1 select box mảng user trên, ta cần khai báo thế nào?
