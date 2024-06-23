# opentofu-doks

Setting up a doks cluster using open tofu (maybe?)

## Requirements before running

Provide a token in a `digitalocean.tfvars` file (or `terraform.tfvars` if you want it to be picked up without specifying),
or pass on the command line when running tofu: `tofu plan -var="do_token=some_token"`

## Connecting to the cluster

After running `tofu apply`, the kube config will be written to `kubeconfig` in the root directory.  This can then be passed to `kubectl` or `k9s`.
For example:

```bash
kubectl --kubeconfig=./kubeconfig get pods
```

or:

```bash
k9s --kubeconfig ./kubeconfig
```
