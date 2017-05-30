From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH v5 04/14] crypto: ecc - rename ecdh_make_pub_key()
Date: Tue, 30 May 2017 15:37:56 +0300
Message-ID: <1496147876-3616-1-git-send-email-tudor.ambarus@microchip.com>
References: <260d4e89-76a5-6566-829a-4e95529dd556@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <horia.geanta@nxp.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:1949 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750965AbdE3Mi3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 May 2017 08:38:29 -0400
In-Reply-To: <260d4e89-76a5-6566-829a-4e95529dd556@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Rename ecdh_make_pub_key() to ecc_make_pub_key().
ecdh_make_pub_key() is not dh specific and the reference
to dh is wrong.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
v5 updates the description of the function by replacing
"ecdh_make_pub_key()" with "ecc_make_pub_key()". I also
updated the commit message.

Herbert, do I need to resend a new series for this change or
having the updated patch like this is ok for you?

 crypto/ecc.c  | 4 ++--
 crypto/ecc.h  | 6 +++---
 crypto/ecdh.c | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index e3a2b8f..6c33c43 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -927,8 +927,8 @@ int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
 	return 0;
 }
 
-int ecdh_make_pub_key(unsigned int curve_id, unsigned int ndigits,
-		      const u64 *private_key, u64 *public_key)
+int ecc_make_pub_key(unsigned int curve_id, unsigned int ndigits,
+		     const u64 *private_key, u64 *public_key)
 {
 	int ret = 0;
 	struct ecc_point *pk;
diff --git a/crypto/ecc.h b/crypto/ecc.h
index af2ffdb..e13fe88 100644
--- a/crypto/ecc.h
+++ b/crypto/ecc.h
@@ -44,7 +44,7 @@ int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
 		     const u64 *private_key, unsigned int private_key_len);
 
 /**
- * ecdh_make_pub_key() - Compute an ECC public key
+ * ecc_make_pub_key() - Compute an ECC public key
  *
  * @curve_id:		id representing the curve to use
  * @ndigits:		curve's number of digits
@@ -54,8 +54,8 @@ int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
  * Returns 0 if the public key was generated successfully, a negative value
  * if an error occurred.
  */
-int ecdh_make_pub_key(const unsigned int curve_id, unsigned int ndigits,
-		      const u64 *private_key, u64 *public_key);
+int ecc_make_pub_key(const unsigned int curve_id, unsigned int ndigits,
+		     const u64 *private_key, u64 *public_key);
 
 /**
  * crypto_ecdh_shared_secret() - Compute a shared secret
diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index c1f0163..ed1464a 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -87,8 +87,8 @@ static int ecdh_compute_value(struct kpp_request *req)
 
 		buf = ctx->shared_secret;
 	} else {
-		ret = ecdh_make_pub_key(ctx->curve_id, ctx->ndigits,
-					ctx->private_key, ctx->public_key);
+		ret = ecc_make_pub_key(ctx->curve_id, ctx->ndigits,
+				       ctx->private_key, ctx->public_key);
 		buf = ctx->public_key;
 		/* Public part is a point thus it has both coordinates */
 		nbytes *= 2;
-- 
2.7.4
