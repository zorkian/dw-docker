// ```
// kubecfg update guestbook.jsonnet
// # poke at $(minikube service --url frontend), etc
// kubecfg delete guestbook.jsonnet
// ```

// Load library from Bitnami. We could use another library if we wanted.
local kube = import "https://raw.githubusercontent.com/bitnami-labs/kube-libsonnet/52ba963ca44f7a4960aeae9ee0fbee44726e481f/kube.libsonnet";

{
  db: {
    svc: kube.Service("db") {
      target_pod: $.db.deploy.spec.template,
    },

    deploy: kube.Deployment("db") {
      spec+: {
        replicas: 1,
        template+: {
          spec+: {
            containers_+: {
              apache: kube.Container("mysql") {
                image: "dreamwidth/mysql",
                resources: {
                  requests: {cpu: "100m", memory: "100Mi"},
                },
                ports: [{containerPort: 3306}],
                readinessProbe: {
                  tcpSocket: {port: 3306},
                },
                livenessProbe: self.readinessProbe {
                  initialDelaySeconds: 10,
                },
                env_: {
                  "MYSQL_ROOT_PASSWORD": "root",
                },
              },
            },
          },
        },
      },
    },
  },

  web: {
    svc: kube.Service("web") {
      target_pod: $.web.deploy.spec.template,
      spec+: {type: "LoadBalancer"},
    },

    deploy: kube.Deployment("web") {
      spec+: {
        replicas: 1,
        template+: {
          spec+: {
            containers_+: {
              apache: kube.Container("apache") {
                image: "dreamwidth/web",
                resources: {
                  requests: {cpu: "100m", memory: "500Mi"},
                },
                ports: [{containerPort: 80}],
                readinessProbe: {
                  httpGet: {path: "/", port: 80},
                },
                livenessProbe: self.readinessProbe {
                  initialDelaySeconds: 10,
                },
              },
            },
          },
        },
      },
    },
  },
}