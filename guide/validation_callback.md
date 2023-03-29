# Validation
  ## Why Use Validations?
   - Ensure only valid data is saved
   - Some way validation :  including native database constraints, client-side validations and controller-level validations.
  ## When Does Validation Happen?
  - new_record?
  - Validations are typically run before these commands are sent to the database
  - Before saved to database
  ## Methods trigger validations, just saved when valid
    - create, create!, save (return false), save!, update (return false), update!
    - note : '!' raise an exception if the record is invalid.
  ## Skipping Validations
      decrement, !, counter
      increment, !, counter

      insert, !, all, all!

      toggle!

      touch, all

      update: all, attribute, column, columns, counters

      upsert, all
  ## valid? and invalid?
    - valid? triggers your validations and returns true if no errors were found in the object, and false otherwise.
      vd :  Person.create(name: nil).valid? => false
    
    - invalid? returning true if any errors were found in the object, and false otherwise.

    - errors :  returns a collection of errors
      vd : p = Person.create
           p.errors?
    

  ## errors
    - It returns an array of all the error messages for :attribute, if no errors on the specified attribute, an empty array is returned.
    - This method is only useful after validations have been run, it only inspects the errors collection and does not trigger validations itself
      vd :person.errors[:name]
      => ["is too short (minimum is 3 characters)"]
    
    ### errors.details
      - errors : returns an instance of the class ActiveModel::Errors containing all errors, each error is represented by an ActiveModel::Error object.
          vd : 
          class Person < ApplicationRecord
              validates :name, presence: true, length: { minimum: 3 }
          end
          person.valid?
          person = Person.new
          person.valid?
          => false  
          irb> person.errors.full_messages
          => ["Name can't be blank", "Name is too short (minimum is 3 characters)"]
      
      - errors[] : is used when you want to check the error messages for a specific attribute. It returns an array of strings with all error messages for the given attribute.
          vd :  person.errors[:name]
              or
                person.errors[:name]
              => ["is too short (minimum is 3 characters)"]

      - errors.where : returns an array of error objects, filtered by various degree of conditions
          vd : person.errors.where(:name, :too_short).full_message
                                                      .attribute
                                                      .type
                                                      .options[:count]
                                                      .message
                                                      .full_message
      
      - errors.add
          vd_1 : class Person < ApplicationRecord
                  validate do |person|
                    errors.add :name, :too_plain, message: "is not cool enough"
                  end
                 end
          person.errors.where(:name).first.type => :too_plain
          person.errors.where(:name).first.full_message  => "Name is not cool enough"
          vd_2 : person.errors.add(:name, :blank)
                  person.errors.messages
                  => {:name=>["can't be blank"]}
                  person.errors.add(:name, :too_long, { count: 25 })
                  person.errors.messages
          vd_3 : it will raise ActiveModel::StrictValidationFailed instead of adding the error.
          person.errors.add(:name, :invalid, strict: true)
    
      - errors[:base] : 
        - Attribute should be set to :base if the error is not directly associated with a single attribute.
          vd: class Person < ApplicationRecord
            validate do |person|
              errors.add :base, :invalid, message: "This person is invalid because ..."
            end
          end
          vd : person.errors.add(:base, :name_or_email_blank, message: "either name or email must be present")
               person.errors.messages  => {:base=>["either name or email must be present"]}
            or
            person.errors.where(:base).first.full_message
            => "This person is invalid because ..."

      - errors.clear
        - An invalid object won't actually make it valid: the errors collection will now be empty, but the next time you call valid? or any method that tries to save this object to the database, the validations will run again
            vd :  person.errors.empty?
                => false
                  person.errors.clear
                  person.errors.empty?
                => true

      - errors.size
        -  Returns the total number of errors for the object.
  
  ## Validation Helpers
    - Can use directly inside your class definitions
    - Every time a validation fails, an error is added to the object's errors collection
    
    ### acceptance 
      - Validates that a checkbox on the user interface was checked when a form was submitted
      - Used when the user needs to agree to your application's terms of service, confirm that some text is read, or any similar concept.
      - The default error message for this helper is "must be accepted"
        vd :
          class Person < ApplicationRecord
            validates :terms_of_service, acceptance: true
          end
      - Can also pass in a custom message via the message option.
          vd : validates :terms_of_service, acceptance: { message: 'must be abided' }
      
      - :accept
          vd:  validates :terms_of_service, acceptance: { accept: 'yes' }
               validates :eula, acceptance: { accept: ['TRUE', 'accepted'] }
    ### validates_associated
      - Use this helper when your model has associations with other models and they also need to be validated. 
      - When you try to save your object, valid? will be called upon each one of the associated objects.
          vd : class Library < ApplicationRecord
                has_many :books
                validates_associated :books
               end
      - The default error message for validates_associated is "is invalid".
    
    ### confirmation
      - Use this helper when you have two text fields that should receive exactly the same content
      - You may want to confirm an email address or a password. 
        vd : 
            class Person < ApplicationRecord
              validates :email, confirmation: true
              validates :email_confirmation, presence: true
            end
            <%= text_field :person, :email %>
            <%= text_field :person, :email_confirmation %>
      - There is also a :case_sensitive option that you can use to define whether the confirmation constraint will be case sensitive or not. This option defaults to true.
            class Person < ApplicationRecord
              validates :email, confirmation: { case_sensitive: false }
            end
    
    ### comparison
      -  Validate a comparison between any two comparable values
            vd : class Promotion < ApplicationRecord
                  validates :start_date, comparison: { greater_than: :end_date }
                 end
    
    ### exclusion
      - Validates that the attributes' values are not included in a given set. In fact, this set can be any enumerable object.
      - Has an option :in that receives the set of values that will not be accepted for the validated attributes. The :in option has an alias called :within that you can use for the same purpose, if you'd like to.

      vd : class Account < ApplicationRecord
              validates :subdomain, exclusion: { in: %w(www us ca jp),
                message: "%{value} is reserved." }
            end
    
    ### format
      -  Validates the attributes' values by testing whether they match a given regular expression, which is specified using the :with option.
        vd : class Product < ApplicationRecord
              validates :legacy_code, format: { with: /\A[a-zA-Z]+\z/,
                message: "only allows letters" }
             end
      - Alternatively, you can require that the specified attribute does not match the regular expression by using the :without option.

    ### length
       vd : validates :bio, length: { maximum: 500 }
            validates :password, length: { in: 6..20 }
            validates :registration_number, length: { is: 6 }

    ### numericality
        vd : validates :points, numericality: true
              validates :games_played, numericality: { only_integer: true }

    ### presence
        vd : validates :name, presence: true

    ### absence 
        vd : validates :name, :login, :email, absence: true

    ### uniqueness
        vd: validates :email, uniqueness: true
        or 
          validates :name, uniqueness: { scope: :year,
          message: "should happen once per year" }
    
    ### validates_with
     vd : class GoodnessValidator < ActiveModel::Validator
            def validate(record)
              if record.first_name == "Evil"
                record.errors.add :base, "This person is evil"
              end
            end
          end

          class Person < ApplicationRecord
            validates_with GoodnessValidator
          end
    
    ### validates_each
    class Person < ApplicationRecord
      validates_each :name, :surname do |record, attr, value|
        record.errors.add(attr, 'must start with upper case') if value =~ /\A[[:lower:]]/
      end
    end

  ## Common Validation Options
    - allow_nil : skips the validation when the value being validated is nil.
        vd: class Coffee < ApplicationRecord
            validates :size, inclusion: { in: %w(small medium large),
              message: "%{value} is not a valid size" }, allow_nil: true
          end
    
    - allow_blank : 
        vd : validates :title, length: { is: 5 }, allow_blank: true

    - :message : 
          vd: validates :name, presence: { message: "must be given please" }

    - :on :
          vd: validates :email, uniqueness: true, on: :create
        or 
            validates :email, uniqueness: true, on: :account_setup
            validates :age, numericality: true, on: :account_setup

            person.valid?(:account_setup)
            => false
            person.errors.messages
            => {:email=>["has already been taken"], :age=>["is not a number"]}

  ## Conditional Validation
     + Using a Symbol with :if and :unless
          validates :card_number, presence: true, if: :paid_with_card?
          def paid_with_card?
            payment_type == "card"
          end
      + Using a Proc with :if and :unless
          class Account < ApplicationRecord
            validates :password, confirmation: true,
              unless: Proc.new { |a| a.password.blank? }
          end
      + Grouping Conditional validations
          class User < ApplicationRecord
            with_options if: :is_admin? do |admin|
              admin.validates :password, length: { minimum: 10 }
              admin.validates :email, presence: true
            end
          end
      + Combining Validation Conditions
          class Computer < ApplicationRecord
            validates :mouse, presence: true,
                              if: [Proc.new { |c| c.market.retail? }, :desktop?],
                              unless: Proc.new { |c| c.trackpad.present? }
          end

  ## Custom validation
    ### Custom Validators
        class MyValidator < ActiveModel::Validator
          def validate(record)
            unless record.name.start_with? 'X'
              record.errors.add :name, "Need a name starting with X please!"
            end
          end
        end

        class Person
          include ActiveModel::Validations
          validates_with MyValidator
        end
   ### Custom Method
      


