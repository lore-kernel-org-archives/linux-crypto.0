From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 4/4] crypto: ecc - remove casts in ecc_is_key_valid
Date: Wed, 10 May 2017 11:40:49 +0300
Message-ID: <1494405649-30322-5-git-send-email-tudor.ambarus@microchip.com>
References: <1494405649-30322-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:41988 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752100AbdEJIuZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 May 2017 04:50:25 -0400
In-Reply-To: <1494405649-30322-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

ecc software implementation works with chunks of u64 data. There were some
unnecessary casts to u8 and then back to u64 for the ecc keys. This patch
removes the unncessary casts.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/ecc.c  | 6 +++---
 crypto/ecc.h  | 2 +-
 crypto/ecdh.c | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index e6f2725..e3a2b8f 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -904,7 +904,7 @@ static inline void ecc_swap_digits(const u64 *in, u64 *out,
 }
 
 int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
-		     const u8 *private_key, unsigned int private_key_len)
+		     const u64 *private_key, unsigned int private_key_len)
 {
 	int nbytes;
 	const struct ecc_curve *curve = ecc_get_curve(curve_id);
@@ -917,11 +917,11 @@ int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
 	if (private_key_len != nbytes)
 		return -EINVAL;
 
-	if (vli_is_zero((const u64 *)&private_key[0], ndigits))
+	if (vli_is_zero(private_key, ndigits))
 		return -EINVAL;
 
 	/* Make sure the private key is in the range [1, n-1]. */
-	if (vli_cmp(curve->n, (const u64 *)&private_key[0], ndigits) != 1)
+	if (vli_cmp(curve->n, private_key, ndigits) != 1)
 		return -EINVAL;
 
 	return 0;
diff --git a/crypto/ecc.h b/crypto/ecc.h
index 28b623bb..37bf7d6 100644
--- a/crypto/ecc.h
+++ b/crypto/ecc.h
@@ -41,7 +41,7 @@
  * Returns 0 if the key is acceptable, a negative value otherwise
  */
 int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
-		     const u8 *private_key, unsigned int private_key_len);
+		     const u64 *private_key, unsigned int private_key_len);
 
 /**
  * ecdh_make_pub_key() - Compute an ECC public key
diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index 4b219a8..f1cc9f4 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -56,7 +56,7 @@ static int ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	ctx->ndigits = ndigits;
 
 	if (ecc_is_key_valid(ctx->curve_id, ctx->ndigits,
-			     (const u8 *)params.key, params.key_size) < 0)
+			     (const u64 *)params.key, params.key_size) < 0)
 		return -EINVAL;
 
 	memcpy(ctx->private_key, params.key, params.key_size);
-- 
2.7.4
