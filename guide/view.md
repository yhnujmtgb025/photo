# Create views for actions
  
  ## What is Action View?
   
   - Action View is responsible for compiling the response.
   - Action View templates are written using embedded Ruby in tags mingled with HTML.
    To avoid cluttering the templates with boilerplate code, several helper classes provide common behavior for forms, dates, and strings.

  ## Using Action View with Rails
    - each controller, there is an associated directory in the "app/views" directory which holds the template files that make up the views associated with that controller
  
  ## Templates, Partials, and Layouts
    ### Templates
      - If the template file has a ".erb" extension then it uses a mixture of ERB (Embedded Ruby) and HTML. If the template file has a ".builder" extension then the Builder::XmlMarkup library is used.

    ### ERB
      - <%%> : used to execute Ruby code that does not return anything, such as conditions, loops, or blocks,
      - <%= %> tags are used when you want output.
      - <%--%> bỏ qua khoảng trắng <=> <%%>

# Partials

  ## Partials
   - With partials, you can extract pieces of code from your templates to separate files and also reuse them throughout your templates.

  ### Naming Partials
     vd :  <%= render "menu" %>
    - This will render a file named _menu.html.erb at that point within the view that is being rendered.
           
          <%= render "shared/menu" %>

    - That code will pull in the partial from app/views/shared/_menu.html.erb
  
  ### Using Partials to simplify Views
    <!-- 
          <%= render "shared/ad_banner" 
            <h1>Products</h1>

            <p>Here are a few of our fine products:</p>
            <% @products.each do |product| %>
              <%= render partial: "product", locals: { product: product } %>
            <% end %>

          <%= render "shared/footer" %>  
    -->

  ### render without partial and locals options

      vd:  <%= render partial: "product", locals: { product: @product } %>
          or 
    not use options: 
           <%= render "product", product: @product %>

  ###  Rendering Collections
      vd: 
        <% @products.each do |product| %>
          <%= render "product", locals: { product: product } %>
        <% end %>
        <%= render partial: "product", collection: @product %>
    shorthand:
        <%= render @products %>
  
  ## Partial Layouts
    vd : 
      articles/show.html.erb: 
    => <%= render partial: 'article', layout: 'box', locals: { article: @article } %>
      
      articles/_box.html.erb
      <div class='box'>
        <%= yield %>      
      </div>
  or
    articles/show.html.erb
      <% render(layout: 'box', locals: { article: @article }) do %>
        <div>
          <p><%= article.body %></p>
        </div>
      <% end %>

# Form helpers

  ## FormHelper
    vd:
      <%= form_with do |form| %>
          Form contents
      <% end %>
  
   - seach form :
        <%= form_with url: "/search", method: :get do |form| %>
          <%= form.label :query, "Search for:" %>
          <%= form.text_field :query %>
          <%= form.submit "Search" %>
        <% end %>

        <%= form_with url:"/search", method: :get do |form|%>
          <%= form.label :query, "Search for"%>
          <%= form.text_field :query%>
          <%= form.submit "search">
        <% end %>
    
  ## FormOptionsHelper
    + Checkboxes
      vd: <%= form.check_box :pet_dog %>
          <%= form.label :pet_dog, "I own a dog" %>

    + Radio Buttons
      <%= form.radio_button :age, "child" %>
      <%= form.label :age_child, "I am younger than 21" %>

    + text_area
        <%= form.text_area :message, size: "70x5" %>
    + hidden_field 
        <%= form.hidden_field :parent_id, value: "foo" %>
    + password_field
        <%= form.password_field :password %>
    + number_field 
        <%= form.number_field :price, in: 1.0..20.0, step: 0.5 %>
    + range_field 
        <%= form.range_field :discount, in: 1..100 %>
    + date_field
        <%= form.date_field :born_on %>
    + time_field 
        <%= form.time_fiđóeld :started_at %>
        <%= form.datetime_local_field :graduation_day %>
        <%= form.month_field :birthday_month %>
        <%= form.week_field :birthday_week %>
    + search_field 
        <%= form.search_field :name %>
    + email_field
        <%= form.email_field :address %>
    + telephone_field
        <%= form.telephone_field :phone %>
    + url_field
        <%= form.url_field :homepage %>
    + color_field
        <%= form.color_field :favorite_color %>

    + select 
         <%= form.select :city, [["Berlin", "BE"], ["Chicago", "CHI"], ["Madrid", "MD"]], selected: "CHI" %>
        <select name="city" id="city">
          <option value="BE">Berlin</option>
          <option value="CHI" selected="selected">Chicago</option>
          <option value="MD">Madrid</option>
        </select>

    + option 
      <%= form.select :city,
      {
        "Europe" => [ ["Berlin", "BE"], ["Madrid", "MD"] ],
        "North America" => [ ["Chicago", "CHI"] ],
      },
      selected: "CHI" %>
        <select name="city" id="city">
        <optgroup label="Europe">
          <option value="BE">Berlin</option>
          <option value="MD">Madrid</option>
        </optgroup>
        <optgroup label="North America">
          <option value="CHI" selected="selected">Chicago</option>
        </optgroup>
      </select>

      + time_zone_select 
      <%= form.time_zone_select :time_zone %>

  ## FormTagHelper

