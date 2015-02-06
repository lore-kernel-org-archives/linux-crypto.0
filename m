From: "Marcelo H. Cerri" <mhcerri@linux.vnet.ibm.com>
Subject: [PATCHv2 2/7] Adding AES routines for VMX module
Date: Fri, 6 Feb 2015 14:57:22 -0200
Message-ID: <20150206165719.GA23681@bluepex.com>
Reply-To: leosilva@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: leosilva@linux.vnet.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:44689 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbbBFQ52 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Feb 2015 11:57:28 -0500
Received: from /spool/local
	by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <mhcerri@linux.vnet.ibm.com>;
	Fri, 6 Feb 2015 14:57:27 -0200
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds AES routines to VMX module in order to
make use of VMX cryptographic acceleration instructions
on Power 8 CPU.

Signed-off-by: Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
---
 drivers/crypto/vmx/aes.c       | 139 +++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/vmx/aesp8-ppc.h |  20 ++++++
 2 files changed, 159 insertions(+)
 create mode 100644 drivers/crypto/vmx/aes.c
 create mode 100644 drivers/crypto/vmx/aesp8-ppc.h

diff --git a/drivers/crypto/vmx/aes.c b/drivers/crypto/vmx/aes.c
new file mode 100644
index 0000000..ab300ea
--- /dev/null
+++ b/drivers/crypto/vmx/aes.c
@@ -0,0 +1,139 @@
+/**
+ * AES routines supporting VMX instructions on the Power 8
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
+#include <linux/types.h>
+#include <linux/err.h>
+#include <linux/crypto.h>
+#include <linux/delay.h>
+#include <linux/hardirq.h>
+#include <asm/switch_to.h>
+#include <crypto/aes.h>
+
+#include "aesp8-ppc.h"
+
+struct p8_aes_ctx {
+    struct crypto_cipher *fallback;
+    struct aes_key enc_key;
+    struct aes_key dec_key;
+};
+
+static int p8_aes_init(struct crypto_tfm *tfm)
+{
+    const char *alg;
+    struct crypto_cipher *fallback;
+    struct p8_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+
+    if (!(alg = crypto_tfm_alg_name(tfm))) {
+        printk(KERN_ERR "Failed to get algorithm name.\n");
+        return -ENOENT;
+    }
+
+    fallback = crypto_alloc_cipher(alg, 0 ,CRYPTO_ALG_NEED_FALLBACK);
+    if (IS_ERR(fallback)) {
+        printk(KERN_ERR "Failed to allocate transformation for '%s': %ld\n",
+                alg, PTR_ERR(fallback));
+        return PTR_ERR(fallback);
+    }
+    printk(KERN_INFO "Using '%s' as fallback implementation.\n",
+            crypto_tfm_alg_driver_name((struct crypto_tfm *) fallback));
+
+    crypto_cipher_set_flags(fallback,
+            crypto_cipher_get_flags((struct crypto_cipher *) tfm));
+    ctx->fallback = fallback;
+
+    return 0;
+}
+
+static void p8_aes_exit(struct crypto_tfm *tfm)
+{
+    struct p8_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+
+    if (ctx->fallback) {
+        crypto_free_cipher(ctx->fallback);
+        ctx->fallback = NULL;
+    }
+}
+
+static int p8_aes_setkey(struct crypto_tfm *tfm, const u8 *key,
+    unsigned int keylen)
+{
+    int ret;
+    struct p8_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+
+    pagefault_disable();
+    enable_kernel_altivec();
+    ret = aes_p8_set_encrypt_key(key, keylen * 8, &ctx->enc_key);
+    ret += aes_p8_set_decrypt_key(key, keylen * 8, &ctx->dec_key);
+    pagefault_enable();
+    
+    ret += crypto_cipher_setkey(ctx->fallback, key, keylen);
+    return ret;
+}
+
+static void p8_aes_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+{
+    struct p8_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+
+    if (in_interrupt()) {
+        crypto_cipher_encrypt_one(ctx->fallback, dst, src);
+    } else {
+        pagefault_disable();
+        enable_kernel_altivec();
+        aes_p8_encrypt(src, dst, &ctx->enc_key);
+        pagefault_enable();
+    }
+}
+
+static void p8_aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+{
+    struct p8_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+
+    if (in_interrupt()) {
+        crypto_cipher_decrypt_one(ctx->fallback, dst, src);
+    } else {
+        pagefault_disable();
+        enable_kernel_altivec();
+        aes_p8_decrypt(src, dst, &ctx->dec_key);
+        pagefault_enable();
+    }
+}
+
+struct crypto_alg p8_aes_alg = {
+    .cra_name = "aes",
+    .cra_driver_name = "p8_aes",
+    .cra_module = THIS_MODULE,
+    .cra_priority = 1000,
+    .cra_type = NULL,
+    .cra_flags = CRYPTO_ALG_TYPE_CIPHER | CRYPTO_ALG_NEED_FALLBACK,
+    .cra_alignmask = 0,
+    .cra_blocksize = AES_BLOCK_SIZE,
+    .cra_ctxsize = sizeof(struct p8_aes_ctx),
+    .cra_init = p8_aes_init,
+    .cra_exit = p8_aes_exit,
+    .cra_cipher = {
+        .cia_min_keysize = AES_MIN_KEY_SIZE,
+        .cia_max_keysize = AES_MAX_KEY_SIZE,
+        .cia_setkey = p8_aes_setkey,
+        .cia_encrypt = p8_aes_encrypt,
+        .cia_decrypt = p8_aes_decrypt,
+    },
+};
+
diff --git a/drivers/crypto/vmx/aesp8-ppc.h b/drivers/crypto/vmx/aesp8-ppc.h
new file mode 100644
index 0000000..e963945
--- /dev/null
+++ b/drivers/crypto/vmx/aesp8-ppc.h
@@ -0,0 +1,20 @@
+#include <linux/types.h>
+#include <crypto/aes.h>
+
+#define AES_BLOCK_MASK  (~(AES_BLOCK_SIZE-1))
+
+struct aes_key {
+    u8 key[AES_MAX_KEYLENGTH];
+    int rounds;
+};
+
+int aes_p8_set_encrypt_key(const u8 *userKey, const int bits,
+        struct aes_key *key);
+int aes_p8_set_decrypt_key(const u8 *userKey, const int bits,
+        struct aes_key *key);
+void aes_p8_encrypt(const u8 *in, u8 *out, const struct aes_key *key);
+void aes_p8_decrypt(const u8 *in, u8 *out,const struct aes_key *key);
+void aes_p8_cbc_encrypt(const u8 *in, u8 *out, size_t len,
+		const struct aes_key *key, u8 *iv, const int enc);
+void aes_p8_ctr32_encrypt_blocks(const u8 *in, u8 *out,
+        size_t len, const struct aes_key *key, const u8 *iv);
-- 
2.1.0
