    require 'csv'
		require 'pathname'
module CL
	def self.import_basel dir = 'data'

 	pn =Pathname.new  File.expand_path('../..', __FILE__)
	path  = pn + dir


	puts "Importing data from  #{path.inspect}"
	CL::Temperature.delete all: true
	CL::Pressure.delete all: true
	CL::Humility.delete all: true

	path.each_entry do | the_file |
		if the_file.extname == '.csv'
			puts "import #{the_file} ? (Y/N)" 
			answer = STDIN.gets.upcase
			puts "Answer: #{answer}"
			if  answer[0] =="Y" 
				pn2 =  path + the_file
				data=  CSV.read pn2.to_s, col_sep: ';'
				data.each_with_index do |d,i| 
					if i > 11
						datum = Date.new( d[0].to_i, d[1].to_i, d[2].to_i).to_tg
						temp = d[5].to_f
						hum =  d[6].to_f
						press= d[7].to_f
						print datum.datum,"\t", temp,"\t", press,  "\t" , hum , "\n"
						the_pressure = CL::Pressure.create( mean: press, max: d[12].to_f, min: d[13].to_f)
						datum.assign vertex:  the_pressure,		via: CL::HAS_PRESSURE
						datum.prev.nodes( via: CL::HAS_PRESSURE ).first.assign( via: CL::GRID, vertex: the_pressure) if i>12

						the_humility = CL::Humility.create( mean: hum, max: d[10].to_f, min: d[11].to_f)
						datum.assign vertex:  the_humility,				via: CL::HAS_HUM
						datum.prev.nodes( via: CL::HAS_HUM ).first.assign( via: CL::GRID, vertex: the_humility) if i>12

						the_date =  CL::Temperature.create( mean: temp, max: d[8].to_f, min: d[9].to_f)
						datum.assign vertex:	the_date,	via: CL::HAS_TEMP 
						datum.prev.nodes( via: CL::HAS_TEMP ).first.assign( via: CL::GRID, vertex: the_date) if i>12
					end
				end
			end
		end
	end
	end # def
end # module


# format
# data starts at row 12 (1999,01,01)
#                     0     0     ----          mean         ---
# year; month; day; hour; minute; Temperature, Huimidity, Pressure
#                               ; Temperature:  max + min
#                               ; Huimidity:    max + min
#                               ; Pressure:     max + min
