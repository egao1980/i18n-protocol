(in-package #:i18n-protocol/tests)

(deftest no-backend-signals
  (let ((*i18n-backend* nil))
    (ok (signals (parse-locale "en-GB") 'i18n-error))
    (ok (signals (format-message "Hello {$name}!" '(("name" . "x"))) 'i18n-error))))

(deftest unsupported-capability
  (let* ((b (make-instance 'i18n-backend))
         (*i18n-backend* b))
    (ok (signals (require-capability :message b) 'i18n-unsupported))))

(deftest translate-needs-catalog
  (let ((*i18n-backend* (make-instance 'i18n-backend))
        (*message-catalog* nil))
    (ok (signals (translate "hi") 'i18n-catalog-error))))
