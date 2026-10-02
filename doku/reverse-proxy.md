# Reverse-Proxy

NETbrain spricht im Container HTTP und wird nur auf `127.0.0.1:4321` veröffentlicht. Zwischen Ihren Anwendern und NETbrain steht ein Reverse-Proxy, den Sie stellen — nginx, Apache, HAProxy, Traefik oder die Appliance, die bei Ihnen ohnehin davorsteht. NETbrain bringt keinen mit und beschafft kein Zertifikat.

## Die acht Punkte

Hinter jedem steht, was passiert, wenn er fehlt.

### 1. TLS beenden, Zertifikat beschaffen und erneuern

NETbrain setzt sein Sitzungscookie als `secure`; über HTTP verwirft der Browser es wortlos. Die Anmeldeseite erscheint dann nach richtigem Passwort einfach wieder. Ein abgelaufenes Zertifikat wirkt genauso — die Erneuerung gehört in Ihre Überwachung.

### 2. Port 80 auf 443 weiterleiten

Anwender tippen den Namen ohne `https://`.

### 3. HSTS setzen

Der Header `Strict-Transport-Security: max-age=31536000; includeSubDomains` kommt entweder vom Proxy oder von NETbrain, mit `NETBRAIN_HSTS: "true"` in der Compose-Datei. Erst einschalten, wenn HTTPS unter dem endgültigen Namen funktioniert: Ein HSTS-Header unter falschem Namen sperrt diesen Namen ein Jahr lang in jedem Browser, der ihn gesehen hat.

### 4. Mindestens 12 MB Request-Body durchlassen

In nginx: `client_max_body_size 12m`. Ein engerer Deckel lässt einen eingeworfenen Scan in einer Fehlerseite Ihres Proxys enden, die dem Anwender nicht sagt, was los ist.

### 5. `X-Forwarded-For` setzen und die Zahl der Proxys hinterlegen

`NETBRAIN_TRUSTED_PROXY_HOPS` in der Compose-Datei oder im Assistenten, bei einem Proxy `1`. Fehlt der Wert, sieht die Anmeldedrossel alle Anwender als eine Adresse, und ein Fehlversuch sperrt alle aus.

### 6. Port 4321 auf den Proxy beschränken

Steht der Proxy auf demselben Server, erledigt das der Installer. Steht er auf einem anderen Rechner (`NETBRAIN_BIND=0.0.0.0`), brauchen Sie eine Firewallregel — sonst kann jeder am Proxy vorbei `X-Forwarded-For` selbst setzen und gezielt fremde Konten aussperren.

### 7. Den DNS-Namen bei NETbrain hinterlegen

(`NETBRAIN_ALLOWED_HOSTS`, siehe [Installation](installation.html#dns-name-und-proxy-kette-eintragen)). Fehlt er, antwortet NETbrain mit **421**. Den `Host`-Header reicht der Proxy unverändert weiter.

### 8. `NODE_ENV=production` nicht überschreiben

Das Image setzt den Wert; ohne ihn ist das Sitzungscookie nicht `secure`.

Empfohlen: Richten Sie die Healthprobe des Proxys auf `/api/ready`. (Nicht auf `/api/health`: Das meldet bei fehlender Lizenz 503, und der Proxy sperrte die Installation dann von ihrer eigenen Lizenzseite aus.) Dann nimmt er NETbrain während eines Updates kurz aus dem Verkehr.

## Beispiel für nginx

Deckt die Punkte 1 bis 5 ab:

```
server {
  listen 443 ssl;
  server_name netbrain.ihre-firma.de;

  ssl_certificate     /etc/ssl/certs/netbrain.crt;
  ssl_certificate_key /etc/ssl/private/netbrain.key;

  add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
  client_max_body_size 12m;

  location / {
    proxy_pass http://127.0.0.1:4321;
    proxy_set_header Host              $host;
    proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
  }
}

server {
  listen 80;
  server_name netbrain.ihre-firma.de;
  return 308 https://$host$request_uri;
}
```

## Firewall, wenn der Proxy woanders steht

Die Regel gehört in die iptables-Kette `DOCKER-USER`. `ufw` und `firewalld` greifen hier **nicht** — Docker hängt seine eigenen Regeln davor, und `ufw status` meldet „aktiv“, obwohl der Port offen ist.

```
sudo iptables -I DOCKER-USER -i <externes-interface> -p tcp --dport 4321 -j DROP
sudo iptables -I DOCKER-USER -i <externes-interface> -s <ip-des-proxys> -p tcp --dport 4321 -j ACCEPT
sudo iptables -I DOCKER-USER -i <externes-interface> -p tcp --dport 4321 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
```

`-I` fügt vorn ein; die zuletzt gesetzte Regel gilt zuerst. Docker legt die Kette bei jedem Start neu an — machen Sie die Regeln mit dem Mittel Ihrer Distribution dauerhaft, und zwar nach `docker.service`.

## Nachweisen statt annehmen

Vier Punkte lassen sich in je einer Minute belegen:

```
# Zertifikat gültig und HSTS kommt an
curl -sI https://netbrain.ihre-firma.de/login | grep -i strict-transport

# Anwendungsport von außen gesperrt (von einem anderen Rechner aus, muss scheitern)
curl -m 5 http://<server-ip>:4321/api/health

# Healthprobe über den Proxy
curl -s https://netbrain.ihre-firma.de/api/health
```

Den vierten Punkt prüfen Sie im Browser: Werfen Sie eine Datei von etwa 10 MB als Firmenwissen ein. Kommt eine Fehlerseite Ihres Proxys statt einer Meldung von NETbrain, ist das Body-Limit zu eng.
