require File.dirname(__FILE__) + '/test_helper.rb'

class TestStaticModel < Test::Unit::TestCase

  context "a static model class" do

    context "with a has many association" do
      context "to another static model" do
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
        
        should "return an association proxy" do
          assert @author.books.is_association_proxy?
        end
      end

      context "to an active record model" do
        setup do
          @author = Author.find(1)
          Article.expects(:with_scope).returns([Article.new, Article.new])
        end

        should "respond to association name" do
          assert @author.articles
        end

        should "return an association proxy" do
          assert @author.articles.is_association_proxy?
        end

        should "return an array of association instances if association is a StaticModel" do
          assert_set_of Article, @author.articles
        end

      end
    end

  end
end