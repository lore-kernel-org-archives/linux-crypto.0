From: Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: [PATCH 2/3] crypto: vmx - Fix memory corruption caused by p8_ghash
Date: Wed, 28 Sep 2016 13:42:10 -0300
Message-ID: <1475080931-7926-3-git-send-email-marcelo.cerri@canonical.com>
References: <1475080931-7926-1-git-send-email-marcelo.cerri@canonical.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
        "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        George Wilson <gcwilson@us.ibm.com>,
        Marcelo Cerri <marcelo.cerri@canonical.com>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:34585 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933883AbcI1Qmy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Sep 2016 12:42:54 -0400
Received: by mail-qk0-f171.google.com with SMTP id j129so44810908qkd.1
        for <linux-crypto@vger.kernel.org>; Wed, 28 Sep 2016 09:42:53 -0700 (PDT)
In-Reply-To: <1475080931-7926-1-git-send-email-marcelo.cerri@canonical.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch changes the p8_ghash driver to use ghash-generic as a fixed
fallback implementation. This allows the correct value of descsize to be
defined directly in its shash_alg structure and avoids problems with
incorrect buffer sizes when its state is exported or imported.

Reported-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Marcelo Cerri <marcelo.cerri@canonical.com>
---
 drivers/crypto/vmx/ghash.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/vmx/ghash.c b/drivers/crypto/vmx/ghash.c
index 6c999cb0..27a94a1 100644
--- a/drivers/crypto/vmx/ghash.c
+++ b/drivers/crypto/vmx/ghash.c
@@ -26,16 +26,13 @@
 #include <linux/hardirq.h>
 #include <asm/switch_to.h>
 #include <crypto/aes.h>
+#include <crypto/ghash.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/internal/hash.h>
 #include <crypto/b128ops.h>
 
 #define IN_INTERRUPT in_interrupt()
 
-#define GHASH_BLOCK_SIZE (16)
-#define GHASH_DIGEST_SIZE (16)
-#define GHASH_KEY_LEN (16)
-
 void gcm_init_p8(u128 htable[16], const u64 Xi[2]);
 void gcm_gmult_p8(u64 Xi[2], const u128 htable[16]);
 void gcm_ghash_p8(u64 Xi[2], const u128 htable[16],
@@ -55,16 +52,11 @@ struct p8_ghash_desc_ctx {
 
 static int p8_ghash_init_tfm(struct crypto_tfm *tfm)
 {
-	const char *alg;
+	const char *alg = "ghash-generic";
 	struct crypto_shash *fallback;
 	struct crypto_shash *shash_tfm = __crypto_shash_cast(tfm);
 	struct p8_ghash_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	if (!(alg = crypto_tfm_alg_name(tfm))) {
-		printk(KERN_ERR "Failed to get algorithm name.\n");
-		return -ENOENT;
-	}
-
 	fallback = crypto_alloc_shash(alg, 0, CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(fallback)) {
 		printk(KERN_ERR
@@ -78,10 +70,18 @@ static int p8_ghash_init_tfm(struct crypto_tfm *tfm)
 	crypto_shash_set_flags(fallback,
 			       crypto_shash_get_flags((struct crypto_shash
 						       *) tfm));
-	ctx->fallback = fallback;
 
-	shash_tfm->descsize = sizeof(struct p8_ghash_desc_ctx)
-	    + crypto_shash_descsize(fallback);
+	/* Check if the descsize defined in the algorithm is still enough. */
+	if (shash_tfm->descsize < sizeof(struct p8_ghash_desc_ctx)
+	    + crypto_shash_descsize(fallback)) {
+		printk(KERN_ERR
+		       "Desc size of the fallback implementation (%s) does not match the expected value: %lu vs %u\n",
+		       alg,
+		       shash_tfm->descsize - sizeof(struct p8_ghash_desc_ctx),
+		       crypto_shash_descsize(fallback));
+		return -EINVAL;
+	}
+	ctx->fallback = fallback;
 
 	return 0;
 }
@@ -113,7 +113,7 @@ static int p8_ghash_setkey(struct crypto_shash *tfm, const u8 *key,
 {
 	struct p8_ghash_ctx *ctx = crypto_tfm_ctx(crypto_shash_tfm(tfm));
 
-	if (keylen != GHASH_KEY_LEN)
+	if (keylen != GHASH_BLOCK_SIZE)
 		return -EINVAL;
 
 	preempt_disable();
@@ -211,7 +211,8 @@ struct shash_alg p8_ghash_alg = {
 	.update = p8_ghash_update,
 	.final = p8_ghash_final,
 	.setkey = p8_ghash_setkey,
-	.descsize = sizeof(struct p8_ghash_desc_ctx),
+	.descsize = sizeof(struct p8_ghash_desc_ctx)
+		+ sizeof(struct ghash_desc_ctx),
 	.base = {
 		 .cra_name = "ghash",
 		 .cra_driver_name = "p8_ghash",
-- 
2.7.4
