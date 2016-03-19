ruleset trip_store {
	meta {
		name "trip store"
		description << part three of the single pico lab >>
		author "Andrew Manwaring"
		logging on
		sharing on
		provides trips
		provides long_trips
	}
	global{
		trips = function() {
			trips = ent:trips;
			trips;
		};

		long_trips = function() {
			long_trips = ent:long_trips;
			long_trips;
		};
	}
	rule collect_trips {
		select when explicit trip_processed
		pre {
			mileage = event:attr("mileage").klog("Mileage: ");
			timestamp = time:now();
			new_trip = {
				"mileage" : mileage,
				"time" : timestamp
			};
			id = random:uuid();
		}
		always {
			set ent:trips{[id]} new_trip;
		}
	}
	rule collect_long_trips {
		select when explicit found_long_trip
		pre {
			mileage = event:attr("mileage").klog("Mileage: ");
			timestamp = time:now();
			new_trip = {
				"mileage" : mileage,
				"time" : timestamp
			};
			id = random:uuid();
		}
		always {
			set ent:long_trips{[id]} new_trip;
		}
	}
	rule clear_trips {
		select when car trip_reset
		always {
			set ent:trips null;
			set ent:long_trips null;
		}
	}
}