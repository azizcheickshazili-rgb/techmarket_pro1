# Changelog

Toutes les modifications notables de ce projet sont documentées dans ce fichier.
Le format suit [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/) et le
projet suit le [Semantic Versioning](https://semver.org/lang/fr/).

## [1.0.0] - 2026-08-17

### Ajouté
- Version production-ready complète de TechMarket.
- Authentification JWT contre `/auth/login` (DummyJSON) avec persistance
  sécurisée des tokens (`flutter_secure_storage`) et restauration de
  session au démarrage.
- Catalogue produits avec pagination infinie, recherche en temps réel,
  écran de détail et système de favoris persistant localement.
- Internationalisation complète FR/EN avec bascule dans le profil.
- Accessibilité : `Semantics` labels sur tous les éléments interactifs
  (champs, boutons, cartes produit, navigation).
- Suite de tests complète : 36 tests unitaires, 13 tests widgets,
  2 tests d'intégration.
- Pipeline CI/CD GitHub Actions : format, analyse statique stricte,
  tests avec couverture, build APK release.
- README professionnel avec architecture, setup et badges CI.

### Performance
- `flutter_hooks` pour la gestion des contrôleurs de formulaire (zéro
  `StatefulWidget` superflu, zéro rebuild inutile).
- Images en cache disque via `cached_network_image` avec
  `memCacheWidth` pour limiter la mémoire.
- Widgets `const` partout où c'est possible (`ProductCard`, indicateurs
  de chargement, chips d'information).
- Chargement paresseux (lazy loading) de la grille produits via
  `GridView.builder` + détection de scroll pour la pagination.

## [0.2.0] - 2026-08-15

### Ajouté
- Architecture Clean (data / domain / presentation) par feature.
- Intégration Riverpod pour la gestion d'état (`StateNotifier`,
  `FutureProvider.family`).
- Router `go_router` avec redirections basées sur l'état d'authentification
  et `ShellRoute` pour la navigation par onglets.
- Thème sombre navy/cyan personnalisé (typographie et palette dédiées).

### Corrigé
- Gestion des erreurs réseau centralisée (`Failure` scellé) au lieu
  d'exceptions non typées remontant jusqu'à l'UI.

## [0.1.0] - 2026-08-12

### Ajouté
- Initialisation du projet Flutter et de la structure de dossiers.
- Premier appel à l'API DummyJSON (`GET /products`) sans état applicatif.
- Mise en place du dépôt Git et du workflow Termux (clé PAT, `safe.directory`).

[1.0.0]: https://github.com/azizcheickshazili-rgb/techmarket_pro1/releases/tag/v1.0.0
[0.2.0]: https://github.com/azizcheickshazili-rgb/techmarket_pro1/releases/tag/v0.2.0
[0.1.0]: https://github.com/azizcheickshazili-rgb/techmarket_pro1/releases/tag/v0.1.0
