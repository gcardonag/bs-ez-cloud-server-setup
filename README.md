# Blade Symphony Easy Cloud Server Setup
Get your own server set up!

Requirements:
- Basic knowledge of the cloud platform you are deploying this on
- Basic knowledge of how Terraform works
- Some patience with my documentation (All feedback to improve it is welcome!)

Setup:
- Download and setup Terraform & terraform-provider-vultr Terraform plugin
  - Terraform: https://www.terraform.io
  - terraform-provider-vultr: https://github.com/squat/terraform-provider-vultr/
    - I had to build this from source when using it in Windows 10
	  - Ensure terraform is installed
	  - Install Go (use the link in that repo)
	  - Install Glide (use the link in that repo)
	  - Clone that repository
	  - In the terminal of your choice
	    - Go to the repository directory and run glide install
	    - Go to the directory at \path_to_your_home\go\src\github.com\squat\terraform-provider-vultr\
	    - Run "go build"
		- In the directory from two steps ago, you should now see a file called "terraform-provider-vultr.exe", copy this and paste it under \path_to_your_home\AppData\Roaming\terraform.d\plugins\
- Create a public SSH certificate to manage access to your server
  - AWS: .pem format
  - Vultr: .pub format
- Clone this repository
- Create a packaged version of the Blade Symphony game files (or ask me for one on Discord)
  - Upload this somewhere. Needs to be a place that your new server can download it from with a URL of some kind. (ex- AWS S3, Dropbox)
- Open the setup_script.sh under the platform of your choice
- Set values for the variables at the beginning of the file
- Create a file called variables.tf and fill the values for the variables listed in terraform.tfvars
- In the terminal of your choice
  - Access the directory where you have cloned this repository
  - Run "terraform init"
  - Run "terraform plan"
  - Run "terraform apply"
    - WARNING: THIS STEP WILL CREATE A SERVER AND THINGS THAT YOU MAY GET BILLED FOR

If you ever want to destroy what you built in the setup steps above:
- In the terminal of your choice
  - Access the directory where you have cloned this repository
  - Run "terraform destroy"
    - You will be given a summary of what will be destroyed and a prompt to proceed