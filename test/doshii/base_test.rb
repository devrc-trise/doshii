module BaseTest
  CREATE_LOCATION_PARAMS = {
    name: 'Starbucks', mobility: 'fixed', availability: 'open',
    address_line1: '1/11-31 York Street', city: 'Sydney', state: 'NSW',
    postalCode: '2000', country: 'AU', phoneNumber: '+61 2 9299 2126',
    latitude: '-33.86532', longitude: '151.20535',
    modeConfigured: true, restaurantMode: 'bistro'
  }
  CREATE_CHECKIN_PARAMS = {
    name: 'John Smith', externalId: 'ias2kk2',
    photoURL: 'http://example.com/profile.png'
  }
  CREATE_CHECKIN_PARAMS2 = {
    name: 'William Smith', externalId: 'ias2kk3',
    photoURL: 'http://example.com/profile2.png'
  }
  CREATE_CHECKIN_PARAMS3 = {
    name: 'Samuel Smith', externalId: 'ias2kk10',
    photoURL: 'http://example.com/profile10.png'
  }
  CREATE_ORDER_PARAMS = {
    tip: '100', status: 'paid', 'transactionId': '123', invoiceId: '123',
    items: [{
      id: '2', pos_id: 'toasted_bread', name: 'Toasted Sourdough Bread & Eggs',
      price: 1100, description: 'Just ye old classic', status: 'accepted'
    }]
  }

  protected

  def create_location
    VCR.use_cassette('location/create') do
      @location = Doshii.location.create do |p|
        p.merge!(CREATE_LOCATION_PARAMS)
      end
    end
  end

  def create_checkin
    create_location
    VCR.use_cassette('checkin/create') do
      @checkin = Doshii.checkin.create @location.id do |p|
        p.merge!(CREATE_CHECKIN_PARAMS)
      end
    end
  end

  def create_order
    create_checkin
    VCR.use_cassette('order/create') do
      @order = Doshii.order.create @checkin.id do |p|
        p.merge!(CREATE_ORDER_PARAMS)
      end
    end
  end

  def create_table
    create_checkin
    VCR.use_cassette('checkin/table') do
      @table = Doshii.checkin.create "#{@checkin.id}/table" do |p|
        p[:name] = '3'
      end
    end
  end
end
