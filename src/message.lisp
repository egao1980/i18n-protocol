(in-package #:i18n-protocol)

;;; MessageFormat 2 templating — ICU MessageFormatter.
;;; Legacy ICU MessageFormat (MF1) may be offered by backends as :message-legacy.

(defclass message-formatter ()
  ((pattern :initarg :pattern :reader message-pattern)
   (locale :initarg :locale :reader message-locale :initform nil)
   (raw :initarg :raw :accessor message-raw :initform nil))
  (:documentation "Immutable MF2 formatter (ICU MessageFormatter)."))

(defclass plural-rules ()
  ((locale :initarg :locale :reader plural-rules-locale)
   (type :initarg :type :reader plural-rules-type :initform :cardinal
         :documentation ":cardinal or :ordinal")
   (raw :initarg :raw :accessor plural-rules-raw :initform nil)))

(defgeneric backend-make-message-formatter (backend pattern &key locale)
  (:documentation "Parse MF2 PATTERN for LOCALE → message-formatter."))

(defgeneric backend-parse-message-pattern (backend pattern)
  (:documentation "Validate/parse MF2 pattern; return opaque data model or PATTERN string."))

(defgeneric backend-format-message (backend formatter arguments)
  (:documentation "ARGUMENTS is a hash-table (equal string keys) or alist.
→ formatted string (format-message-to-string) or structured result."))

(defgeneric backend-make-plural-rules (backend locale &key type)
  (:documentation "CLDR plural rules for LOCALE."))

(defgeneric backend-plural-category (backend rules number)
  (:documentation "→ :zero :one :two :few :many :other"))

(defun make-message-formatter (pattern &key locale (backend *i18n-backend*))
  "Build MF2 formatter. PATTERN is a MessageFormat 2 syntax string."
  (backend-make-message-formatter
   (require-capability :message (ensure-i18n-backend backend))
   (string pattern)
   :locale (or locale *locale*)))

(defun parse-message-pattern (pattern &key (backend *i18n-backend*))
  (backend-parse-message-pattern
   (require-capability :message (ensure-i18n-backend backend))
   (string pattern)))

(defun format-message-to-string (formatter arguments &key (backend *i18n-backend*))
  "ICU MessageFormatter.formatToString. ARGUMENTS = hash-table or alist."
  (backend-format-message
   (require-capability :message (ensure-i18n-backend backend))
   formatter arguments))

(defun format-message (pattern arguments &key locale (backend *i18n-backend*))
  "One-shot: compile PATTERN and format ARGUMENTS."
  (format-message-to-string
   (make-message-formatter pattern :locale locale :backend backend)
   arguments :backend backend))

(defun make-plural-rules (locale &key (type :cardinal) (backend *i18n-backend*))
  (backend-make-plural-rules
   (require-capability :plural (ensure-i18n-backend backend))
   locale :type type))

(defun plural-category (number &key locale (type :cardinal) rules
                                 (backend *i18n-backend*))
  "CLDR plural category for NUMBER."
  (let* ((b (require-capability :plural (ensure-i18n-backend backend)))
         (r (or rules (make-plural-rules (or locale *locale*) :type type :backend b))))
    (backend-plural-category b r number)))
