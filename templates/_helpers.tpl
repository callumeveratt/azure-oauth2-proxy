{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "azure-oauth2-proxy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "azure-oauth2-proxy.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "azure-oauth2-proxy.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "azure-oauth2-proxy.labels" -}}
helm.sh/chart: {{ include "azure-oauth2-proxy.chart" . }}
{{ include "azure-oauth2-proxy.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "azure-oauth2-proxy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "azure-oauth2-proxy.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "azure-oauth2-proxy.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "azure-oauth2-proxy.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create a cookie secret randomly, unless one already exists
*/}}
{{- define "azure-oauth2-proxy.cookieSecret" -}}
{{- $secret := (lookup "v1" "Secret" ( .Release.Namespace ) ( include "azure-oauth2-proxy.fullname" .) ) -}}
  {{- if $secret -}}
    {{-  index $secret "data" "OAUTH2_PROXY_COOKIE_SECRET" -}}
  {{- else -}}
    {{- (randAlphaNum 16) | b64enc | quote -}}
  {{- end -}}
{{- end -}}