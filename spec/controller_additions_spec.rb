require 'spec_helper'

describe ActionBack::ControllerAdditions do
  let(:route_set) { ActionDispatch::Routing::RouteSet.new }

  describe '#fetch_resource_id' do
    context 'non-nested routes' do
      subject { UsersController }

      it "returns resource's id" do
        route_set.draw do
          get ':id/users' => 'users#show'
        end

        route_params = route_set.recognize_path '/3/users'

        expect(subject.fetch_resource_id(route_params)).to eq '3'
      end

      context 'with format option' do
        it "returns the resource's id" do
          route_set.draw do
            get 'users/:id(.:format)' => 'users#show'
          end

          route_params = route_set.recognize_path '/users/1'

          expect(subject.fetch_resource_id(route_params)).to eq '1'
        end
      end
    end

    context 'namespaced routes' do
      subject { V1::UsersController }

      it "returns the resource's id" do
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

      it "returns the resource's id and group_id" do
        route_set.draw do
          get '/groups/:group_id/users/:id' => 'group_users#show'
        end

        route_params = route_set.recognize_path '/groups/3/users/5'

        expect(subject.fetch_resource_id(route_params))
          .to eq({:id => '5', :group_id => '3'})
      end
    end
  end

  describe '#fetch_resource' do
    context 'non-nested routes' do
      subject { UsersController }

      it 'finds the resource' do
        route_set.draw do
          get ':id/users' => 'users#show'
        end

        route_params = route_set.recognize_path '/3/users'

        expect(User).to receive(:find).with '3'

        subject.fetch_resource route_params
      end

      context 'with format option' do
        it 'finds the resource' do
          route_set.draw do
            get 'users/:id(.:format)' => 'users#show'
          end

          route_params = route_set.recognize_path '/users/1.json'

          expect(User).to receive(:find).with '1'

          subject.fetch_resource route_params
        end
      end
    end

    context 'namespaced routes' do
      subject { V1::UsersController }

      it 'finds the resource' do
        route_set.draw do
          namespace :v1 do
            get 'users/:id' => 'users#show'
          end
        end

        route_params = route_set.recognize_path '/v1/users/1'

        expect(User).to receive(:find).with '1'

        subject.fetch_resource route_params
      end
    end

    context 'nested routes' do
      subject { GroupUsersController }

      it 'finds the resource' do
        route_set.draw do
          get '/groups/:group_id/users/:id' => 'group_users#show'
        end

        route_params = route_set.recognize_path '/groups/11/users/10'

        expect(User).to receive(:where).with({:id => '10', :group_id => '11'})

        subject.fetch_resource route_params
      end
    end
  end
end
