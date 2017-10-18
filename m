From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: [PATCH v5 15/18] ima: Add modsig appraise_type option for module-style appended signatures
Date: Tue, 17 Oct 2017 22:53:28 -0200
Message-ID: <20171018005331.2688-16-bauerman@linux.vnet.ibm.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171018005331.2688-1-bauerman@linux.vnet.ibm.com>
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

For now, the rule above will behave exactly the same as if
appraise_type=imasig was specified because the actual modsig implementation
will be introduced in a separate patch.

Suggested-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
---
 Documentation/ABI/testing/ima_policy |  6 +++++-
 security/integrity/ima/Kconfig       | 10 +++++++++
 security/integrity/ima/Makefile      |  1 +
 security/integrity/ima/ima.h         | 11 ++++++++++
 security/integrity/ima/ima_modsig.c  | 39 ++++++++++++++++++++++++++++++++++++
 security/integrity/ima/ima_policy.c  | 12 +++++++++--
 security/integrity/integrity.h       |  3 ++-
 7 files changed, 78 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
index e76432b9954d..ced1e1835a30 100644
--- a/Documentation/ABI/testing/ima_policy
+++ b/Documentation/ABI/testing/ima_policy
@@ -36,7 +36,7 @@ Description:
 			euid:= decimal value
 			fowner:= decimal value
 		lsm:  	are LSM specific
-		option:	appraise_type:= [imasig]
+		option:	appraise_type:= [imasig] [modsig|imasig]
 			pcr:= decimal value
 
 		default policy:
@@ -102,3 +102,7 @@ Description:
 
 			measure func=KEXEC_KERNEL_CHECK pcr=4
 			measure func=KEXEC_INITRAMFS_CHECK pcr=5
+
+		Example of appraise rule allowing modsig appended signatures:
+
+			appraise func=KEXEC_KERNEL_CHECK appraise_type=modsig|imasig
diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 35ef69312811..40c6618d00e6 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -163,6 +163,16 @@ config IMA_APPRAISE_BOOTPARAM
 	  This option enables the different "ima_appraise=" modes
 	  (eg. fix, log) from the boot command line.
 
+config IMA_APPRAISE_MODSIG
+	bool "Support module-style signatures for appraisal"
+	depends on IMA_APPRAISE
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
index c9ba4362760b..156ba218e0b6 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -255,6 +255,10 @@ enum hash_algo ima_get_hash_algo(struct evm_ima_xattr_data *xattr_value,
 int ima_read_xattr(struct dentry *dentry,
 		   struct evm_ima_xattr_data **xattr_value);
 
+#ifdef CONFIG_IMA_APPRAISE_MODSIG
+bool ima_hook_supports_modsig(enum ima_hooks func);
+#endif
+
 #else
 static inline int ima_appraise_measurement(enum ima_hooks func,
 					   struct integrity_iint_cache *iint,
@@ -298,6 +302,13 @@ static inline int ima_read_xattr(struct dentry *dentry,
 
 #endif /* CONFIG_IMA_APPRAISE */
 
+#ifndef CONFIG_IMA_APPRAISE_MODSIG
+static inline bool ima_hook_supports_modsig(enum ima_hooks func)
+{
+	return false;
+}
+#endif
+
 /* LSM based policy rules require audit */
 #ifdef CONFIG_IMA_LSM_RULES
 
diff --git a/security/integrity/ima/ima_modsig.c b/security/integrity/ima/ima_modsig.c
new file mode 100644
index 000000000000..452ce6048a7e
--- /dev/null
+++ b/security/integrity/ima/ima_modsig.c
@@ -0,0 +1,39 @@
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
+#include "ima.h"
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
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 7355d4ab7bf4..c5f98c54e59d 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -854,6 +854,10 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 			ima_log_string(ab, "appraise_type", args[0].from);
 			if (strcmp(args[0].from, "imasig") == 0)
 				entry->flags |= IMA_DIGSIG_REQUIRED;
+			else if (ima_hook_supports_modsig(entry->func) &&
+				 strcmp(args[0].from, "modsig|imasig") == 0)
+				entry->flags |= IMA_DIGSIG_REQUIRED
+						| IMA_MODSIG_ALLOWED;
 			else
 				result = -EINVAL;
 			break;
@@ -1139,8 +1143,12 @@ int ima_policy_show(struct seq_file *m, void *v)
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
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 657ce4558984..da709558ec8b 100644
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
