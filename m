From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 3/8] crypto: ecc - remove casts in ecdh_make_pub_key
Date: Fri, 12 May 2017 13:11:41 +0300
Message-ID: <1494583906-15472-4-git-send-email-tudor.ambarus@microchip.com>
References: <1494583906-15472-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:27442 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757671AbdELKL4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 May 2017 06:11:56 -0400
In-Reply-To: <1494583906-15472-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

ecc software implementation works with chunks of u64 data. There were some
unnecessary casts to u8 and then back to u64 for the ecc keys. This patch
removes the unnecessary casts.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/ecc.c  | 10 ++++------
 crypto/ecc.h  |  2 +-
 crypto/ecdh.c |  3 +--
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index 69b4cc4..0d88cec 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -928,12 +928,11 @@ int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
 }
 
 int ecdh_make_pub_key(unsigned int curve_id, unsigned int ndigits,
-		      const u8 *private_key, u8 *public_key)
+		      const u64 *private_key, u64 *public_key)
 {
 	int ret = 0;
 	struct ecc_point *pk;
 	u64 priv[ndigits];
-	unsigned int nbytes;
 	const struct ecc_curve *curve = ecc_get_curve(curve_id);
 
 	if (!private_key || !curve) {
@@ -941,7 +940,7 @@ int ecdh_make_pub_key(unsigned int curve_id, unsigned int ndigits,
 		goto out;
 	}
 
-	ecc_swap_digits((const u64 *)private_key, priv, ndigits);
+	ecc_swap_digits(private_key, priv, ndigits);
 
 	pk = ecc_alloc_point(ndigits);
 	if (!pk) {
@@ -955,9 +954,8 @@ int ecdh_make_pub_key(unsigned int curve_id, unsigned int ndigits,
 		goto err_free_point;
 	}
 
-	nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
-	ecc_swap_digits(pk->x, (u64 *)public_key, ndigits);
-	ecc_swap_digits(pk->y, (u64 *)&public_key[nbytes], ndigits);
+	ecc_swap_digits(pk->x, public_key, ndigits);
+	ecc_swap_digits(pk->y, &public_key[ndigits], ndigits);
 
 err_free_point:
 	ecc_free_point(pk);
diff --git a/crypto/ecc.h b/crypto/ecc.h
index 1ca9bf7..0d1a2a6 100644
--- a/crypto/ecc.h
+++ b/crypto/ecc.h
@@ -55,7 +55,7 @@ int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
  * if an error occurred.
  */
 int ecdh_make_pub_key(const unsigned int curve_id, unsigned int ndigits,
-		      const u8 *private_key, u8 *public_key);
+		      const u64 *private_key, u64 *public_key);
 
 /**
  * crypto_ecdh_shared_secret() - Compute a shared secret
diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index 69c3951..848a141 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -88,8 +88,7 @@ static int ecdh_compute_value(struct kpp_request *req)
 		buf = ctx->shared_secret;
 	} else {
 		ret = ecdh_make_pub_key(ctx->curve_id, ctx->ndigits,
-					(const u8 *)ctx->private_key,
-					(u8 *)ctx->public_key);
+					ctx->private_key, ctx->public_key);
 		buf = ctx->public_key;
 		/* Public part is a point thus it has both coordinates */
 		nbytes *= 2;
-- 
2.7.4
