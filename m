From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/6] ima: Support appended signatures for appraisal
Date: Thu, 20 Apr 2017 20:41:59 -0300
Message-ID: <35565259.p7kmk0rNRg@morokweng>
References: <201704201148.IPsFhl4B%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: kbuild-all@01.org, linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Claudio Carvalho <cclaudio@linux.vnet.ibm.com>
To: kbuild test robot <lkp@intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <201704201148.IPsFhl4B%fengguang.wu@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Donnerstag, 20. April 2017, 11:04:40 BRT schrieb kbuild test robot:
>    In file included from security/integrity/ima/ima_appraise.c:19:0:
> 
>    include/keys/asymmetric-type.h: In function 'asymmetric_key_ids':
> >> include/keys/asymmetric-type.h:76:12: error: dereferencing pointer to
> >> incomplete type 'const struct key'
>      return key->payload.data[asym_key_ids];
>                ^~

This happens with CONFIG_IMA_APPRAISE=y and CONFIG_KEYS=n.
Fixed by only including the new header files in ima_appraise.c if 
CONFIG_IMA_APPRAISE_APPENDED_SIG=y

-- 
Thiago Jung Bauermann
IBM Linux Technology Center


>From e2d3143b13d6601f6a1f4936dfb569a04a1ce0cc Mon Sep 17 00:00:00 2001
From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Date: Mon, 20 Mar 2017 11:08:21 -0300
Subject: [PATCH 6/6] ima: Support appended signatures for appraisal

This patch introduces the appended_imasig keyword to the IMA policy syntax
to specify that a given hook should expect the file to have the IMA
signature appended to it. Here is how it can be used in a rule:

appraise func=KEXEC_KERNEL_CHECK appraise_type=appended_imasig
appraise func=KEXEC_KERNEL_CHECK appraise_type=appended_imasig|imasig

In the second form, IMA will accept either an appended signature or a
signature stored in the extended attribute. In that case, it will first
check whether there is an appended signature, and if not it will read it
from the extended attribute.

The format of the appended signature is the same used for signed kernel
modules. This means that the file can be signed with the scripts/sign-file
tool, with a command line such as this:

$ sign-file sha256 privkey_ima.pem x509_ima.der vmlinux

This code only works for files that are hashed from a memory buffer, not
for files that are read from disk at the time of hash calculation. In other
words, only hooks that use kernel_read_file can support appended
signatures.

The change in CONFIG_INTEGRITY_SIGNATURE to select CONFIG_KEYS instead of
depending on it is to avoid a dependency recursion in
CONFIG_IMA_APPRAISE_APPENDED_SIG, because CONFIG_MODULE_SIG_FORMAT selects
CONFIG_KEYS and Kconfig complains that CONFIG_INTEGRITY_SIGNATURE depends
on it.

Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
---
 crypto/asymmetric_keys/asymmetric_type.c |  1 +
 crypto/asymmetric_keys/pkcs7_parser.c    | 12 +++++
 crypto/asymmetric_keys/pkcs7_verify.c    | 13 +++++
 include/crypto/pkcs7.h                   |  3 ++
 include/linux/verification.h             |  1 +
 security/integrity/Kconfig               |  2 +-
 security/integrity/ima/Kconfig           | 13 +++++
 security/integrity/ima/ima.h             |  8 +++
 security/integrity/ima/ima_appraise.c    | 86 +++++++++++++++++++++++++++++++-
 security/integrity/ima/ima_main.c        | 30 +++++++++--
 security/integrity/ima/ima_policy.c      | 29 ++++++++---
 security/integrity/integrity.h           | 20 +++++---
 12 files changed, 199 insertions(+), 19 deletions(-)

diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index e4b0ed386bc8..0d58ecfba2ea 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -28,6 +28,7 @@ const char *const key_being_used_for[NR__KEY_BEING_USED_FOR] = {
 	[VERIFYING_KEXEC_PE_SIGNATURE]		= "kexec PE sig",
 	[VERIFYING_KEY_SIGNATURE]		= "key sig",
 	[VERIFYING_KEY_SELF_SIGNATURE]		= "key self sig",
+	[VERIFYING_KEXEC_CMS_SIGNATURE]		= "kexec CMS sig",
 	[VERIFYING_UNSPECIFIED_SIGNATURE]	= "unspec sig",
 };
 EXPORT_SYMBOL_GPL(key_being_used_for);
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
diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index 2d93d9eccb4d..eee78074580a 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -420,6 +420,19 @@ int pkcs7_verify(struct pkcs7_message *pkcs7,
 			return -EKEYREJECTED;
 		}
 		break;
