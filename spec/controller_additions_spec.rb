require 'spec_helper'

describe ActionBack::ControllerAdditions do
  let(:route_set) { ActionDispatch::Routing::RouteSet.new }
  let(:route) { route_set.routes.routes.first }
  let :route_wrapper do
    ActionDispatch::Routing::RouteWrapper.new(route)
  end

  subject { UsersController }

  describe '#fetch_resource_id' do
    context 'non-nested routes' do
      it 'should return User ID 1' do
        route_set.draw do
          get 'users/:id(.:format)' => 'users#show'
        end

        reg_match = route_match route_wrapper, '/users/1'
        expect(subject.fetch_resource_id(reg_match, route_wrapper)).to eq 1
      end

      it 'should return User ID 3' do
        route_set.draw do
          get ':id/users' => 'users#show'
        end

        reg_match = route_match route_wrapper, '/3/users'
        expect(subject.fetch_resource_id(reg_match, route_wrapper)).to eq 3
      end
    end

    context 'namespaced routes' do
      it 'should call User.find with ID 7' do
        route_set.draw do
          namespace :v1 do
            get 'users/:id' => 'users#show'
          end
        end

        reg_match = route_match route_wrapper, '/v1/users/7'
        expect(subject.fetch_resource_id(reg_match, route_wrapper)).to eq 7
      end
    end

    context 'nested routes' do
      it 'should call User.find with ID 5' do
        route_set.draw do
          get '/groups/:group_id/users/:id' => 'group_users#show'
        end

        reg_match = route_match route_wrapper, '/groups/3/users/5'
        expect(subject.fetch_resource_id(reg_match, route_wrapper)).to eq 5
      end
    end
  end

  describe '#fetch_resource' do
    context 'non-nested routes' do
      it 'should call User.find with ID 1' do
        route_set.draw do
          get 'users/:id(.:format)' => 'users#show'
        end

        reg_match = route_match route_wrapper, '/users/1.json'
        allow(subject).to receive(:fetch_resource_id).with(reg_match, route_wrapper).and_return 1

        expect(User).to receive(:find).with 1
        subject.fetch_resource reg_match, route_wrapper
      end

      it 'should call User.find with ID 3' do
        route_set.draw do
          get ':id/users' => 'users#show'
        end

        reg_match = route_match route_wrapper, '/3/users'
        allow(subject).to receive(:fetch_resource_id).with(reg_match, route_wrapper).and_return 3

        expect(User).to receive(:find).with 3
        subject.fetch_resource reg_match, route_wrapper
      end
    end

    context 'namespaced routes' do
      it 'should call User.find with ID 1' do
        route_set.draw do
          namespace :v1 do
            get 'users/:id' => 'users#show'
          end
        end

        reg_match = route_match route_wrapper, '/v1/users/1'
        allow(subject).to receive(:fetch_resource_id).with(reg_match, route_wrapper).and_return 1

        expect(User).to receive(:find).with 1
        subject.fetch_resource reg_match, route_wrapper
      end
    end

    context 'nested routes' do
      it 'should call User.find with ID 10' do
        route_set.draw do
          get '/groups/:group_id/users/:id' => 'group_users#show'
        end

        reg_match = route_match route_wrapper, '/groups/11/users/10'
        allow(subject).to receive(:fetch_resource_id).with(reg_match, route_wrapper).and_return 10

        expect(User).to receive(:find).with 10
        subject.fetch_resource reg_match, route_wrapper
      end
    end
  end
end
