From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: [PATCH v2 6/6] ima: Support module-style appended signatures for appraisal
Date: Wed,  7 Jun 2017 22:49:15 -0300
Message-ID: <1496886555-10082-7-git-send-email-bauerman@linux.vnet.ibm.com>
References: <1496886555-10082-1-git-send-email-bauerman@linux.vnet.ibm.com>
Cc: linux-ima-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jessica Yu <jeyu@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "AKASHI, Takahiro" <takahiro.akashi@linaro.org>,
        Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1496886555-10082-1-git-send-email-bauerman@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch introduces the modsig keyword to the IMA policy syntax to
specify that a given hook should expect the file to have the IMA signature
appended to it. Here is how it can be used in a rule:

appraise func=KEXEC_KERNEL_CHECK appraise_type=modsig|imasig

With this rule, IMA will accept either an appended signature or a signature
stored in the extended attribute. In that case, it will first check whether
there is an appended signature, and if not it will read it from the
extended attribute.

The format of the appended signature is the same used for signed kernel
modules. This means that the file can be signed with the scripts/sign-file
tool, with a command line such as this:

$ sign-file sha256 privkey_ima.pem x509_ima.der vmlinux

This code only works for files that are hashed from a memory buffer, not
for files that are read from disk at the time of hash calculation. In other
words, only hooks that use kernel_read_file can support appended
signatures. This means that only FIRMWARE_CHECK, KEXEC_KERNEL_CHECK,
KEXEC_INITRAMFS_CHECK and POLICY_CHECK can be supported.

This feature warrants a separate config option because it depends on many
other config options:

 ASYMMETRIC_KEY_TYPE n -> y
 CRYPTO_RSA n -> y
 INTEGRITY_SIGNATURE n -> y
 MODULE_SIG_FORMAT n -> y
 SYSTEM_DATA_VERIFICATION n -> y
+ASN1 y
+ASYMMETRIC_PUBLIC_KEY_SUBTYPE y
+CLZ_TAB y
+CRYPTO_AKCIPHER y
+IMA_APPRAISE_MODSIG y
+IMA_TRUSTED_KEYRING n
+INTEGRITY_ASYMMETRIC_KEYS y
+INTEGRITY_TRUSTED_KEYRING n
+MPILIB y
+OID_REGISTRY y
+PKCS7_MESSAGE_PARSER y
+PKCS7_TEST_KEY n
+SECONDARY_TRUSTED_KEYRING n
+SIGNATURE y
+SIGNED_PE_FILE_VERIFICATION n
+SYSTEM_EXTRA_CERTIFICATE n
+SYSTEM_TRUSTED_KEYRING y
+SYSTEM_TRUSTED_KEYS ""
+X509_CERTIFICATE_PARSER y

The change in CONFIG_INTEGRITY_SIGNATURE to select CONFIG_KEYS instead of
depending on it is to avoid a dependency recursion in
CONFIG_IMA_APPRAISE_MODSIG, because CONFIG_MODULE_SIG_FORMAT selects
CONFIG_KEYS and Kconfig complains that CONFIG_INTEGRITY_SIGNATURE depends
on it.

Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
---
 crypto/asymmetric_keys/pkcs7_parser.c     |  12 +++
 include/crypto/pkcs7.h                    |   3 +
 security/integrity/Kconfig                |   2 +-
 security/integrity/digsig.c               |  28 +++--
 security/integrity/ima/Kconfig            |  13 +++
 security/integrity/ima/Makefile           |   1 +
 security/integrity/ima/ima.h              |  53 ++++++++++
 security/integrity/ima/ima_api.c          |   2 +-
 security/integrity/ima/ima_appraise.c     |  41 ++++++--
 security/integrity/ima/ima_main.c         |  91 ++++++++++++----
 security/integrity/ima/ima_modsig.c       | 167 ++++++++++++++++++++++++++++++
 security/integrity/ima/ima_policy.c       |  26 +++--
 security/integrity/ima/ima_template_lib.c |  14 ++-
 security/integrity/integrity.h            |   5 +-
 14 files changed, 404 insertions(+), 54 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index af4cd8649117..e41beda297a8 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -673,3 +673,15 @@ int pkcs7_note_signed_info(void *context, size_t hdrlen,
 		return -ENOMEM;
 	return 0;
 }
