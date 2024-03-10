# fiap-tech-challenge-infra-db

### Tech Challenge 3:
### Passos para homologação dos professores da Fiap

Foi utilizada a nuvem da Amazon (AWS) para este tech challenge:

1. Faça o login na plataforma da AWS;
2. Acesse IAM->Usuários e crie um novo usuário chamado Github;
3. Com esse usuário criado, vá até a listagem de usuários e acesse os detalhes do mesmo;
4. No menu Permissões que irá aparecer na tela de detalhes, clique no botão "Adicionar permissões" que aparece no canto direito e selecione a opção "Criar política em linha";
5. No combo de serviços do formulário que será aberto, selecione a opção EC2, marque a opção "Todas as ações do EC2 (ec2:*)" que irá aparecer, e em Recursos marque a opção "Tudo", logo abaixo irá aparecer um botão "Adicionar mais permissões", clique nele e repita o mesmo processo que fez com o EC2 para os seguintes serviços: EKS, IAM e CloudWatch Logs;
6. Após avançar, defina um nome e clique em "Criar política";
7. Após isso, ainda no menu de Permissões, clique em "Adicionar permissões" mais um vez, porém dessa vez, selecione a opção "Adicionar permissões" ao invés de "Criar política em linha";
8. Na tela que irá aparecer, selecione a opção "Anexar políticas diretamente";
9. Pesquise pela permissão "AmazonEC2ContainerRegistryPowerUser" e adicione ela;
10. Após isso, de volta a tela de detalhes do usuário, clique na aba "Credenciais de Segurança", e no bloco "Chaves de acesso", clique em "Criar chave de acesso";
11. Na tela que irá se abrir, selecione a opção "Command Line Interface (CLI)" e clique em próximo;
12. No valor da etiqueta, coloque o valor "github actions" ou qualquer um que prefira para identificar posteriormente;
13. Copie os valores dos campos "Chave de acesso" e "Chave de acesso secreta";
14. Na plataforma do Github, acesse o menu "Settings" do projeto, na tela que se abrir, clique no menu Security->Secrets and variables->Actions;
15. Adicione uma "repository secret" chamada AWS_ACCESS_KEY_ID com o valor copiado de "Chave de acesso", e crie outra "repository secret" chamada AWS_SECRET_ACCESS_KEY com o valor copiado de "Chave de acesso secreta";
16. Após isso qualquer commit neste repositório que for para a branch "main", irá subir um cluster no EKS e toda a estrutura Kubernetes utilizando os arquivos yamls;

### Validação da execução do Kubernetes

- A plataforma da AWS não permite inicialmente que um usuário root visualize os recursos do kubernetes nos detalhes do Cluster EKS, para que isso seja possível é necessário seguir um tutorial criado por eles mesmos:

(https://docs.aws.amazon.com/eks/latest/userguide/view-kubernetes-resources.html#view-kubernetes-resources-permissions)https://docs.aws.amazon.com/eks/latest/userguide/view-kubernetes-resources.html#view-kubernetes-resources-permissions

- Porém conseguimos visualizar toda a estrutura através do CloudShell. Para isso acesse ele e após ele abrir, digite os comandos abaixo:

```sh

// Será solicitado os seguintes valores neste comando:
// AWS Access Key ID: o mesmo de AWS_ACCESS_KEY_ID configurado em Settings->Security->Secrets and variables->Actions
// AWS Secret Access Key: o mesmo de AWS_SECRET_ACCESS_KEY configurado em Settings->Security->Secrets and variables->Actions
// Default region name: us-east-1
aws configure

aws eks update-kubeconfig --name fiap-tech-challenge-infra-db --region=us-east-2

kubectl get pods

//O valor de api-deployment-b846c58bd-22v7s é apenas como exemplo, verifique a saída do comando get pods acima para validar os logs de um pod específico
kubectl logs --tail=20 api-deployment-b846c58bd-22v7s

```