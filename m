From: "Marcelo H. Cerri" <mhcerri@linux.vnet.ibm.com>
Subject: [PATCH 1/7] Adding VMX module for Power 8
Date: Thu, 5 Feb 2015 15:16:38 -0200
Message-ID: <20150205171634.GA13979@bluepex.com>
Reply-To: leosilva@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: leosilva@linux.vnet.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:44837 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757721AbbBERQm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Feb 2015 12:16:42 -0500
Received: from /spool/local
	by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <mhcerri@linux.vnet.ibm.com>;
	Thu, 5 Feb 2015 15:16:41 -0200
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds routines supporting VMX instructions on the
Power 8.

Signed-off-by: Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
---
 drivers/crypto/vmx/vmx.c | 88 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)
 create mode 100644 drivers/crypto/vmx/vmx.c

diff --git a/drivers/crypto/vmx/vmx.c b/drivers/crypto/vmx/vmx.c
new file mode 100644
index 0000000..44d8d5c
--- /dev/null
+++ b/drivers/crypto/vmx/vmx.c
@@ -0,0 +1,88 @@
+/**
+ * Routines supporting VMX instructions on the Power 8
+ *
+ * Copyright (C) 2015 International Business Machines Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 only.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ * Author: Marcelo Henrique Cerri <mhcerri@br.ibm.com>
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/err.h>
+#include <linux/crypto.h>
+#include <asm/cputable.h>
+#include <crypto/internal/hash.h>
+
+extern struct shash_alg p8_ghash_alg;
+extern struct crypto_alg p8_aes_alg;
+extern struct crypto_alg p8_aes_cbc_alg;
+extern struct crypto_alg p8_aes_ctr_alg;
+static struct crypto_alg *algs[] = {
+    &p8_aes_alg,
+    &p8_aes_cbc_alg,
+    &p8_aes_ctr_alg,
+    NULL,
+};
+
+int __init p8_init(void)
+{
+    int ret = 0;
+    struct crypto_alg **alg_it;
+
+    if (!(cur_cpu_spec->cpu_user_features2 & PPC_FEATURE2_VEC_CRYPTO))
+        return -ENODEV;
+
+    for (alg_it = algs; *alg_it; alg_it++) {
+        ret = crypto_register_alg(*alg_it);
+        printk(KERN_INFO "crypto_register_alg '%s' = %d\n",
+                (*alg_it)->cra_name, ret);
+        if (ret) {
+            for (alg_it--; alg_it >= algs; alg_it--)
+                crypto_unregister_alg(*alg_it);
+            break;
+        }
+    }
+    if (ret)
+        return ret;
+
+    ret = crypto_register_shash(&p8_ghash_alg);
+    if (ret) {
+        for (alg_it = algs; *alg_it; alg_it++)
+            crypto_unregister_alg(*alg_it);
+    }
+    return ret;
+}
+
+void __exit p8_exit(void)
+{
+    struct crypto_alg **alg_it;
+
+    for (alg_it = algs; *alg_it; alg_it++) {
+        printk(KERN_INFO "Removing '%s'\n", (*alg_it)->cra_name);
+        crypto_unregister_alg(*alg_it);
+    }
+    crypto_unregister_shash(&p8_ghash_alg);
+}
+
+module_init(p8_init);
+module_exit(p8_exit);
+
+MODULE_AUTHOR("Marcelo Cerri<mhcerri@br.ibm.com>");
+MODULE_DESCRIPTION("IBM VMX cryptogaphic acceleration instructions support on Power 8");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("1.0.0");
+
-- 
2.1.0
