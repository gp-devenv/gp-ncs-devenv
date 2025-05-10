#!/bin/sh

#
# gp-ncs-devenv
# Copyright (c) 2025, Greg PFISTER. MIT License.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <UBUNUT_VERSION>"
    exit 1
fi

VERSION=$(cat .version)
VERSION_MAJOR=$(echo $VERSION | sed 's/\([0-9]*\).\([0-9]*\).\([0-9]*\)$/\1/')
VERSION_MINOR=$(echo $VERSION | sed 's/\([0-9]*\).\([0-9]*\).\([0-9]*\)$/\1.\2/')
DOCKERFILE=$(echo "./Dockerfile."$1)
IMAGE_NAME=$(cat .image_name)
IMAGE_BASE_TAG="$IMAGE_NAME:$1"
IMAGE_VERSION="$IMAGE_BASE_TAG-$VERSION"
IMAGE_VERSION_MAJOR="$IMAGE_BASE_TAG-$VERSION_MAJOR"
IMAGE_VERSION_MINOR="$IMAGE_BASE_TAG-$VERSION_MINOR"

if [ ! -f "$DOCKERFILE" ]; then
    echo "Dockerfile '$DOCKERFILE' not found"
    exit 1
fi

docker buildx build --no-cache \
                    --platform linux/amd64 \
                    --label org.opencontainers.image.source="https://github.com/gp-devenv/gp-ncs-devenv" \
                    --label org.opencontainers.image.description="NCS dev container for VS Code running Ubuntu $1" \
                    --label org.opencontainers.image.licenses=MIT \
                    -t $IMAGE_BASE_TAG \
                    -t $IMAGE_VERSION \
                    -t $IMAGE_VERSION_MAJOR \
                    -t $IMAGE_VERSION_MINOR \
                    -f "$DOCKERFILE" .

# End