output "kubeconfig" {
  value = <<KUBECONFIG


apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.aws_eks.endpoint}
    certificate-authority-data: ${aws_eks_cluster.aws_eks.certificate_authority.0.data}
  name: ${aws_eks_cluster.aws_eks.name}
contexts:
- context:
    cluster: ${aws_eks_cluster.aws_eks.name}
    user: ${var.keyname}
  name: ${aws_eks_cluster.aws_eks.name}
current-context: ${aws_eks_cluster.aws_eks.name}
kind: Config
preferences: {}
users:
- name: ${var.keyname}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${aws_eks_cluster.aws_eks.name}"
KUBECONFIG
}
