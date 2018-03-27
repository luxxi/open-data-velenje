# Open Data Velenje

Open Data Velenje is a project where we have built an interface through which organizations can share their data in a simple way. With the help of Organicity experiment, we made it possible.

Getting started
---------------

Download [Docker](https://www.docker.com/products/overview). If you are on Mac or Windows, [Docker Compose](https://docs.docker.com/compose) will be automatically installed. On Linux, make sure you have the latest version of [Compose](https://docs.docker.com/compose/install/). If you're using [Docker for Windows](https://docs.docker.com/docker-for-windows/) on Windows 10 pro or later, you must also [switch to Linux containers](https://docs.docker.com/docker-for-windows/#switch-between-windows-and-linux-containers).

Run in this directory:
```
docker-compose up --build
```
The app will be running at [http://localhost](http://localhost).

Architecture
-----

![Architecture diagram](https://i.imgur.com/rcpCoEV.jpg)

An organization creates a new account and provide data source (URL) and fetch type.
Platform periodically pool data from the source, parse and store them in the database.
Admin should approve organization by setting `approved` to true.
The approved organization can access API configurator to set up field types and write a short description of a field.
If `oc_sync` is set to the true platform will push organization data to [Organicity](http://organicity.eu/) (set LOCAL_OC_URL environment variable to point at your local OC Site).
Organization data is available at endpoint [http://localhost/api/v1/organizations/:organization_name](http://localhost/api/v1/organizations/:organization_name)
