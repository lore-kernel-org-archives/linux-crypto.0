From: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Subject: [PATCH v7 11/14] ima: Implement support for module-style appended signatures
Date: Tue, 22 May 2018 21:12:50 -0300
Message-ID: <20180523001253.15247-12-bauerman@linux.ibm.com>
References: <20180523001253.15247-1-bauerman@linux.ibm.com>
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "AKASHI, Takahiro" <takahiro.akashi@linaro.org>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>
To: linux-integrity@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180523001253.15247-1-bauerman@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Implement the appraise_type=imasig|modsig option, allowing IMA to read and
verify modsig signatures.

In case both are present in the same file, IMA will first check whether the
key used by the xattr signature is present in the kernel keyring. If not,
it will try the appended signature.

Signed-off-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
---
 security/integrity/ima/Kconfig        |   3 +
 security/integrity/ima/ima.h          |  36 ++++++++-
 security/integrity/ima/ima_appraise.c |  64 +++++++++++++--
 security/integrity/ima/ima_main.c     |  17 +++-
 security/integrity/ima/ima_modsig.c   | 145 ++++++++++++++++++++++++++++++++++
 security/integrity/integrity.h        |   1 +
 6 files changed, 255 insertions(+), 11 deletions(-)

diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index ee278189e0bb..306601d62f0b 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -167,6 +167,9 @@ config IMA_APPRAISE_BOOTPARAM
 config IMA_APPRAISE_MODSIG
 	bool "Support module-style signatures for appraisal"
 	depends on IMA_APPRAISE
+	depends on INTEGRITY_ASYMMETRIC_KEYS
+	select PKCS7_MESSAGE_PARSER
+	select MODULE_SIG_FORMAT
 	default n
 	help
 	   Adds support for signatures appended to files. The format of the
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 01f379916583..0fa8d89c8bd4 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -156,7 +156,8 @@ void ima_init_template_list(void);
 
 static inline bool is_signed(const struct evm_ima_xattr_data *xattr_value)
 {
-	return xattr_value && xattr_value->type == EVM_IMA_XATTR_DIGSIG;
+	return xattr_value && (xattr_value->type == EVM_IMA_XATTR_DIGSIG ||
+			       xattr_value->type == IMA_MODSIG);
 }
 
 /*
@@ -252,6 +253,8 @@ enum integrity_status ima_get_cache_status(struct integrity_iint_cache *iint,
 					   enum ima_hooks func);
 enum hash_algo ima_get_hash_algo(struct evm_ima_xattr_data *xattr_value,
 				 int xattr_len);
+bool ima_xattr_sig_known_key(const struct evm_ima_xattr_data *xattr_value,
+			     int xattr_len);
 int ima_read_xattr(struct dentry *dentry,
 		   struct evm_ima_xattr_data **xattr_value);
 
@@ -290,6 +293,12 @@ ima_get_hash_algo(struct evm_ima_xattr_data *xattr_value, int xattr_len)
 	return ima_hash_algo;
 }
 
+static inline bool ima_xattr_sig_known_key(const struct evm_ima_xattr_data
+					   *xattr_value, int xattr_len)
+{
+	return false;
+}
+
 static inline int ima_read_xattr(struct dentry *dentry,
 				 struct evm_ima_xattr_data **xattr_value)
 {
@@ -300,11 +309,36 @@ static inline int ima_read_xattr(struct dentry *dentry,
 
 #ifdef CONFIG_IMA_APPRAISE_MODSIG
 bool ima_hook_supports_modsig(enum ima_hooks func);
+int ima_read_modsig(enum ima_hooks func, const void *buf, loff_t buf_len,
+		    struct evm_ima_xattr_data **xattr_value,
+		    int *xattr_len);
+int ima_modsig_verify(const unsigned int keyring_id,
+		      struct evm_ima_xattr_data *hdr);
+void ima_free_xattr_data(struct evm_ima_xattr_data *hdr);
 #else
 static inline bool ima_hook_supports_modsig(enum ima_hooks func)
 {
 	return false;
 }
+
+static inline int ima_read_modsig(enum ima_hooks func, const void *buf,
+				  loff_t buf_len,
+				  struct evm_ima_xattr_data **xattr_value,
+				  int *xattr_len)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int ima_modsig_verify(const unsigned int keyring_id,
+				    struct evm_ima_xattr_data *hdr)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void ima_free_xattr_data(struct evm_ima_xattr_data *hdr)
+{
+	kfree(hdr);
+}
 #endif /* CONFIG_IMA_APPRAISE_MODSIG */
 
 /* LSM based policy rules require audit */
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index bcbbd8f86fe1..048f068c3a4a 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -189,6 +189,22 @@ enum hash_algo ima_get_hash_algo(struct evm_ima_xattr_data *xattr_value,
 	return ima_hash_algo;
 }
 
