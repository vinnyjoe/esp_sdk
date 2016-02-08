require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class RegionTest < ActiveSupport::TestCase
    context ESP::Region do
      context '#create' do
        should 'not be implemented' do
          assert_raises ESP::NotImplementedError do
            ESP::Region.create(code: 'test')
          end
        end
      end

      context '#update' do
        should 'not be implemented' do
          region = build(:region)
          assert_raises ESP::NotImplementedError do
            region.save
          end
        end
      end

      context '#destroy' do
        should 'not be implemented' do
          region = build(:region)
          assert_raises ESP::NotImplementedError do
            region.destroy
          end
        end
      end

      context '.find' do
        should 'call the show api and return a region if searching by id' do
          stub_region = stub_request(:get, %r{regions/5.json*}).to_return(body: json(:region))

          region = ESP::Region.find(5)

          assert_requested(stub_region)
          assert_equal ESP::Region, region.class
        end
      end

      context '#suppress' do
        should 'call the api' do
          stub_request(:post, %r{suppressions/regions.json*}).to_return(body: json(:suppression_region))
          region = build(:region)

          suppression = region.suppress(external_account_ids: [5], reason: 'because')

          assert_requested(:post, %r{suppressions/regions.json*}) do |req|
            body = JSON.parse(req.body)
            assert_equal 'because', body['data']['attributes']['reason']
            assert_equal [region.code], body['data']['attributes']['regions']
            assert_equal [5], body['data']['attributes']['external_account_ids']
          end
          assert_equal ESP::Suppression::Region, suppression.class
        end
      end

      context 'live calls' do
        setup do
          skip "Make sure you run the live calls locally to ensure proper integration" if ENV['CI_SERVER']
          WebMock.allow_net_connect!
          @region = ESP::Region.last
          skip "Live DB does not have any regions.  Add a region and run tests again." if @region.blank?
        end

        teardown do
          WebMock.disable_net_connect!
        end

        context '.where' do
          should 'return region objects' do
            regions = ESP::Region.where(id_eq: @region.id)

            assert_equal ESP::Region, regions.resource_class
          end
        end

        context '#CRUD' do
          should 'be able to read' do
            assert_not_nil @region

            region = ESP::Region.find(@region.id)

            assert_not_nil region
          end
        end
      end
    end
  end
end
