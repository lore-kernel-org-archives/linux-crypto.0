From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: [PATCH v3 2/7] MODSIGN: Export module signature definitions.
Date: Thu,  6 Jul 2017 19:17:48 -0300
Message-ID: <20170706221753.17380-3-bauerman@linux.vnet.ibm.com>
References: <20170706221753.17380-1-bauerman@linux.vnet.ibm.com>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50862 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751989AbdGFWS1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jul 2017 18:18:27 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v66ME2Gd111721
        for <linux-crypto@vger.kernel.org>; Thu, 6 Jul 2017 18:18:26 -0400
Received: from e24smtp04.br.ibm.com (e24smtp04.br.ibm.com [32.104.18.25])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bhqu9pk4w-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Thu, 06 Jul 2017 18:18:26 -0400
Received: from localhost
        by e24smtp04.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <bauerman@linux.vnet.ibm.com>;
        Thu, 6 Jul 2017 19:18:24 -0300
In-Reply-To: <20170706221753.17380-1-bauerman@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

IMA will use the module_signature format for append signatures, so export
the relevant definitions and factor out the code which verifies that the
appended signature trailer is valid.

Also, create a CONFIG_MODULE_SIG_FORMAT option so that IMA can select it
and be able to use validate_module_signature without having to depend on
CONFIG_MODULE_SIG.

Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
---
 include/linux/module.h           |  3 --
 include/linux/module_signature.h | 47 +++++++++++++++++++++++++
 init/Kconfig                     |  6 +++-
 kernel/Makefile                  |  2 +-
 kernel/module.c                  |  1 +
 kernel/module_signing.c          | 74 +++++++++++++++++-----------------------
 6 files changed, 85 insertions(+), 48 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 21f56393602f..76a233f120ba 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -23,9 +23,6 @@
 #include <linux/percpu.h>
 #include <asm/module.h>
 
-/* In stripped ARM and x86-64 modules, ~ is surprisingly rare. */
-#define MODULE_SIG_STRING "~Module signature appended~\n"
-
 /* Not Yet Implemented */
 #define MODULE_SUPPORTED_DEVICE(name)
 
diff --git a/include/linux/module_signature.h b/include/linux/module_signature.h
new file mode 100644
index 000000000000..e80728e5b86c
--- /dev/null
+++ b/include/linux/module_signature.h
@@ -0,0 +1,47 @@
+/* Module signature handling.
+ *
+ * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _LINUX_MODULE_SIGNATURE_H
+#define _LINUX_MODULE_SIGNATURE_H
+
+/* In stripped ARM and x86-64 modules, ~ is surprisingly rare. */
+#define MODULE_SIG_STRING "~Module signature appended~\n"
+
+enum pkey_id_type {
+	PKEY_ID_PGP,		/* OpenPGP generated key ID */
+	PKEY_ID_X509,		/* X.509 arbitrary subjectKeyIdentifier */
+	PKEY_ID_PKCS7,		/* Signature in PKCS#7 message */
+};
+
+/*
+ * Module signature information block.
+ *
+ * The constituents of the signature section are, in order:
+ *
+ *	- Signer's name
+ *	- Key identifier
+ *	- Signature data
+ *	- Information block
+ */
+struct module_signature {
+	u8	algo;		/* Public-key crypto algorithm [0] */
+	u8	hash;		/* Digest algorithm [0] */
+	u8	id_type;	/* Key identifier type [PKEY_ID_PKCS7] */
+	u8	signer_len;	/* Length of signer's name [0] */
+	u8	key_id_len;	/* Length of key identifier [0] */
+	u8	__pad[3];
+	__be32	sig_len;	/* Length of signature data */
+};
+
+int validate_module_sig(const struct module_signature *ms, size_t file_len);
+int mod_verify_sig(const void *mod, unsigned long *_modlen);
+
+#endif /* _LINUX_MODULE_SIGNATURE_H */
diff --git a/init/Kconfig b/init/Kconfig
index 1d3475fc9496..5f20513098ff 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -2063,7 +2063,7 @@ config MODULE_SRCVERSION_ALL
 config MODULE_SIG
 	bool "Module signature verification"
 	depends on MODULES
-	select SYSTEM_DATA_VERIFICATION
+	select MODULE_SIG_FORMAT
 	help
 	  Check modules for valid signatures upon load: the signature
 	  is simply appended to the module. For more information see
@@ -2078,6 +2078,10 @@ config MODULE_SIG
 	  debuginfo strip done by some packagers (such as rpmbuild) and
 	  inclusion into an initramfs that wants the module size reduced.
 
+config MODULE_SIG_FORMAT
+	def_bool n
+	select SYSTEM_DATA_VERIFICATION
+
 config MODULE_SIG_FORCE
 	bool "Require modules to be validly signed"
 	depends on MODULE_SIG
diff --git a/kernel/Makefile b/kernel/Makefile
index 72aa080f91f0..dcb548b68084 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -56,7 +56,7 @@ obj-y += up.o
 endif
 obj-$(CONFIG_UID16) += uid16.o
 obj-$(CONFIG_MODULES) += module.o
