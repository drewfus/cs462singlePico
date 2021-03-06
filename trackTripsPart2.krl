ruleset track_trips_part_2 {
	meta {
		name "track trips part 2"
		description << part two of the single pico lab >>
		author "Andrew Manwaring"
		logging on
		sharing on
	}
	global{
		long_trip = 60;
	}
	rule process_trip {
		select when car new_trip
		pre {
			mileage = event:attr("mileage").klog("Mileage: ");
			attribute = {
				"mileage":mileage
			}
		}
		{
			send_directive("trip") with
				trip_length = mileage;
		}
		always {
			raise explicit event 'trip_processed'
				attributes attribute;
		}
	}
	rule find_long_trips {
		select when explicit trip_processed
		pre {
			mileage = event:attr("mileage").klog("Mileage: ");
			attribute = {
				"mileage":mileage
			}
		}
		if (mileage > long_trip) then {
			log("Mileage: " + mileage + ", greater than long_trip: " + long_trip);
		}
		fired {
			raise explicit event 'found_long_trip'
				attributes attribute;
		}
	}
}