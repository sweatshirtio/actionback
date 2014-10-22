require 'spec_helper'

describe ActionBack::RouteBack do
  let(:route_set) { Rails.application.routes }

  subject do
    class UserSerializer
      include ActionBack::RouteBack
    end.new
  end

  describe '#id_from_url' do
    it 'should raise ActionController::RoutingError: no route match' do
      route_set.draw do
        resources :users
      end

      error_msg = 'No route matches "http://www.yo.com"'

      expect{ subject.id_from_url 'http://www.yo.com' }
        .to raise_error(ActionController::RoutingError, error_msg)
    end

    it 'should raise ActionController::RoutingError: missing controller' do
      route_set.draw do
        get '/ello_there' => 'ello_there#show'
      end

      error_msg = <<-EOS.gsub(/^[\s\t]*/, '').gsub(/[\s\t]*\n/, ' ').strip
        A route matches "http://www.ello.com/ello_there",
        but references missing controller: ElloThereController
      EOS

      expect{ subject.id_from_url 'http://www.ello.com/ello_there' }
        .to raise_error(ActionController::RoutingError, error_msg)
    end

    context 'non-nested routes' do
      it 'should call UsersController#fetch_resource_id with correct route params' do
        route_set.draw do
          resources :users
        end

        expect(UsersController).to receive(:fetch_resource_id)
          .with({:action=>'show', :controller=>'users', :id=>'1'})

        subject.id_from_url 'http://www.example.com/users/1'
      end
    end

    context 'namespaced routes' do
      it 'should  call V1::UsersController#fetch_resource_id with correct route params' do
        route_set.draw do
          namespace :v1 do
            resources :users
          end
        end

        expect(V1::UsersController).to receive(:fetch_resource_id)
          .with({:action=>'show', :controller=>'v1/users', :id=>'1'})

        subject.id_from_url 'http://www.example.com/v1/users/1'
      end
    end

    context 'nested routes' do
      it 'should call UsersController#fetch_resource_id with correct route params' do
        route_set.draw do
          resources :groups do
            resources :users
          end
        end

        expect(UsersController).to receive(:fetch_resource_id)
          .with({:action=>'show', :controller=>'users', :group_id=>'5', :id=>'1'})

        subject.id_from_url 'http://www.example.com/groups/5/users/1'
      end

      it 'should call GroupUsersController#fetch_resource_id with correct route params' do
        route_set.draw do
          get '/groups/:group_id/users/:id' => 'group_users#show'
        end

        expect(GroupUsersController).to receive(:fetch_resource_id)
          .with({:action=>'show', :controller=>'group_users', :group_id=>'6', :id=>'3'})

        subject.id_from_url 'http://www.example.com/groups/6/users/3'
      end
    end

    context 'nested and namespaced routes' do
      it 'should call Groups::UsersController#fetch_resource_id with correct route params' do
        route_set.draw do
          get '/groups/:group_id/users/:id' => 'groups/users#show'
        end

        expect(Groups::UsersController).to receive(:fetch_resource_id)
          .with({:action=>'show', :controller=>'groups/users', :group_id=>'6', :id=>'3'})

        subject.id_from_url 'http://www.example.com/groups/6/users/3'
      end
    end
  end

  describe '#resource_from_url' do
    it 'should raise ActionController::RoutingError: no route match' do
      route_set.draw do
        resources :users
      end

      error_msg = 'No route matches "http://www.yoyo.com"'

      expect{ subject.resource_from_url 'http://www.yoyo.com' }
        .to raise_error(ActionController::RoutingError, error_msg)
    end

    it 'should raise ActionController::RoutingError: missing controller' do
      route_set.draw do
        get '/ello_there_mate' => 'ello_there_mate#show'
      end

      error_msg = <<-EOS.gsub(/^[\s\t]*/, '').gsub(/[\s\t]*\n/, ' ').strip
        A route matches "http://www.ello.com/ello_there_mate",
        but references missing controller: ElloThereMateController
      EOS

      expect{ subject.resource_from_url 'http://www.ello.com/ello_there_mate' }
        .to raise_error(ActionController::RoutingError, error_msg)
    end

    context 'non-nested routes' do
      it 'should call UsersController#fetch_resource with correct route params' do
        route_set.draw do
          resources :users
        end

        expect(UsersController).to receive(:fetch_resource)
          .with({:action=>'show', :controller=>'users', :id=>'1'})

        subject.resource_from_url 'http://www.example.com/users/1'
      end
    end

    context 'namespaced routes' do
      it 'should  call V1::UsersController#fetch_resource with correct route params' do
        route_set.draw do
          namespace :v1 do
            resources :users
          end
        end

        expect(V1::UsersController).to receive(:fetch_resource)
          .with({:action=>'show', :controller=>'v1/users', :id=>'1'})

        subject.resource_from_url 'http://www.example.com/v1/users/1'
      end
    end

    context 'nested routes' do
      it 'should call UsersController#fetch_resource with correct route params' do
        route_set.draw do
          resources :groups do
            resources :users
          end
        end

        expect(UsersController).to receive(:fetch_resource)
          .with({:action=>'show', :controller=>'users', :group_id=>'5', :id=>'1'})

        subject.resource_from_url 'http://www.example.com/groups/5/users/1'
      end

      it 'should call GroupUsersController#fetch_resource with correct route params' do
        route_set.draw do
          get '/groups/:group_id/users/:id' => 'group_users#show'
        end

        expect(GroupUsersController).to receive(:fetch_resource)
          .with({:action=>'show', :controller=>'group_users', :group_id=>'6', :id=>'3'})

        subject.resource_from_url 'http://www.example.com/groups/6/users/3'
      end
    end

    context 'nested and namespaced routes' do
      it 'should call Groups::UsersController#fetch_resource with correct route params' do
        route_set.draw do
          get '/groups/:group_id/users/:id' => 'groups/users#show'
        end

        expect(Groups::UsersController).to receive(:fetch_resource)
          .with({:action=>'show', :controller=>'groups/users', :group_id=>'6', :id=>'3'})

        subject.resource_from_url 'http://www.example.com/groups/6/users/3'
      end
    end
  end
end
