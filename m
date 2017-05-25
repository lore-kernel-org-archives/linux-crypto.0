From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH v4 03/14] crypto: ecc - remove unnecessary casts
Date: Thu, 25 May 2017 10:18:05 +0300
Message-ID: <1495696696-22580-4-git-send-email-tudor.ambarus@microchip.com>
References: <1495696696-22580-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <horia.geanta@nxp.com>, <dan.douglass@nxp.com>,
        <giovanni.cabiddu@intel.com>, <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:28624 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932943AbdEYHSf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 May 2017 03:18:35 -0400
In-Reply-To: <1495696696-22580-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

ecc software implementation works with chunks of u64 data. There were some
unnecessary casts to u8 and then back to u64 for the ecc keys. This patch
removes the unnecessary casts.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/ecc.c  | 28 +++++++++++++---------------
 crypto/ecc.h  |  8 ++++----
 crypto/ecdh.c | 11 +++++------
 3 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index 69b4cc4..e3a2b8f 100644
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
@@ -917,23 +917,22 @@ int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
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
@@ -966,8 +964,8 @@ int ecdh_make_pub_key(unsigned int curve_id, unsigned int ndigits,
 }
 
 int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
-			      const u8 *private_key, const u8 *public_key,
-			      u8 *secret)
+			      const u64 *private_key, const u64 *public_key,
+			      u64 *secret)
 {
 	int ret = 0;
 	struct ecc_point *product, *pk;
@@ -997,13 +995,13 @@ int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
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
index 1ca9bf7..af2ffdb 100644
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
@@ -55,7 +55,7 @@ int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
  * if an error occurred.
  */
 int ecdh_make_pub_key(const unsigned int curve_id, unsigned int ndigits,
-		      const u8 *private_key, u8 *public_key);
+		      const u64 *private_key, u64 *public_key);
 
 /**
  * crypto_ecdh_shared_secret() - Compute a shared secret
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
index 69c3951..c1f0163 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -56,7 +56,7 @@ static int ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	ctx->ndigits = ndigits;
 
 	if (ecc_is_key_valid(ctx->curve_id, ctx->ndigits,
-			     (const u8 *)params.key, params.key_size) < 0)
+			     (const u64 *)params.key, params.key_size) < 0)
 		return -EINVAL;
 
 	memcpy(ctx->private_key, params.key, params.key_size);
@@ -81,15 +81,14 @@ static int ecdh_compute_value(struct kpp_request *req)
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
 		ret = ecdh_make_pub_key(ctx->curve_id, ctx->ndigits,
-					(const u8 *)ctx->private_key,
-					(u8 *)ctx->public_key);
+					ctx->private_key, ctx->public_key);
 		buf = ctx->public_key;
 		/* Public part is a point thus it has both coordinates */
 		nbytes *= 2;
-- 
2.7.4
