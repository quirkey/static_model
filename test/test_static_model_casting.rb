require File.dirname(__FILE__) + '/test_helper.rb'

class TestStaticModelCasting < Test::Unit::TestCase

  context "Static Model" do
    context "Casting" do
      context "with no options" do
        should "raise error" do
          assert_raise(StaticModel::BadOptions) do
            Project.send(:cast, :name)
          end
        end
      end

      context "with :to => :integer" do
        setup do
          Project.module_eval do
            cast :num_pages, :to => :integer
          end
          @project = Project[3]
        end

        should "force attribute into an integer" do
          assert_equal 123456, @project.num_pages
        end

        should "still return nil when attribute is not set" do
          @project.num_pages = nil
          assert_nil @project.num_pages
        end
      end

      context "with :to => :time" do
        setup do
          Project.module_eval do
            cast :updated_at, :to => :time
          end
          @project = Project[3]
        end

        should "parse string time into Time" do
          assert @project.updated_at.is_a?(Time)
          assert_equal 1.day.ago.day, @project.updated_at.day
        end

        should "still return nil when attribute is not set" do
          @project.updated_at = nil
          assert_nil @project.updated_at
        end
      end

      context "with a block" do
        setup do
          @internal_value = nil
          Project.module_eval do
            cast :name do |name|
              @internal_value = name
              name.upcase
            end
          end
          @project = Project[3]
        end

        should "pass attribute value to the block when called" do
          assert_equal 'My last project', @internal_value
        end

        should "return result of block" do
          assert_equal 'MY LAST PROJECT', @project.name
        end

        should "still return nil when attribute is not set" do
          @project.name = nil
          assert_nil @project.name
        end
      end

    end 
  end

end