+	case VERIFYING_KEXEC_CMS_SIGNATURE:
+		/* Shipping certificates in the CMS message is not allowed. */
+		if (pkcs7->certs) {
+			pr_warn("Signature isn't allowed to contain certificates.\n");
+			return -EBADMSG;
+		}
+
+		/* Shipping CRLs in the CMS message is not allowed. */
+		if (pkcs7->crl) {
+			pr_warn("Signature isn't allowed to contain CRLs.\n");
+			return -EBADMSG;
+		}
+		break;
 	default:
 		return -EINVAL;
 	}
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
diff --git a/include/linux/verification.h b/include/linux/verification.h
index a10549a6c7cd..b7298d804440 100644
--- a/include/linux/verification.h
+++ b/include/linux/verification.h
@@ -22,6 +22,7 @@ enum key_being_used_for {
 	VERIFYING_KEY_SIGNATURE,
 	VERIFYING_KEY_SELF_SIGNATURE,
 	VERIFYING_UNSPECIFIED_SIGNATURE,
+	VERIFYING_KEXEC_CMS_SIGNATURE,
 	NR__KEY_BEING_USED_FOR
 };
 extern const char *const key_being_used_for[NR__KEY_BEING_USED_FOR];
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
diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 370eb2f4dd37..13662043bf90 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -155,6 +155,19 @@ config IMA_APPRAISE
 	  <http://linux-ima.sourceforge.net>
 	  If unsure, say N.
 
