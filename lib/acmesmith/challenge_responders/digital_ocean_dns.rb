require "acmesmith/challenge_responders/base"

require "json"
require "droplet_kit"
require "resolv"
require "set"

module Acmesmith
  module ChallengeResponders
    class DigitalOceanDns < Base
      def support?(type)
        type == 'dns-01'
      end

      def cap_respond_all?
        true
      end

      def initialize(config)
        @config = config
        @client = DropletKit::Client.new(access_token: @config[:digitalocean_token])
      end

      def respond_all(*domain_and_challenges)
        domain_and_challenges.each do |domain, challenge|
          hdomain = get_hdomain(domain)
          sdomain = (domain.split(".") - hdomain.split(".")).join(".")
          record = DropletKit::DomainRecord.new(type: challenge.record_type, name: "#{challenge.record_name}.#{sdomain}", data: challenge.record_content)
          @client.domain_records.create(record, for_domain: hdomain)
        end
        sleep 5
      end

      def cleanup_all(*domain_and_challenges)
        domain_and_challenges.each do |domain, challenge|
          hdomain = get_hdomain(domain)
          sdomain = (domain.split(".") - hdomain.split(".")).join(".")
          expected_name = "#{challenge.record_name}.#{sdomain}"
          all_records = @client.domain_records.all(for_domain: hdomain, type: challenge.record_type)
          matching_records = all_records.select { |r| r.name == expected_name && r.data == challenge.record_content }
          matching_records.each do |record|
            @client.domain_records.delete(for_domain: hdomain, id: record.id)
          end
        end
      end

      private
      def canonicalize(domain)
        "#{domain}.".gsub(/\.{2,}/, '.')
      end

      def get_hdomain(domain)
        hdomain = domain
        (1...domain.split(".").size).reverse_each do |sdc|
          hdomain = domain.split(".")[(-1-sdc)..-1].join(".")
          begin
            @client.domains.find(name: hdomain)
            break
          rescue DropletKit::Error
          end
        end
        return hdomain
      end
    end
  end
end
