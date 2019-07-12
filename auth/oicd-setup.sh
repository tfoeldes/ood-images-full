#!/bin/bash

#Change Admin Credentials & Add Master Realm
sleep 20
KCADM='/opt/jboss/keycloak/bin/kcadm.sh'

$KCADM config credentials --server http://localhost:8080/auth --realm master --user admin  --password admin
$KCADM create realms -s realm=ondemand -s enabled=true -s loginWithEmailAllowed=false -s rememberMe=true

# Configure LDAP
REALMID=$($KCADM get realms/ondemand --fields id | egrep -v '{|}' | sed 's/.*id".*:\s*"//g; s/"//g')

$KCADM create components -r ondemand -s name=ldap -s providerId=ldap -s providerType=org.keycloak.storage.UserStorageProvider -s parentId=$REALMID  -s 'config.importUsers=["false"]'   -s 'config.priority=["1"]' -s 'config.fullSyncPeriod=["-1"]' -s 'config.changedSyncPeriod=["-1"]' -s 'config.cachePolicy=["DEFAULT"]' -s config.evictionDay=[] -s config.evictionHour=[] -s config.evictionMinute=[] -s config.maxLifespan=[] -s 'config.batchSizeForSync=["1000"]'  -s 'config.editMode=["READ_ONLY"]'  -s 'config.syncRegistrations=["false"]'  -s 'config.vendor=["other"]'  -s 'config.usernameLDAPAttribute=["uid"]' -s 'config.rdnLDAPAttribute=["uid"]' -s 'config.uuidLDAPAttribute=["entryUUID"]'  -s 'config.userObjectClasses=["posixAccount"]' -s 'config.connectionUrl=["ldap://ldap:389"]' -s 'config.usersDn=["ou=People,dc=example,dc=org"]'  -s 'config.authType=["simple"]'  -s 'config.bindDn=["cn=admin,dc=example,dc=org"]' -s 'config.bindCredential=["admin"]'  -s 'config.useTruststoreSpi=["never"]'  -s 'config.connectionPooling=["true"]' -s 'config.pagination=["true"]'

# Add OnDemand as a client
CID=$($KCADM create clients -r ondemand -f /tmp/ondemand-clients.json -i)
$KCADM  get -r ondemand clients/$CID/client-secret | sed -n '/value/p' | sed  's/^.* "//; s/"//' > /tmp/secret
# Add Custom Theme
#cd ../themes
#curl -LOk  https://github.com/OSC/keycloak-theme/archive/v0.0.1.zip
#unzip v0.0.1.zip
#$KCADM update realms/ondemand -s "loginTheme=keycloak-theme-0.0.1"



