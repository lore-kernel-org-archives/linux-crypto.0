From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH v4 14/14] crypto: pkcs1pad - comply with crypto_akcipher_maxsize()
Date: Thu, 25 May 2017 10:18:16 +0300
Message-ID: <1495696696-22580-15-git-send-email-tudor.ambarus@microchip.com>
References: <1495696696-22580-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <horia.geanta@nxp.com>, <dan.douglass@nxp.com>,
        <giovanni.cabiddu@intel.com>, <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:29475 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964949AbdEYHTT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 May 2017 03:19:19 -0400
In-Reply-To: <1495696696-22580-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto_akcipher_maxsize() asks for the output buffer size without
caring for errors. It allways assume that will be called after
a valid setkey. Comply with it and return what he wants.

crypto_akcipher_maxsize() now returns an unsigned int.
Remove the unnecessary check.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/rsa-pkcs1pad.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 8baab43..044bcfa 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -120,9 +120,6 @@ static int pkcs1pad_set_pub_key(struct crypto_akcipher *tfm, const void *key,
 
 	/* Find out new modulus size from rsa implementation */
 	err = crypto_akcipher_maxsize(ctx->child);
-	if (err < 0)
-		return err;
-
 	if (err > PAGE_SIZE)
 		return -ENOTSUPP;
 
@@ -144,9 +141,6 @@ static int pkcs1pad_set_priv_key(struct crypto_akcipher *tfm, const void *key,
 
 	/* Find out new modulus size from rsa implementation */
 	err = crypto_akcipher_maxsize(ctx->child);
-	if (err < 0)
-		return err;
-
 	if (err > PAGE_SIZE)
 		return -ENOTSUPP;
 
@@ -154,7 +148,7 @@ static int pkcs1pad_set_priv_key(struct crypto_akcipher *tfm, const void *key,
 	return 0;
 }
 
-static int pkcs1pad_get_max_size(struct crypto_akcipher *tfm)
+static unsigned int pkcs1pad_get_max_size(struct crypto_akcipher *tfm)
 {
 	struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
 
@@ -164,7 +158,7 @@ static int pkcs1pad_get_max_size(struct crypto_akcipher *tfm)
 	 * decrypt/verify.
 	 */
 
-	return ctx->key_size ?: -EINVAL;
+	return ctx->key_size;
 }
 
 static void pkcs1pad_sg_set_buf(struct scatterlist *sg, void *buf, size_t len,
-- 
2.7.4
