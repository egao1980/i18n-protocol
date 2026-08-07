# i18n-protocol

Lispy **CLOS** internationalization for [cl-stack](https://github.com/egao1980/cl-stack) — locales, **MessageFormat 2** templating, plural/select, catalogs.

| System | Nick | Role |
|--------|------|------|
| `i18n-protocol` | `stack-i18n` | Locale identity, MF2, plural rules, message catalogs |

**Not here:** Unicode properties / normalize / IDNA → [`unicode-protocol`](https://github.com/egao1980/unicode-protocol). Collation / number·date·currency format → [`l10n-protocol`](https://github.com/egao1980/l10n-protocol).

## Shape

| ICU / Unicode | This protocol |
|---------------|----------------|
| `Locale` / BCP 47 | `make-locale` / `parse-locale` / `*locale*` |
| `MessageFormatter` (MF2) | `make-message-formatter` / `format-message` |
| CLDR PluralRules | `plural-category` / `make-plural-rules` |
| ResourceBundle / catalogs | `load-catalog` / `translate` / `ntranslate` |

```lisp
(asdf:load-system "i18n-backend-icu")  ; forthcoming

(stack-i18n:format-message
  "Hello {$name}!"
  '(("name" . "Ada"))
  :locale "en")

(stack-i18n:format-message
  ".match {$n :plural} when 1 {one} when * {{$n} items}"
  '(("n" . 3))
  :locale "en")
```

Tracks [cl-stack#151](https://github.com/egao1980/cl-stack/issues/151).

## License

MIT