+
+/**
+ * pkcs7_get_message_sig - get signature in @pkcs7
+ *
+ * This function doesn't meaningfully support messages with more than one
+ * signature. It will always return the first signature.
+ */
+const struct public_key_signature *pkcs7_get_message_sig(
+					const struct pkcs7_message *pkcs7)
+{
+	return pkcs7->signed_infos ? pkcs7->signed_infos->sig : NULL;
+}
diff --git a/include/crypto/pkcs7.h b/include/crypto/pkcs7.h
index 583f199400a3..a05a0d7214e6 100644
--- a/include/crypto/pkcs7.h
+++ b/include/crypto/pkcs7.h
@@ -29,6 +29,9 @@ extern int pkcs7_get_content_data(const struct pkcs7_message *pkcs7,
 				  const void **_data, size_t *_datalen,
 				  size_t *_headerlen);
 
+extern const struct public_key_signature *pkcs7_get_message_sig(
+					const struct pkcs7_message *pkcs7);
+
 /*
  * pkcs7_trust.c
  */
diff --git a/security/integrity/Kconfig b/security/integrity/Kconfig
index da9565891738..0d642e0317c7 100644
--- a/security/integrity/Kconfig
+++ b/security/integrity/Kconfig
@@ -17,8 +17,8 @@ if INTEGRITY
 
 config INTEGRITY_SIGNATURE
 	bool "Digital signature verification using multiple keyrings"
-	depends on KEYS
 	default n
+	select KEYS
 	select SIGNATURE
 	help
 	  This option enables digital signature verification support
diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
index 06554c448dce..9190c9058f4f 100644
--- a/security/integrity/digsig.c
+++ b/security/integrity/digsig.c
@@ -48,11 +48,10 @@ static bool init_keyring __initdata;
 #define restrict_link_to_ima restrict_link_by_builtin_trusted
 #endif
 
-int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
-			    const char *digest, int digestlen)
+struct key *integrity_keyring_from_id(const unsigned int id)
 {
-	if (id >= INTEGRITY_KEYRING_MAX || siglen < 2)
-		return -EINVAL;
+	if (id >= INTEGRITY_KEYRING_MAX)
+		return ERR_PTR(-EINVAL);
 
 	if (!keyring[id]) {
 		keyring[id] =
@@ -61,18 +60,29 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 			int err = PTR_ERR(keyring[id]);
 			pr_err("no %s keyring: %d\n", keyring_name[id], err);
 			keyring[id] = NULL;
-			return err;
+			return ERR_PTR(err);
 		}
 	}
 
