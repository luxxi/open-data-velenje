DataType.destroy_all

data_type_list = [
  { name: "TEMPERATURE".humanize, data: "urn:oc:attributeType:temperature:ambient" },
  { name: "ATMOSPHERIC_PRESSURE".humanize, data: "urn:oc:attributeType:atmosphericPressure" },
  { name: "WIND_DIRECTION".humanize, data: "urn:oc:attributeType:windDirection" },
  { name: "SOUND_PRESSURE_LEVEL".humanize, data: "urn:oc:attributeType:soundPressureLevel:ambient" },
  { name: "WIND_SPEED".humanize, data: "urn:oc:attributeType:windSpeed" },
  { name: "RELATIVE_HUMIDITY".humanize, data: "urn:oc:attributeType:relativeHumidity" },
  { name: "SOLAR_RADIATION".humanize, data: "urn:oc:attributeType:solarRadiation" },
  { name: "RAINFALL".humanize, data: "urn:oc:attributeType:rainfall" },
  { name: "BATTERY_LEVEL".humanize, data: "urn:oc:attributeType:batteryLevel" },
  { name: "BATTERY_VOLTAGE".humanize, data: "urn:oc:attributeType:batteryVoltage" },
  { name: "ILLUMINANCE".humanize, data: "urn:oc:attributeType:illuminance" },
  { name: "DIRECTION_AZIMUTH".humanize, data: "urn:oc:attributeType:direction:azimuth" },
  { name: "CARBON_MONOXIDE".humanize, data: "urn:oc:attributeType:chemicalAgentAtmosphericConcentration:CO" },
  { name: "NITROGEN_DIOXIDE".humanize, data: "urn:oc:attributeType:chemicalAgentAtmosphericConcentration:NO2" },
  { name: "SULPHUR_DIOXIDE".humanize, data: "urn:oc:attributeType:chemicalAgentAtmosphericConcentration:SO2" },
  { name: "OXYGEN_CONCENTRATION".humanize, data: "urn:oc:attributeType:chemicalAgentAtmosphericConcentration:O3" },
  { name: "NITROGEN_OXIDE".humanize, data: "urn:oc:attributeType:chemicalAgentAtmosphericConcentration:NO" },
  { name: "METHANE".humanize, data: "urn:oc:attributeType:chemicalAgentAtmosphericConcentration:CH4" },
  { name: "LPG".humanize, data: "urn:oc:attributeType:chemicalAgentAtmosphericConcentration:LPG" },
  { name: "DEVICE_TEMPERATURE".humanize, data: "urn:oc:attributeType:temperature:device" },
  { name: "PARTICLES".humanize, data: "urn:oc:attributeType:chemicalAgentAtmosphericConcentration:airParticles" },
  { name: "PARTICLES10".humanize, data: "urn:oc:attributeType:chemicalAgentAtmosphericConcentration:airParticlesPM10" },
  { name: "PARTICLES25".humanize, data: "urn:oc:attributeType:chemicalAgentAtmosphericConcentration:airParticlesPM25" },
  { name: "ELECTRICAL_CURRENT".humanize, data: "urn:oc:attributeType:electricalCurrent" },
  { name: "POWER_CONSUMPTION".humanize, data: "urn:oc:attributeType:powerConsumption" },
  { name: "FREE_BIKES".humanize, data: "urn:oc:attributeType:freeBikes" },
  { name: "FREE_SPACES".humanize, data: "urn:oc:attributeType:freeSpaces" },
  { name: "POPULATION_DENSITY".humanize, data: "urn:oc:attributeType:populationDensity" },
  { name: "HOUSEHOLD_INCOME".humanize, data: "urn:oc:attributeType:householdIncome" },
  { name: "MEDIAN_HOUSE_PRICE".humanize, data: "urn:oc:attributeType:housePrice" },
  { name: "PROPORTION_GREENSPACE".humanize, data: "urn:oc:attributeType:greenspace" },
  { name: "CARBON_EMISSION".humanize, data: "urn:oc:attributeType:carbonEmission" },
  { name: "CARS_PER_HOUSEHOLD".humanize, data: "urn:oc:attributeType:householdCarOwnership" },
  { name: "WALK_5X_WEEK".humanize, data: "urn:oc:attributeType:walkingFrequency" },
  { name: "CYCLE_1X_WEEK".humanize, data: "urn:oc:attributeType:cyclingFrequency" },
  { name: "PROPORTION_OBESE".humanize, data: "urn:oc:attributeType:obesity" },
  { name: "TRAFFIC_INTENSITY_BICYCLE".humanize, data: "urn:oc:attributeType:trafficIntensity:bicycle" },
  { name: "TRAFFIC_INTENSITY_MOTORCYCLE".humanize, data: "urn:oc:attributeType:trafficIntensity:motorcycle" },
  { name: "TRAFFIC_INTENSITY_CAR".humanize, data: "urn:oc:attributeType:trafficIntensity:car" },
  { name: "TRAFFIC_INTENSITY_BUS".humanize, data: "urn:oc:attributeType:trafficIntensity:bus" },
  { name: "TRAFFIC_INTENSITY_LGV".humanize, data: "urn:oc:attributeType:trafficIntensity:lightGoodsVehicle" },
  { name: "TRAFFIC_INTENSITY_HGV".humanize, data: "urn:oc:attributeType:trafficIntensity:heavyGoodsVehicle" },
  { name: "TRANSPORT_SERVICE_PERFORMANCE".humanize, data: "urn:oc:attributeType:transportServicePerformance" },
  { name: "DESCRIPTION".humanize, data: "urn:oc:attributeType:description" },
  { name: "AREA".humanize, data: "urn:oc:attributeType:area" },
  { name: "POSITION".humanize, data: "urn:oc:attributeType:position" },
  { name: "LOCATION".humanize, data: "geo:point" },
  { name: "COMMENTS".humanize, data: "urn:oc:attributeType:comments" },
  { name: "RANKING".humanize, data: "urn:oc:attributeType:ranking" },
  { name: "ORIGIN".humanize, data: "urn:oc:attributeType:origin" },
  { name: "DATASOURCE".humanize, data: "urn:oc:attributeType:datasource" },
  { name: "NUMERIC".humanize, data:  "urn:oc:datatype:numeric" },
  { name: "STRING".humanize, data:  "urn:oc:datatype:string" },
  { name: "BOOLEAN".humanize, data:  "urn:oc:datatype:boolean" },
  { name: "COORDINATES".humanize, data:  "urn:oc:datatype:coordinates" },
  { name: "GEOJSON".humanize, data:  "urn:oc:datatype:geoJson" },
  { name: "URL".humanize, data:  "urn:oc:datatype:url" },
  { name: "DATETIME".humanize, data:  "urn:oc:datatype:iso8691" },
  { name: "IOT_DEVICE".humanize, data:  "urn:oc:entityType:iotdevice" },
  { name: "BUS_STOP".humanize, data:  "urn:oc:entityType:busStop" },
  { name: "SMARTPHONE".humanize, data:  "urn:oc:entityType:smartphone" },
  { name: "BIKE_STATION".humanize, data:  "urn:oc:entitytype:bikeStation" },
  { name: "BOROUGH".humanize, data:  "urn:oc:entityType:borough" },
  { name: "MANUAL_COUNTER".humanize, data:  "urn:oc:entityType:manualCounter" },
  { name: "DISTRICT_PROFILE".humanize, data:  "urn:oc:entityType:districtProfile" },
  { name: "WEATHER_STATION".humanize, data:  "urn:oc:entityType:weatherstation" },
  { name: "TRAFFIC_STATS".humanize, data:  "urn:oc:entityType:trafficstats" },
  { name: "TRANSPORT_STATION".humanize, data:  "urn:oc:entityType:transportStation" },
  { name: "VOLTS".humanize, data:  "urn:oc:uom:volts" },
  { name: "PPM".humanize, data:  "urn:oc:uom:ppm" },
  { name: "METRE".humanize, data:  "urn:oc:uom:metre" },
  { name: "KGR".humanize, data:  "urn:oc:uom:kilogram" },
  { name: "MBAR".humanize, data:  "urn:oc:uom:mbar" },
  { name: "BAR".humanize, data:  "urn:oc:uom:bar" },
  { name: "CENTIBAR".humanize, data:  "urn:oc:uom:centibar" },
  { name: "DECIBEL".humanize, data:  "urn:oc:uom:decibel" },
  { name: "DEGREE_ANGLE".humanize, data:  "urn:oc:uom:degreeAngle" },
  { name: "DEGREE_CELSIUS".humanize, data:  "urn:oc:uom:degreeCelsius" },
  { name: "INDEX".humanize, data:  "urn:oc:uom:index" },
  { name: "KILOMETRE".humanize, data:  "urn:oc:uom:kilometre" },
  { name: "KILLOMETRE_PER_HOUR".humanize, data:  "urn:oc:uom:kilometrePerHour" },
  { name: "KILOTONNE".humanize, data:  "urn:oc:uom:kilotonne" },
  { name: "LITRE".humanize, data:  "urn:oc:uom:litre" },
  { name: "LITRE_PER_100_KILOMETERS".humanize, data:  "urn:oc:uom:litrePer100Kilometers" },
  { name: "LUX".humanize, data:  "urn:oc:uom:lux" },
  { name: "METRE_PER_SECOND".humanize, data:  "urn:oc:uom:metrePerSecond" },
  { name: "MILIGRAM_PER_CUBIC_METRE".humanize, data:  "urn:oc:uom:miligramPerCubicMetre" },
  { name: "MICROGRAM_PER_CUBIC_METRE".humanize, data:  "urn:oc:uom:microgramPerCubicMetre" },
  { name: "MILILITER_PER_HOUR".humanize, data:  "urn:oc:uom:mililiterPerHour" },
  { name: "MILIVOLT_PER_METRE".humanize, data:  "urn:oc:uom:milivoltPerMetre" },
  { name: "PERCENT".humanize, data:  "urn:oc:uom:percent" },
  { name: "FRACTION".humanize, data:  "urn:oc:uom:fraction" },
  { name: "COUNT".humanize, data:  "urn:oc:uom:count" },
  { name: "REVOLUTION_PER_MINUTE".humanize, data:  "urn:oc:uom:revolutionPerMinute" },
  { name: "SCALE".humanize, data:  "urn:oc:uom:scale" },
  { name: "VEHICLE_PER_DAY".humanize, data:  "urn:oc:uom:vehiclePerDay" },
  { name: "VEHICLE_PER_MINUTE".humanize, data:  "urn:oc:uom:vehiclePerMinute" },
  { name: "WATT_PER_SQUARE_METER".humanize, data:  "urn:oc:uom:wattPerSquareMeter" },
  { name: "LAT_LONG_POSITION".humanize, data:  "coords" },
  { name: "LONG_LAT_POSITION".humanize, data:  "coords" },
  { name: "NOT_APPLIED".humanize, data: "NOT_APPLIED" },
  { name: "PEOPLE_PER_HECTARE".humanize, data: "urn:oc:uom:peoplePerHectare" },
  { name: "MONETARY_VALUE_POUNDS".humanize, data: "urn:oc:uom:monetaryValuePounds" },
  { name: "AMPERE".humanize, data:  "urn:oc:uom:ampere" },
  { name: "KWH".humanize, data:  "urn:oc:uom:kWh" },
  { name: "BIKE".humanize, data: "urn:oc:uom:bike" }
]

data_type_list.each do |data_type|
  DataType.create( name: data_type[:name], data: data_type[:data] )
end

p "Created #{DataType.count} Data types"
