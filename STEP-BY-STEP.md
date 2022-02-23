# Running Bareos Filedaemon in a Kubernetes POD

This is the step-by-step guide to reproduce our test setup.

## Test Environment
This guide has been tested with Red Hat Enterprise Linux 8 (x86_64) and Fedora 35 (x86_64) with a graphical environment and a browser to work with Wordpress later on.
The driver we use for minikube will fetch disk images and create a KVM-based virtual machine. For that you will need at least 2 GB of free memory and around 10 GB of free diskspace in your home-directory.

We also assume that you have an existing setup of Bareos Director and Storage Daemon and that these are accessible from your test-machine.

## Configure `libvirt`
1. Install virtualization packages using `sudo dnf install @virt`
2. Add your user to the group `libvirt` using `sudo usermod -a -G libvirt $USER`
3. Log out and back in
4. Check that you're a member of libvirt now using `id`
5. Start `libvirtd` with `sudo systemctl enable --now libvirtd`
6. Check setup with `sudo virt-host-validate` (IOMMU and secure guest are not needed)

## Install Minikube
1. Download binary from `https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64`
2. Install to /usr/local/bin using `install minikube-linux-amd64 /usr/local/bin/minikube`
3. Configure KVM2 driver with `minikube config set vm-driver kvm2`
4. Start minikube using `minikube start`. This will take some time.
5. Determine minikube's address with `minikube ip`. We will need this later on.
6. Install NGINX Ingress into minikube so we can access our web-service later: `minikube addons enable ingress`.
7. Test the Ingress by opening `http://<your-minikube-ip>` in your browser. You should see an error message stating "404 Not Found" as we don't have any application deployed yet.

You can use `minikube dashboard` to get a Dashboard where you can see what minikube is doing and for example to restart a deployment.

## Building the Bareos Filedaemon image
1. Run `minikube image build -t bareos-fd container-image/` to build the container image and deploy it to your minikube.

## Deploy to Kubernetes
1. In `k8s/wordpress.yaml` set `DIR_ADDRESS` to the address of your Bareos Director.
2. If desired change passwords in `k8s/kustomization.yaml` and in `bareos-dir.d/client/wordpress.conf`.
3. Deploy application with `minikube kubectl -- apply -k k8s/`. This will take some time to finish.
4. Open `http://<your-minikube-ip>` in your browser again. Eventually you should see the Wordpress installer.

## Configuring Bareos
1. Add the files from `bareos-dir.d` to your Director's configuration.
2. Reload the configuration
3. Regularly check `status dir` for the client initiated connection. This may take up to one minute.

## Backup and restore operation
1. Go to `http://<your-minikube-ip>`. Finish the Wordpress installation.
2. Run the `wordpress` job in Bareos.
3. Do some changes in your Blog
4. Restore the `wordpress` job using Bareos to the original directories (where = /). Your changes are now gone.
5. Nuke the Kubernetes application using `minikube kubectl -- delete -k k8s/`.
6. Redeploy the application with `minikube kubectl -- apply -k k8s/`.
7. Go back to `http://<your-minikube-ip>`. The Wordpress installer should greet you again.
8. Restore using Bareos again. Your Blog should be back to where it was when you took the Backup!

## Known issues
During testing the MySQL POD sometimes did not start up correctly, leaving Wordpress unable to connect to its database. Restarting the MySQL POD usually fixes this.
