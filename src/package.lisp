(defpackage #:i18n-protocol
  (:use #:cl)
  (:nicknames #:stack-i18n)
  (:export
   ;; conditions
   #:i18n-error
   #:i18n-unsupported
   #:i18n-locale-error
   #:i18n-message-error
   #:i18n-catalog-error
   #:i18n-error-message
   #:i18n-error-capability

   ;; backend
   #:i18n-backend
   #:*i18n-backend*
   #:backend-capabilities
   #:use-i18n-backend
   #:with-i18n-backend
   #:ensure-i18n-backend
   #:require-capability

   #:backend-make-locale
   #:backend-parse-locale
   #:backend-available-locales
   #:backend-accept-language
   #:backend-make-message-formatter
   #:backend-parse-message-pattern
   #:backend-format-message
   #:backend-make-plural-rules
   #:backend-plural-category
   #:backend-load-catalog
   #:backend-make-message-catalog
   #:backend-catalog-get
   #:backend-catalog-has-p
   #:backend-catalog-locales

   ;; locale (BCP 47 / ICU Locale)
   #:locale
   #:make-locale
   #:locale-language
   #:locale-script
   #:locale-region
   #:locale-variants
   #:locale-extensions
   #:locale-string
   #:parse-locale
   #:available-locales
   #:*locale*
   #:with-locale
   #:accept-language

   ;; MessageFormat 2 templating (ICU MessageFormatter)
   #:message-formatter
   #:make-message-formatter
   #:message-pattern
   #:message-locale
   #:format-message
   #:format-message-to-string
   #:parse-message-pattern

   ;; plural / select (CLDR plural rules; used by MF2)
   #:plural-category
   #:plural-rules
   #:make-plural-rules

   ;; catalogs / resource bundles
   #:message-catalog
   #:make-message-catalog
   #:catalog-get
   #:catalog-has-p
   #:catalog-locales
   #:load-catalog
   #:with-catalog
   #:*message-catalog*
   #:translate
   #:ntranslate))

(in-package #:i18n-protocol)
