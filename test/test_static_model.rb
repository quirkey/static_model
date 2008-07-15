require File.dirname(__FILE__) + '/test_helper.rb'

class TestStaticModel < Test::Unit::TestCase

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
            assert_raise(StaticModel::BadOptions) do
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

        context "to_s" do
          should "inspect" do
            assert_equal @book.inspect, @book.to_s
          end
        end

      end

      context "on the class" do
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
              assert_raise(StaticModel::RecordNotFound) do
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

        context "find_first_by_*attribute*" do
          should "be equivalent to find_first_by(attribute,)" do
            assert_equal Book.find_first_by(:genre, 'Non-Fiction'), Book.find_first_by_genre('Non-Fiction')
          end
        end

        context "find_all_by_*attribute*" do
          should "be equivalent to find_all_by(attribute,)" do
            assert_equal Book.find_all_by(:genre, 'Non-Fiction'), Book.find_all_by_genre('Non-Fiction')
          end
        end

        context "count" do
          should "return the count of all records" do
            assert_equal Book.all.length, Book.count
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