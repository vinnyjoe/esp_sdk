require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

module ESP
  class TeamTest < ActiveSupport::TestCase
    context ESP::Team do
      context '#organization' do
        should 'call the api' do
          team = build(:team, organization_id: 4)
          stub_org = stub_request(:get, %r{organizations/#{team.organization_id}.json*}).to_return(body: json(:organization))

          team.organization

          assert_requested(stub_org)
        end
      end

      context '#sub_organization' do
        should 'call the api' do
          team = build(:team, sub_organization_id: 4)
          stub_sub_org = stub_request(:get, %r{sub_organizations/#{team.sub_organization_id}.json*}).to_return(body: json(:sub_organization))

          team.sub_organization

          assert_requested(stub_sub_org)
        end
      end

      context '#external_accounts' do
        should 'call the api' do
          team = build(:team)
          stub_request(:get, /external_accounts.json*/).to_return(body: json_list(:external_account, 2))

          team.external_accounts

          assert_requested(:get, /external_accounts.json*/) do |req|
            assert_equal "filter[team_id_eq]=#{team.id}", URI.unescape(req.uri.query)
          end
        end
      end

      context '#reports' do
        should 'call the api' do
          team = build(:team)
          stub_request(:get, /reports.json*/).to_return(body: json_list(:report, 2))

          team.reports

          assert_requested(:get, /reports.json*/) do |req|
            assert_equal "filter[team_id_eq]=#{team.id}", URI.unescape(req.uri.query)
          end
        end
      end

      context '#create_report' do
        should 'call Report.create_for_team' do
          Report.stubs(:create_for_team)
          team = build(:team)

          team.create_report

          assert_received(Report, :create_for_team) do |expects|
            expects.with do |id|
              assert_equal team.id, id
            end
          end
        end
      end
    end
  end
end
