From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 03/13] crypto: omap-des: add check for weak keys
Date: Wed, 24 May 2017 10:35:24 +0300
Message-ID: <1495611334-15039-4-git-send-email-t-kristo@ti.com>
References: <1495611334-15039-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-omap@vger.kernel.org>
To: <herbert@gondor.apana.org.au>, <lokeshvutla@ti.com>,
        <davem@davemloft.net>, <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lelnx194.ext.ti.com ([198.47.27.80]:35394 "EHLO
        lelnx194.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964801AbdEXHgC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 May 2017 03:36:02 -0400
In-Reply-To: <1495611334-15039-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

OMAP DES crypto accelerator itself is unable to detect weak keys, so
add a specific call to the generic des driver to check the key strength
if requested.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/omap-des.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index a6f6553..0d68f77 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -699,16 +699,28 @@ static int omap_des_crypt(struct ablkcipher_request *req, unsigned long mode)
 
 /* ********************** ALG API ************************************ */
 
-static int omap_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+static int omap_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 			   unsigned int keylen)
 {
-	struct omap_des_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	struct omap_des_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
 
 	if (keylen != DES_KEY_SIZE && keylen != (3*DES_KEY_SIZE))
 		return -EINVAL;
 
 	pr_debug("enter, keylen: %d\n", keylen);
 
+	/* Do we need to test against weak key? */
+	if (tfm->crt_flags & CRYPTO_TFM_REQ_WEAK_KEY) {
+		u32 tmp[DES_EXPKEY_WORDS];
+		int ret = des_ekey(tmp, key);
+
+		if (!ret) {
+			tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
+			return -EINVAL;
+		}
+	}
+
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
 
-- 
1.9.1
