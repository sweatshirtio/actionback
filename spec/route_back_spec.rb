require 'spec_helper'

describe ActionBack::RouteBack do
  let(:route_set) { Rails.application.routes }

  subject do
    class UserSerializer
      include ActionBack::RouteBack
    end.new
  end

  describe '#match_path' do
    it 'raises ActionBack::RouteBack::RoutingError not a valid URL' do
      allow(ENV).to receive(:[])
      allow(ENV).to receive(:[]).with('DOMAIN_NAME').and_return 'example.com'

      expect{ subject.match_path 'http://www.yo.com' }
        .to raise_error(ActionBack::RouteBack::RoutingError, 'not a valid URL')
    end
  end

  describe '#id_from_url' do
    it 'raises ActionController::RoutingError: no route match' do
      route_set.draw do
        resources :users
      end

      expect{ subject.id_from_url 'http://www.yo.com' }
        .to raise_error(ActionController::RoutingError)
    end

    it 'raises ActionController::RoutingError: missing controller' do
      route_set.draw do
        get '/ello_there' => 'ello_there#show'
      end

      expect{ subject.id_from_url 'http://www.ello.com/ello_there' }
        .to raise_error(ActionController::RoutingError)
    end

    context 'non-nested routes' do
      it "returns the resource's id" do
        route_set.draw do
          resources :users
        end

        expect(subject.id_from_url('http://www.example.com/users/1')).to eq '1'
      end
    end

    context 'namespaced routes' do
      it "returns the resource's id" do
        route_set.draw do
          namespace :v1 do
            resources :users
          end
        end

        expect(subject.id_from_url('http://www.example.com/v1/users/1'))
          .to eq '1'
      end
    end

    context 'nested routes' do
      it "returns the resource's id" do
        route_set.draw do
          resources :groups do
            resources :users
          end
        end

        expect(subject.id_from_url('http://www.example.com/groups/5/users/1'))
          .to eq '1'
      end

      context 'specified controller' do
        it "returns the resource's id and group_id" do
          route_set.draw do
            get '/groups/:group_id/users/:id' => 'group_users#show'
          end

          expect(subject.id_from_url('http://www.example.com/groups/6/users/3'))
            .to eq({:id => '3', :group_id => '6'})
        end
      end
    end

    context 'nested and namespaced routes' do
      it "returns the resource's id and group_id" do
        route_set.draw do
          get '/groups/:group_id/users/:id' => 'groups/users#show'
        end

        expect(subject.id_from_url('http://www.example.com/groups/6/users/3'))
          .to eq({:id => '3', :group_id => '6'})
      end
    end
  end

  describe '#resource_from_url' do
    it 'raises ActionController::RoutingError: no route match' do
      route_set.draw do
        resources :users
      end

      expect{ subject.resource_from_url 'http://www.yoyo.com' }
        .to raise_error(ActionController::RoutingError)
    end

    it 'raises ActionController::RoutingError: missing controller' do
      route_set.draw do
        get '/ello_there_mate' => 'ello_there_mate#show'
      end

      expect{ subject.resource_from_url 'http://www.ello.com/ello_there_mate' }
        .to raise_error(ActionController::RoutingError)
    end

    context 'non-nested routes' do
      it 'finds the resource' do
        route_set.draw do
          resources :users
        end

        expect(User).to receive(:find).with '1'

        subject.resource_from_url 'http://www.example.com/users/1'
      end
    end

    context 'namespaced routes' do
      it 'finds the resource' do
        route_set.draw do
          namespace :v1 do
            resources :users
          end
        end

        expect(User).to receive(:find).with '1'

        subject.resource_from_url 'http://www.example.com/v1/users/1'
      end
    end

    context 'nested routes' do
      it 'finds the resource' do
        route_set.draw do
          resources :groups do
            resources :users
          end
        end

        expect(User).to receive(:find).with '1'

        subject.resource_from_url 'http://www.example.com/groups/5/users/1'
      end

      context 'specified controller' do
        it 'finds the resource' do
          route_set.draw do
            get '/groups/:group_id/users/:id' => 'group_users#show'
          end

          expect(User).to receive(:where).with({:id => '3', :group_id => '6'})

          subject.resource_from_url 'http://www.example.com/groups/6/users/3'
        end
      end
    end

    context 'nested and namespaced routes' do
      it 'finds the resource' do
        route_set.draw do
          get '/groups/:group_id/users/:id' => 'groups/users#show'
        end

        expect(User).to receive(:where).with({:id => '3', :group_id => '6'})

        subject.resource_from_url 'http://www.example.com/groups/6/users/3'
      end
    end
  end
end
