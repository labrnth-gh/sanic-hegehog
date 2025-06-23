—
authors: Lorenzo Booth, et al.
state: prediscussion
—

## Edge Operating System & Configuration

Edge devices (ED) comprise the fleet of machines that we develop, provision, and sustain once they are in customers' hands. While each device has a Linux-capable CPU, the exact hardware configuration may vary depending on the category and model of device; e.g., development prototypes (DP) or customer devices (MK-01, MK-02, etc.) As long as connectivity is established with the ED, we can assume that we have access to the full capabilities of a Linux Jetson-based ARM device with a UEFI bootloader. This RFD will explore options for the initial provisioning and ongoing sustainment of the software stack that runs atop the edge device CPU: the Operating System (OS) and client services.

### Operating System Choices

When choosing the operating system, there are several options:

*   Buildroot
*   Yocto
*   Server Linux OS configured with a configuration management tool (eg, Ubuntu Server with SaltStack/Ansible)
*   Server Linux OS configured with Nix
*   NixOS

We will choose NixOS because it provides a good balance between configuration reproducibility, ease of development, access to software libraries, and developer effort. Namely, build reproducibility can be obtained with any of the other options provided that we maintain a build process and infrastructure. With NixOS and Flakes, this process can be specified in a single repository and reproduced on any developer machine and/or the build server.

It shall be configured according to the base configuration described in the next section:

### Base Configuration

*   NixOS with client UI for field access and debugging
*   Client application with auto-start
*   Device health and telemetry

### Goals and Exploration

As mentioned in the introduction, this RFD addresses the provisioning and sustainment of the operating system and configuration for edge devices. From this motivation, some key goals emerge:

### Procedure for deployment

A procedure must exist for preparing the configuration for the ED and applying the configuration to the edge device. This procedure must be reproducible and documented.

#### Linux operating system configuration

As our hardware drivers run in the Linux kernel and our software stack exists in the GNU/Linux userspace, our product expects a Linux environment to exist on the ED. The ED must be configured with the hardware and software configuration necessary to access the hardware devices (sensors and actuators) and run our main software routine. The OS-level configuration can include:

*   Hardware drivers
*   Diagnostic UI / Telemetry
*   Network configuration

#### Application deployment and monitoring

As part of the provisioning process, the ED must be able to automatically run our main software routine and be able to provide an indication of the software's health and functionality. This userspace-level configuration can include:

*   Software appliance deployment
*   Test suite for the appliance
*   Telemetry for the appliance

### Failsafe and Rollback

As part of the ongoing sustainment process, the ED must be able to be recovered without human intervention in the event of anomalies during the provisioning or update process. This can be accomplished with features including:

*   A/B partitioning and updates
*   Healthchecks and watchdog processes which may exist on the CPU or a separate co-processor.

### Regression Testing

As part of our development process, the ED operating system and configuration should be able to tested with a typical code coverage and regression testing framework.

### Measurement of Success

Drawing inspiration from [Oxide RFD0026](https://rfd.shared.oxide.computer/rfd/0026#_measurement_of_success): For a foundational choice like the one this document describes, we should also consider the shape of a successful outcome. To succeed, we not only need to ship a product on a specific time frame, but we also need to be able to sustain the product over its entire lifecycle. This means picking a stable foundation that allows us to build the product features we want, but also to support them once they are deployed in the field. It also requires us, where possible, to choose software that is already close to being what we need — where any improvements required to produce something we can ship are tractable and sustainable.

### Determinations