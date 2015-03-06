require "helper"

class StaticModelTest < Minitest::Test

  context "StaticModel" do
    context "A class that inherits from Base" do
      context "an instance" do

        setup do
          @book = Book.new(book_params)
        end

        context "initialization" do

          should "set attributes with a hash" do
            assert @book.id
          end

          should "raise error if passed anything but hash" do
            assert_raises(StaticModel::BadOptions) do
              Book.new("im bad")
            end
          end
        end

        context "attributes" do
          should "get attributes by methods" do
            assert_equal book_params[:title], @book.title
            assert_equal book_params[:genre], @book.genre
          end

          should "set attributes by methods" do
            @book.title = 'New Title'
            assert_equal 'New Title', @book.title
          end
        end

        context "attribute" do
          should "define methods for the attribute" do
            book = Book[1]
            assert book.respond_to?(:rating)
            assert book.respond_to?(:rating=)
            assert book.respond_to?(:rating?)
            assert_equal 5, book.rating
          end

          should "return the default if attribute is not set" do
            book = Book[2]
            assert book.respond_to?(:rating)
            assert book.respond_to?(:rating=)
            assert book.respond_to?(:rating?)
            assert_equal 3, book.rating
          end

          should "freeze the attribute" do
            book = Book[1]
            assert book.read?
            book.read = false
            assert book.read?
          end

        end

        context "has_attribute?" do
          should "return false if attribute doesn't exist" do
            assert !@book.has_attribute?(:blurgh)
          end

          should "return true if attribute exists" do
            assert @book.has_attribute?(:id)
            assert @book.has_attribute?(:title)
          end
        end

        context "comparing" do

          should "be equal to an instance of the same class with same id" do
            assert_equal @book, Book.new(book_params)
          end

          should "not be equal to an instance with the same class with different ids" do
            refute_equal Book[1], @book
          end

          should "not be equal to an instance with different classes and the same ids" do
            refute_equal Book[1], Author[1]
          end
        end

        context "respond_to?" do
          context 'with attributes explicitly set' do
            setup do
              @book = Book[1]
            end

            should 'respond_to? attribute methods' do
              assert @book.respond_to?(:rating)
              assert @book.respond_to?(:rating=)
            end
          end

          context 'with attributes inferred from data file' do
            setup do
              @book = BookWithInferredAttributes[1]
            end

            should 'respond_to? attribute methods' do
              assert @book.respond_to?(:rating)
              assert @book.respond_to?(:rating=)
            end
          end
        end

      end

      context "on the class" do
        context "set data file" do
          context "After the class is defined" do

            setup do
              @book = Book.find(1)
              @author = Author.find(1)
              @original_data_file = Book.data_file
              @data_file = File.join(File.dirname(__FILE__), 'data', 'authors.yml')
              Book.set_data_file @data_file
              @new_book = Book.find(1)
            end

            should "set the @data_file" do
              assert_equal @data_file, Book.data_file
            end

            should "reload with next find" do
              assert_equal @author.attributes, @new_book.attributes
            end

            teardown do
              Book.set_data_file @original_data_file
            end
          end
        end

        context "next_id" do
          context "if id's were automaticaly assigned" do
            should "be length + 1" do
              Store.load
              assert_equal Store.count + 1, Store.next_id
            end
          end

          context "if ids were manualy assigned" do
            should "be 1 after the last id" do
              Publisher.load
              assert_equal 8, Publisher.next_id
            end
          end
        end

        context "where the records are defined without ids" do
          setup do
            Store.reload!
          end

          context "loading" do
            setup do
              @stores = Store.all
            end

            should "automaticaly assign ids" do
              @stores.each do |store|
                assert store.id
                assert store.id.is_a?(Fixnum)
              end
            end

            should "assign next id" do
              assert Store.next_id
              assert_equal 3, Store.next_id
            end
          end

          context "initializing without id" do
            setup do
              @store = Store.new({:name => 'Metro Comics', :city => 'New York'})
            end

            should "return instance" do
              assert @store.is_a?(Store)
            end

            should "set attributes" do
              assert_equal 'New York', @store.city
            end

            should "assign id from next id" do
              assert_equal 3, @store.id
            end

            should "increment next_id" do
              assert_equal 4, Store.next_id
            end

          end
        end

        context "loading a data_file with embedded erb" do
          setup do
            @projects = Project.all
          end

          should "evaluate erb expressions at load time" do
            assert_equal "Thu, 05 Feb 2015 00:32:43 UTC +00:00", @projects.first.created_at.to_s
          end

          should "evaluate erb in current context" do
            assert_equal Author.first, @projects[1].author
          end
        end

        context "find" do

          context "with an integer" do
            setup do
              @book = Book.find(1)
            end

            should "set loaded?" do
              assert Book.loaded?
            end

            should "load by id" do
              assert_equal 1, @book.id
            end

            should "return instance of klass" do
              assert @book.is_a?(Book)
            end

            should "raise error if cant find record with id" do
              assert_raises(StaticModel::RecordNotFound) do
                @book = Book.find(1000)
              end
            end
          end
        end

        context "[]" do
          should "be an alias for find by id" do
            assert_equal Book.find(1), Book[1]
          end
        end

        context "find(:all)" do
          should "be an alias for find_all" do
            assert_equal Book.find_all, Book.find(:all)
          end
        end
        context "find(:first)" do
          should "be an alias for find_first" do
            assert_equal Book.find_first, Book.find(:first)
          end
        end
        context "find(:last)" do
          should "be an alias for find_last" do
            assert_equal Book.find_last, Book.find(:last)
          end
        end

        context "all" do
          should "be an alias for find_all" do
            assert_equal Book.all, Book.find(:all)
          end
        end
        context "first" do
          should "be an alias for find_first" do
            assert_equal Book.first, Book.find(:first)
          end
        end
        context "last" do
          should "be an alias for find_last" do
            assert_equal Book.last, Book.find(:last)
          end
        end

        context "find_first" do
          setup do
            @book = Book.find_first
          end

          should "return the first instance from all records" do
            assert_equal Book.find_all.first, @book
          end

          should "return instance of klass" do
            assert @book.is_a?(Book)
          end
        end

        context "find_last" do
          setup do
            @book = Book.find_last
          end

          should "return the last instance from all records" do
            assert_equal Book.find_all.last, @book
          end

          should "return an instance of klass" do
            assert @book.is_a?(Book)
          end
        end

        context "find_all" do
          setup do
            @books = Book.find_all
          end

          should "return an array" do
            assert @books.is_a?(Array)
          end

          should "return all records" do
            assert_equal 4, @books.length
          end

          should "return set of klass instances" do
            @books.each do |book|
              assert book.is_a?(Book)
            end
          end

          context "with an empty data file" do
            setup do
              @original_data_file = Book.data_file
              @data_file = File.join(File.dirname(__FILE__), 'data', 'empty.yml')
              Book.set_data_file @data_file
            end

            should "return an empty array" do
              assert_equal [], Book.find_all
            end

            teardown do
              Book.set_data_file @original_data_file
            end

          end
        end

        context "find_first_by" do
          setup do
            @author = 'Michael Pollan'
            @book = Book.find_first_by(:author,@author)
          end

          should "return an instance of klass" do
            assert @book.is_a?(Book)
          end

          should "return record matching search" do
            assert @author, @book.author
          end

          context "when there is no match" do
            should "return nil" do
              assert_nil Book.find_first_by(:author,'Aaron Quint')
            end
          end
        end

        context "find_last_by" do
          setup do
            @author = 'Chuck Palahniuk'
            @book = Book.find_last_by(:author, @author)
          end

          should "return an instance of klass" do
            assert @book.is_a?(Book)
          end

          should "return record matching search" do
            assert @author, @book.author
          end

          context "when there is no match" do
            should "return nil" do
              assert_nil Book.find_last_by(:author, 'Michael R. Bernstein')
            end
          end
        end

        context "find_by" do
          setup do
            @author = 'Michael Pollan'
            @book = Book.find_by(:author,@author)
          end

          should "return an instance of klass" do
            assert @book.is_a?(Book)
          end

          should "return record matching search" do
            assert @author, @book.author
          end

          context "when there is no match" do
            should "return nil" do
              assert_nil Book.find_by(:author,'Aaron Quint')
            end
          end

        end

        context "find_all_by" do
          setup do
            @author = 'Michael Pollan'
            @books = Book.find_all_by(:author,@author)
          end

          should "return an array" do
            assert @books.is_a?(Array)
          end

          should "return all records that match search" do
            @books.each {|b| assert_equal @author, b.author}
          end

          should "return set of klass instances" do
            @books.each {|b| assert b.is_a?(Book) }
          end

          context "when there is no match" do
            should "return an empty array" do
              assert_equal [], Book.find_all_by(:author,'Aaron Quint')
            end
          end
          context "when there is only one match" do
            should "return an array" do
              assert_equal [Book.find(3)], Book.find_all_by(:author,'Piers Anthony')
            end
          end
        end

        context "dynamic finders" do
          setup do
            @book = Book.first
          end

          context "find_by_*attribute*" do
            should "be equivalent to find_first_by(attribute,)" do
              assert_equal @book, Book.find_first_by(:genre, 'Non-Fiction')
              assert_equal Book.find_first_by(:genre, 'Non-Fiction'), Book.find_by_genre('Non-Fiction')
            end
          end

          context "find_first_by_*attribute*" do
            should "be equivalent to find_first_by(attribute,)" do
              assert_equal @book, Book.find_first_by(:genre, 'Non-Fiction')
              assert_equal Book.find_first_by(:genre, 'Non-Fiction'), Book.find_first_by_genre('Non-Fiction')
            end
          end

          context "find_all_by_*attribute*" do
            should "be equivalent to find_all_by(attribute,)" do
              assert_equal Book.find_all_by(:genre, 'Non-Fiction'), Book.find_all_by_genre('Non-Fiction')
            end
          end
        end

        context "count" do
          should "return the count of all records" do
            assert_equal Book.all.length, Book.count
          end
        end

        context "with a class with yaml class vars" do
          setup do
            @pages = Page.all
          end

          should "load :records into @records" do
            assert_set_of Page, @pages
            assert Page.loaded?
          end

          should "give access to top level attributes as class methods" do
            assert_equal 'http://www.quirkey.com', Page.url
            assert_equal 'The Best Ever', Page.title
          end

          should "return a hash for class attribute" do
            assert Page.settings.is_a?(Hash)
            assert_equal 'test', Page.settings['username']
          end

          should "have class attributes appear as record accessor defaults if none exist" do
            assert_equal 'http://www.quirkey.com', Page[1].url
          end

          should "not overwrite record specific methods" do
            assert_equal 'http://github.com', Page[2].url
          end

          context "class_attributes" do
            setup do
              @attributes = Page.class_attributes
            end

            should "return a hash of all top level settings" do
              assert @attributes.is_a?(Hash)
              assert_equal 3, @attributes.length
              assert_equal 'http://www.quirkey.com', @attributes['url']
            end
          end
        end

      end
    end
  end

  protected
  def book_params
    {:id => 15, :title => 'Lord of the Rings', :author => 'J.R. Tolkien', :genre => 'Fantasy'}
  end


end
