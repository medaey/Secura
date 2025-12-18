# Secura

🛡️ **Secura – Linux Infrastructure Audit Tool**

**Version : 0.1.0**

Secura est un outil open-source **d’audit Linux en lecture seule** destiné aux **PME, MSP et consultants IT**. Il permet de visualiser rapidement l’état d’un serveur Linux, détecter les risques et générer des rapports clairs pour les équipes IT ou les clients.

---

## 🎯 Objectifs

* Fournir une **vision rapide et fiable** de l’état d’un serveur
* Détecter les **risques de sécurité évidents**
* Produire un **rapport exploitable** pour un client ou pour l’équipe IT
* Rester **simple, lisible et open-source friendly**

---

## 🧩 Fonctionnalités

### Gratuit (Open-Source Core)

* Audit basique de serveur Linux
* Vérification SSH, utilisateurs sudo, firewall, ports ouverts et mises à jour
* Rapport Markdown simple
* Commande unique pour audit local

### Payant (Pro / Enterprise)

* Export PDF avec branding client et résumé exécutif
* Multi-serveurs / Fleet management
* Conformité légère (CIS, ISO, ANSSI)
* Support et SLA
* Intégration CI / automatisation avec Ansible ou scripts
* Alertes et notifications pour les équipes IT

---

## 📦 Installation

```bash
git clone https://github.com/medaey/secura.git
cd secura
chmod +x secura.sh
```

---

## ▶️ Utilisation

### Scan rapide

```bash
sudo ./secura.sh scan
```

Affiche l’état actuel du serveur :

* OS et version
* Uptime
* SSH root login
* Utilisateurs sudo
* Firewall
* Ports ouverts
* Packages à mettre à jour

### Générer un rapport Markdown

```bash
sudo ./secura.sh report
```

Crée un fichier `secureinfra-report.md` lisible et prêt à partager.

---

## 🧠 Avantages pour les PME / MSP

* Standardisation des audits
* Gain de temps pour les administrateurs
* Livrable clair pour clients ou équipe IT
* Facilite le suivi des actions correctives

---

## 🔒 Sécurité

* Lecture seule par défaut
* Aucun changement automatique sur le système
* Transparent et auditable

---

## 💡 Contribuer

Les contributions sont les bienvenues :

* Idées et améliorations
* Retours sur l’expérience terrain
* Corrections et documentation

**Les issues débutants sont taguées `good first issue`.**

---

## 📄 Licence

MIT — utilisez, modifiez, partagez.

---

## ⚠️ Avertissement

Secura **n’est pas un outil de conformité complet**. Il fournit un aperçu rapide et des recommandations, mais ne remplace pas l’expertise humaine en sécurité informatique.
