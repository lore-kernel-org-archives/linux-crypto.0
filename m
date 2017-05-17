From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH v2 02/11] crypto: ecc - remove unused function arguments
Date: Wed, 17 May 2017 18:00:29 +0300
Message-ID: <1495033238-26016-3-git-send-email-tudor.ambarus@microchip.com>
References: <1495033238-26016-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <keyrings@vger.kernel.org>,
        <Nicolas.Ferre@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:61686 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754508AbdEQPAy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 May 2017 11:00:54 -0400
In-Reply-To: <1495033238-26016-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/ecc.c  |  8 +++-----
 crypto/ecc.h  | 13 +++----------
 crypto/ecdh.c | 11 +++++------
 3 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index 414c78a..69b4cc4 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -928,8 +928,7 @@ int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
 }
 
 int ecdh_make_pub_key(unsigned int curve_id, unsigned int ndigits,
-		      const u8 *private_key, unsigned int private_key_len,
-		      u8 *public_key, unsigned int public_key_len)
+		      const u8 *private_key, u8 *public_key)
 {
 	int ret = 0;
 	struct ecc_point *pk;
@@ -967,9 +966,8 @@ int ecdh_make_pub_key(unsigned int curve_id, unsigned int ndigits,
 }
 
 int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
-		       const u8 *private_key, unsigned int private_key_len,
-		       const u8 *public_key, unsigned int public_key_len,
-		       u8 *secret, unsigned int secret_len)
+			      const u8 *private_key, const u8 *public_key,
+			      u8 *secret)
 {
 	int ret = 0;
 	struct ecc_point *product, *pk;
diff --git a/crypto/ecc.h b/crypto/ecc.h
index 37f4385..1ca9bf7 100644
--- a/crypto/ecc.h
+++ b/crypto/ecc.h
@@ -49,16 +49,13 @@ int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
  * @curve_id:		id representing the curve to use
  * @ndigits:		curve's number of digits
  * @private_key:	pregenerated private key for the given curve
- * @private_key_len:	length of private_key
  * @public_key:		buffer for storing the generated public key
- * @public_key_len:	length of the public_key buffer
  *
  * Returns 0 if the public key was generated successfully, a negative value
  * if an error occurred.
  */
 int ecdh_make_pub_key(const unsigned int curve_id, unsigned int ndigits,
-		      const u8 *private_key, unsigned int private_key_len,
-		      u8 *public_key, unsigned int public_key_len);
+		      const u8 *private_key, u8 *public_key);
 
 /**
  * crypto_ecdh_shared_secret() - Compute a shared secret
@@ -66,11 +63,8 @@ int ecdh_make_pub_key(const unsigned int curve_id, unsigned int ndigits,
  * @curve_id:		id representing the curve to use
  * @ndigits:		curve's number of digits
  * @private_key:	private key of part A
- * @private_key_len:	length of private_key
  * @public_key:		public key of counterpart B
- * @public_key_len:	length of public_key
  * @secret:		buffer for storing the calculated shared secret
- * @secret_len:		length of the secret buffer
  *
  * Note: It is recommended that you hash the result of crypto_ecdh_shared_secret
  * before using it for symmetric encryption or HMAC.
@@ -79,7 +73,6 @@ int ecdh_make_pub_key(const unsigned int curve_id, unsigned int ndigits,
  * if an error occurred.
  */
 int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
-		       const u8 *private_key, unsigned int private_key_len,
-		       const u8 *public_key, unsigned int public_key_len,
-		       u8 *secret, unsigned int secret_len);
+			      const u8 *private_key, const u8 *public_key,
+			      u8 *secret);
 #endif
diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index 3623307..69c3951 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -81,16 +81,15 @@ static int ecdh_compute_value(struct kpp_request *req)
 			return -EINVAL;
 
 		ret = crypto_ecdh_shared_secret(ctx->curve_id, ctx->ndigits,
-					 (const u8 *)ctx->private_key, nbytes,
-					 (const u8 *)ctx->public_key, 2 * nbytes,
-					 (u8 *)ctx->shared_secret, nbytes);
+						(const u8 *)ctx->private_key,
+						(const u8 *)ctx->public_key,
+						(u8 *)ctx->shared_secret);
 
 		buf = ctx->shared_secret;
 	} else {
 		ret = ecdh_make_pub_key(ctx->curve_id, ctx->ndigits,
-					(const u8 *)ctx->private_key, nbytes,
-					(u8 *)ctx->public_key,
-					sizeof(ctx->public_key));
+					(const u8 *)ctx->private_key,
+					(u8 *)ctx->public_key);
 		buf = ctx->public_key;
 		/* Public part is a point thus it has both coordinates */
 		nbytes *= 2;
-- 
2.7.4