# Callback
  ## The Object Life Cycle
    - During the normal operation of a Rails application, objects may be created, updated, and destroyed. Active Record provides hooks into this object life cycle so that you can control your application and its data.
    - Callbacks allow you to trigger logic before or after an alteration of an object's state.
  ## Callbacks Overview
      - Callbacks are methods that get called at certain moments of an object's life cycle. With callbacks it is possible to write code that will run whenever an Active Record object is created, saved, updated, deleted, validated, or loaded from the database.  
   ### Callback Registration
      - to use the available callbacks, you need to register them.
      vd : before_validation :ensure_login_has_a_value
            private
              def ensure_login_has_a_value
                if login.nil?
                  self.login = email unless email.blank?
                end
              end
      vd : validates :login, :email, presence: true 
           before_create do
            self.name = login.capitalize if name.blank?
           end
      
      vd: before_validation :normalize_name, on: :create
          => :on takes an array as well
          after_validation :set_location, on: [ :create, :update ]
          private
            def normalize_name
              self.name = name.downcase.titleize
            end

            def set_location
              self.location = LocationService.query(self)
            end
  ## Available Callbacks
   #### Creating, updating an Object
      - before_validation
      - after_validation
      - before_save
      - around_save
      - before_create
      - around_create
      - after_create
      - after_save
      - after_commit / after_rollback
       
       note : 
            + after_save runs both on create and update, but always after the more specific callbacks after_create and after_update.

            + don't call update(attribute: "value") within a callback:
              - you can safely assign values directly (for example, self.attribute = "value") in before_create / before_update or earlier callbacks.

            + before_destroy callbacks should be placed before dependent: :destroy associations (or use the prepend: true option), to ensure they execute before the records are deleted
   #### Destroying an Object
      - before_destroy
      - around_destroy
      - after_destroy
      - after_commit / after_rollback
   #### after_initialize and after_find
      * The after_initialize callback will be called whenever an Active Record object is instantiated, either by directly using new or when a record is loaded from the database
      -  It can be useful to avoid the need to directly override your Active Record
      * The after_find callback will be called whenever Active Record loads a record from the database. after_find is called before after_initialize if both are defined.
      vd: 
          after_initialize do |user|
            puts "You have initialized an object!"
          end

          after_find do |user|
            puts "You have found an object!"
          end
      =>  User.new, User.first
   #### after_touch
        * The after_touch callback will be called whenever an Active Record object is touched.
        vd:  after_touch do |user|
              puts "You have touched an object"
            end
        =>  u = User.create(name: 'Kuldeep')
        =>  u.touch => true

        * It can be used along with belongs_to:
  ## Running Callbacks
    - Methods trigger callbacks:
        + create
        + create!
        + destroy
        + destroy!
        + destroy_all
        + destroy_by
        + save
        + save!
        + save(validate: false)
        + toggle!
        + touch
        + update_attribute
        + update
        + update!
        + valid?
    - Additionally, the "after_find" callback is triggered by the following finder methods:
        + all
        + first
        + find
        + find_by
        + find_by_*
        + find_by_*!
        + find_by_sql
        + last
    - The after_initialize callback is triggered every time a new object of the class is initialized
  ## Skipping Callbacks
        decrement, !, counter
        increment, !, counter

        delete, all, by

        insert, !, all, all!

        touch:all

        update: all, column, columns, counters

        upsert, all
  ## Conditional Callbacks
   ### Using :if and :unless with a Symbol
      vd : class Order < ApplicationRecord
              before_save :normalize_card_number, if: :paid_with_card?
            end 
   ### Using :if and :unless with a Proc
      vd : before_save :normalize_card_number,
            if: Proc.new { |order| order.paid_with_card? }
  
   ### Using both :if and :unless
       vd:  before_save :filter_content,
            if: Proc.new { forum.parental_control? },
            unless: Proc.new { author.trusted? }
   ### Multiple Callback Conditions
       vd: before_save :filter_content,
        if: [:subject_to_parental_control?, :untrusted_author?]
  ## Transaction Callbacks
    vd : 
    PictureFile.transaction do
      picture_file_1.destroy
      picture_file_2.save!
    end
    after_commit :delete_picture_file_from_disk, on: :destroy
    def delete_picture_file_from_disk
      if File.exist?(filepath)
        File.delete(filepath)
      end
    end
  ## Halting Execution
