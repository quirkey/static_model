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

  end
end