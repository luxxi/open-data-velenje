# Open Data Velenje

Open Data Velenje is a project where we have built an interface through which organizations can share their data in a simple way. With the help of Organicity experiment, we made it possible.

![Organicity logo](https://tranquilcity.files.wordpress.com/2017/03/organicity_large.png?w=285&h=152)

Getting started
---------------

Download [Docker](https://www.docker.com/products/overview). If you are on Mac or Windows, [Docker Compose](https://docs.docker.com/compose) will be automatically installed. On Linux, make sure you have the latest version of [Compose](https://docs.docker.com/compose/install/). If you're using [Docker for Windows](https://docs.docker.com/docker-for-windows/) on Windows 10 pro or later, you must also [switch to Linux containers](https://docs.docker.com/docker-for-windows/#switch-between-windows-and-linux-containers).

Run in this directory:
```
docker-compose up --build
```
The app will be running at [http://localhost](http://localhost).

Add Organicity data types:

Run `rake db:seed` to add all Organicity data types into database. This will also add some test organizations, so you can start experimenting with the app right away.

You can always edit the `seeds.rb` file to add your own test organizations or change the data types. You can find all current Organicity data types [here](https://github.com/OrganicityEu/OrganicityEntities/tree/master/src/main/java/eu/organicity/entities/namespace).

Architecture
-----

![Architecture diagram](https://i.imgur.com/rcpCoEV.jpg)

An organization creates a new account and provide data source (URL) and fetch type.
Platform periodically pool data from the source, parse and store them in the database.
Admin should approve organization by calling `approve!` function on your desired organization. This will display the organization on `/organizations`, allow the organization to sign in, add API documentation and also send a notification email to the organization stating that they were approved.
The approved organization can access API configurator to set up field types and write a short description of a field.
If `oc_sync` is set to the true platform will push organization data to [Organicity](http://organicity.eu/) (set LOCAL_OC_URL environment variable to point at your local OC Site).
Organization data is available at endpoint [http://localhost/api/v1/organizations/:organization_name](http://localhost/api/v1/organizations/:organization_name)
