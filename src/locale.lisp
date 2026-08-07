(in-package #:i18n-protocol)

;;; BCP 47 / ICU Locale — identity only. Formatting lives in l10n-protocol.

(defclass locale ()
  ((language :initarg :language :reader locale-language :initform nil)
   (script :initarg :script :reader locale-script :initform nil)
   (region :initarg :region :reader locale-region :initform nil)
   (variants :initarg :variants :reader locale-variants :initform nil)
   (extensions :initarg :extensions :reader locale-extensions :initform nil)
   (tag :initarg :tag :reader locale-string :initform nil
        :documentation "Canonical BCP 47 tag when known."))
  (:documentation "Locale identity (language / script / region / variants)."))

(defvar *locale* nil
  "Dynamically bound current locale (locale object or BCP 47 string).")

(defgeneric backend-make-locale (backend &key language script region variants extensions tag)
  (:documentation "Construct a locale object."))

(defgeneric backend-parse-locale (backend string)
  (:documentation "Parse BCP 47 / ICU locale ID → locale."))

(defgeneric backend-available-locales (backend)
  (:documentation "List of available locale tags (strings)."))

(defgeneric backend-accept-language (backend header &key available)
  (:documentation "Negotiate Accept-Language HEADER against AVAILABLE tags → locale."))

(defun make-locale (&key language script region variants extensions tag
                      (backend *i18n-backend*))
  (backend-make-locale
   (require-capability :locale (ensure-i18n-backend backend))
   :language language :script script :region region
   :variants variants :extensions extensions :tag tag))

(defun parse-locale (string &key (backend *i18n-backend*))
  (backend-parse-locale
   (require-capability :locale (ensure-i18n-backend backend))
   (string string)))

(defun available-locales (&key (backend *i18n-backend*))
  (backend-available-locales
   (require-capability :locale (ensure-i18n-backend backend))))

(defun accept-language (header &key available (backend *i18n-backend*))
  (backend-accept-language
   (require-capability :locale (ensure-i18n-backend backend))
   header :available available))

(defmacro with-locale (locale &body body)
  `(let ((*locale* ,locale))
     ,@body))
