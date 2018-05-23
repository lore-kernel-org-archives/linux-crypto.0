From: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Subject: [PATCH v7 10/14] ima: Add modsig appraise_type option for module-style appended signatures
Date: Tue, 22 May 2018 21:12:49 -0300
Message-ID: <20180523001253.15247-11-bauerman@linux.ibm.com>
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

Introduce the modsig keyword to the IMA policy syntax to specify that
a given hook should expect the file to have the IMA signature appended
to it. Here is how it can be used in a rule:

appraise func=KEXEC_KERNEL_CHECK appraise_type=imasig|modsig

With this rule, IMA will accept either a signature stored in the extended
attribute or an appended signature.

For now, the rule above will behave exactly the same as if
appraise_type=imasig was specified. The actual modsig implementation
will be introduced separately.

Suggested-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
---
 Documentation/ABI/testing/ima_policy |  6 +++++-
 security/integrity/ima/Kconfig       | 10 ++++++++++
 security/integrity/ima/Makefile      |  1 +
 security/integrity/ima/ima.h         |  9 +++++++++
 security/integrity/ima/ima_modsig.c  | 31 +++++++++++++++++++++++++++++++
 security/integrity/ima/ima_policy.c  | 12 ++++++++++--
 security/integrity/integrity.h       |  1 +
 7 files changed, 67 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
index 74c6702de74e..9d1dfd0a8891 100644
--- a/Documentation/ABI/testing/ima_policy
+++ b/Documentation/ABI/testing/ima_policy
@@ -37,7 +37,7 @@ Description:
 			euid:= decimal value
 			fowner:= decimal value
 		lsm:  	are LSM specific
-		option:	appraise_type:= [imasig]
+		option:	appraise_type:= [imasig] [imasig|modsig]
 			pcr:= decimal value
 
 		default policy:
@@ -103,3 +103,7 @@ Description:
 
 			measure func=KEXEC_KERNEL_CHECK pcr=4
 			measure func=KEXEC_INITRAMFS_CHECK pcr=5
+
+		Example of appraise rule allowing modsig appended signatures:
+
+			appraise func=KEXEC_KERNEL_CHECK appraise_type=imasig|modsig
diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 6a8f67714c83..ee278189e0bb 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -164,6 +164,16 @@ config IMA_APPRAISE_BOOTPARAM
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
index d921dc4f9eb0..31d57cdf2421 100644
--- a/security/integrity/ima/Makefile
+++ b/security/integrity/ima/Makefile
@@ -9,5 +9,6 @@ obj-$(CONFIG_IMA) += ima.o
 ima-y := ima_fs.o ima_queue.o ima_init.o ima_main.o ima_crypto.o ima_api.o \
 	 ima_policy.o ima_template.o ima_template_lib.o
 ima-$(CONFIG_IMA_APPRAISE) += ima_appraise.o
+ima-$(CONFIG_IMA_APPRAISE_MODSIG) += ima_modsig.o
 ima-$(CONFIG_HAVE_IMA_KEXEC) += ima_kexec.o
 obj-$(CONFIG_IMA_BLACKLIST_KEYRING) += ima_mok.o
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 567be3c6568c..01f379916583 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -298,6 +298,15 @@ static inline int ima_read_xattr(struct dentry *dentry,
 
 #endif /* CONFIG_IMA_APPRAISE */
 
+#ifdef CONFIG_IMA_APPRAISE_MODSIG
+bool ima_hook_supports_modsig(enum ima_hooks func);
+#else
+static inline bool ima_hook_supports_modsig(enum ima_hooks func)
+{
+	return false;
+}
+#endif /* CONFIG_IMA_APPRAISE_MODSIG */
+
 /* LSM based policy rules require audit */
 #ifdef CONFIG_IMA_LSM_RULES
 
diff --git a/security/integrity/ima/ima_modsig.c b/security/integrity/ima/ima_modsig.c
new file mode 100644
index 000000000000..d8ea811b6f74
--- /dev/null
+++ b/security/integrity/ima/ima_modsig.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * IMA support for appraising module-style appended signatures.
+ *
+ * Copyright (C) 2018  IBM Corporation
+ *
+ * Author:
+ * Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
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
index d454949493c6..66d0d3bcf1b2 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -919,6 +919,10 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 			ima_log_string(ab, "appraise_type", args[0].from);
 			if ((strcmp(args[0].from, "imasig")) == 0)
 				entry->flags |= IMA_DIGSIG_REQUIRED;
+			else if (ima_hook_supports_modsig(entry->func) &&
+				 strcmp(args[0].from, "imasig|modsig") == 0)
+				entry->flags |= IMA_DIGSIG_REQUIRED
+						| IMA_MODSIG_ALLOWED;
 			else
 				result = -EINVAL;
 			break;
@@ -1211,8 +1215,12 @@ int ima_policy_show(struct seq_file *m, void *v)
 			}
 		}
 	}
-	if (entry->flags & IMA_DIGSIG_REQUIRED)
-		seq_puts(m, "appraise_type=imasig ");
+	if (entry->flags & IMA_DIGSIG_REQUIRED) {
+		if (entry->flags & IMA_MODSIG_ALLOWED)
+			seq_puts(m, "appraise_type=imasig|modsig ");
+		else
+			seq_puts(m, "appraise_type=imasig ");
+	}
 	if (entry->flags & IMA_PERMIT_DIRECTIO)
 		seq_puts(m, "permit_directio ");
 	rcu_read_unlock();
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 7f80c3e44d51..05fdbf953f90 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -35,6 +35,7 @@
 #define IMA_NEW_FILE		0x04000000
 #define EVM_IMMUTABLE_DIGSIG	0x08000000
 #define IMA_FAIL_UNVERIFIABLE_SIGS	0x10000000
+#define IMA_MODSIG_ALLOWED	0x20000000
 
 #define IMA_DO_MASK		(IMA_MEASURE | IMA_APPRAISE | IMA_AUDIT | \
 				 IMA_HASH | IMA_APPRAISE_SUBMASK)
