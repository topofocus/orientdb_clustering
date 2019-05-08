require 'pastel'
require 'active_support'
require 'active-orient'
require 'orientdb_time_graph'
require_relative "db_init"
	

module CL 

	def setup environment = :test
 #   mattr_accessor :orient 
	 ActiveOrient::Init.connect  database: (environment == :production) ?  'ml-cluster' : 'ml-cl-test',
				user: 'hctw',
				password: 'hc',
				server: '172.28.50.25'

	  
		ActiveOrient::Init.define_namespace { TG } 
		TG.connect

		project_root = File.expand_path('../..', __FILE__)
		ActiveOrient::Model.model_dir =  project_root + '/model'
		ActiveOrient::Init.define_namespace { CL }
		ActiveOrient::Model.keep_models_without_file = true
		ActiveOrient::OrientDB.new  preallocate: true 

	end
 end
