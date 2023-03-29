# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create(last_name:"Nguyen",first_name:"An",email:"an@gmail.com",active:true)
User.create(last_name:"Tran",first_name:"Van Son",email:"son@gmail.com", active:false)
User.create(last_name:"Le",first_name:"Thi Hong",email:"hong@gmail.com", active:true)