{{/*
Expand the name of the application.
*/}}
{{- define "helper.service" -}}
{{- default .Release.Name $.Values.serviceName | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "helper.project" -}}
{{- required "Provide the projectName in values " $.Values.projectName | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "helper.name" -}}
{{- (print (include "helper.project" $) "-" (include "helper.service" $)) }}
{{- end }}


{{/*
Create the name of the service account to use
*/}}
{{- define "helper.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- include "helper.name" . }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "helper.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "helper.labels" -}}
helm.sh/chart: {{ include "helper.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with $.Values.default.labels.all }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "helper.selectorLabels" -}}
app.kubernetes.io/name: {{ include "helper.fullname" . }}
{{- end }}

{{- define "helper.annotations" -}}
{{- if $.Values.default.annotations }}
{{- with $.Values.default.annotations.all -}}
{{ toYaml . }}
{{- end }}
{{- end }}
{{- end }}


{{- define "helper.fullname" -}}
{{- if .fullnameOverride }}
{{- .fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else -}}
{{ printf "%s-%s" (include "helper.name" $) ($name := .name | required ".name or .fullnameOverride should be given for resources") }}
{{- end }}
{{- end }}