# Action view helpers: number, currency, text..
  
  ## NumberHelper
   + number_to_currency
      vd: number_to_currency(1234567890.50) # => $1,234,567,890.50
   +  number_to_human
      vd: number_to_human(1234)    # => 1.23 Thousand
          number_to_human(1234567) # => 1.23 Million
   + number_to_human_size
      vd: number_to_human_size(1234)    # => 1.21 KB
          number_to_human_size(1234567) # => 1.18 MB
    + number_to_percentage
      vd: number_to_percentage(100, precision: 0) # => 100%
    + number_to_phone
      vd: number_to_phone(1235551234) # => 123-555-1234
    + number_with_delimiter
      vd : number_with_delimiter(12345678) # => 12,345,678
    + number_with_precision
      vd: number_with_precision(111.2345)               # => 111.235
          number_with_precision(111.2345, precision: 2) # => 111.23

# SLIM
  + What is Slim?
   - Slim is a fast, lightweight templating engine with support for Rails 3 and later.
  
  + Why use Slim?
    + Slim allows you to write very minimal templates which are easy to maintain and pretty much guarantees that you write well-formed HTML and XML
    + The Slim syntax is aesthetic and makes it more fun to write templates. Since you can use Slim as a drop-in replacement in all the major frameworks it is easy to adopt.
    + The Slim architecture is very flexible and allows you to write syntax extensions and plugins
  
  + How to start?
    + gem install slim

  + Syntax example
    doctype html
    html
      head
        title Slim Examples
        meta name="keywords" content="template language"
        meta name="author" content=author
        link rel="icon" type="image/png" href=file_path("favicon.png")
        javascript:
          alert('Slim supports embedded javascript!')

      body
        h1 Markup examples

        #content
          p This example shows you how a basic Slim file looks.

        == yield

        - if items.any?
          table#items
            - for item in items
              tr
                td.name = item.name
                td.price = item.price
        - else
          p No items found. Please add some inventory.
            Thank you!

        div id="footer"
          == render 'footer'
          | Copyright &copy; #{@year} #{@author}

  + Verbatim text |
      body
        p
          |
            This is a test of the text block.

      => <body><p>This is a test of the text block.</p></body>

  + Verbatim text with trailing white space '
      - The single quote tells Slim to copy the line (similar to |), but makes sure that a single trailing white space is appended.

  + Control code -
       body
      - if articles.empty?
        | No inventory

  + Output =
      - The equals sign tells Slim it's a Ruby call that produces output to add to the buffer. If your ruby code needs to use multiple lines, append a backslash \ at the end of the lines.
      vd:  = javascript_include_tag \
          "jquery",
          "application"

  + Code comment /
    - Use / for code comments and /! for html comments
      
      body
      p
        / This line won't get displayed.
          Neither does this line.
        /! This will get displayed as html comments.
    

  + Trailing and leading whitespace
    - trailing : a> href='url1' Link1
    - leading : a< href='url1' Link1
    - combine : a<> href='url1' Link1

  + Text content
      body
        h1 id="headline" Welcome to my site.

  + Dynamic content (= and ==)
        body
        h1 id="headline" = page_headline

  + Attributes
      a href="http://slim-lang.com" title='Slim Homepage' Goto the Slim homepage

  + Attributes wrapper
    body
    h1(id="logo") = page_logo
    h2[id="tagline" class="small tagline"] = page_tagline

  + Quoted attributes 
      a href="http://slim-lang.com" title='Slim Homepage' Goto the Slim homepage
    => a href="http://#{url}" Goto the #{url}

  + Ruby attributes
      body
      table
        - for user in users
          td id="user_#{user.id}" class=user.role
            a href=user_action(user, :edit) Edit #{user.name}
            a href=(path_to_user user) = user.name

  + Boolean attributes
      input type="text" disabled="disabled"
      input type="text" disabled=true
      input(type="text" disabled)

  + ID shortcut # and class shortcut .
      body
      h1#headline
        = page_headline
      h2#tagline.small.tagline
        = page_tagline
      .content
        = show_content

  + Text interpolation
      body
      h1 Welcome #{current_user.name} to the show.
      | Unescaped #{{content}} is also possible.

  + Embedded engines (Markdown, …)
    coffee:
    square = (x) -> x * x

    markdown:
      #Header
        Hello from #{"Markdown!"}
        Second Line!

    p: markdown: Tag with **inline** markdown!