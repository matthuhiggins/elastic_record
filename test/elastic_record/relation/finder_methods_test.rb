require 'helper'

class ElasticRecord::Relation::FinderMethodsTest < MiniTest::Spec
  def setup
    Widget.reset_index!
    create_widgets
  end

  def test_find
    refute_nil Widget.relation.find('05')
    refute_nil Widget.relation.filter('color' => 'red').find('05')
    assert_nil Widget.relation.filter('color' => 'blue').find('05')
  end

  def test_first
    assert_equal '05', Widget.relation.first.id
    assert_equal '05', Widget.relation.filter('color' => 'red').first.id
    assert_equal '10', Widget.relation.filter('color' => 'blue').first.id
    assert_nil Widget.relation.filter('color' => 'green').first
  end

  def test_last
    assert_equal '10', Widget.relation.last.id
    assert_equal '05', Widget.relation.filter('color' => 'red').last.id
    assert_equal '10', Widget.relation.filter('color' => 'blue').last.id
    assert_nil Widget.relation.filter('color' => 'green').last
  end

  def test_all
    assert_equal 2, Widget.relation.all.size
    assert_equal 1, Widget.relation.filter('color' => 'red').all.size
  end

  private

    def create_widgets
      Widget.elastic_connection.index({'widget' => {'color' => 'red'}}, {index: 'widgets', type: 'widget', id: '05'})
      Widget.elastic_connection.index({'widget' => {'color' => 'blue'}}, {index: 'widgets', type: 'widget', id: '10'})
      
      Widget.elastic_connection.refresh
    end
end