+config IMA_APPRAISE_APPENDED_SIG
+	bool "Support appended signatures for appraisal"
+	depends on IMA_APPRAISE
+	depends on INTEGRITY_ASYMMETRIC_KEYS
+	select PKCS7_MESSAGE_PARSER
+	select MODULE_SIG_FORMAT
+	default n
+	help
+	   Adds support for signatures appended to files. The format of the
+	   appended signature is the same used for signed kernel modules.
+	   The appended_imasig keyword can be used in the IMA policy for this
+	   purpose.
+
 config IMA_TRUSTED_KEYRING
 	bool "Require all keys on the .ima keyring be signed (deprecated)"
 	depends on IMA_APPRAISE && SYSTEM_TRUSTED_KEYRING
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 51ef805cf7f3..60a823630d2a 100644
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
@@ -248,6 +250,12 @@ enum hash_algo ima_get_hash_algo(struct evm_ima_xattr_data *xattr_value,
 int ima_read_xattr(struct dentry *dentry,
 		   struct evm_ima_xattr_data **xattr_value);
 
+#ifdef CONFIG_IMA_APPRAISE_APPENDED_SIG
+void ima_read_appended_sig(const void *buf, loff_t *buf_len,
+			  struct evm_ima_xattr_data **xattr_value,
+			  int *xattr_len);
+#endif
+
 #else
 static inline int ima_appraise_measurement(enum ima_hooks func,
 					   struct integrity_iint_cache *iint,
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 8c8030a29117..789bcb1b2d89 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -15,6 +15,11 @@
 #include <linux/magic.h>
 #include <linux/ima.h>
 #include <linux/evm.h>
+#ifdef CONFIG_IMA_APPRAISE_APPENDED_SIG
+#include <linux/module_signature.h>
+#include <keys/asymmetric-type.h>
+#include <crypto/pkcs7.h>
+#endif
 
 #include "ima.h"
 
@@ -177,6 +182,85 @@ int ima_read_xattr(struct dentry *dentry,
 	return ret;
 }
 
+#ifdef CONFIG_IMA_APPRAISE_APPENDED_SIG
+void ima_read_appended_sig(const void *buf, loff_t *buf_len,
+			  struct evm_ima_xattr_data **xattr_value,
+			  int *xattr_len)
+{
+	const size_t marker_len = sizeof(MODULE_SIG_STRING) - 1;
+	const struct public_key_signature *pks;
+	const struct module_signature *sig;
+	struct signature_v2_hdr *hdr;
+	struct pkcs7_message *pkcs7;
+	int i, hdr_len;
+	loff_t file_len = *buf_len;
+	size_t sig_len;
+	const void *p;
+
+	if (file_len <= marker_len + sizeof(*sig))
+		return;
+
+	p = buf + file_len - marker_len;
+	if (memcmp(p, MODULE_SIG_STRING, marker_len))
+		return;
+
+	file_len -= marker_len;
+	sig = (const struct module_signature *) (p - sizeof(*sig));
+
+	if (validate_module_signature(sig, file_len))
+		return;
+
+	sig_len = be32_to_cpu(sig->sig_len);
+	file_len -= sig_len + sizeof(*sig);
+
+	pkcs7 = pkcs7_parse_message(buf + file_len, sig_len);
+	if (IS_ERR(pkcs7))
+		return;
+
+	if (pkcs7_verify(pkcs7, VERIFYING_KEXEC_CMS_SIGNATURE))
+		goto out;
+
+	pks = pkcs7_get_message_sig(pkcs7);
+	if (!pks)
+		goto out;
+
+	/* IMA only supports RSA keys. */
+	if (strcmp(pks->pkey_algo, "rsa"))
+		goto out;
+
+	if (!pks->auth_ids[0])
+		goto out;
+
+	for (i = 0; i < HASH_ALGO__LAST; i++)
+		if (!strcmp(hash_algo_name[i], pks->hash_algo))
+			break;
+
+	if (i == HASH_ALGO__LAST)
+		goto out;
+
+	hdr_len = sizeof(*hdr) + pks->s_size;
+	hdr = kmalloc(hdr_len, GFP_KERNEL);
+	if (!hdr)
+		goto out;
+
+	hdr->type = EVM_IMA_XATTR_DIGSIG;
+	hdr->version = 2;
+	hdr->hash_algo = i;
+	memcpy(hdr->sig, pks->s, pks->s_size);
+	hdr->sig_size = cpu_to_be16(pks->s_size);
+
+	p = pks->auth_ids[0]->data + pks->auth_ids[0]->len - sizeof(hdr->keyid);
+	memcpy(&hdr->keyid, p, sizeof(hdr->keyid));
+
+	*xattr_value = (typeof(*xattr_value)) hdr;
+	*xattr_len = hdr_len;
+	*buf_len = file_len;
+
+ out:
+	pkcs7_free_message(pkcs7);
+}
+#endif /* CONFIG_IMA_APPRAISE_APPENDED_SIG */
+
 /*
  * ima_appraise_measurement - appraise file measurement
  *
@@ -205,7 +289,7 @@ int ima_appraise_measurement(enum ima_hooks func,
 		if (rc && rc != -ENODATA)
 			goto out;
 
-		cause = iint->flags & IMA_DIGSIG_REQUIRED ?
+		cause = iint->flags & IMA_DIGSIG_REQUIRED_MASK ?
 				"IMA-signature-required" : "missing-hash";
 		status = INTEGRITY_NOLABEL;
 		if (opened & FILE_CREATED) {
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 2aebb7984437..994ee420b2ec 100644
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
@@ -228,9 +231,30 @@ static int process_measurement(struct file *file, char *buf, loff_t size,
 
 	template_desc = ima_template_desc_current();
 	if ((action & IMA_APPRAISE_SUBMASK) ||
-		    strcmp(template_desc->name, IMA_TEMPLATE_IMA_NAME) != 0)
-		/* read 'security.ima' */
-		xattr_len = ima_read_xattr(file_dentry(file), &xattr_value);
+		    strcmp(template_desc->name, IMA_TEMPLATE_IMA_NAME) != 0) {
+#ifdef CONFIG_IMA_APPRAISE_APPENDED_SIG
+		unsigned long digsig_req;
+
+		if (iint->flags & IMA_APPENDED_DIGSIG_REQUIRED) {
+			if (!buf || !size)
+				pr_err("%s doesn't support appended_imasig\n",
+				       func_tokens[func]);
+			else
+				ima_read_appended_sig(buf, &size, &xattr_value,
+						      &xattr_len);
+		}
+
+		/*
+		 * Don't try to read the xattr if we require an appended
+		 * signature but failed to get one.
+		 */
+		digsig_req = iint->flags & IMA_DIGSIG_REQUIRED_MASK;
+		if (!xattr_len && digsig_req != IMA_APPENDED_DIGSIG_REQUIRED)
+#endif /* CONFIG_IMA_APPRAISE_APPENDED_SIG */
+			/* read 'security.ima' */
+			xattr_len = ima_read_xattr(file_dentry(file),
+						   &xattr_value);
+	}
 
 	hash_algo = ima_get_hash_algo(xattr_value, xattr_len);
 
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 39d43a5beb5a..fb652f5e3999 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -777,8 +777,15 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 			}
 
 			ima_log_string(ab, "appraise_type", args[0].from);
