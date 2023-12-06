# Introduction

Hi everybody and welcome to the ALM Workshop of 2023.

Goals:
* Learn new technologies
* Implement CI ALM concepts
* Securely manage secrets for your applications
* Automatically deploy new versions of your application

While it's easier to work with technologies that you use day-to-day, today I would like to try some technologies that you (probably) haven't really worked with yet:

* Golang
* DockerHub
* GitHub DevSpaces
* GitHub Actions
* RedHat OpenShift
    * You can also opt for running Kubernetes locally with **Kind** (Kubernetes in Docker) or **k3d** (k3s in docker)

# Workshop

The workshop will be divided in several tasks that each represent a checkpoint.
If one of the tasks is not working or you ran out of time you can always check-out the branch for that specific checkpoint and catch-up from there.

# Tasks

## Code repository
The code repository is called **aelm-workshop-23**.

## Task 1

* Start your own CodeSpace from the "main" branch
* Run the Golang application from your CodeSpace & checkout the code
* Create a GitHub Actions pipeline:
    * Create the directory .github/workflows and add a ci.yaml file (You can name the file however you want)
    * Compile the Go code on every branch and creates the artifacts
        * HINT: https://pkg.go.dev/cmd/go#hdr-Compile_packages_and_dependencies
        * HINT: https://docs.github.com/en/actions/automating-builds-and-tests/building-and-testing-go
    * When the code is build succesfully a step should occur which containerizes the application and pushes this to DockerHub, This image should be named as such <dockerhub-user>/aelm-workshop-23
        * HINT: Dockerfile is already provided, but we still need a base image
        * HINT: How will you manage your DockerHub password? Try to push from CodeSpace as well, you might have some secret issues here.

## Task 2

* Add SemVer release images
    * This means that when you create a GitHub release with a certain SemVer, the pipeline should be ran again and the docker-image should be <dockerhub-user>/aelm-workshop-23:x.x.x
        * HINT: https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#release
* Release your current code as version 1.0.0

## Task 3

:exclamation: **This task needs to be completed in the aelm-workshop-23-cfg configuration repository**

## Task 4

:exclamation: **This task needs to be completed in the aelm-workshop-23-cfg configuration repository**

## Task 5

* Update the content of the /workshop endpoint:
    * To include yourself in the list of participants
    * Add a field "SweaterScore" that holds a numeric value of 1-10 on the presentators Christmas Sweater. 
        * Provide Validation on this range.
        * The default value of the SweaterScore is setup via an environment variable.
* Release this code as 1.1.0

## Task 6

:exclamation: **This task needs to be completed in the aelm-workshop-23-cfg configuration repository**

## Finish?

**Congratulations, you've now got a functioning code pipeline!! You can update, release and expose you're application on demand now** :clap::muscle:
The next step is to now improve upon this, so that you as a developer can focus solely on producing the code. Choose some of the extra tasks to do, in both repositories are different tasks related to their type.

## Extra's
* Do custom tags for your docker builds, right now it takes the branch name but try something as followed:
    * On "main" branch, should be tagged as such <name>:latest
    * On other branches, should be tagged as such <name>:dev-<commitHash> with the hash being a substring of 8 characters
* The dev Openshift environment should always the use the :latest image that is created when a developer pushes code to main and the build succeeds. Create a trigger in your pipeline that automatically restarts the deployment on Openshift
* Add a metrics endpoint to your application that will give you insights into the application performance
* Add an extra endpoint /settings that:
    * Reads a file called settings.json that is stored in /tmp/settings folder
    * When working merge and release this image as a new version
* If you merge to "main" and your build succeeds at an extra step that Restarts your deployment on Openshift to redeploy the main image immediately
* Write a Go test for our /workshop endpoint

# Directory structure

```
/
|── /.devcontainer
    └── devcontainer.json
|── /.github
    |── /workflows
        └── ci.yaml 
|── /workshop-service
    ├── main.go
    |── workshop.go
    ├── go.mod
    └── go.sum
|── .gitignore
|── Dockerfile
└── README.md
```

# Solutions / Tips

In general I tried to work in a branching structure which is named as followed solution/task-<number>-<description>

## Code repository

### Task 1 - Build pipeline

#### Application

**Golang**

`go run main.go workshop.go`

`go build -o ../bin/workshop -v ./...`

**POST command**

`curl -X POST -H "Content-Type: application/json" -d '{
  "name": "AELM Workshop",
  "date": "07/12/2023",
  "presentator": "Arnout Hoebreckx",
  "participants": ["Arnout Hoebreckx"],
  "sweaterscore": 8
}' http://localhost:3000/workshop`

#### Docker

**Build** 

`docker build -t aelm-workshop-23 .`

**Run / Test** 

`docker run -d --rm -p 3000:3000 --name test-app aelm-workshop-23` 

`curl localhost:3000`

**Rename** 

`docker tag aelm-workshop-2023:main $DOCKER_USERNAME/aelm-workshop-23:main`

**Login to repository** 

`docker login -u $DOCKER_USERNAME` --> You can create access tokens on your profile to use (use devspaces secrets)

**Push to repository** 

`docker push $DOCKER_USERNAME/aelm-workshop-23:main`

## Task 2 - Release

GitHub has a built-in release mechanism, that you can access through the UI. Important for the builds to check out when 