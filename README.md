# Running Bareos Filedaemon in a Kubernetes POD

This is an example project to show that you can run a Bareos Filedaemon as a Sidecar in a Kubernetes deployment to do logical backup and restore of the application you have deployed. The example will deploy a Wordpress blog with a MySQL database backend.

While this repository is meant as a reference to see how this can be achieved, we provide [steps to reproduce the setup](STEP-BY-STEP.md). However, this is by no means ready to be used in production.

## Bareos Filedaemon container image
In subdirectory `container-image` you'll find a Dockerfile to build a container image that will run `bareos-fd`.

The image can be customized using envionment variables at deployment time. This will configure the bareos filedaemon and the mysql client in the resulting container.

## Kubernetes Deployment
Subdirectory `k8s` is a kubernetes kustomization directory that you can use to deploy the application with its bareos-fd sidecar. Before deploying you will need to change `DIR_ADDRESS` in `wordpress.yaml` to point to your director.

## Bareos Director configuration
In directory `bareos-dir.d` you will find example configuration for your director to back up and restore the Wordpress blog.
