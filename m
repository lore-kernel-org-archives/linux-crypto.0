From: Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH stable 2/2] crypto: vmx - Adding enable_kernel_vsx() to access VSX instructions
Date: Wed, 16 Sep 2015 11:40:37 +1000
Message-ID: <1442367639-11527-2-git-send-email-mpe@ellerman.id.au>
References: <1442367639-11527-1-git-send-email-mpe@ellerman.id.au>
Cc: <linuxppc-dev@ozlabs.org>, linux-crypto@vger.kernel.org,
	"Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: stable@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:38080 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbbIPBkq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Sep 2015 21:40:46 -0400
In-Reply-To: <1442367639-11527-1-git-send-email-mpe@ellerman.id.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

commit 2d6f0600b2cd755959527230ef5a6fba97bb762a upstream.

vmx-crypto driver make use of some VSX instructions which are
only available if VSX is enabled. Running in cases where VSX
are not enabled vmx-crypto fails in a VSX exception.

In order to fix this enable_kernel_vsx() was added to turn on
VSX instructions for vmx-crypto.

Signed-off-by: Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Fixes: 8676590a1593 ("crypto: vmx - Adding AES routines for VMX module")
Cc: stable@vger.kernel.org # 4.1
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 drivers/crypto/vmx/aes.c     | 3 +++
 drivers/crypto/vmx/aes_cbc.c | 3 +++
 drivers/crypto/vmx/aes_ctr.c | 3 +++
 drivers/crypto/vmx/ghash.c   | 4 ++++
 4 files changed, 13 insertions(+)

diff --git a/drivers/crypto/vmx/aes.c b/drivers/crypto/vmx/aes.c
index ab300ea19434..41f93334cc44 100644
--- a/drivers/crypto/vmx/aes.c
+++ b/drivers/crypto/vmx/aes.c
@@ -80,6 +80,7 @@ static int p8_aes_setkey(struct crypto_tfm *tfm, const u8 *key,
 
     pagefault_disable();
     enable_kernel_altivec();
+    enable_kernel_vsx();
     ret = aes_p8_set_encrypt_key(key, keylen * 8, &ctx->enc_key);
     ret += aes_p8_set_decrypt_key(key, keylen * 8, &ctx->dec_key);
     pagefault_enable();
@@ -97,6 +98,7 @@ static void p8_aes_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
     } else {
         pagefault_disable();
         enable_kernel_altivec();
+        enable_kernel_vsx();
         aes_p8_encrypt(src, dst, &ctx->enc_key);
         pagefault_enable();
     }
@@ -111,6 +113,7 @@ static void p8_aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
     } else {
         pagefault_disable();
         enable_kernel_altivec();
+        enable_kernel_vsx();
         aes_p8_decrypt(src, dst, &ctx->dec_key);
         pagefault_enable();
     }
diff --git a/drivers/crypto/vmx/aes_cbc.c b/drivers/crypto/vmx/aes_cbc.c
index 1a559b7dddb5..c8e7f653e5d3 100644
--- a/drivers/crypto/vmx/aes_cbc.c
+++ b/drivers/crypto/vmx/aes_cbc.c
@@ -81,6 +81,7 @@ static int p8_aes_cbc_setkey(struct crypto_tfm *tfm, const u8 *key,
 
     pagefault_disable();
     enable_kernel_altivec();
+    enable_kernel_vsx();
     ret = aes_p8_set_encrypt_key(key, keylen * 8, &ctx->enc_key);
     ret += aes_p8_set_decrypt_key(key, keylen * 8, &ctx->dec_key);
     pagefault_enable();
@@ -108,6 +109,7 @@ static int p8_aes_cbc_encrypt(struct blkcipher_desc *desc,
     } else {
         pagefault_disable();
         enable_kernel_altivec();
+        enable_kernel_vsx();
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
         ret = blkcipher_walk_virt(desc, &walk);
@@ -143,6 +145,7 @@ static int p8_aes_cbc_decrypt(struct blkcipher_desc *desc,
     } else {
         pagefault_disable();
         enable_kernel_altivec();
+        enable_kernel_vsx();
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
         ret = blkcipher_walk_virt(desc, &walk);
diff --git a/drivers/crypto/vmx/aes_ctr.c b/drivers/crypto/vmx/aes_ctr.c
index 96dbee4bf4a6..266e708d63df 100644
--- a/drivers/crypto/vmx/aes_ctr.c
+++ b/drivers/crypto/vmx/aes_ctr.c
@@ -79,6 +79,7 @@ static int p8_aes_ctr_setkey(struct crypto_tfm *tfm, const u8 *key,
 
     pagefault_disable();
     enable_kernel_altivec();
+    enable_kernel_vsx();
     ret = aes_p8_set_encrypt_key(key, keylen * 8, &ctx->enc_key);
     pagefault_enable();
 
@@ -97,6 +98,7 @@ static void p8_aes_ctr_final(struct p8_aes_ctr_ctx *ctx,
 
     pagefault_disable();
     enable_kernel_altivec();
+    enable_kernel_vsx();
     aes_p8_encrypt(ctrblk, keystream, &ctx->enc_key);
     pagefault_enable();
 
@@ -127,6 +129,7 @@ static int p8_aes_ctr_crypt(struct blkcipher_desc *desc,
         while ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE) {
             pagefault_disable();
             enable_kernel_altivec();
+            enable_kernel_vsx();
             aes_p8_ctr32_encrypt_blocks(walk.src.virt.addr, walk.dst.virt.addr,
                 (nbytes & AES_BLOCK_MASK)/AES_BLOCK_SIZE, &ctx->enc_key, walk.iv);
             pagefault_enable();
diff --git a/drivers/crypto/vmx/ghash.c b/drivers/crypto/vmx/ghash.c
index d0ffe277af5c..917b3f09e724 100644
--- a/drivers/crypto/vmx/ghash.c
+++ b/drivers/crypto/vmx/ghash.c
@@ -116,6 +116,7 @@ static int p8_ghash_setkey(struct crypto_shash *tfm, const u8 *key,
 
     pagefault_disable();
     enable_kernel_altivec();
+    enable_kernel_vsx();
     enable_kernel_fp();
     gcm_init_p8(ctx->htable, (const u64 *) key);
     pagefault_enable();
@@ -142,6 +143,7 @@ static int p8_ghash_update(struct shash_desc *desc,
                     GHASH_DIGEST_SIZE - dctx->bytes);
             pagefault_disable();
             enable_kernel_altivec();
+            enable_kernel_vsx();
             enable_kernel_fp();
             gcm_ghash_p8(dctx->shash, ctx->htable, dctx->buffer,
                     GHASH_DIGEST_SIZE);
@@ -154,6 +156,7 @@ static int p8_ghash_update(struct shash_desc *desc,
         if (len) {
             pagefault_disable();
             enable_kernel_altivec();
+            enable_kernel_vsx();
             enable_kernel_fp();
             gcm_ghash_p8(dctx->shash, ctx->htable, src, len);
             pagefault_enable();
@@ -182,6 +185,7 @@ static int p8_ghash_final(struct shash_desc *desc, u8 *out)
                 dctx->buffer[i] = 0;
             pagefault_disable();
             enable_kernel_altivec();
+            enable_kernel_vsx();
             enable_kernel_fp();
             gcm_ghash_p8(dctx->shash, ctx->htable, dctx->buffer,
                     GHASH_DIGEST_SIZE);
-- 
2.1.4
