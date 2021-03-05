
## jetson nano config
- Connect to nano
```bash
ssh sx@192.168.55.1
192.168.55.1:8888
```
> password: dlinano

- use ssh to connect nano
```bash
ssh <username>@192.168.55.1
```

- USB camera
```bash
echo "sudo docker run --runtime nvidia -it --rm --network host \
    --volume ~/nvdli-data:/nvdli-nano/data \
    --device /dev/video0 \
    nvcr.io/nvidia/dli/dli-nano-ai:v2.0.1-r32.4.4" > docker_dli_run.sh
chmod +x docker_dli_run.sh
./docker_dli_run.sh
```

- CSI camera
```bash
echo "sudo docker run --runtime nvidia -it --rm --network host \
    --volume ~/nvdli-data:/nvdli-nano/data \
    --volume /tmp/argus_socket:/tmp/argus_socket \
    --device /dev/video0 \
    nvcr.io/nvidia/dli/dli-nano-ai:v2.0.1-r32.4.4" > docker_dli_run.sh
chmod +x docker_dli_run.sh
./docker_dli_run.sh
```
Remember to change the <tag> if you need other versions:
> v2.0.1-r32.4.4
  
You can find all containers [here](https://ngc.nvidia.com/catalog/containers/nvidia:dli:dli-nano-ai).