-obj-$(CONFIG_MODULE_SIG) += module_signing.o
+obj-$(CONFIG_MODULE_SIG_FORMAT) += module_signing.o
 obj-$(CONFIG_KALLSYMS) += kallsyms.o
 obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
 obj-$(CONFIG_CRASH_CORE) += crash_core.o
diff --git a/kernel/module.c b/kernel/module.c
index 4a3665f8f837..0f973856d6d2 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -19,6 +19,7 @@
 #include <linux/export.h>
 #include <linux/extable.h>
 #include <linux/moduleloader.h>
+#include <linux/module_signature.h>
 #include <linux/trace_events.h>
 #include <linux/init.h>
 #include <linux/kallsyms.h>
diff --git a/kernel/module_signing.c b/kernel/module_signing.c
index 937c844bee4a..204c60d4cc9f 100644
--- a/kernel/module_signing.c
+++ b/kernel/module_signing.c
@@ -11,36 +11,38 @@
 
 #include <linux/kernel.h>
 #include <linux/errno.h>
+#include <linux/module_signature.h>
 #include <linux/string.h>
 #include <linux/verification.h>
 #include <crypto/public_key.h>
 #include "module-internal.h"
 
-enum pkey_id_type {
-	PKEY_ID_PGP,		/* OpenPGP generated key ID */
-	PKEY_ID_X509,		/* X.509 arbitrary subjectKeyIdentifier */
-	PKEY_ID_PKCS7,		/* Signature in PKCS#7 message */
-};
-
-/*
- * Module signature information block.
- *
- * The constituents of the signature section are, in order:
+/**
+ * validate_module_sig - validate that the given signature is sane
  *
- *	- Signer's name
- *	- Key identifier
- *	- Signature data
- *	- Information block
+ * @ms:		Signature to validate.
+ * @file_len:	Size of the file to which @ms is appended.
  */
-struct module_signature {
-	u8	algo;		/* Public-key crypto algorithm [0] */
-	u8	hash;		/* Digest algorithm [0] */
-	u8	id_type;	/* Key identifier type [PKEY_ID_PKCS7] */
-	u8	signer_len;	/* Length of signer's name [0] */
-	u8	key_id_len;	/* Length of key identifier [0] */
-	u8	__pad[3];
-	__be32	sig_len;	/* Length of signature data */
-};
+int validate_module_sig(const struct module_signature *ms, size_t file_len)
+{
+	if (be32_to_cpu(ms->sig_len) >= file_len - sizeof(*ms))
+		return -EBADMSG;
+	else if (ms->id_type != PKEY_ID_PKCS7) {
+		pr_err("Module is not signed with expected PKCS#7 message\n");
+		return -ENOPKG;
+	} else if (ms->algo != 0 ||
+		   ms->hash != 0 ||
+		   ms->signer_len != 0 ||
+		   ms->key_id_len != 0 ||
+		   ms->__pad[0] != 0 ||
+		   ms->__pad[1] != 0 ||
+		   ms->__pad[2] != 0) {
+		pr_err("PKCS#7 signature info has unexpected non-zero params\n");
+		return -EBADMSG;
+	}
+
+	return 0;
+}
 
 /*
  * Verify the signature on a module.
@@ -49,6 +51,7 @@ int mod_verify_sig(const void *mod, unsigned long *_modlen)
 {
 	struct module_signature ms;
 	size_t modlen = *_modlen, sig_len;
+	int ret;
 
 	pr_devel("==>%s(,%zu)\n", __func__, modlen);
 
@@ -56,30 +59,15 @@ int mod_verify_sig(const void *mod, unsigned long *_modlen)
 		return -EBADMSG;
 
 	memcpy(&ms, mod + (modlen - sizeof(ms)), sizeof(ms));
-	modlen -= sizeof(ms);
+
+	ret = validate_module_sig(&ms, modlen);
+	if (ret)
+		return ret;
 
 	sig_len = be32_to_cpu(ms.sig_len);
-	if (sig_len >= modlen)
-		return -EBADMSG;
-	modlen -= sig_len;
+	modlen -= sig_len + sizeof(ms);
 	*_modlen = modlen;
 
-	if (ms.id_type != PKEY_ID_PKCS7) {
-		pr_err("Module is not signed with expected PKCS#7 message\n");
-		return -ENOPKG;
-	}
-
-	if (ms.algo != 0 ||
-	    ms.hash != 0 ||
-	    ms.signer_len != 0 ||
-	    ms.key_id_len != 0 ||
-	    ms.__pad[0] != 0 ||
-	    ms.__pad[1] != 0 ||
-	    ms.__pad[2] != 0) {
-		pr_err("PKCS#7 signature info has unexpected non-zero params\n");
-		return -EBADMSG;
-	}
-
 	return verify_pkcs7_signature(mod, modlen, mod + modlen, sig_len,
 				      NULL, VERIFYING_MODULE_SIGNATURE,
 				      NULL, NULL);
-- 
2.13.0