+bool ima_xattr_sig_known_key(const struct evm_ima_xattr_data *xattr_value,
+			     int xattr_len)
+{
+	struct key *keyring;
+
+	if (xattr_value->type != EVM_IMA_XATTR_DIGSIG)
+		return false;
+
+	keyring = integrity_keyring_from_id(INTEGRITY_KEYRING_IMA);
+	if (IS_ERR(keyring))
+		return false;
+
+	return asymmetric_sig_has_known_key(keyring, (const char *) xattr_value,
+					    xattr_len);
+}
+
 int ima_read_xattr(struct dentry *dentry,
 		   struct evm_ima_xattr_data **xattr_value)
 {
@@ -198,6 +214,14 @@ int ima_read_xattr(struct dentry *dentry,
 				 0, GFP_NOFS);
 	if (ret == -EOPNOTSUPP)
 		ret = 0;
+	/* IMA_MODSIG is only allowed when appended to files. */
+	else if (ret > 0 && (*xattr_value)->type == IMA_MODSIG) {
+		ret = -EINVAL;
+
+		kfree(*xattr_value);
+		*xattr_value = NULL;
+	}
+
 	return ret;
 }
 
@@ -221,8 +245,12 @@ int ima_appraise_measurement(enum ima_hooks func,
 	struct inode *inode = d_backing_inode(dentry);
 	enum integrity_status status = INTEGRITY_UNKNOWN;
 	int rc = xattr_len, hash_start = 0;
+	size_t xattr_contents_len;
+	void *xattr_contents;
 
-	if (!(inode->i_opflags & IOP_XATTR))
+	/* If not appraising a modsig, we need an xattr. */
+	if ((xattr_value == NULL || xattr_value->type != IMA_MODSIG) &&
+	    !(inode->i_opflags & IOP_XATTR))
 		return INTEGRITY_UNKNOWN;
 
 	if (rc <= 0) {
@@ -241,13 +269,29 @@ int ima_appraise_measurement(enum ima_hooks func,
 		goto out;
 	}
 
-	status = evm_verifyxattr(dentry, XATTR_NAME_IMA, xattr_value, rc, iint);
+	/*
+	 * If it's a modsig, we don't have the xattr contents to pass to
+	 * evm_verifyxattr().
+	 */
+	if (xattr_value->type == IMA_MODSIG) {
+		xattr_contents = NULL;
+		xattr_contents_len = 0;
+	} else {
+		xattr_contents = xattr_value;
+		xattr_contents_len = xattr_len;
+	}
+
+	status = evm_verifyxattr(dentry, XATTR_NAME_IMA, xattr_contents,
+				 xattr_contents_len, iint);
 	switch (status) {
 	case INTEGRITY_PASS:
 	case INTEGRITY_PASS_IMMUTABLE:
 	case INTEGRITY_UNKNOWN:
 		break;
 	case INTEGRITY_NOXATTRS:	/* No EVM protected xattrs. */
+		/* It's fine not to have xattrs when using a modsig. */
+		if (xattr_value->type == IMA_MODSIG)
+			break;
 	case INTEGRITY_NOLABEL:		/* No security.evm xattr. */
 		cause = "missing-HMAC";
 		goto out;
@@ -288,11 +332,16 @@ int ima_appraise_measurement(enum ima_hooks func,
 		status = INTEGRITY_PASS;
 		break;
 	case EVM_IMA_XATTR_DIGSIG:
+	case IMA_MODSIG:
 		set_bit(IMA_DIGSIG, &iint->atomic_flags);
-		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
-					     (const char *)xattr_value, rc,
-					     iint->ima_hash->digest,
-					     iint->ima_hash->length);
+		if (xattr_value->type == EVM_IMA_XATTR_DIGSIG)
+			rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
+						     (const char *)xattr_value,
+						     rc, iint->ima_hash->digest,
+						     iint->ima_hash->length);
+		else
+			rc = ima_modsig_verify(INTEGRITY_KEYRING_IMA,
+					       xattr_value);
 		if (rc == -EOPNOTSUPP) {
 			status = INTEGRITY_UNKNOWN;
 		} else if (rc) {
@@ -444,7 +493,8 @@ int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
 	result = ima_protect_xattr(dentry, xattr_name, xattr_value,
 				   xattr_value_len);
 	if (result == 1) {
-		if (!xattr_value_len || (xvalue->type >= IMA_XATTR_LAST))
+		if (!xattr_value_len || xvalue->type == IMA_MODSIG ||
+		    xvalue->type >= IMA_XATTR_LAST)
 			return -EINVAL;
 		ima_reset_appraise_flags(d_backing_inode(dentry),
 					 is_signed(xvalue));
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 83f84928ad76..9d32ce6c3df3 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -184,6 +184,7 @@ static int process_measurement(struct file *file, const struct cred *cred,
 	struct evm_ima_xattr_data *xattr_value = NULL;
 	int xattr_len = 0;
 	bool violation_check;
+	bool read_xattr;
 	enum hash_algo hash_algo;
 
 	if (!ima_policy_flag || !S_ISREG(inode->i_mode))
@@ -277,13 +278,23 @@ static int process_measurement(struct file *file, const struct cred *cred,
 	}
 
 	template_desc = ima_template_desc_current();
-	if ((action & IMA_APPRAISE_SUBMASK) ||
-		    strcmp(template_desc->name, IMA_TEMPLATE_IMA_NAME) != 0)
+	read_xattr = action & IMA_APPRAISE_SUBMASK ||
+		     strcmp(template_desc->name, IMA_TEMPLATE_IMA_NAME) != 0;
+	if (read_xattr)
 		/* read 'security.ima' */
 		xattr_len = ima_read_xattr(file_dentry(file), &xattr_value);
 
 	hash_algo = ima_get_hash_algo(xattr_value, xattr_len);
 
+	/*
+	 * Try to find a modsig if there's no xattr sig or if it is signed by an
+	 * unknown key.
+	 */
+	if (read_xattr && iint->flags & IMA_MODSIG_ALLOWED &&
+	    (xattr_len <= 0 || !ima_xattr_sig_known_key(xattr_value,
+							xattr_len)))
+		ima_read_modsig(func, buf, size, &xattr_value, &xattr_len);
+
 	rc = ima_collect_measurement(iint, file, buf, size, hash_algo);
 	if (rc != 0 && rc != -EBADF && rc != -EINVAL)
 		goto out_locked;
@@ -310,7 +321,7 @@ static int process_measurement(struct file *file, const struct cred *cred,
 	     !(iint->flags & IMA_NEW_FILE))
 		rc = -EACCES;
 	mutex_unlock(&iint->mutex);
-	kfree(xattr_value);
+	ima_free_xattr_data(xattr_value);
 out:
 	if (pathbuf)
 		__putname(pathbuf);
diff --git a/security/integrity/ima/ima_modsig.c b/security/integrity/ima/ima_modsig.c
index d8ea811b6f74..aa6b91c3745b 100644
--- a/security/integrity/ima/ima_modsig.c
+++ b/security/integrity/ima/ima_modsig.c
@@ -8,8 +8,25 @@
  * Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
  */
 
+#include <linux/types.h>
+#include <linux/module_signature.h>
+#include <keys/asymmetric-type.h>
+#include <crypto/pkcs7.h>
+
 #include "ima.h"
 
+struct modsig_hdr {
+	uint8_t type;		/* Should be IMA_MODSIG. */
+	struct pkcs7_message *pkcs7_msg;
+	int raw_pkcs7_len;
+
+	/*
+	 * This is what will go to the measurement list if the template requires
+	 * storing the signature.
+	 */
+	struct evm_ima_xattr_data raw_pkcs7;
+};
+
 /**
  * ima_hook_supports_modsig - can the policy allow modsig for this hook?
  *
@@ -29,3 +46,131 @@ bool ima_hook_supports_modsig(enum ima_hooks func)
 		return false;
 	}
 }
+
+static bool modsig_has_known_key(struct modsig_hdr *hdr)
+{
+	const struct public_key_signature *pks;
+	struct key *keyring;
+	struct key *key;
+
+	keyring = integrity_keyring_from_id(INTEGRITY_KEYRING_IMA);
+	if (IS_ERR(keyring))
+		return false;
+
+	pks = pkcs7_get_message_sig(hdr->pkcs7_msg);
+	if (!pks)
+		return false;
+
+	key = find_asymmetric_key(keyring, pks->auth_ids[0], NULL, false);
+	if (IS_ERR(key))
+		return false;
+
+	key_put(key);
+
+	return true;
+}
+
+int ima_read_modsig(enum ima_hooks func, const void *buf, loff_t buf_len,
+		    struct evm_ima_xattr_data **xattr_value,
+		    int *xattr_len)
+{
+	const size_t marker_len = sizeof(MODULE_SIG_STRING) - 1;
+	const struct module_signature *sig;
+	struct modsig_hdr *hdr;
+	size_t sig_len;
+	const void *p;
+	int rc;
+
+	/*
+	 * Not supposed to happen. Hooks that support modsig are whitelisted
+	 * when parsing the policy using ima_hooks_supports_modsig().
+	 */
+	if (!buf || !buf_len) {
+		WARN_ONCE(true, "%s doesn't support modsig\n",
+			  func_tokens[func]);
+		return -ENOENT;
+	} else if (buf_len <= marker_len + sizeof(*sig))
+		return -ENOENT;
+
+	p = buf + buf_len - marker_len;
+	if (memcmp(p, MODULE_SIG_STRING, marker_len))
+		return -ENOENT;
+
+	buf_len -= marker_len;
+	sig = (const struct module_signature *) (p - sizeof(*sig));
+
+	rc = validate_module_sig(sig, buf_len);
+	if (rc)
+		return rc;
+
+	sig_len = be32_to_cpu(sig->sig_len);
+	buf_len -= sig_len + sizeof(*sig);
+
+	/* Allocate sig_len additional bytes to hold the raw PKCS#7 data. */
+	hdr = kmalloc(sizeof(*hdr) + sig_len, GFP_KERNEL);
+	if (!hdr)
+		return -ENOMEM;
+
+	hdr->pkcs7_msg = pkcs7_parse_message(buf + buf_len, sig_len);
+	if (IS_ERR(hdr->pkcs7_msg)) {
+		rc = PTR_ERR(hdr->pkcs7_msg);
+		goto err_no_msg;
+	}
+
+	rc = pkcs7_supply_detached_data(hdr->pkcs7_msg, buf, buf_len);
+	if (rc)
+		goto err;
+
+	if (!modsig_has_known_key(hdr)) {
+		rc = -ENOKEY;
+		goto err;
+	}
+
+	memcpy(hdr->raw_pkcs7.data, buf + buf_len, sig_len);
+	hdr->raw_pkcs7_len = sig_len + 1;
+	hdr->raw_pkcs7.type = IMA_MODSIG;
+
+	hdr->type = IMA_MODSIG;
+
+	*xattr_value = (typeof(*xattr_value)) hdr;
+	*xattr_len = sizeof(*hdr);
+
+	return 0;
+
+ err:
+	pkcs7_free_message(hdr->pkcs7_msg);
+ err_no_msg:
+	kfree(hdr);
+	return rc;
+}
+
+int ima_modsig_verify(const unsigned int keyring_id,
+		      struct evm_ima_xattr_data *hdr)
+{
+	struct modsig_hdr *modsig = (struct modsig_hdr *) hdr;
+	struct key *keyring;
+
+	if (!hdr || hdr->type != IMA_MODSIG)
+		return -EINVAL;
+
+	keyring = integrity_keyring_from_id(keyring_id);
+	if (IS_ERR(keyring))
+		return PTR_ERR(keyring);
+
+	return verify_pkcs7_message_sig(NULL, 0, modsig->pkcs7_msg, keyring,
+					VERIFYING_MODULE_SIGNATURE, NULL, NULL);
+}
+
+void ima_free_xattr_data(struct evm_ima_xattr_data *hdr)
+{
+	if (!hdr)
+		return;
+
+	if (hdr->type == IMA_MODSIG) {
+		struct modsig_hdr *modsig = (struct modsig_hdr *) hdr;
+
+		pkcs7_free_message(modsig->pkcs7_msg);
+	}
+
+	kfree(hdr);
+}
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 05fdbf953f90..b38339c02541 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -74,6 +74,7 @@ enum evm_ima_xattr_type {
 	EVM_IMA_XATTR_DIGSIG,
 	IMA_XATTR_DIGEST_NG,
 	EVM_XATTR_PORTABLE_DIGSIG,
+	IMA_MODSIG,
 	IMA_XATTR_LAST
 };
 
