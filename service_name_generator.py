import string
list(string.ascii_lowercase)

count = 0
service_url = ''
for c in list(string.ascii_lowercase):

    template_vs = '''
    apiVersion: networking.istio.io/v1alpha3
    kind: VirtualService
    metadata:
      name: activemq-service-vs-http-e{1}
      namespace: djin-productivity
    spec:
      gateways:
        - mesh-gateway.djin-productivity.svc.cluster.local
      hosts:
        - activemq-{1}.contentmgmt.stag.pib.dowjones.io
        - ore.activemq-{1}.contentmgmt.stag.pib.dowjones.io
        - vir.activemq-{1}.contentmgmt.stag.pib.dowjones.io
      http:
        - match:
            - port: 8161
              uri:
                prefix: /
          route:
            - destination:
                host: activemq-{0}.djin-shared.svc.cluster.local
                port:
                  number: 8161  
    '''.format(c, count)

    #print template

    template_service = '''
    apiVersion: v1
    kind: Service
    metadata:
      name: activemq-{0}
      namespace: djin-shared
      annotations:
        # Create endpoints also if the related pod isn't ready
        service.alpha.kubernetes.io/tolerate-unready-endpoints: "true"     
    spec:
      ports:
        - name: tcp
          port: 61616
          protocol: TCP
          targetPort: 61616
        - name: http
          port: 8161
          targetPort: 8161
        - name: http-jmx
          port: 9404
          targetPort: 9404
        - name: tcp-jmx
          port: 1099
          targetPort: 1099      
      selector:
        statefulset.kubernetes.io/pod-name: activemq-{1} 
    ---
    '''.format(c, count)

    print template_service


    service_url = service_url + 'tcp://activemq-{0}:61616,'.format(c)


    if count == 15:
        break
    count = count+1

print service_url