-			if ((strcmp(args[0].from, "imasig")) == 0)
+			if (!strcmp(args[0].from, "imasig"))
 				entry->flags |= IMA_DIGSIG_REQUIRED;
+#ifdef CONFIG_IMA_APPRAISE_APPENDED_SIG
+			else if (!strcmp(args[0].from, "appended_imasig"))
+				entry->flags |= IMA_APPENDED_DIGSIG_REQUIRED;
+			else if (!strcmp(args[0].from, "appended_imasig|imasig"))
+				entry->flags |= IMA_DIGSIG_REQUIRED
+						| IMA_APPENDED_DIGSIG_REQUIRED;
+#endif /* CONFIG_IMA_APPRAISE_APPENDED_SIG */
 			else
 				result = -EINVAL;
 			break;
@@ -884,6 +891,12 @@ void ima_delete_rules(void)
 	}
 }
 
+#define __ima_hook_stringify(str)	#str,
+
+const char *const func_tokens[] = {
+	__ima_hooks(__ima_hook_stringify)
+};
+
 #ifdef	CONFIG_IMA_READ_POLICY
 enum {
 	mask_exec = 0, mask_write, mask_read, mask_append
@@ -896,12 +909,6 @@ static const char *const mask_tokens[] = {
 	"MAY_APPEND"
 };
 
-#define __ima_hook_stringify(str)	#str,
-
-static const char *const func_tokens[] = {
-	__ima_hooks(__ima_hook_stringify)
-};
-
 void *ima_policy_start(struct seq_file *m, loff_t *pos)
 {
 	loff_t l = *pos;
@@ -1049,7 +1056,13 @@ int ima_policy_show(struct seq_file *m, void *v)
 			}
 		}
 	}
-	if (entry->flags & IMA_DIGSIG_REQUIRED)
+	if ((entry->flags & IMA_DIGSIG_REQUIRED_MASK) == IMA_DIGSIG_REQUIRED_MASK)
+#ifdef CONFIG_IMA_APPRAISE_APPENDED_SIG
+		seq_puts(m, "appraise_type=appended_imasig|imasig ");
+	else if (entry->flags & IMA_APPENDED_DIGSIG_REQUIRED)
+		seq_puts(m, "appraise_type=appended_imasig ");
+	else if (entry->flags & IMA_DIGSIG_REQUIRED)
+#endif /* CONFIG_IMA_APPRAISE_APPENDED_SIG */
 		seq_puts(m, "appraise_type=imasig ");
 	if (entry->flags & IMA_PERMIT_DIRECTIO)
 		seq_puts(m, "permit_directio ");
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index a53e7e4ab06c..de2a666740c1 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -27,12 +27,20 @@
 #define IMA_AUDITED		0x00000080
 
 /* iint cache flags */
-#define IMA_ACTION_FLAGS	0xff000000
-#define IMA_ACTION_RULE_FLAGS	0x06000000
-#define IMA_DIGSIG		0x01000000
-#define IMA_DIGSIG_REQUIRED	0x02000000
-#define IMA_PERMIT_DIRECTIO	0x04000000
-#define IMA_NEW_FILE		0x08000000
+#define IMA_ACTION_FLAGS		0xff000000
+#define IMA_ACTION_RULE_FLAGS		0x16000000
+#define IMA_DIGSIG			0x01000000
+#define IMA_DIGSIG_REQUIRED		0x02000000
+#define IMA_PERMIT_DIRECTIO		0x04000000
+#define IMA_NEW_FILE			0x08000000
+#define IMA_APPENDED_DIGSIG_REQUIRED	0x10000000
+
+#ifdef CONFIG_IMA_APPRAISE_APPENDED_SIG
+#define IMA_DIGSIG_REQUIRED_MASK	(IMA_DIGSIG_REQUIRED | \
+					 IMA_APPENDED_DIGSIG_REQUIRED)
+#else
+#define IMA_DIGSIG_REQUIRED_MASK	IMA_DIGSIG_REQUIRED
+#endif /* CONFIG_IMA_APPRAISE_APPENDED_SIG */
 
 #define IMA_DO_MASK		(IMA_MEASURE | IMA_APPRAISE | IMA_AUDIT | \
 				 IMA_APPRAISE_SUBMASK)
-- 
2.7.4


