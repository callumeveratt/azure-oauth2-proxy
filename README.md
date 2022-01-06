# azure-oauth2-proxy

This is a helm chart tailor-built for usage with Azure AD. It allows you to add a proxy infront of things such as prometheus and jaeger.
All that is required is an nginx / ingress with the following annotations:
nginx.ingress.kubernetes.io/auth-signin: https://YOUR OUATH EXTERNAL URL(e.g. oauth.mycompany.com)/oauth2/start?rd=https%3A%2F%2F**PRODUCTURL(e.g. prometheus.mycompany.com)**
nginx.ingress.kubernetes.io/auth-url: http://oauth-proxy-azure-oauth2-proxy.oauth.svc.cluster.local:4180/oauth2/auth (change this to the svc path for your proxy)

Updated from the no longer working copy:
https://git.psu.edu/ais-swe/swe-site/-/wikis/k8s/oauth2-proxy