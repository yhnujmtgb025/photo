# belongs_to
  + association
      author = book.author
      author = book.reload_author
  
  + association=(associate)
      @book.author = @author
  
  + build_association(attributes = {})
      @author = @book.build_author(author_number: 123, author_name: "John Doe")
    
  + create_association(attributes = {})
      @author = @book.create_author(author_number: 123, author_name: "John Doe")

  + create_association!(attributes = {})
      raises ActiveRecord::RecordInvalid if the record is invalid.

  + association_changed?
      @book.author # => <Book author_number: 123, author_name: "John Doe">
      @book.author_changed?  => false

      @book.author = Author.second # => <Book author_number: 456, author_name: "Jane Smith">
      @book.author_changed?
  
  + association_previously_changed?
      @book.author  => <Book author_number: 123, author_name: "John Doe">
      @book.author_previously_changed?  => false

      @book.author = Author.second # => <Book author_number: 456, author_name: "Jane Smith">
      @book.save!
      @book.author_previously_changed? 

# has_many
  +collection
    @books = @author.books
  