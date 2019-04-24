# demo-secrets-can-remain
A simple demo of retrieving secrets from earlier layers

## Checkout and Build

Build the demo container. 

```bash
git clone git@github.com:philipstaffordwood/demo-secrets-can-remain.git
cd demo-secrets-can-remain
docker build . -t secrets
```

Have a look at the [Dockerfile](./Dockerfile), it copies in a secret text file that later gets deleted and it copies in a secret text file that later gets overwritted.

## Save Image as TAR file
Images can be exported as TAR file. Do this:
```bash
docker save secrets:latest -o secrets-image-save.tar
```

## Poke around and find secrets
This just extracts the saved TAR file to a `stuff` folder and then extracts all the TAR files contained inside it to a directory named after the file appended with a `.dir`: 
```bash
mdir stuff
tar xvf ./secrets-image-save.tar -C stuff
cd stuff
find . -name '*.tar' | xargs -I {} sh -c "mkdir {}.dir; tar xvf {} -C {}.dir"
```
Now any secrets left?

### Overwritten Secrets
Let's look for the overwritten secret:
```bash
grep -r "This secret file is to be overwritted"
```
yep!
```
user@server:/code/bigbaobab/qa/demo-secrets-can-remain/stuff$ grep -r "This secret file is to be overwritted" .
Binary file ./19a9c8b11005792ba02317d2a4cebfa3222308fd311b8f8e8499bf30e50a0084/layer.tar matches
./19a9c8b11005792ba02317d2a4cebfa3222308fd311b8f8e8499bf30e50a0084/layer.tar.dir/files/secret.txt:This secret file is to be overwritted in a "later" layer, but is it gone?
```
Have a look at the original overwritten secret:
```bash
cat ./19a9c8b11005792ba02317d2a4cebfa3222308fd311b8f8e8499bf30e50a0084/layer.tar.dir/files/secret.txt
```

### Deleted Secrets
Let's look for the deleted secret:
```bash
grep -r "This secret file is to be deleted" .
```
Also still there:
```
user@server:/code/bigbaobab/qa/demo-secrets-can-remain/stuff$ grep -r "This secret file is to be deleted" .Binary file ./62a97f58a84e4d70338551adb3a50de0e6beb7726ad2f1b4be70a72c70914cc1/layer.tar matches
./62a97f58a84e4d70338551adb3a50de0e6beb7726ad2f1b4be70a72c70914cc1/layer.tar.dir/files/deleted-secret.txt:This secret file is to be deleted in a "later" layer, but is it gone?
```
Have a look at the original deleted secret:
```bash
cat ./62a97f58a84e4d70338551adb3a50de0e6beb7726ad2f1b4be70a72c70914cc1/layer.tar.dir/files/deleted-secret.txt
```
