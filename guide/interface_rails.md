
<!-- 
Class Author
  has_one :book
end

Class Book
  belongs_to :author
end 

module Pagination
  def page(number)
    puts "this is a #{number}"
  end
end

author = Author

-->
  
  # Retrieving Objects from the Database  
    + annotate 
      vd : author.annotate('Select name to show name of all author').select(:name)

    + find 
      vd : author.find(1)  -> ActiveRecord_Relation
      author.find([1,2]) -> array

    + create_with (Sets attributes to be used when creating new records from a relation object.)
      vd : author = Author.where(name:'Leroi')
           author = author.create_with(name: 'SonTung')

    + distinct
      vd : author = Author.select(:name).distinct
         -> un_distinct : Author.select(:name).distinct.distinct(false)

    + eager_load
      vd : author = Author.eager_load(:books)

    + extending 
    <!-- (Used to extend a scope with additional methods, either through a module or through a block provided.) -->
      
      vd: scope = Author.all.extending(Pagination)
          scope.page(param[:page])
      or
          scope = Model.all.extending <!--(module khac)--> do
            def page(number)
              # pagination code goes here
            end
          end
          scope.page(params[:page])

    + extract_associated
        vd : author.books.extract_associated(:user)
             short-hand: author.books.preload(:user).collect(&:user)

    + from
        vd : Author.select('publisted_at').from('books')
            
    + group
        vd : Author.group(:name)

    + having
        vd : Author.having('id > 1').group('name')

    + includes
        vd : Author.includes(:books)

    + joins -> perform inner join
        vd : Author.joins(:books)
             Author.joins(:books, :procedues)
             Author.joins(books: [:review])

    + left_outer_joins
        vd : Author.left_outer_joins(:books)

    + limit
        vd : Author.where('id >1').limit(2)

    + lock
        vd : 

    + none (Returns a chainable relation with zero records.)
        vd : Author.none

    + offset
        vd: Author.offset(1).select(:name)

    + optimizer_hints (Specify optimizer hints to be used in the SELECT statement)
        vd : Author.optimizer_hints('Select name to get name of Author')

    + order
        vd : Author.order(:name) or Author.order(:name, email: :desc)

    + preload
        vd : Author.preload(:books)
        -> SELECT "books".* FROM "books" WHERE "books"."author_id" IN (1, 2, 3)

    + readonly
        vd : author = Author.readonly
             author.first.save

    + references
        vd : Author.includes(:books).where("books.name = 'foo'").references(:books)

    + reorder (Replaces any existing order defined on the relation with the specified order)
        vd : Author.order('name DESC').reorder('id ASC')

    + reselect (takes a block so it can be used just like Array#select)
        vd : Author.select(:id).reselect(:created_at)
           

    + reverse_order
        vd : Author.order('name ASC').reverse_order  # generated SQL has 'ORDER BY name DESC'

    + select (takes a block so it can be used just like Array#select)
        vd :  Author.all.select { |m| m.field == value }
    
    + where
        vd : Author.where(id:1)


  # Retrieving a Single Object
    + find
    + take
    + first
    + last
    + find_by -> Author.find_by name: 'Lifo'
  
  # Retrieving Multiple Objects in Batches
  + find_each (batch_size: 1000 or (start :2000 or finish:2010))
      vd : Customer.find_each do |customer|
            NewsMailer.weekly(customer).deliver_now
          end

  + find_in_batches (batch_size: 1000 or (start :2000 or finish:2010)
  vd : Give add_customers an array of 1000 customers at a time.
        Customer.find_in_batches do |customers|
          export.add_customers(customers)
        end

  # Condition
  +  Placeholder Conditions (?)
    vd:    LIKE -> Book.where("title LIKE ?", params[:title] + "%")
  + Pure String Conditions
      vd : Book.where("title = 'Introduction to Algorithms'")

  # Array Conditions
    + Book.where("title = ?", params[:title])
    + Book.where("title = ? AND out_of_print = ?", params[:title], false)


  # Hash condition
    + Equality Conditions
        vd :Book.where(out_of_print: true)
    + Range Conditions
      vd : Book.where(created_at: (Time.now.midnight - 1.day)..Time.now.midnight)
    + Subset Conditions (IN)
      vd : Customer.where(orders_count: [1..3])

  # NOT Conditions
    vd : Customer.where.not(orders_count: [1,3,5])

  # Ordering
    vd : Book.order(:created_at) or Book.order(created_at: :desc)

  # Selecting Specific Fields
    vd : Book.select(:isbn, :out_of_print)

  #  Limit and Offset
    vd : Author.limit(5)
          Author.offset(3)

  
  #  Overriding Conditions
    + unscope
      vd : Book.where(id: 10, out_of_print: false).unscope(where: :id)
           <!-- SELECT books.* FROM books WHERE out_of_print = 0 -->
    + only
       vd : Book.where('id > 10').limit(20).order('id desc').only(:order, :where)
       <!-- SELECT * FROM books WHERE id > 10 ORDER BY id DESC
                Original query without `only`
            SELECT * FROM books WHERE id > 10 ORDER BY id DESC LIMIT 20 -->

    + reselect
        vd : Book.select(:title, :isbn).reselect(:created_at)
    
    + reorder
        vd: User.order('email DESC').reorder('id ASC') 
    
    + reverse_order
        vd : User.order('name ASC').reverse_order 
        <!-- generated SQL has 'ORDER BY name DESC' -->
    
    +  rewhere
        vd : Post.where(trashed: true).rewhere(trashed: false)
    
  # Jointable
         
      vd : Author.joins("INNER JOIN books ON books.author_id = authors.id AND books.out_of_print = FALSE")

      + Book.joins(:reviews)

      + Book.joins(reviews: :customer)
      <!-- SELECT books.* FROM books
      INNER JOIN reviews ON reviews.book_id = books.id
      INNER JOIN customers ON customers.id = reviews.customer_id -->
  
  # left_outer_joins
      vd : Customer.left_outer_joins(:reviews).distinct.select('customers.*, COUNT(reviews.*) AS reviews_count').group('customers.id')

  # Eager Loading Associations
        + includes
        + preload
        + eager_load
    
  # Finding by SQL
        + select_all
            vd : Customer.connection.select_all("SELECT first_name, created_at FROM customers WHERE id = '1'").to_a
        
        +  pluck
            vd : Book.where(out_of_print: true).pluck(:id) or Customer.pluck(:id, :first_name)
           <!-- Customer.select(:id, :first_name).map { |c| [c.id, c.first_name] } -->
        
        + ids
            vd : Customer.ids
    
  # Existence of Objects
          + exists? or(any? -> return limit(1) or many? -> return count(*))
              vd : Customer.exists?(id: [1,2,3])
          
  # Calculations
        + count 
            vd : Customer.where(first_name: 'Ryan').count
        + Average
            vd : Order.average("subtotal")
        +  Minimum
            vd : Order.minimum("subtotal")
        + Maximum
            vd: Order.maximum("subtotal")
        +  Sum
            vd: Order.sum("subtotal")
    
  # Scope
      + vd :  
        class Book < ApplicationRecord
          scope :out_of_print, -> { where(out_of_print: true) }
        end
      
      +  Passing in arguments
        vd : 
        class Book < ApplicationRecord
          scope :costs_more_than, ->(amount) { where("price > ?", amount) }
        end
          -> Book.costs_more_than(100.10)
      
      + Using conditionals
        vd:
          class Order < ApplicationRecord
            scope :created_before, ->(time) { where("created_at < ?", time) if time.present? }
          end
      
      + Applying a default scope
        vd :
        class Book < ApplicationRecord
          default_scope { where(out_of_print: false) }
        end

      + Merging of scopes
        vd : 
        class Book < ApplicationRecord
          scope :in_print, -> { where(out_of_print: false) }
          scope :out_of_print, -> { where(out_of_print: true) }
        end
      
      + Removing all scoping
        vd : 
         Book.where(out_of_print: true).unscoped.all
         or Book.unscoped.load
         or Book.unscoped { Book.out_of_print }
      
      ActiveRecord::Relation (where or group)