require "helper"

class StaticModel::AssociationsTest < Minitest::Test

  context "a static model class" do

    context "with a has many association" do
      context "to another static model" do
        # Author has many books
        setup do
          @author = Author.find(1)
        end

        should "respond to association name" do
          assert @author.books
        end

        should "return an array of association instances if association is a StaticModel" do
          assert_set_of Book, @author.books
        end

        should "find books by foreign_key" do
          assert_equal Book.find_all_by_author_id(@author.id), @author.books
        end

        should "add association to associations" do
          assert Author.associations.has_key?(:books)
        end

        should "have HasManyAssociation in associations" do
          assert Author.associations[:books].is_a?(StaticModel::Associations::HasManyAssociation)
        end
      end

      context "to an active record model" do
        setup do
          @author = Author.find(1)
          Article.expects(:scoped).returns([Article.new, Article.new])
        end

        should "respond to association name" do
          assert @author.articles
        end

        should "return an array of association instances if association is a StaticModel" do
          assert_set_of Article, @author.articles
        end

      end
    end


    context "with a belongs to association" do
      context "to another static model" do
        # Author belongs to publisher
        setup do
          @author = Author.find(1)
        end

        should "respond to association name" do
          assert @author.publisher
        end

        should "return a single instance" do
          assert @author.publisher.is_a?(Publisher)
        end

        should "find publisher by foreign key" do
          assert_equal Publisher.find(1), @author.publisher
        end

        should "add association to associations" do
          assert Author.associations.has_key?(:publisher)
        end

        should "have BelongsTo association in associations" do
          assert Author.associations[:publisher].is_a?(StaticModel::Associations::BelongsToAssociation)
        end

        context "when foreign key is nil" do
          setup do
            @author = Author.find(2)
          end

          should "respond to association name and return nil" do
            assert_nil @author.publisher
          end
        end
      end
    end

  end
end
