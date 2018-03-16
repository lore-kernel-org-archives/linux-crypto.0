From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: [PATCH v6 10/12] ima: Add functions to read and verify a modsig signature
Date: Fri, 16 Mar 2018 17:38:35 -0300
Message-ID: <20180316203837.10174-11-bauerman@linux.vnet.ibm.com>
References: <20180316203837.10174-1-bauerman@linux.vnet.ibm.com>
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
        Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
To: linux-integrity@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180316203837.10174-1-bauerman@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This is the code needed by IMA-appraise to work with modsig signatures.
It will be used by the next two patches.

Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
---
 security/integrity/ima/Kconfig      |   3 +
 security/integrity/ima/ima.h        |  41 ++++++++
 security/integrity/ima/ima_modsig.c | 181 ++++++++++++++++++++++++++++++++++++
 security/integrity/integrity.h      |   1 +
 4 files changed, 226 insertions(+)

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
index c61d8fc5190d..49aef56dc96d 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -301,11 +301,52 @@ static inline int ima_read_xattr(struct dentry *dentry,
 
 #ifdef CONFIG_IMA_APPRAISE_MODSIG
 bool ima_hook_supports_modsig(enum ima_hooks func);
+int ima_read_modsig(enum ima_hooks func, const void *buf, loff_t buf_len,
+		    struct evm_ima_xattr_data **xattr_value,
+		    int *xattr_len);
+int ima_get_modsig_hash(struct evm_ima_xattr_data *hdr, enum hash_algo *algo,
+			const u8 **hash, u8 *len);
+int ima_modsig_serialize_data(struct evm_ima_xattr_data **data, int *data_len);
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
+	return -ENOTSUPP;
+}
+
+static inline int ima_get_modsig_hash(struct evm_ima_xattr_data *hdr,
+				      enum hash_algo *algo, const u8 **hash,
+				      u8 *len)
+{
+	return -ENOTSUPP;
+}
+
+static inline int ima_modsig_serialize_data(struct evm_ima_xattr_data **data,
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
 #endif /* CONFIG_IMA_APPRAISE_MODSIG */
 
 /* LSM based policy rules require audit */
diff --git a/security/integrity/ima/ima_modsig.c b/security/integrity/ima/ima_modsig.c
index d8ea811b6f74..105fd04d585e 100644
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
@@ -29,3 +46,167 @@ bool ima_hook_supports_modsig(enum ima_hooks func)
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
+int ima_get_modsig_hash(struct evm_ima_xattr_data *hdr, enum hash_algo *algo,
+			const u8 **hash, u8 *len)
+{
+	struct modsig_hdr *modsig = (typeof(modsig)) hdr;
+	const struct public_key_signature *pks;
+	int i;
+
+	if (!hdr || hdr->type != IMA_MODSIG)
+		return -EINVAL;
+
+	pks = pkcs7_get_message_sig(modsig->pkcs7_msg);
+	if (!pks)
+		return -EBADMSG;
+
+	for (i = 0; i < HASH_ALGO__LAST; i++)
+		if (!strcmp(hash_algo_name[i], pks->hash_algo))
+			break;
+
+	*algo = i;
+
+	return pkcs7_get_digest(modsig->pkcs7_msg, hash, len);
+}
+
+int ima_modsig_serialize_data(struct evm_ima_xattr_data **data, int *data_len)
+{
+	struct modsig_hdr *modsig = (struct modsig_hdr *) *data;
+
+	if (!*data || (*data)->type != IMA_MODSIG)
+		return -EINVAL;
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
index 6643c6550787..4acb1fb86b3b 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -74,6 +74,7 @@ enum evm_ima_xattr_type {
 	EVM_IMA_XATTR_DIGSIG,
 	IMA_XATTR_DIGEST_NG,
 	EVM_XATTR_PORTABLE_DIGSIG,
+	IMA_MODSIG,
 	IMA_XATTR_LAST
 };
 
