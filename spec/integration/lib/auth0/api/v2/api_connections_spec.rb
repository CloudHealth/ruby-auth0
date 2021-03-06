require 'spec_helper'
describe Auth0::Api::V2::Connections do
  let(:client) { Auth0Client.new(v2_creds) }

  let(:name) { SecureRandom.uuid[0..25] }
  let(:strategy) { 'google-oauth2' }
  let(:options) { {} }
  let(:enabled_clients) { [] }

  let!(:connection) do
    client.create_connection(name: name,
                             strategy: strategy,
                             options: options,
                             enabled_clients: enabled_clients)
  end

  describe '.connections' do
    let(:connections) { client.connections }

    it { expect(connections.size).to be > 0 }
    it { expect(connections.find { |con| con['name'] == name }).to_not be_nil }

    context '#filters' do
      it { expect(client.connections(strategy: strategy).size).to be > 0 }
      it { expect(client.connections(strategy: strategy, fields: [:name].join(',')).first).to include('name') }
      it do
        expect(client.connections(strategy: strategy, fields: [:name].join(','), include_fields: false).first).to_not(
          include('name'))
      end
    end
  end

  describe '.connection' do
    let(:subject) { client.connection(connection['id']) }

    it { should include('name' => connection['name']) }

    context '#filters' do
      it { expect(client.connection(connection['id'], fields: [:name, :id].join(','))).to include('id', 'name') }
      it do
        expect(client.connection(connection['id'], fields: [:name, :id].join(','), include_fields: false)).to_not(
          include('id', 'name'))
      end
    end
  end

  describe '.create_connection' do
    let(:subject) { connection }

    it { should include('id', 'name') }
    it { should include('name' => connection['name']) }
  end

  describe '.delete_connection' do
    it { expect { client.delete_connection connection['id'] }.to_not raise_error }
    it { expect { client.delete_connection '' }.to raise_error(Auth0::MissingConnectionId) }
  end

  describe '.update_connection' do
    new_name = SecureRandom.uuid[0..25]
    let(:options) { { username: new_name } }
    it do
      expect(
        client.update_connection(connection['id'], 'options' => options)['options']
      ).to include('username' => new_name)
    end
  end
end
