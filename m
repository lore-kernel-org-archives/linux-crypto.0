From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [v3 RFC PATCH 2/2] crypto: ecc: use caller's GFP flags
Date: Wed, 28 Jun 2017 17:08:36 +0300
Message-ID: <1498658916-11044-3-git-send-email-tudor.ambarus@microchip.com>
References: <1498658916-11044-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <nicolas.ferre@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:45867 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751659AbdF1OIq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Jun 2017 10:08:46 -0400
In-Reply-To: <1498658916-11044-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Using GFP_KERNEL when allocating data and implicitly
assuming that we can sleep was wrong because the caller
could be in atomic context. Let the caller decide whether
sleeping is possible or not.

The caller (ecdh) was updated in the same patch in order
to not affect bissectability.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/ecc.c  | 22 +++++++++++-----------
 crypto/ecc.h  |  6 ++++--
 crypto/ecdh.c |  4 ++--
 3 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index 633a9bc..9501a56 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -52,14 +52,14 @@ static inline const struct ecc_curve *ecc_get_curve(unsigned int curve_id)
 	}
 }
 
-static u64 *ecc_alloc_digits_space(unsigned int ndigits)
+static u64 *ecc_alloc_digits_space(unsigned int ndigits, gfp_t gfp)
 {
 	size_t len = ndigits * sizeof(u64);
 
 	if (!len)
 		return NULL;
 
-	return kmalloc(len, GFP_KERNEL);
+	return kmalloc(len, gfp);
 }
 
 static void ecc_free_digits_space(u64 *space)
@@ -67,18 +67,18 @@ static void ecc_free_digits_space(u64 *space)
 	kzfree(space);
 }
 
-static struct ecc_point *ecc_alloc_point(unsigned int ndigits)
+static struct ecc_point *ecc_alloc_point(unsigned int ndigits, gfp_t gfp)
 {
-	struct ecc_point *p = kmalloc(sizeof(*p), GFP_KERNEL);
+	struct ecc_point *p = kmalloc(sizeof(*p), gfp);
 
 	if (!p)
 		return NULL;
 
-	p->x = ecc_alloc_digits_space(ndigits);
+	p->x = ecc_alloc_digits_space(ndigits, gfp);
 	if (!p->x)
 		goto err_alloc_x;
 
-	p->y = ecc_alloc_digits_space(ndigits);
+	p->y = ecc_alloc_digits_space(ndigits, gfp);
 	if (!p->y)
 		goto err_alloc_y;
 
@@ -984,7 +984,7 @@ int ecc_gen_privkey(unsigned int curve_id, unsigned int ndigits, u64 *privkey)
 }
 
 int ecc_make_pub_key(unsigned int curve_id, unsigned int ndigits,
-		     const u64 *private_key, u64 *public_key)
+		     const u64 *private_key, u64 *public_key, gfp_t gfp)
 {
 	int ret = 0;
 	struct ecc_point *pk;
@@ -998,7 +998,7 @@ int ecc_make_pub_key(unsigned int curve_id, unsigned int ndigits,
 
 	ecc_swap_digits(private_key, priv, ndigits);
 
-	pk = ecc_alloc_point(ndigits);
+	pk = ecc_alloc_point(ndigits, gfp);
 	if (!pk) {
 		ret = -ENOMEM;
 		goto out;
@@ -1021,7 +1021,7 @@ int ecc_make_pub_key(unsigned int curve_id, unsigned int ndigits,
 
 int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
 			      const u64 *private_key, const u64 *public_key,
-			      u64 *secret)
+			      u64 *secret, gfp_t gfp)
 {
 	int ret = 0;
 	struct ecc_point *product, *pk;
@@ -1039,13 +1039,13 @@ int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
 
 	get_random_bytes(rand_z, nbytes);
 
-	pk = ecc_alloc_point(ndigits);
+	pk = ecc_alloc_point(ndigits, gfp);
 	if (!pk) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	product = ecc_alloc_point(ndigits);
+	product = ecc_alloc_point(ndigits, gfp);
 	if (!product) {
 		ret = -ENOMEM;
 		goto err_alloc_product;
diff --git a/crypto/ecc.h b/crypto/ecc.h
index b35855b..f189ceb 100644
--- a/crypto/ecc.h
+++ b/crypto/ecc.h
@@ -62,12 +62,13 @@ int ecc_gen_privkey(unsigned int curve_id, unsigned int ndigits, u64 *privkey);
  * @ndigits:		curve's number of digits
  * @private_key:	pregenerated private key for the given curve
  * @public_key:		buffer for storing the generated public key
+ * @gfp:		GFP flags
  *
  * Returns 0 if the public key was generated successfully, a negative value
  * if an error occurred.
  */
 int ecc_make_pub_key(const unsigned int curve_id, unsigned int ndigits,
-		     const u64 *private_key, u64 *public_key);
+		     const u64 *private_key, u64 *public_key, gfp_t gfp);
 
 /**
  * crypto_ecdh_shared_secret() - Compute a shared secret
@@ -77,6 +78,7 @@ int ecc_make_pub_key(const unsigned int curve_id, unsigned int ndigits,
  * @private_key:	private key of part A
  * @public_key:		public key of counterpart B
  * @secret:		buffer for storing the calculated shared secret
+ * @gfp:		GFP flags
  *
  * Note: It is recommended that you hash the result of crypto_ecdh_shared_secret
  * before using it for symmetric encryption or HMAC.
@@ -86,5 +88,5 @@ int ecc_make_pub_key(const unsigned int curve_id, unsigned int ndigits,
  */
 int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
 			      const u64 *private_key, const u64 *public_key,
-			      u64 *secret);
+			      u64 *secret, gfp_t gfp);
 #endif
diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index e258ab3..6a8e2f5 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -119,12 +119,12 @@ static int ecdh_compute_value(struct kpp_request *req)
 
 		ret = crypto_ecdh_shared_secret(ctx->curve_id, ctx->ndigits,
 						ctx->private_key, public_key,
-						shared_secret);
+						shared_secret, gfp);
 
 		buf = shared_secret;
 	} else {
 		ret = ecc_make_pub_key(ctx->curve_id, ctx->ndigits,
-				       ctx->private_key, public_key);
+				       ctx->private_key, public_key, gfp);
 		buf = public_key;
 		nbytes = public_key_sz;
 	}
-- 
2.7.4
