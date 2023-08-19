# sudo chmod 755 build_push_image.sh

# declare some variables
image_name=havus/webhook-nginx
image_version=1.0
image_name_with_version="$image_name:$image_version"

# build image from current working dir
docker build -t $image_name_with_version .

# Login to github container registry (ghcr)
echo $CR_PAT | docker login --username havus --password-stdin

# push image to container registry
docker push $image_name_with_version
