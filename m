From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH v2 06/11] crypto: ecc - don't be selfish on pubkeys
Date: Wed, 17 May 2017 18:00:33 +0300
Message-ID: <1495033238-26016-7-git-send-email-tudor.ambarus@microchip.com>
References: <1495033238-26016-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <keyrings@vger.kernel.org>,
        <Nicolas.Ferre@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:12463 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753158AbdEQPBK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 May 2017 11:01:10 -0400
In-Reply-To: <1495033238-26016-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Rename ecdh_make_pub_key() to ecc_make_pub_key().
This function might as well be used by ecdsa.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/ecc.c  | 4 ++--
 crypto/ecc.h  | 4 ++--
 crypto/ecdh.c | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

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
index af2ffdb..673c834 100644
--- a/crypto/ecc.h
+++ b/crypto/ecc.h
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
index 830dfb6..8b6450d 100644
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
