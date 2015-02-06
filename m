From: "Marcelo H. Cerri" <mhcerri@linux.vnet.ibm.com>
Subject: [PATCHv2 3/7] Adding CBC routines for VMX module
Date: Fri, 6 Feb 2015 14:57:53 -0200
Message-ID: <20150206165750.GA23831@bluepex.com>
Reply-To: leosilva@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: leosilva@linux.vnet.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:54385 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbbBFQ56 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Feb 2015 11:57:58 -0500
Received: from /spool/local
	by e24smtp03.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <mhcerri@linux.vnet.ibm.com>;
	Fri, 6 Feb 2015 14:57:57 -0200
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds AES CBC routines to VMX module in order to
make use of VMX cryptographic acceleration instructions
on Power 8 CPU.

Signed-off-by: Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
---
 drivers/crypto/vmx/aes_cbc.c | 184 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 184 insertions(+)
 create mode 100644 drivers/crypto/vmx/aes_cbc.c

diff --git a/drivers/crypto/vmx/aes_cbc.c b/drivers/crypto/vmx/aes_cbc.c
new file mode 100644
index 0000000..1a559b7
--- /dev/null
+++ b/drivers/crypto/vmx/aes_cbc.c
@@ -0,0 +1,184 @@
+/**
+ * AES CBC routines supporting VMX instructions on the Power 8
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
+#include <crypto/scatterwalk.h>
+
+#include "aesp8-ppc.h"
+
+struct p8_aes_cbc_ctx {
+    struct crypto_blkcipher *fallback;
+    struct aes_key enc_key;
+    struct aes_key dec_key;
+};
+
+static int p8_aes_cbc_init(struct crypto_tfm *tfm)
+{
+    const char *alg;
+    struct crypto_blkcipher *fallback;
+    struct p8_aes_cbc_ctx *ctx = crypto_tfm_ctx(tfm);
+
+    if (!(alg = crypto_tfm_alg_name(tfm))) {
+        printk(KERN_ERR "Failed to get algorithm name.\n");
+        return -ENOENT;
+    }
+
+    fallback = crypto_alloc_blkcipher(alg, 0 ,CRYPTO_ALG_NEED_FALLBACK);
+    if (IS_ERR(fallback)) {
+        printk(KERN_ERR "Failed to allocate transformation for '%s': %ld\n",
+                alg, PTR_ERR(fallback));
+        return PTR_ERR(fallback);
+    }
+    printk(KERN_INFO "Using '%s' as fallback implementation.\n",
+            crypto_tfm_alg_driver_name((struct crypto_tfm *) fallback));
+
+    crypto_blkcipher_set_flags(fallback,
+            crypto_blkcipher_get_flags((struct crypto_blkcipher *) tfm));
+    ctx->fallback = fallback;
+
+    return 0;
+}
+
+static void p8_aes_cbc_exit(struct crypto_tfm *tfm)
+{
+    struct p8_aes_cbc_ctx *ctx = crypto_tfm_ctx(tfm);
+
+    if (ctx->fallback) {
+        crypto_free_blkcipher(ctx->fallback);
+        ctx->fallback = NULL;
+    }
+}
+
+static int p8_aes_cbc_setkey(struct crypto_tfm *tfm, const u8 *key,
+    unsigned int keylen)
+{
+    int ret;
+    struct p8_aes_cbc_ctx *ctx = crypto_tfm_ctx(tfm);
+
+    pagefault_disable();
+    enable_kernel_altivec();
+    ret = aes_p8_set_encrypt_key(key, keylen * 8, &ctx->enc_key);
+    ret += aes_p8_set_decrypt_key(key, keylen * 8, &ctx->dec_key);
+    pagefault_enable();
+
+    ret += crypto_blkcipher_setkey(ctx->fallback, key, keylen);
+    return ret;
+}
+
+static int p8_aes_cbc_encrypt(struct blkcipher_desc *desc,
+    struct scatterlist *dst, struct scatterlist *src,
+    unsigned int nbytes)
+{
+    int ret;
+    struct blkcipher_walk walk;
+    struct p8_aes_cbc_ctx *ctx = crypto_tfm_ctx(
+            crypto_blkcipher_tfm(desc->tfm));
+    struct blkcipher_desc fallback_desc = {
+        .tfm = ctx->fallback,
+        .info = desc->info,
+        .flags = desc->flags
+    };
+
+    if (in_interrupt()) {
+        ret = crypto_blkcipher_encrypt(&fallback_desc, dst, src, nbytes);
+    } else {
+        pagefault_disable();
+        enable_kernel_altivec();
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+        ret = blkcipher_walk_virt(desc, &walk);
+        while ((nbytes = walk.nbytes)) {
+			aes_p8_cbc_encrypt(walk.src.virt.addr, walk.dst.virt.addr,
+				nbytes & AES_BLOCK_MASK, &ctx->enc_key, walk.iv, 1);
+			nbytes &= AES_BLOCK_SIZE - 1;
+			ret = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+        pagefault_enable();
+    }
+
+    return ret;
+}
+
+static int p8_aes_cbc_decrypt(struct blkcipher_desc *desc,
+    struct scatterlist *dst, struct scatterlist *src,
+    unsigned int nbytes)
+{
+    int ret;
+    struct blkcipher_walk walk;
+    struct p8_aes_cbc_ctx *ctx = crypto_tfm_ctx(
+            crypto_blkcipher_tfm(desc->tfm));
+    struct blkcipher_desc fallback_desc = {
+        .tfm = ctx->fallback,
+        .info = desc->info,
+        .flags = desc->flags
+    };
+
+    if (in_interrupt()) {
+        ret = crypto_blkcipher_decrypt(&fallback_desc, dst, src, nbytes);
+    } else {
+        pagefault_disable();
+        enable_kernel_altivec();
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+        ret = blkcipher_walk_virt(desc, &walk);
+        while ((nbytes = walk.nbytes)) {
+			aes_p8_cbc_encrypt(walk.src.virt.addr, walk.dst.virt.addr,
+				nbytes & AES_BLOCK_MASK, &ctx->dec_key, walk.iv, 0);
+			nbytes &= AES_BLOCK_SIZE - 1;
+			ret = blkcipher_walk_done(desc, &walk, nbytes);
+		}
+
+        pagefault_enable();
+    }
+
+    return ret;
+}
+
+
+struct crypto_alg p8_aes_cbc_alg = {
+    .cra_name = "cbc(aes)",
+    .cra_driver_name = "p8_aes_cbc",
+    .cra_module = THIS_MODULE,
+    .cra_priority = 1000,
+    .cra_type = &crypto_blkcipher_type,
+    .cra_flags = CRYPTO_ALG_TYPE_BLKCIPHER | CRYPTO_ALG_NEED_FALLBACK,
+    .cra_alignmask = 0,
+    .cra_blocksize = AES_BLOCK_SIZE,
+    .cra_ctxsize = sizeof(struct p8_aes_cbc_ctx),
+    .cra_init = p8_aes_cbc_init,
+    .cra_exit = p8_aes_cbc_exit,
+    .cra_blkcipher = {
+        .ivsize = 0,
+        .min_keysize = AES_MIN_KEY_SIZE,
+        .max_keysize = AES_MAX_KEY_SIZE,
+        .setkey = p8_aes_cbc_setkey,
+        .encrypt = p8_aes_cbc_encrypt,
+        .decrypt = p8_aes_cbc_decrypt,
+    },
+};
+
-- 
2.1.0
