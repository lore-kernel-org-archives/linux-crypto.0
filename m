From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH 09/10] crypto/des_generic: Eliminate some flags pointers.
Date: Sun, 08 Feb 2009 06:54:32 -0500
Message-ID: <20090208115432.6193.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux@horizon.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from science.horizon.com ([192.35.100.1]:17690 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752752AbZBHMBO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 8 Feb 2009 07:01:14 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

There's no need to cache a value that's used once in the typical case.
---
 crypto/des_generic.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index baf51cf..a4f3165 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -690,15 +690,14 @@ static int des_setkey(struct crypto_tfm *tfm, const u8 *key,
 		      unsigned int keylen)
 {
 	struct des_ctx *dctx = crypto_tfm_ctx(tfm);
-	u32 *flags = &tfm->crt_flags;
 	u32 tmp[DES_EXPKEY_WORDS];
 	int ret;
 
 	/* Expand to tmp */
 	ret = des_ekey(tmp, key);
 
-	if (unlikely(ret == 0) && (*flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
-		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
+	if (unlikely(ret == 0) && (tfm->crt_flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
 		return -EINVAL;
 	}
 
@@ -773,13 +772,12 @@ static int des3_ede_setkey(struct crypto_tfm *tfm, const u8 *key,
 	const u32 *K = (const u32 *)key;
 	struct des3_ede_ctx *dctx = crypto_tfm_ctx(tfm);
 	u32 *expkey = dctx->expkey;
-	u32 *flags = &tfm->crt_flags;
 
 	if (unlikely(!(((K[0] ^ K[2]) | (K[1] ^ K[3])) & 0xfefefefe) ||
 		     !(((K[2] ^ K[4]) | (K[3] ^ K[5])) & 0xfefefefe)) &&
-		     (*flags & CRYPTO_TFM_REQ_WEAK_KEY))
+		     (tfm->crt_flags & CRYPTO_TFM_REQ_WEAK_KEY))
 	{
-		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
+		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
 		return -EINVAL;
 	}
 
-- 
1.6.0.6

