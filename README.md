# Tools for building Hazelcast documentation

## Usage

Within the container run

```bash
git clone --depth 1 https://github.com/hazelcast/hazelcast.git
git clone --depth 1 https://github.com/hazelcast/hazelcast-reference-manual.git

cd hazelcast

HAZELCAST_VERSION=$(mvn -B org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version | grep -v '\[' | grep -vi 'download')

mvn -B javadoc:aggregate -Prelease-snapshot -DskipTests

cd ../hazelcast-reference-manual
gradle --console=plain build

cd ..
mkdir linkchecker

linkchecker -F html/utf_8/linkchecker/index.html \
  -F text/utf_8/linkchecker/linkchecker.txt \
  --check-extern  --no-robots \
  --ignore-url '.*//groups.google.com/forum/.*' \
  -r 1 \
  hazelcast-reference-manual/build/asciidoc/html5/index.html \
  \
  | true

cat linkchecker/linkchecker.txt

```
