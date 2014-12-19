require "test_helper"

class SelectFollowedByNoneTest < CheckTest

  def test_canonical_case_is_found
    assert_problems "[1,2,3].select {|x| x > 1 }.none?"
  end

  def test_requires_first_call_be_to_select
    assert_no_problems "[1,2,3].map {|x| x > 1 }.none?"
  end

  def test_requires_last_call_be_to_none
    assert_no_problems "[1,2,3].select {|x| x > 1 }.size"
  end

  def test_works_across_statements
    assert_problems "tmp = [1,2,3].select {|x| x > 1 } ; tmp.none?"
  end

  def test_will_not_flag_if_theres_an_intervening_method
    assert_no_problems "[1,2,3].select {|x| x > 1 }.map {|x| x+1 }.none?"
  end

  def test_will_not_flag_if_other_method_invoked_on_select_result
    assert_no_problems "tmp = [1,2,3].select {|x| x > 1 } ; tmp.reject! {|x| x } ; tmp.none?"
  end

  def test_will_not_flag_if_method_subsequently_invoked
    assert_no_problems "tmp = [1,2,3].select {|x| x > 1 } ; tmp. none? ; y = tmp.sort!"
  end

  def test_clear_fault_proc_should_not_error_out_if_line_not_removed
    str = <<-EOS
tmp = [1,2,3].select {|x| x > 4 }
tmp.none?
tmp = tmp.reject{|l| l.nil? }
tmp.map {|x| 1 }
EOS
    assert_no_problems str
  end

  def test_clear_fault_proc_should_attempt_to_clear_fault_using_line_of_fault_not_line_of_subsequent_call
    str = <<-EOS
tmp = [1,2,3].select {|x| x > 4 }
tmp.none?
tmp.first
EOS
  assert_no_problems str
  end
end
