# GitHub Action for Synopsys Detect

This Action is for [detect](https://synopsys.atlassian.net/wiki/spaces/INTDOCS/pages/62423113/Synopsys+Detect), it enables scanning a repository with the `Synopsys Detect`, Synopsys Detect (formerly Hub Detect) consolidates the functionality of Black Duck™ and Coverity™ on Polaris™ tools into a single tool. Synopsys Detect also makes it easier to set up and scan code bases using a variety of languages and package managers.  

## Usage

An example workflow to build, detect, and Tag a project to scan the application is as follows:

```hcl
workflow "Build, Test, and Publish" {
  on = "push"
  resolves = ["Publish"]
}

action "Build" {
  uses = "gautambaghel/synopsys-detect/maven-cli@master"
  args = "clean package"
}

action "Synopsys detect" {
  needs = "Build"
  uses = "gautambaghel/synopsys-detect@master"
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

## License

The Dockerfile and associated scripts and documentation in this project are released under the [APACHE 2.0](LICENSE).

Container images built with this project include third party materials. See [THIRD_PARTY_NOTICE.md](THIRD_PARTY_NOTICE.md) for details.
