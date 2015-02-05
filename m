From: "Marcelo H. Cerri" <mhcerri@linux.vnet.ibm.com>
Subject: [PATCH 4/7] Adding CTR routines for VMX module
Date: Thu, 5 Feb 2015 15:19:30 -0200
Message-ID: <20150205171924.GA14707@bluepex.com>
Reply-To: leosilva@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: leosilva@linux.vnet.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:37409 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758156AbbBERTh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Feb 2015 12:19:37 -0500
Received: from /spool/local
	by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <mhcerri@linux.vnet.ibm.com>;
	Thu, 5 Feb 2015 15:19:35 -0200
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds AES CTR routines to VMX module in order to
make use of VMX cryptographic acceleration instructions
on Power 8 CPU.

Signed-off-by: Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
---
 drivers/crypto/vmx/aes_ctr.c | 167 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 167 insertions(+)
 create mode 100644 drivers/crypto/vmx/aes_ctr.c

diff --git a/drivers/crypto/vmx/aes_ctr.c b/drivers/crypto/vmx/aes_ctr.c
new file mode 100644
index 0000000..96dbee4
--- /dev/null
+++ b/drivers/crypto/vmx/aes_ctr.c
@@ -0,0 +1,167 @@
+/**
+ * AES CTR routines supporting VMX instructions on the Power 8
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
+#include "aesp8-ppc.h"
+
+struct p8_aes_ctr_ctx {
+    struct crypto_blkcipher *fallback;
+    struct aes_key enc_key;
+};
+
+static int p8_aes_ctr_init(struct crypto_tfm *tfm)
+{
+    const char *alg;
+    struct crypto_blkcipher *fallback;
+    struct p8_aes_ctr_ctx *ctx = crypto_tfm_ctx(tfm);
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
+static void p8_aes_ctr_exit(struct crypto_tfm *tfm)
+{
+    struct p8_aes_ctr_ctx *ctx = crypto_tfm_ctx(tfm);
+
+    if (ctx->fallback) {
+        crypto_free_blkcipher(ctx->fallback);
+        ctx->fallback = NULL;
+    }
+}
+
+static int p8_aes_ctr_setkey(struct crypto_tfm *tfm, const u8 *key,
+    unsigned int keylen)
+{
+    int ret;
+    struct p8_aes_ctr_ctx *ctx = crypto_tfm_ctx(tfm);
+
+    pagefault_disable();
+    enable_kernel_altivec();
+    ret = aes_p8_set_encrypt_key(key, keylen * 8, &ctx->enc_key);
+    pagefault_enable();
+
+    ret += crypto_blkcipher_setkey(ctx->fallback, key, keylen);
+    return ret;
+}
+
+static void p8_aes_ctr_final(struct p8_aes_ctr_ctx *ctx,
+                struct blkcipher_walk *walk)
+{
+    u8 *ctrblk = walk->iv;
+    u8 keystream[AES_BLOCK_SIZE];
+    u8 *src = walk->src.virt.addr;
+    u8 *dst = walk->dst.virt.addr;
+    unsigned int nbytes = walk->nbytes;
+
+    pagefault_disable();
+    enable_kernel_altivec();
+    aes_p8_encrypt(ctrblk, keystream, &ctx->enc_key);
+    pagefault_enable();
+
+    crypto_xor(keystream, src, nbytes);
+    memcpy(dst, keystream, nbytes);
+    crypto_inc(ctrblk, AES_BLOCK_SIZE);
+}
+
+static int p8_aes_ctr_crypt(struct blkcipher_desc *desc,
+    struct scatterlist *dst, struct scatterlist *src,
+    unsigned int nbytes)
+{
+    int ret;
+    struct blkcipher_walk walk;
+    struct p8_aes_ctr_ctx *ctx = crypto_tfm_ctx(
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
+        blkcipher_walk_init(&walk, dst, src, nbytes);
+        ret = blkcipher_walk_virt_block(desc, &walk, AES_BLOCK_SIZE);
+        while ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE) {
+            pagefault_disable();
+            enable_kernel_altivec();
+            aes_p8_ctr32_encrypt_blocks(walk.src.virt.addr, walk.dst.virt.addr,
+                (nbytes & AES_BLOCK_MASK)/AES_BLOCK_SIZE, &ctx->enc_key, walk.iv);
+            pagefault_enable();
+
+            crypto_inc(walk.iv, AES_BLOCK_SIZE);
+            nbytes &= AES_BLOCK_SIZE - 1;
+            ret = blkcipher_walk_done(desc, &walk, nbytes);
+        }
+        if (walk.nbytes) {
+            p8_aes_ctr_final(ctx, &walk);
+            ret = blkcipher_walk_done(desc, &walk, 0);
+        }
+    }
+
+    return ret;
+}
+
+struct crypto_alg p8_aes_ctr_alg = {
+    .cra_name = "ctr(aes)",
+    .cra_driver_name = "p8_aes_ctr",
+    .cra_module = THIS_MODULE,
+    .cra_priority = 1000,
+    .cra_type = &crypto_blkcipher_type,
+    .cra_flags = CRYPTO_ALG_TYPE_BLKCIPHER | CRYPTO_ALG_NEED_FALLBACK,
+    .cra_alignmask = 0,
+    .cra_blocksize = 1,
+    .cra_ctxsize = sizeof(struct p8_aes_ctr_ctx),
+    .cra_init = p8_aes_ctr_init,
+    .cra_exit = p8_aes_ctr_exit,
+    .cra_blkcipher = {
+        .ivsize = 0,
+        .min_keysize = AES_MIN_KEY_SIZE,
+        .max_keysize = AES_MAX_KEY_SIZE,
+        .setkey = p8_aes_ctr_setkey,
+        .encrypt = p8_aes_ctr_crypt,
+        .decrypt = p8_aes_ctr_crypt,
+    },
+};
-- 
2.1.0
