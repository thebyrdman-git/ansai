# AAP 2.4 on OpenShift Local (CRC) Setup Guide

This guide outlines the steps to set up Red Hat Ansible Automation Platform (AAP) 2.4 on OpenShift Local (formerly CodeReady Containers - CRC) for troubleshooting and reproduction purposes.

## 📋 Prerequisites

- **Hardware:**
  - macOS (Intel or Apple Silicon), Linux, or Windows Professional.
  - **RAM:** Minimum 16GB recommended (AAP is resource intensive). 32GB is ideal.
  - **CPUs:** 4 vCPUs minimum.
  - **Disk:** 50GB+ free space.
- **Software:**
  - [OpenShift Local (CRC)](https://console.redhat.com/openshift/create/local)
  - Red Hat Account (for pull secrets).

## 🚀 Step 1: Install & Configure OpenShift Local (CRC)

### Automated Setup (Recommended)

You can use the provided Ansible playbook to automate most of these steps:

1.  Install the Kubernetes collection:
    ```bash
    ansible-galaxy collection install kubernetes.core
    pip3 install kubernetes openshift
    ```
2.  Run the playbook:
    ```bash
    ansible-playbook playbooks/setup-local-aap.yml
    ```

### Manual Setup

1.  **Download & Install CRC:**
    Follow the instructions for your OS from the [Red Hat Console](https://console.redhat.com/openshift/create/local).

2.  **Configure Resources:**
    AAP requires significant resources. Before starting CRC, increase the default allocation.
    ```bash
    crc config set cpus 6
    crc config set memory 24576  # 24GB (adjust based on your available RAM, min 16GB)
    crc config set disk-size 60  # 60GB
    ```

3.  **Setup & Start CRC:**
    ```bash
    crc setup
    crc start
    ```
    *Follow the prompts to paste your Pull Secret.*

4.  **Log in:**
    ```bash
    # Source the crc-oc-env to add 'oc' to your path
    eval $(crc oc-env)
    
    # Login as kubeadmin
    oc login -u kubeadmin -p <password-printed-by-crc-start> https://api.crc.testing:6443
    ```

## 📦 Step 2: Install AAP 2.5 Operator

1.  **Create Namespace:**
    ```bash
    oc new-project aap
    ```

2.  **Install Operator via Web Console (Recommended for CRC):**
    - Run `crc console` to open the OpenShift Web Console.
    - Log in as `kubeadmin`.
    - Navigate to **Operators** -> **OperatorHub**.
    - Search for **Ansible Automation Platform**.
    - Select the **Red Hat Ansible Automation Platform** operator.
    - Click **Install**.
    - **Update Channel:** Select `stable-2.5`.
    - **Installation Mode:** A specific namespace on the cluster (`aap`).
    - Click **Install**.

3.  **Verify Installation:**
    Wait for the operator to show "Succeeded" in **Installed Operators**.

### Automated Setup (Playbook)

Alternatively, you can use the provided Ansible playbook (`playbooks/setup-local-aap.yml`), which will attempt to install AAP 2.5 using the default `redhat-operators` catalog.

```bash
ansible-playbook playbooks/setup-local-aap.yml
```

*Note: If the playbook hangs on Operator installation, use the Web Console method above, then re-run the playbook to deploy the Controller.*

## ⚙️ Step 3: Deploy Automation Controller

1.  **Create Controller Instance:**
    - In the **Installed Operators** view, click **Red Hat Ansible Automation Platform**.
    - Click the **Automation Controller** tab.
    - Click **Create AutomationController**.
    - **Name:** `example-controller`
    - **View:** Form view is usually easiest.
    - **Replicas:** Set to `1` (for local resource saving).
    - **Ingress type:** `Route`.
    - Click **Create**.

2.  **Monitor Deployment:**
    ```bash
    oc get pods -n aap -w
    ```
    Wait for the postgres and controller pods to be `Running`.

3.  **Access Controller:**
    - Go to **Networking** -> **Routes** in the console to find the URL.
    - **Username:** `admin`
    - **Password:** Found in the Secret named `example-controller-admin-password`.
      ```bash
      oc extract secret/example-controller-admin-password -n aap --to=-
      ```

## 🧹 Cleanup / Pause

To save battery/resources when not using it:
```bash
crc stop
```

## 📝 Troubleshooting Tips

- **Resource Exhaustion:** If pods are stuck in `Pending`, check `oc describe pod <pod-name>` for "Insufficient cpu/memory". You may need to increase CRC config and run `crc delete && crc start`.
- **Pull Secret Issues:** Ensure your pull secret is up to date if you get `ImagePullBackOff`. Update it via `crc config set pull-secret-file path/to/pull-secret`.

