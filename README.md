# GitHub Action for Synopsys Detect

This Action is for [detect](https://synopsys.atlassian.net/wiki/spaces/INTDOCS/pages/62423113/Synopsys+Detect), it enables scanning a repository with `Synopsys Detect`, Synopsys Detect (formerly Hub Detect) consolidates the functionality of Black Duck™ and Coverity™ on Polaris™ tools into a single tool. Synopsys Detect also makes it easier to set up and scan code bases using a variety of languages and package managers.  

## Usage

Including Synopsys detect in your workflow is fairly simple. Just select Synopsys-detect from [Github Marketplace](https://github.com/marketplace/actions/) and click on use the latest version to include it in your workspace. Detailed on using Actions is provided by Github [Learn more](https://help.github.com/en/articles/creating-a-workflow-with-github-actions) about creating a workflow and adding new actions to the workflow.

## Example Usage

An example workflow to build, detect, and Tag a maven project to scan the application is as follows:

```hcl
workflow "Build, Test, and Publish" {
  on = "push"
  resolves = ["Publish"]
}

# User defined maven compiler action (Not currently in actions store)
action "Build" {
  uses = "gautambaghel/ducky-crm/maven-cli@master"
  args = "clean package"
}

# The Detect block, override the arguments to configure options as required 
action "Synopsys detect" {
  needs = "Build"
  uses = "actions/synopsys-detect@master"
  secrets = ["BLACKDUCK_API_TOKEN", "BLACKDUCK_URL"]
  args = "--detect.tools=SIGNATURE_SCAN --detect.project.name=$GITHUB_REPOSITORY"
}

# Filter for a new tag
action "Tag" {
  needs = "Test"
  uses = "actions/bin/filter@master"
  args = "tag"
}

```

### Secrets

* `BLACKDUCK_API_TOKEN` - **REQUIRED**. The token to use for authentication with the blackduck server. Required for scan initiations ([more info](https://synopsys.atlassian.net/wiki/spaces/INTDOCS/pages/62423113/Synopsys+Detect#SynopsysDetect-Providingcredentials))
* `BLACKDUCK_URL` - **REQUIRED**. The URL to use for scan to reside with detect. Required for scan initiations ([more info](https://synopsys.atlassian.net/wiki/spaces/INTDOCS/pages/62423113/Synopsys+Detect#SynopsysDetect-Providingcredentials))


# Using this Action to run Polaris

Although Polaris™ generates it's own build commands depending on the project manager used we strongly recommend having your own *swip.yml* file in the repository.

## Buildless Capture

Including a file like this in the repository with the name *swip.yml* should run a buildless capture in Polaris™. Make sure to include all the languages used in repo.

```
version: "1"
project:
  name: Project-Name
  branch: master
  revision:
    name: Project-Name-Buildless
    date: 2019-04-20T13:25:30Z
    modified: "false"
capture:
  tools:
   coverity:
    2018.12:
     buildless:
      project:
       languages:
         - "java"
install:
  coverity:
    version: latest
serverUrl: https://polaris.synopsys.com
```

Then just including the polaris files in detect should suffice.

```hcl

action "Polaris" {
  uses = "gautambaghel/synopsys-detect@master"
  secrets = ["BLACKDUCK_URL","BLACKDUCK_API_TOKEN","SWIP_ACCESS_TOKEN", "SWIP_SERVER_URL"]
  args = "--detect.tools=POLARIS --detect.project.name=$GITHUB_REPOSITORY --polaris.url=$SWIP_SERVER_URL --polaris.access.token=SWIP_ACCESS_TOKEN"
}

```

## Build Capture

In the polaris folder here is defined a Dockerfile, for a build capture you need to use the Base Image used during the build phase. For example for a Maven project base image would be something like "maven:3.6.1-jdk-8". (Refrain from using alpine based images as some commands may not work)

Usage will be 

```hcl

action "Polaris" {
  uses = "actions/synopsys-detect/polaris@master"
  secrets = ["SWIP_ACCESS_TOKEN", "SWIP_SERVER_URL"]
}

```

## License

The Dockerfile and associated scripts and documentation in this project are released under the [APACHE 2.0](LICENSE).

Container images built with this project include third party materials. See [THIRD_PARTY_NOTICE.md](THIRD_PARTY_NOTICE.md) for details.
