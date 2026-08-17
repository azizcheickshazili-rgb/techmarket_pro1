import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  static const String routeName = 'login';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final GlobalKey<FormState> formKey = useMemoized(() => GlobalKey<FormState>());
    final TextEditingController usernameController = useTextEditingController();
    final TextEditingController passwordController = useTextEditingController();
    final ValueNotifier<bool> obscurePassword = useState<bool>(true);

    final AuthState authState = ref.watch(authControllerProvider);
    final bool isLoading = authState is AuthLoading;
    final String? errorMessage =
        authState is AuthUnauthenticated ? authState.errorMessage : null;

    Future<void> submit() async {
      if (!(formKey.currentState?.validate() ?? false)) return;
      await ref.read(authControllerProvider.notifier).login(
            username: usernameController.text,
            password: passwordController.text,
          );
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Semantics(
                    header: true,
                    child: Text(l10n.loginTitle,
                        style: Theme.of(context).textTheme.headlineMedium),
                  ),
                  const SizedBox(height: 6),
                  Text(l10n.loginSubtitle,
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 32),
                  Semantics(
                    textField: true,
                    label: l10n.usernameLabel,
                    child: TextFormField(
                      key: const Key('login_username_field'),
                      controller: usernameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: l10n.usernameLabel),
                      validator: (String? value) =>
                          (value == null || value.trim().isEmpty)
                              ? 'Ce champ est requis.'
                              : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ValueListenableBuilder<bool>(
                    valueListenable: obscurePassword,
                    builder: (BuildContext context, bool obscure, _) {
                      return Semantics(
                        textField: true,
                        label: l10n.passwordLabel,
                        child: TextFormField(
                          key: const Key('login_password_field'),
                          controller: passwordController,
                          obscureText: obscure,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => submit(),
                          decoration: InputDecoration(
                            labelText: l10n.passwordLabel,
                            suffixIcon: Semantics(
                              button: true,
                              label: obscure
                                  ? 'Afficher le mot de passe'
                                  : 'Masquer le mot de passe',
                              child: IconButton(
                                icon: Icon(
                                  obscure
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () =>
                                    obscurePassword.value = !obscure,
                              ),
                            ),
                          ),
                          validator: (String? value) =>
                              (value == null || value.isEmpty)
                                  ? 'Ce champ est requis.'
                                  : null,
                        ),
                      );
                    },
                  ),
                  if (errorMessage != null) ...<Widget>[
                    const SizedBox(height: 12),
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: AppColors.danger),
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),
                  Semantics(
                    button: true,
                    label: l10n.loginButton,
                    enabled: !isLoading,
                    child: ElevatedButton(
                      key: const Key('login_submit_button'),
                      onPressed: isLoading ? null : submit,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                color: Color(0xFF01221F),
                              ),
                            )
                          : Text(l10n.loginButton),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Démo DummyJSON — identifiant: emilys / mot de passe: emilyspass',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
