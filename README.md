This is a Docker container holding the [MISO](https://github.com/TGAC/miso-lims) LIMS application from [TGAC](http://www.tgac.ac.uk/). Currently, this container sets up an appropriate database and configures/starts a basic MISO instance. Note that the database is currently being saved within the docker container, so things will be lost once the container is stopper. Further, which `/storage/miso` is an imported volume, it's not yet being used. In short, this container is sufficient for testing, but not yet actual deployment.

One can start things with `docker run -d -p 8080:8080 -v /some/directory:/storage/miso docker-miso`.

The default username password is admin/admin.

You can find further documentation on MISO [here](https://documentation.tgac.ac.uk/display/MISO/MISO+0.2.0+User+Manual).
