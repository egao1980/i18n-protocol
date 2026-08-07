(defsystem "i18n-protocol"
  :version "0.1.0"
  :description "CLOS i18n protocol for cl-stack (locales, MessageFormat 2 templating, plural/select, catalogs)"
  :author "egao1980"
  :license "MIT"
  :depends-on ()
  :serial t
  :pathname "src"
  :components ((:file "package")
               (:file "conditions")
               (:file "backend")
               (:file "locale")
               (:file "message")
               (:file "catalog"))
  :in-order-to ((test-op (test-op "i18n-protocol/tests"))))

(defsystem "i18n-protocol/tests"
  :depends-on ("i18n-protocol" "rove")
  :pathname "tests"
  :serial t
  :components ((:file "package")
               (:file "protocol-test"))
  :perform (test-op (o c)
             (unless (symbol-call :rove :run c)
               (error "tests failed for ~A" (component-name c)))))