+	return keyring[id];
+}
+
+int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
+			    const char *digest, int digestlen)
+{
+	struct key *keyring = integrity_keyring_from_id(id);
+
+	if (IS_ERR(keyring) || siglen < 2)
+		return -EINVAL;
+
 	switch (sig[1]) {
 	case 1:
 		/* v1 API expect signature without xattr type */
-		return digsig_verify(keyring[id], sig + 1, siglen - 1,
-				     digest, digestlen);
+		return digsig_verify(keyring, sig + 1, siglen - 1, digest,
+				     digestlen);
 	case 2:
-		return asymmetric_verify(keyring[id], sig, siglen,
-					 digest, digestlen);
+		return asymmetric_verify(keyring, sig, siglen, digest,
+					 digestlen);
 	}
 
 	return -EOPNOTSUPP;
diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 35ef69312811..55f734a6124b 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -163,6 +163,19 @@ config IMA_APPRAISE_BOOTPARAM
 	  This option enables the different "ima_appraise=" modes
 	  (eg. fix, log) from the boot command line.
 
+config IMA_APPRAISE_MODSIG
+	bool "Support module-style signatures for appraisal"
+	depends on IMA_APPRAISE
+	depends on INTEGRITY_ASYMMETRIC_KEYS
+	select PKCS7_MESSAGE_PARSER
+	select MODULE_SIG_FORMAT
+	default n
+	help
+	   Adds support for signatures appended to files. The format of the
+	   appended signature is the same used for signed kernel modules.
+	   The modsig keyword can be used in the IMA policy to allow a hook
+	   to accept such signatures.
+
 config IMA_TRUSTED_KEYRING
 	bool "Require all keys on the .ima keyring be signed (deprecated)"
 	depends on IMA_APPRAISE && SYSTEM_TRUSTED_KEYRING
diff --git a/security/integrity/ima/Makefile b/security/integrity/ima/Makefile
index 29f198bde02b..c72026acecc3 100644
--- a/security/integrity/ima/Makefile
+++ b/security/integrity/ima/Makefile
@@ -8,5 +8,6 @@ obj-$(CONFIG_IMA) += ima.o
 ima-y := ima_fs.o ima_queue.o ima_init.o ima_main.o ima_crypto.o ima_api.o \
 	 ima_policy.o ima_template.o ima_template_lib.o
 ima-$(CONFIG_IMA_APPRAISE) += ima_appraise.o
+ima-$(CONFIG_IMA_APPRAISE_MODSIG) += ima_modsig.o
 ima-$(CONFIG_HAVE_IMA_KEXEC) += ima_kexec.o
 obj-$(CONFIG_IMA_BLACKLIST_KEYRING) += ima_mok.o
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index d52b487ad259..eb3ff7286b07 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -190,6 +190,8 @@ enum ima_hooks {
 	__ima_hooks(__ima_hook_enumify)
 };
 
+extern const char *const func_tokens[];
+
 /* LIM API function definitions */
 int ima_get_action(struct inode *inode, int mask,
 		   enum ima_hooks func, int *pcr);
@@ -248,6 +250,19 @@ enum hash_algo ima_get_hash_algo(struct evm_ima_xattr_data *xattr_value,
 int ima_read_xattr(struct dentry *dentry,
 		   struct evm_ima_xattr_data **xattr_value);
 
+#ifdef CONFIG_IMA_APPRAISE_MODSIG
+bool ima_hook_supports_modsig(enum ima_hooks func);
+int ima_read_modsig(const void *buf, loff_t *buf_len,
+		    struct evm_ima_xattr_data **xattr_value,
+		    int *xattr_len);
+enum hash_algo ima_get_modsig_hash_algo(struct evm_ima_xattr_data *hdr);
+int ima_modsig_serialize_data(struct evm_ima_xattr_data *hdr,
+			      struct evm_ima_xattr_data **data, int *data_len);
+int ima_modsig_verify(const unsigned int keyring_id,
+		      struct evm_ima_xattr_data *hdr);
+void ima_free_xattr_data(struct evm_ima_xattr_data *hdr);
+#endif
+
 #else
 static inline int ima_appraise_measurement(enum ima_hooks func,
 					   struct integrity_iint_cache *iint,
@@ -291,6 +306,44 @@ static inline int ima_read_xattr(struct dentry *dentry,
 
 #endif /* CONFIG_IMA_APPRAISE */
 
+#ifndef CONFIG_IMA_APPRAISE_MODSIG
+static inline bool ima_hook_supports_modsig(enum ima_hooks func)
+{
+	return false;
+}
+
+static inline int ima_read_modsig(const void *buf, loff_t *buf_len,
+				  struct evm_ima_xattr_data **xattr_value,
+				  int *xattr_len)
+{
+	return -ENOTSUPP;
+}
+
+static inline enum hash_algo ima_get_modsig_hash_algo(
+						struct evm_ima_xattr_data *hdr)
+{
+	return HASH_ALGO__LAST;
+}
+
+static inline int ima_modsig_serialize_data(struct evm_ima_xattr_data *hdr,
+					    struct evm_ima_xattr_data **data,
+					    int *data_len)
+{
+	return -ENOTSUPP;
+}
+
+static inline int ima_modsig_verify(const unsigned int keyring_id,
+				    struct evm_ima_xattr_data *hdr)
+{
+	return -ENOTSUPP;
+}
+
+static inline void ima_free_xattr_data(struct evm_ima_xattr_data *hdr)
+{
+	kfree(hdr);
+}
+#endif
+
 /* LSM based policy rules require audit */
 #ifdef CONFIG_IMA_LSM_RULES
 
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index c2edba8de35e..e3328c866362 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -204,7 +204,7 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 		char digest[IMA_MAX_DIGEST_SIZE];
 	} hash;
 
-	if (!(iint->flags & IMA_COLLECTED)) {
+	if (!(iint->flags & IMA_COLLECTED) || iint->ima_hash->algo != algo) {
 		u64 i_version = file_inode(file)->i_version;
 
 		if (file->f_flags & O_DIRECT) {
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 87d2b601cf8e..8716c4fb3675 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -172,6 +172,11 @@ enum hash_algo ima_get_hash_algo(struct evm_ima_xattr_data *xattr_value,
 		} else if (xattr_len == 17)
 			return HASH_ALGO_MD5;
 		break;
+	case IMA_MODSIG:
+		ret = ima_get_modsig_hash_algo(xattr_value);
+		if (ret < HASH_ALGO__LAST)
+			return ret;
+		break;
 	}
 
 	/* return default hash algo */
@@ -229,10 +234,14 @@ int ima_appraise_measurement(enum ima_hooks func,
 		goto out;
 	}
 
-	status = evm_verifyxattr(dentry, XATTR_NAME_IMA, xattr_value, rc, iint);
-	if ((status != INTEGRITY_PASS) && (status != INTEGRITY_UNKNOWN)) {
-		if ((status == INTEGRITY_NOLABEL)
-		    || (status == INTEGRITY_NOXATTRS))
+	/* Appended signatures aren't protected by EVM. */
+	status = evm_verifyxattr(dentry, XATTR_NAME_IMA,
+				 xattr_value->type == IMA_MODSIG ?
+				 NULL : xattr_value, rc, iint);
+	if (status != INTEGRITY_PASS && status != INTEGRITY_UNKNOWN &&
+	    !(xattr_value->type == IMA_MODSIG &&
+	      (status == INTEGRITY_NOLABEL || status == INTEGRITY_NOXATTRS))) {
+		if (status == INTEGRITY_NOLABEL || status == INTEGRITY_NOXATTRS)
 			cause = "missing-HMAC";
 		else if (status == INTEGRITY_FAIL)
 			cause = "invalid-HMAC";
@@ -267,11 +276,18 @@ int ima_appraise_measurement(enum ima_hooks func,
 		status = INTEGRITY_PASS;
 		break;
 	case EVM_IMA_XATTR_DIGSIG:
+	case IMA_MODSIG:
 		iint->flags |= IMA_DIGSIG;
-		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
-					     (const char *)xattr_value, rc,
-					     iint->ima_hash->digest,
-					     iint->ima_hash->length);
+
+		if (xattr_value->type == EVM_IMA_XATTR_DIGSIG)
+			rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
+						     (const char *)xattr_value,
+						     rc, iint->ima_hash->digest,
+						     iint->ima_hash->length);
+		else
+			rc = ima_modsig_verify(INTEGRITY_KEYRING_IMA,
+					       xattr_value);
+
 		if (rc == -EOPNOTSUPP) {
 			status = INTEGRITY_UNKNOWN;
 		} else if (rc) {
@@ -291,13 +307,15 @@ int ima_appraise_measurement(enum ima_hooks func,
 	if (status != INTEGRITY_PASS) {
 		if ((ima_appraise & IMA_APPRAISE_FIX) &&
 		    (!xattr_value ||
-		     xattr_value->type != EVM_IMA_XATTR_DIGSIG)) {
+		     (xattr_value->type != EVM_IMA_XATTR_DIGSIG &&
+		      xattr_value->type != IMA_MODSIG))) {
 			if (!ima_fix_xattr(dentry, iint))
 				status = INTEGRITY_PASS;
 		} else if ((inode->i_size == 0) &&
 			   (iint->flags & IMA_NEW_FILE) &&
 			   (xattr_value &&
-			    xattr_value->type == EVM_IMA_XATTR_DIGSIG)) {
+			    (xattr_value->type == EVM_IMA_XATTR_DIGSIG ||
+			     xattr_value->type == IMA_MODSIG))) {
 			status = INTEGRITY_PASS;
 		}
 		integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode, filename,
@@ -406,7 +424,8 @@ int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
 		if (!xattr_value_len || (xvalue->type >= IMA_XATTR_LAST))
 			return -EINVAL;
 		ima_reset_appraise_flags(d_backing_inode(dentry),
-			 (xvalue->type == EVM_IMA_XATTR_DIGSIG) ? 1 : 0);
+					 xvalue->type == EVM_IMA_XATTR_DIGSIG ||
+					 xvalue->type == IMA_MODSIG);
 		result = 0;
 	}
 	return result;
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 2aebb7984437..5527acab034e 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -16,6 +16,9 @@
  *	implements the IMA hooks: ima_bprm_check, ima_file_mmap,
  *	and ima_file_check.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/file.h>
 #include <linux/binfmts.h>
@@ -155,12 +158,66 @@ void ima_file_free(struct file *file)
 	ima_check_last_writer(iint, inode, file);
 }
 
+static int measure_and_appraise(struct file *file, char *buf, loff_t size,
+				enum ima_hooks func, int opened, int action,
+				struct integrity_iint_cache *iint,
+				struct evm_ima_xattr_data **xattr_value_,
+				int *xattr_len_, const char *pathname,
+				bool appended_sig)
+{
+	struct ima_template_desc *template_desc;
+	struct evm_ima_xattr_data *xattr_value = NULL;
+	enum hash_algo hash_algo;
+	int rc, xattr_len = 0;
+
+	template_desc = ima_template_desc_current();
+	if (action & IMA_APPRAISE_SUBMASK ||
+	    strcmp(template_desc->name, IMA_TEMPLATE_IMA_NAME) != 0) {
+		if (appended_sig) {
+			/* Shouldn't happen. */
+			if (WARN_ONCE(!buf || !size,
+				      "%s doesn't support modsig\n",
+				      func_tokens[func]))
+				return -ENOTSUPP;
+
+			rc = ima_read_modsig(buf, &size, &xattr_value,
+					     &xattr_len);
+			if (rc)
+				return rc;
+		} else
+			/* read 'security.ima' */
+			xattr_len = ima_read_xattr(file_dentry(file),
+						   &xattr_value);
+	}
+
+	hash_algo = ima_get_hash_algo(xattr_value, xattr_len);
+
+	rc = ima_collect_measurement(iint, file, buf, size, hash_algo);
+	if (rc != 0) {
+		if (file->f_flags & O_DIRECT)
+			rc = (iint->flags & IMA_PERMIT_DIRECTIO) ? 0 : -EACCES;
+		goto out;
+	}
+
+	if (action & IMA_APPRAISE_SUBMASK)
+		rc = ima_appraise_measurement(func, iint, file, pathname,
+					      xattr_value, xattr_len, opened);
+out:
+	if (rc)
+		ima_free_xattr_data(xattr_value);
+	else {
+		*xattr_value_ = xattr_value;
+		*xattr_len_ = xattr_len;
+	}
+
+	return rc;
+}
+
 static int process_measurement(struct file *file, char *buf, loff_t size,
 			       int mask, enum ima_hooks func, int opened)
 {
 	struct inode *inode = file_inode(file);
 	struct integrity_iint_cache *iint = NULL;
-	struct ima_template_desc *template_desc;
 	char *pathbuf = NULL;
 	char filename[NAME_MAX];
 	const char *pathname = NULL;
@@ -169,7 +226,6 @@ static int process_measurement(struct file *file, char *buf, loff_t size,
 	struct evm_ima_xattr_data *xattr_value = NULL;
 	int xattr_len = 0;
 	bool violation_check;
-	enum hash_algo hash_algo;
 
 	if (!ima_policy_flag || !S_ISREG(inode->i_mode))
 		return 0;
@@ -226,30 +282,23 @@ static int process_measurement(struct file *file, char *buf, loff_t size,
 		goto out_digsig;
 	}
 
-	template_desc = ima_template_desc_current();
-	if ((action & IMA_APPRAISE_SUBMASK) ||
-		    strcmp(template_desc->name, IMA_TEMPLATE_IMA_NAME) != 0)
-		/* read 'security.ima' */
-		xattr_len = ima_read_xattr(file_dentry(file), &xattr_value);
-
-	hash_algo = ima_get_hash_algo(xattr_value, xattr_len);
-
-	rc = ima_collect_measurement(iint, file, buf, size, hash_algo);
-	if (rc != 0) {
-		if (file->f_flags & O_DIRECT)
-			rc = (iint->flags & IMA_PERMIT_DIRECTIO) ? 0 : -EACCES;
-		goto out_digsig;
-	}
-
 	if (!pathbuf)	/* ima_rdwr_violation possibly pre-fetched */
 		pathname = ima_d_path(&file->f_path, &pathbuf, filename);
 
+	if (iint->flags & IMA_MODSIG_ALLOWED)
+		rc = measure_and_appraise(file, buf, size, func, opened, action,
+					  iint, &xattr_value, &xattr_len,
+					  pathname, true);
+	if (!xattr_len)
+		rc = measure_and_appraise(file, buf, size, func, opened, action,
+					  iint, &xattr_value, &xattr_len,
+					  pathname, false);
+	if (rc)
+		goto out_digsig;
+
 	if (action & IMA_MEASURE)
 		ima_store_measurement(iint, file, pathname,
 				      xattr_value, xattr_len, pcr);
-	if (action & IMA_APPRAISE_SUBMASK)
-		rc = ima_appraise_measurement(func, iint, file, pathname,
-					      xattr_value, xattr_len, opened);
 	if (action & IMA_AUDIT)
 		ima_audit_measurement(iint, pathname);
 
@@ -257,7 +306,7 @@ static int process_measurement(struct file *file, char *buf, loff_t size,
 	if ((mask & MAY_WRITE) && (iint->flags & IMA_DIGSIG) &&
 	     !(iint->flags & IMA_NEW_FILE))
 		rc = -EACCES;
-	kfree(xattr_value);
+	ima_free_xattr_data(xattr_value);
 out_free:
 	if (pathbuf)
 		__putname(pathbuf);
diff --git a/security/integrity/ima/ima_modsig.c b/security/integrity/ima/ima_modsig.c
new file mode 100644
index 000000000000..f224acb95191
--- /dev/null
+++ b/security/integrity/ima/ima_modsig.c
@@ -0,0 +1,167 @@
+/*
+ * IMA support for appraising module-style appended signatures.
+ *
+ * Copyright (C) 2017  IBM Corporation
+ *
+ * Author:
+ * Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation (version 2 of the License).
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/types.h>
+#include <linux/module_signature.h>
+#include <keys/asymmetric-type.h>
+#include <crypto/pkcs7.h>
+
+#include "ima.h"
+
+struct signature_modsig_hdr {
+	uint8_t type;		/* Should be IMA_MODSIG. */
+	const void *data;	/* Pointer to data covered by pkcs7_msg. */
+	size_t data_len;
+	struct pkcs7_message *pkcs7_msg;
+	int raw_pkcs7_len;
+
+	/* This will be in the measurement list if required by the template. */
+	struct evm_ima_xattr_data raw_pkcs7;
+};
+
+/**
+ * ima_hook_supports_modsig - can the policy allow modsig for this hook?
+ *
+ * modsig is only supported by hooks using ima_post_read_file, because only they
+ * preload the contents of the file in a buffer. FILE_CHECK does that in some
+ * cases, but not when reached from vfs_open. POLICY_CHECK can support it, but
+ * it's not useful in practice because it's a text file so deny.
+ */
+bool ima_hook_supports_modsig(enum ima_hooks func)
+{
+	switch (func) {
+	case FIRMWARE_CHECK:
+	case KEXEC_KERNEL_CHECK:
+	case KEXEC_INITRAMFS_CHECK:
+		return true;
+	default:
+		return false;
+	}
+}
+
+int ima_read_modsig(const void *buf, loff_t *buf_len,
+		    struct evm_ima_xattr_data **xattr_value,
+		    int *xattr_len)
+{
+	const size_t marker_len = sizeof(MODULE_SIG_STRING) - 1;
+	const struct module_signature *sig;
+	struct signature_modsig_hdr *hdr;
+	loff_t file_len = *buf_len;
+	size_t sig_len;
+	const void *p;
+	int rc;
+
+	if (file_len <= marker_len + sizeof(*sig))
+		return -ENOENT;
+
+	p = buf + file_len - marker_len;
+	if (memcmp(p, MODULE_SIG_STRING, marker_len))
+		return -ENOENT;
+
+	file_len -= marker_len;
+	sig = (const struct module_signature *) (p - sizeof(*sig));
+
+	rc = validate_module_signature(sig, file_len);
+	if (rc)
+		return rc;
+
+	sig_len = be32_to_cpu(sig->sig_len);
+	file_len -= sig_len + sizeof(*sig);
+
+	hdr = kmalloc(sizeof(*hdr) + sig_len, GFP_KERNEL);
+	if (!hdr)
+		return -ENOMEM;
+
+	hdr->pkcs7_msg = pkcs7_parse_message(buf + file_len, sig_len);
+	if (IS_ERR(hdr->pkcs7_msg)) {
+		rc = PTR_ERR(hdr->pkcs7_msg);
+		kfree(hdr);
+		return rc;
+	}
+
+	memcpy(hdr->raw_pkcs7.data, buf + file_len, sig_len);
+	hdr->raw_pkcs7_len = sig_len + 1;
+	hdr->raw_pkcs7.type = IMA_MODSIG;
+
+	hdr->type = IMA_MODSIG;
+	hdr->data = buf;
+	hdr->data_len = file_len;
+
+	*xattr_value = (typeof(*xattr_value)) hdr;
+	*xattr_len = sizeof(*hdr);
+	*buf_len = file_len;
+
+	return 0;
+}
+
+enum hash_algo ima_get_modsig_hash_algo(struct evm_ima_xattr_data *hdr)
+{
+	const struct public_key_signature *pks;
+	struct signature_modsig_hdr *modsig = (typeof(modsig)) hdr;
+	int i;
+
+	pks = pkcs7_get_message_sig(modsig->pkcs7_msg);
+	if (!pks)
+		return HASH_ALGO__LAST;
+
+	for (i = 0; i < HASH_ALGO__LAST; i++)
+		if (!strcmp(hash_algo_name[i], pks->hash_algo))
+			break;
+
+	return i;
+}
+
+int ima_modsig_serialize_data(struct evm_ima_xattr_data *hdr,
+			      struct evm_ima_xattr_data **data, int *data_len)
+{
+	struct signature_modsig_hdr *modsig = (typeof(modsig)) hdr;
+
+	*data = &modsig->raw_pkcs7;
+	*data_len = modsig->raw_pkcs7_len;
+
+	return 0;
+}
+
+int ima_modsig_verify(const unsigned int keyring_id,
+		      struct evm_ima_xattr_data *hdr)
+{
+	struct signature_modsig_hdr *modsig = (typeof(modsig)) hdr;
+	struct key *trusted_keys = integrity_keyring_from_id(keyring_id);
+
+	if (IS_ERR(trusted_keys))
+		return -EINVAL;
+
+	return verify_pkcs7_message_signature(modsig->data, modsig->data_len,
+					      modsig->pkcs7_msg, trusted_keys,
+					      VERIFYING_MODULE_SIGNATURE,
+					      NULL, NULL);
+}
+
+void ima_free_xattr_data(struct evm_ima_xattr_data *hdr)
+{
+	if (!hdr)
+		return;
+
+	if (hdr->type == IMA_MODSIG) {
+		struct signature_modsig_hdr *modsig = (typeof(modsig)) hdr;
+
+		pkcs7_free_message(modsig->pkcs7_msg);
+	}
+
+	kfree(hdr);
+}
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index f4436626ccb7..4047ccabcbbf 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -853,8 +853,12 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 			}
 
 			ima_log_string(ab, "appraise_type", args[0].from);
-			if ((strcmp(args[0].from, "imasig")) == 0)
+			if (strcmp(args[0].from, "imasig") == 0)
 				entry->flags |= IMA_DIGSIG_REQUIRED;
+			else if (ima_hook_supports_modsig(entry->func) &&
+				 strcmp(args[0].from, "modsig|imasig") == 0)
+				entry->flags |= IMA_DIGSIG_REQUIRED
+						| IMA_MODSIG_ALLOWED;
 			else
 				result = -EINVAL;
 			break;
@@ -960,6 +964,12 @@ void ima_delete_rules(void)
 	}
 }
 
+#define __ima_hook_stringify(str)	(#str),
+
+const char *const func_tokens[] = {
+	__ima_hooks(__ima_hook_stringify)
+};
+
 #ifdef	CONFIG_IMA_READ_POLICY
 enum {
 	mask_exec = 0, mask_write, mask_read, mask_append
@@ -972,12 +982,6 @@ static const char *const mask_tokens[] = {
 	"MAY_APPEND"
 };
 
-#define __ima_hook_stringify(str)	(#str),
-
-static const char *const func_tokens[] = {
-	__ima_hooks(__ima_hook_stringify)
-};
-
 void *ima_policy_start(struct seq_file *m, loff_t *pos)
 {
 	loff_t l = *pos;
@@ -1140,8 +1144,12 @@ int ima_policy_show(struct seq_file *m, void *v)
 			}
 		}
 	}
-	if (entry->flags & IMA_DIGSIG_REQUIRED)
-		seq_puts(m, "appraise_type=imasig ");
+	if (entry->flags & IMA_DIGSIG_REQUIRED) {
+		if (entry->flags & IMA_MODSIG_ALLOWED)
+			seq_puts(m, "appraise_type=modsig|imasig ");
+		else
+			seq_puts(m, "appraise_type=imasig ");
+	}
 	if (entry->flags & IMA_PERMIT_DIRECTIO)
 		seq_puts(m, "permit_directio ");
 	rcu_read_unlock();
diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index f9ba37b3928d..be123485e486 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -322,9 +322,21 @@ int ima_eventsig_init(struct ima_event_data *event_data,
 	int xattr_len = event_data->xattr_len;
 	int rc = 0;
 
-	if ((!xattr_value) || (xattr_value->type != EVM_IMA_XATTR_DIGSIG))
+	if (!xattr_value || (xattr_value->type != EVM_IMA_XATTR_DIGSIG &&
+			     xattr_value->type != IMA_MODSIG))
 		goto out;
 
+	/*
+	 * The xattr_value for IMA_MODSIG is a runtime structure containing
+	 * pointers. Get its raw data instead.
+	 */
+	if (xattr_value->type == IMA_MODSIG) {
+		rc = ima_modsig_serialize_data(xattr_value, &xattr_value,
+					       &xattr_len);
+		if (rc)
+			goto out;
+	}
+
 	rc = ima_write_template_field_data(xattr_value, xattr_len, fmt,
 					   field_data);
 out:
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 874211aba6e9..2c9393cf2860 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -28,11 +28,12 @@
 
 /* iint cache flags */
 #define IMA_ACTION_FLAGS	0xff000000
-#define IMA_ACTION_RULE_FLAGS	0x06000000
+#define IMA_ACTION_RULE_FLAGS	0x16000000
 #define IMA_DIGSIG		0x01000000
 #define IMA_DIGSIG_REQUIRED	0x02000000
 #define IMA_PERMIT_DIRECTIO	0x04000000
 #define IMA_NEW_FILE		0x08000000
+#define IMA_MODSIG_ALLOWED	0x10000000
 
 #define IMA_DO_MASK		(IMA_MEASURE | IMA_APPRAISE | IMA_AUDIT | \
 				 IMA_APPRAISE_SUBMASK)
@@ -58,6 +59,7 @@ enum evm_ima_xattr_type {
 	EVM_XATTR_HMAC,
 	EVM_IMA_XATTR_DIGSIG,
 	IMA_XATTR_DIGEST_NG,
+	IMA_MODSIG,
 	IMA_XATTR_LAST
 };
 
@@ -129,6 +131,7 @@ int __init integrity_read_file(const char *path, char **data);
 
 #ifdef CONFIG_INTEGRITY_SIGNATURE
 
+struct key *integrity_keyring_from_id(const unsigned int id);
 int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 			    const char *digest, int digestlen);
 
-- 
2.7.4
