require 'spec_helper'

describe ActionBack::ControllerAdditions do
  let(:route_set) { ActionDispatch::Routing::RouteSet.new }

  describe '#fetch_resource_id' do
    context 'non-nested routes' do
      subject { UsersController }

      it 'should return User ID 1' do
        route_set.draw do
          get 'users/:id(.:format)' => 'users#show'
        end

        route_params = route_set.recognize_path '/users/1'

        expect(subject.fetch_resource_id(route_params)).to eq '1'
      end

      it 'should return User ID 3' do
        route_set.draw do
          get ':id/users' => 'users#show'
        end

        route_params = route_set.recognize_path '/3/users'

        expect(subject.fetch_resource_id(route_params)).to eq '3'
      end
    end

    context 'namespaced routes' do
      subject { V1::UsersController }

      it 'should call User.find with ID 7' do
        route_set.draw do
          namespace :v1 do
            get 'users/:id' => 'users#show'
          end
        end

        route_params = route_set.recognize_path '/v1/users/7'

        expect(subject.fetch_resource_id(route_params)).to eq '7'
      end
    end

    context 'nested routes' do
      subject { GroupUsersController }

      it 'should call User.find with ID 5' do
        route_set.draw do
          get '/groups/:group_id/users/:id' => 'group_users#show'
        end

        route_params = route_set.recognize_path '/groups/3/users/5'

        expect(subject.fetch_resource_id(route_params)).to eq '5'
      end
    end
  end

  describe '#fetch_resource' do
    context 'non-nested routes' do
      subject { UsersController }

      it 'should call User.find with ID 1' do
        route_set.draw do
          get 'users/:id(.:format)' => 'users#show'
        end

        route_params = route_set.recognize_path '/users/1.json'

        allow(subject).to receive(:fetch_resource_id)
          .with(route_params)
          .and_return '1'

        expect(User).to receive(:find).with '1'

        subject.fetch_resource route_params
      end

      it 'should call User.find with ID 3' do
        route_set.draw do
          get ':id/users' => 'users#show'
        end

        route_params = route_set.recognize_path '/3/users'

        allow(subject).to receive(:fetch_resource_id)
          .with(route_params)
          .and_return '3'

        expect(User).to receive(:find).with '3'

        subject.fetch_resource route_params
      end
    end

    context 'namespaced routes' do
      subject { V1::UsersController }

      it 'should call User.find with ID 1' do
        route_set.draw do
          namespace :v1 do
            get 'users/:id' => 'users#show'
          end
        end

        route_params = route_set.recognize_path '/v1/users/1'

        allow(subject).to receive(:fetch_resource_id)
          .with(route_params)
          .and_return '1'

        expect(User).to receive(:find).with '1'

        subject.fetch_resource route_params
      end
    end

    context 'nested routes' do
      subject { GroupUsersController }

      it 'should call User.find with ID 10' do
        route_set.draw do
          get '/groups/:group_id/users/:id' => 'group_users#show'
        end

        route_params = route_set.recognize_path '/groups/11/users/10'

        allow(subject).to receive(:fetch_resource_id)
          .with(route_params)
          .and_return '10'

        expect(User).to receive(:where).with id: '10', group_id: '11'

        subject.fetch_resource route_params
      end
    end
  end
end
