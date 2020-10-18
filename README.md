[![Docker Pulls](https://img.shields.io/docker/pulls/oursource/sogo.svg)](https://hub.docker.com/r/oursource/sogo/)
[![Docker layers](https://images.microbadger.com/badges/image/oursource/sogo.svg)](https://microbadger.com/images/oursource/sogo)
[![Github Stars](https://img.shields.io/github/stars/our-source/sogo.svg?label=github%20%E2%98%85)](https://github.com/our-source/sogo/)
[![Github Stars](https://img.shields.io/github/contributors/our-source/sogo.svg)](https://github.com/our-source/sogo/)

# SOGo groupware

## webbased groupware

SOGo is a easy to use webmail client that has support for imap, smtp, caldav and carddav.

## Configuration options

For all configuration options read here: https://sogo.nu/files/docs/SOGoInstallationGuide.html

## Kubernetes example

```yaml
---

apiVersion: v1
kind: ConfigMap
metadata:
  name: sogo-conf
data:
  sogo.conf: |-
    {
      /* *********************  Main SOGo configuration file  **********************
       *                                                                           *
       * Since the content of this file is a dictionary in OpenStep plist format,  *
       * the curly braces enclosing the body of the configuration are mandatory.   *
       * See the Installation Guide for details on the format.                     *
       *                                                                           *
       * C and C++ style comments are supported.                                   *
       *                                                                           *
       * This example configuration contains only a subset of all available        *
       * configuration parameters. Please see the installation guide more details. *
       *                                                                           *
       * ~sogo/GNUstep/Defaults/.GNUstepDefaults has precedence over this file,    *
       * make sure to move it away to avoid unwanted parameter overrides.          *
       *                                                                           *
       * **************************************************************************/

      /* Database configuration (mysql:// or postgresql://) */
      //SOGoProfileURL = "postgresql://sogo:sogo@localhost:5432/sogo/sogo_user_profile";
      //OCSFolderInfoURL = "postgresql://sogo:sogo@localhost:5432/sogo/sogo_folder_info";
      //OCSSessionsFolderURL = "postgresql://sogo:sogo@localhost:5432/sogo/sogo_sessions_folder";

      /* Mail */
      SOGoDraftsFolderName = Drafts;
      SOGoSentFolderName = Sent;
      SOGoTrashFolderName = Trash;
      //SOGoIMAPServer = localhost;
      //SOGoSieveServer = sieve://127.0.0.1:4190;
      //SOGoSMTPServer = smtp://domain:port/?tls=YES;
      //SOGoMailDomain = acme.com;
      SOGoMailingMechanism = smtp;
      //SOGoForceExternalLoginWithEmail = NO;
      //SOGoMailSpoolPath = /var/spool/sogo;
      //NGImap4ConnectionStringSeparator = "/";

      /* Notifications */
      //SOGoAppointmentSendEMailNotifications = NO;
      //SOGoACLsSendEMailNotifications = NO;
      //SOGoFoldersSendEMailNotifications = NO;

      /* Authentication */
      SOGoPasswordChangeEnabled = YES;

      /* LDAP authentication example */
      //SOGoUserSources = (
      //  {
      //    type = ldap;
      //    CNFieldName = cn;
      //    UIDFieldName = uid;
      //    IDFieldName = uid; // first field of the DN for direct binds
      //    bindFields = (uid, mail); // array of fields to use for indirect binds
      //    baseDN = "ou=users,dc=acme,dc=com";
      //    bindDN = "uid=sogo,ou=users,dc=acme,dc=com";
      //    bindPassword = qwerty;
      //    canAuthenticate = YES;
      //    displayName = "Shared Addresses";
      //    hostname = ldap://127.0.0.1:389;
      //    id = public;
      //    isAddressBook = YES;
      //  }
      //);

      /* LDAP AD/Samba4 example */
      //SOGoUserSources = (
      //  {
      //    type = ldap;
      //    CNFieldName = cn;
      //    UIDFieldName = sAMAccountName;
      //    baseDN = "CN=users,dc=domain,dc=tld";
      //    bindDN = "CN=sogo,CN=users,DC=domain,DC=tld";
      //    bindFields = (sAMAccountName, mail);
      //    bindPassword = password;
      //    canAuthenticate = YES;
      //    displayName = "Public";
      //    hostname = ldap://127.0.0.1:389;
      //    filter = "mail = '*'";
      //    id = directory;
      //    isAddressBook = YES;
      //  }
      //);


      /* SQL authentication example */
      /*  These database columns MUST be present in the view/table:
       *    c_uid - will be used for authentication -  it's the username or username@domain.tld)
       *    c_name - which can be identical to c_uid -  will be used to uniquely identify entries
       *    c_password - password of the user, plain-text, md5 or sha encoded for now
       *    c_cn - the user's common name - such as "John Doe"
       *    mail - the user's mail address
       *  See the installation guide for more details
       */
      //SOGoUserSources =
      //  (
      //    {
      //      type = sql;
      //      id = directory;
      //      viewURL = "postgresql://sogo:sogo@127.0.0.1:5432/sogo/sogo_view";
      //      canAuthenticate = YES;
      //      isAddressBook = YES;
      //      userPasswordAlgorithm = md5;
      //    }
      //  );

      /* Web Interface */
      //SOGoPageTitle = SOGo;
      SOGoVacationEnabled = YES;
      SOGoForwardEnabled = YES;
      SOGoSieveScriptsEnabled = YES;
      //SOGoMailAuxiliaryUserAccountsEnabled = YES;
      //SOGoTrustProxyAuthentication = NO;
      SOGoXSRFValidationEnabled = YES;

      /* General - SOGoTimeZone *MUST* be defined */
      //SOGoLanguage = English;
      //SOGoTimeZone = America/Montreal;
      //SOGoCalendarDefaultRoles = (
      //  PublicDAndTViewer,
      //  ConfidentialDAndTViewer
      //);
      //SOGoSuperUsernames = (sogo1, sogo2); // This is an array - keep the parens!
      SxVMemLimit = 384;
      //WOPidFile = "/var/run/sogo/sogo.pid";
      SOGoMemcachedHost = "/var/run/memcached/memcached.sock";

      /* Debug */
      //SOGoDebugRequests = YES;
      //SoDebugBaseURL = YES;
      //ImapDebugEnabled = YES;
      //LDAPDebugEnabled = YES;
      //PGDebugEnabled = YES;
      //MySQL4DebugEnabled = YES;
      //SOGoUIxDebugEnabled = YES;
      //WODontZipResponse = YES;
      //WOLogFile = /var/log/sogo/sogo.log;
    }

---

apiVersion: v1
kind: Service
metadata:
  name: sogo
  labels:
    app: sogo
spec:
  ports:
  - port: 80
    targetPort: 80
  selector:
    app: sogo

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: sogo
spec:
  # Stop old container before starting new one.
  # No known upgrade policy know. Save to stop and start a new one.
  strategy:
    type: Recreate
    rollingUpdate: null
  selector:
    matchLabels:
      app: sogo
  replicas: 1
  template:
    metadata:
      labels:
        app: sogo
    spec:
      containers:
      - name: sogo
        image: oursource/sogo:v1.0.0
        imagePullPolicy: IfNotPresent
        resources:
          requests:
            cpu: 100m
            memory: 400Mi
        ports:
        - containerPort: 80
        volumeMounts:
        - mountPath: /etc/sogo/sogo.conf
          name: sogo-conf
          subPath: sogo.conf
          readOnly: true
      volumes:
      - name: sogo-config
        configMap:
          name: sogo-conf
          optional: false

---

apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: sogo-ingress
  annotations:
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    nginx.ingress.kubernetes.io/whitelist-source-range: 172.31.0.0/16
    nginx.ingress.kubernetes.io/proxy-body-size: "0"
spec:
  rules:
  - host: sogo.example.com
    http:
      paths:
      - backend:
          serviceName: sogo
          servicePort: 80
  tls:
  - hosts:
    - sogo.example.com
    secretName: sogo
```
