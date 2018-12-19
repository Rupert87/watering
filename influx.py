import time
import sys
import datetime
import Adafruit_DHT
import psycopg2
import json
#from influxdb import InfluxDBClient
# Configure InfluxDB connection variables
#host = "10.3.1.122" # My Ubuntu NUC
#port = 5432 # default port
user = "its" # the user/password created for the pi, with write access
password = "Turbo01Cloud!!" 
#dbname = "influx" # the database we created earlier
interval = 60 # Sample period in seconds
# Create the InfluxDB client object
#client = InfluxDBClient(host, port, user, password, dbname)
# Enter the sensor details
sensor = Adafruit_DHT.DHT11
sensor_gpio = 4
    
    
# think of measurement as a SQL table, it's not...but...
measurement = "rpi-dht11"
# location will be used as a grouping tag later
location = "Kyle-Greenhouse"
# Run until you get a ctrl^c
try:
    while True:
        # Read the sensor using the configured driver and gpio
        humidity, temperature = Adafruit_DHT.read_retry(sensor, sensor_gpio)
        temperatue = temperature * 9/5.0 + 32
        iso = time.ctime()
        # Print for debugging, uncomment the below line
        # print("[%s] Temp: %s, Humidity: %s" % (iso, temperature, humidity)) 
        # Create the JSON data structure
        data = [
        {
          "measurement": measurement,
              "tags": {
                  "location": location,
              },
              "time": iso,
              "fields": {
                  "temperature" : temperature,
                  "humidity": humidity
              }
         }
        ]
        # Send the JSON data to InfluxDB
        #client.write_points(data)
        #myjson = JSON.dump(data);
        # Wait until it's time to query again...
        time.sleep(interval)

        conn = psycopg2.connect(database='watering', user='water_user', password='password', host='10.3.1.122', port='5432')
        cur = conn.cursor()
        cur.execute("INSERT INTO json (data) VALUES (%s)", [temp(data)])
        #cur.execute("""INSERT INTO tax VALUES (%(data: "temperature")""")
        #cur.execute("INSERT INTO temperature VALUES(%s, %s, %s);", [temperature])
        #cur.execute("""INSERT INTO tax VALUES (1,"data": "temperature")""")
        #cur.execute("INSERT INTO measurements VALUES(%s);", [humidity])
        #cur.execute("INSERT INTO tax VALUES(%s);", [humidity])
        #(INSERT INTO books VALUES (1,
        #'{ "name": "Book the First", "author": { "first_name": "Bob", "last_name": "White" } }');
        #INSERT INTO books VALUES (2,
        #'{ "name": "Book the Second", "author": { "first_name": "Charles", "last_name": "Xavier" } }');
        #cur.execute("""INSERT INTO temperature VALUES (1,'{"measurement": "location", "time", "temperature", "humidity": "data"} ')""")
        conn.commit()
        conn.close()
#req = data()

# data here is a list of dicts
#data = req.json()['data']

#cur = conn.cursor()
# create a table with one column of type JSON
#cur.execute("CREATE TABLE temperatue (data json);")

#fields = [
#    'temperature',
#    'humidity'
#]

#for item in data:
#    my_data = {field: item[field] for field in fields}
#    cur.execute("INSERT INTO temperatue VALUES (%s)", (json.dumps(my_data),))


# commit changes
#conn.commit()
# Close the connection
#conn.close()
     
#cur = conn.cursor()
# create a table with one column of type JSON
    #temp = json.loads(temperature)
    #print (temp["temperature"])
except KeyboardInterrupt:
    pass
