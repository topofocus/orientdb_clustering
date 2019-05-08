module Orient
	def self.db_init db
			#vertices =  db.class_hierarchy["V"].flatten
			vertices= db.class_hierarchy( base_class: 'V' ).flatten
			return if vertices.include? "k_cluster"
     	ActiveOrient::Init.define_namespace { CL }

		  V.create_class :weather
			CL::Weather.create_class :temperature, :humility, :pressure
	
						

			TG::Setup.init_database db

			TG::TimeGraph.populate 1990..2050
			TG.info

			ActiveOrient::Init.define_namespace { CL }
			E.create_class :base
			edges = CL::BASE.create_class :has_temp, :has_hum, :has_pressure, :grid 
			edges.each &:uniq_index


	end
end

# inputdata 
# https://www.meteoblue.com/de/wetter/archive/export/basel_schweiz_2661604?daterange=1999-01-01+to+2019-05-01&params=&params%5B%5D=11%3B2+m+above+gnd&params%5B%5D=52%3B2+m+above+gnd&params%5B%5D=2%3BMSL&utc_offset=1&aggregation=daily&temperatureunit=CELSIUS&windspeedunit=KILOMETER_PER_HOUR

