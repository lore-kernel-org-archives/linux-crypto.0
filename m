From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: [PATCH v5 16/18] ima: Add functions to read and verify a modsig signature
Date: Tue, 17 Oct 2017 22:53:29 -0200
Message-ID: <20171018005331.2688-17-bauerman@linux.vnet.ibm.com>
References: <20171018005331.2688-1-bauerman@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
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
To: linux-integrity@vger.kernel.org
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20171018005331.2688-1-bauerman@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This is the code needed by IMA-appraise to work with modsig signatures.
It will be used by the next patch.

Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
---
 security/integrity/ima/Kconfig      |   3 +
 security/integrity/ima/ima.h        |  34 +++++++++++
 security/integrity/ima/ima_modsig.c | 119 ++++++++++++++++++++++++++++++++++++
 security/integrity/integrity.h      |   1 +
 4 files changed, 157 insertions(+)

diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 40c6618d00e6..55f734a6124b 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -166,6 +166,9 @@ config IMA_APPRAISE_BOOTPARAM
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
index 156ba218e0b6..eb58af06566f 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -257,6 +257,14 @@ int ima_read_xattr(struct dentry *dentry,
 
 #ifdef CONFIG_IMA_APPRAISE_MODSIG
 bool ima_hook_supports_modsig(enum ima_hooks func);
+int ima_read_modsig(enum ima_hooks func, const void *buf, loff_t buf_len,
+		    struct evm_ima_xattr_data **xattr_value,
+		    int *xattr_len);
+int ima_get_modsig_hash(struct evm_ima_xattr_data *hdr, enum hash_algo *algo,
+			void const **hash, u8 *len);
+int ima_modsig_verify(const unsigned int keyring_id,
+		      struct evm_ima_xattr_data *hdr);
+void ima_free_xattr_data(struct evm_ima_xattr_data *hdr);
 #endif
 
 #else
@@ -307,6 +315,32 @@ static inline bool ima_hook_supports_modsig(enum ima_hooks func)
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
+				      enum hash_algo *algo, void const **hash,
+				      u8 *len)
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
 #endif
 
 /* LSM based policy rules require audit */
diff --git a/security/integrity/ima/ima_modsig.c b/security/integrity/ima/ima_modsig.c
index 452ce6048a7e..2786aa97060e 100644
--- a/security/integrity/ima/ima_modsig.c
+++ b/security/integrity/ima/ima_modsig.c
@@ -16,8 +16,19 @@
  * GNU General Public License for more details.
  */
 
+#include <linux/types.h>
+#include <linux/module_signature.h>
+#include <crypto/pkcs7.h>
+
 #include "ima.h"
 
+struct modsig_hdr {
+	uint8_t type;		/* Should be IMA_MODSIG. */
+	const void *data;	/* Pointer to data covered by pkcs7_msg. */
+	size_t data_len;
+	struct pkcs7_message *pkcs7_msg;
+};
+
 /**
  * ima_hook_supports_modsig - can the policy allow modsig for this hook?
  *
@@ -37,3 +48,111 @@ bool ima_hook_supports_modsig(enum ima_hooks func)
 		return false;
 	}
 }
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
+	 * Not supposed to happen. Hooks that support modsig are
+	 * whitelisted when parsing the policy using
+	 * ima_hooks_supports_modsig.
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
+	hdr = kmalloc(sizeof(*hdr), GFP_KERNEL);
+	if (!hdr)
+		return -ENOMEM;
+
+	hdr->pkcs7_msg = pkcs7_parse_message(buf + buf_len, sig_len);
+	if (IS_ERR(hdr->pkcs7_msg)) {
+		rc = PTR_ERR(hdr->pkcs7_msg);
+		kfree(hdr);
+		return rc;
+	}
+
+	hdr->type = IMA_MODSIG;
+	hdr->data = buf;
+	hdr->data_len = buf_len;
+
+	*xattr_value = (typeof(*xattr_value)) hdr;
+	*xattr_len = sizeof(*hdr);
+
+	return 0;
+}
+
+int ima_get_modsig_hash(struct evm_ima_xattr_data *hdr, enum hash_algo *algo,
+			void const **hash, u8 *len)
+{
+	const struct public_key_signature *pks;
+	struct modsig_hdr *modsig = (typeof(modsig)) hdr;
+	int i;
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
+	*hash = pks->digest;
+	*len = pks->digest_size;
+
+	return 0;
+}
+
+int ima_modsig_verify(const unsigned int keyring_id,
+		      struct evm_ima_xattr_data *hdr)
+{
+	struct modsig_hdr *modsig = (struct modsig_hdr *) hdr;
+	struct key *trusted_keys = integrity_keyring_from_id(keyring_id);
+
+	if (IS_ERR(trusted_keys))
+		return -EINVAL;
+
+	return verify_pkcs7_message_sig(modsig->data, modsig->data_len,
+					modsig->pkcs7_msg, trusted_keys,
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
index da709558ec8b..ce2bd9d5afa5 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -59,6 +59,7 @@ enum evm_ima_xattr_type {
 	EVM_XATTR_HMAC,
 	EVM_IMA_XATTR_DIGSIG,
 	IMA_XATTR_DIGEST_NG,
+	IMA_MODSIG,
 	IMA_XATTR_LAST
 };
 

