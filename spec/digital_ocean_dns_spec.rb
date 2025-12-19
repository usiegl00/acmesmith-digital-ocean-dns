require 'spec_helper'
require 'acmesmith/challenge_responders/digital_ocean_dns'

describe Acmesmith::ChallengeResponders::DigitalOceanDns do
  let(:config) { { digitalocean_token: 'test-token' } }
  let(:responder) { described_class.new(config) }
  let(:client) { double('DropletKit::Client') }
  let(:domain_records) { double('DomainRecordResource') }
  let(:domains) { double('DomainResource') }

  before do
    allow(DropletKit::Client).to receive(:new).and_return(client)
    allow(client).to receive(:domain_records).and_return(domain_records)
    allow(client).to receive(:domains).and_return(domains)
    # get_hdomain iterates from most specific to least specific subdomain
    allow(domains).to receive(:find).with(name: 'smtp.example.com').and_raise(DropletKit::Error)
    allow(domains).to receive(:find).with(name: 'example.com').and_return(true)
  end

  describe '#cleanup_all' do
    let(:challenge) do
      double('challenge',
        record_type: 'TXT',
        record_name: '_acme-challenge',
        record_content: 'correct-challenge-token'
      )
    end

    let(:matching_record) do
      double('record', id: 123, name: '_acme-challenge.smtp', data: 'correct-challenge-token')
    end

    let(:stale_record) do
      double('record', id: 456, name: '_acme-challenge.smtp', data: 'old-stale-token')
    end

    let(:unrelated_record) do
      double('record', id: 789, name: '_acme-challenge.other', data: 'other-token')
    end

    it 'deletes all records matching the challenge name, including stale ones' do
      allow(domain_records).to receive(:all)
        .with(for_domain: 'example.com', type: 'TXT')
        .and_return([matching_record, stale_record, unrelated_record])

      expect(domain_records).to receive(:delete)
        .with(for_domain: 'example.com', id: 123)
      expect(domain_records).to receive(:delete)
        .with(for_domain: 'example.com', id: 456)

      responder.cleanup_all(['smtp.example.com', challenge])
    end

    it 'does not delete records with different subdomain' do
      allow(domain_records).to receive(:all)
        .with(for_domain: 'example.com', type: 'TXT')
        .and_return([unrelated_record])

      expect(domain_records).not_to receive(:delete)

      responder.cleanup_all(['smtp.example.com', challenge])
    end
  end
end
