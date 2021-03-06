# frozen_string_literal: true

require 'dotenv/tasks'
require_relative './export/csv_creator'

namespace :findit do
  namespace :data do
    namespace :export do
      erb = ERB.new(IO.read(Rails.root.join('config/export_styles.yml'))).result(binding)
      styles = YAML.safe_load(erb)
      styles.each do |style, config|
        desc "Export CSV file for #{style}"
        task style => :environment do |_task|
          csv = CsvCreator.new config
          csv.write
        end
      end
      desc 'Export a solr backup'
      task as_solr: :environment do |_task|
        solr = RSolr.connect url: ENV['SOLR_URL']
        solr.get 'replication', params: {
          command: 'backup',
          name: 'new'
        }
      end
    end
  end
end
