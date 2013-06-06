require 'test_helper'

class BitPayHelperTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations
  
  def setup
    @helper = BitPay::Helper.new('order-500','cody@example.com', :amount => '5.00', :currency => 'USD')
  end
 
  def test_basic_helper_fields
    assert_field 'api_key', 'cody@example.com'

    assert_field 'price', '5.00'
    assert_field 'orderID', 'order-500'
  end
  
  def test_customer_fields
    @helper.customer :first_name => 'Cody', :last_name => 'Fauser', :email => 'cody@example.com', :phone => '555-1234'
    assert_field 'buyerName', 'Cody Fauser'
    assert_field 'buyerEmail', 'cody@example.com'
    assert_field 'buyerPhone', '555-1234'
  end

  def test_address_mapping
    @helper.billing_address :address1 => '1 My Street',
                            :address2 => 'apt 42',
                            :city => 'Leeds',
                            :state => 'Yorkshire',
                            :zip => 'LS2 7EE',
                            :country  => 'CA'
   
    assert_field 'buyerAddress1', '1 My Street'
    assert_field 'buyerAddress2', 'apt 42'
    assert_field 'buyerCity', 'Leeds'
    assert_field 'buyerState', 'Yorkshire'
    assert_field 'buyerZip', 'LS2 7EE'
    assert_field 'buyerCountry', 'CA'
  end
  
  def test_unknown_address_mapping
    @helper.billing_address :farm => 'CA'
    assert_equal 3, @helper.fields.size
  end

  def test_unknown_mapping
    assert_nothing_raised do
      @helper.company_address :address => '500 Dwemthy Fox Road'
    end
  end
  
  def test_setting_invalid_address_field
    fields = @helper.fields.dup
    @helper.billing_address :street => 'My Street'
    assert_equal fields, @helper.fields
  end
end