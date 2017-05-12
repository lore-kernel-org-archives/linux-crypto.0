From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 4/8] crypto: ecc - remove casts in crypto_ecdh_shared_secret
Date: Fri, 12 May 2017 13:11:42 +0300
Message-ID: <1494583906-15472-5-git-send-email-tudor.ambarus@microchip.com>
References: <1494583906-15472-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:27442 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757671AbdELKL6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 May 2017 06:11:58 -0400
In-Reply-To: <1494583906-15472-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

ecc software implementation works with chunks of u64 data. There were some
unnecessary casts to u8 and then back to u64 for the ecc keys. This patch
removes the unnecessary casts.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/ecc.c  | 12 ++++++------
 crypto/ecc.h  |  4 ++--
 crypto/ecdh.c |  6 +++---
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index 0d88cec..e6f2725 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -964,8 +964,8 @@ int ecdh_make_pub_key(unsigned int curve_id, unsigned int ndigits,
 }
 
 int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
-			      const u8 *private_key, const u8 *public_key,
-			      u8 *secret)
+			      const u64 *private_key, const u64 *public_key,
+			      u64 *secret)
 {
 	int ret = 0;
 	struct ecc_point *product, *pk;
@@ -995,13 +995,13 @@ int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
 		goto err_alloc_product;
 	}
 
-	ecc_swap_digits((const u64 *)public_key, pk->x, ndigits);
-	ecc_swap_digits((const u64 *)&public_key[nbytes], pk->y, ndigits);
-	ecc_swap_digits((const u64 *)private_key, priv, ndigits);
+	ecc_swap_digits(public_key, pk->x, ndigits);
+	ecc_swap_digits(&public_key[ndigits], pk->y, ndigits);
+	ecc_swap_digits(private_key, priv, ndigits);
 
 	ecc_point_mult(product, pk, priv, rand_z, curve->p, ndigits);
 
-	ecc_swap_digits(product->x, (u64 *)secret, ndigits);
+	ecc_swap_digits(product->x, secret, ndigits);
 
 	if (ecc_point_is_zero(product))
 		ret = -EFAULT;
diff --git a/crypto/ecc.h b/crypto/ecc.h
index 0d1a2a6..f3351c4 100644
--- a/crypto/ecc.h
+++ b/crypto/ecc.h
@@ -73,6 +73,6 @@ int ecdh_make_pub_key(const unsigned int curve_id, unsigned int ndigits,
  * if an error occurred.
  */
 int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
-			      const u8 *private_key, const u8 *public_key,
-			      u8 *secret);
+			      const u64 *private_key, const u64 *public_key,
+			      u64 *secret);
 #endif
diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index 848a141..f69ec30 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -81,9 +81,9 @@ static int ecdh_compute_value(struct kpp_request *req)
 			return -EINVAL;
 
 		ret = crypto_ecdh_shared_secret(ctx->curve_id, ctx->ndigits,
-						(const u8 *)ctx->private_key,
-						(const u8 *)ctx->public_key,
-						(u8 *)ctx->shared_secret);
+						ctx->private_key,
+						ctx->public_key,
+						ctx->shared_secret);
 
 		buf = ctx->shared_secret;
 	} else {
-- 
2.7.4
