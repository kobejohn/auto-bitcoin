# auto-bitcoin

Intention
----

Provide a node meeting these requirements:
- Self-healing
- DDoS resistant
- Relatively low cost
- Easy to set up (WIP - definitely not easy yet)

Detail
----

**Self-healing** is accomplished in three ways:
- Use a managed instance group on Google Compute Engine which automatially restarts if the node dies.
- Regularly confirm all required parts (bitcoin, storage, etc.) are available and up to date.
- Store the blockchain on a separate persistent disk so it survives regardless of the creation and deletion of stateless instances running the bitcoin client.

**DDoS resistant** is accomplished by using Google Cloud Platform with minimal exposure.

**Low cost** is accomplished by sacrificing 24/7 availabilty to use Google's pre-emptible instances which have no service level guarantee but are much cheaper.

**Easy to set up** is not accomplished yet. It is planned with Docker, Google Container Engine, and perhaps a web service in the future.

Setup
----

1. Get a google cloud platform account.
    - (to be documented)
1. Install the gcloud command line utility
    - (to be documented)
1. Create a service account with certain permissions
    - (to be documented)
1. Create an Compute Engine Instance Template
    - (to be documented)
    - Turn on preemptible (otherwise it will be much more expensive)
1. Create a Compute Engine Instance Group based on the template
    - (to be documented)
    - startup script using `startup-bootstrap.sh`
    - shutdown script using `shutdown.sh`
