From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH v4 10/14] crypto: akcipher: maxsize() - assume key is already set
Date: Thu, 25 May 2017 10:18:12 +0300
Message-ID: <1495696696-22580-11-git-send-email-tudor.ambarus@microchip.com>
References: <1495696696-22580-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <horia.geanta@nxp.com>, <dan.douglass@nxp.com>,
        <giovanni.cabiddu@intel.com>, <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:17718 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933384AbdEYHTD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 May 2017 03:19:03 -0400
In-Reply-To: <1495696696-22580-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As of now, crypto_akcipher_maxsize() can not be reached without
successfully setting the key for the transformation. akcipher
algorithm implementations check if the key was set and then return
the output buffer size required for the given key.

Change the return type to unsigned int and always assume that this
function is called after a successful setkey of the transformation.
akcipher algorithm implementations will remove the check if key is not NULL
and directly return the max size.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 include/crypto/akcipher.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index c37cc59..b5e11de 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -98,7 +98,7 @@ struct akcipher_alg {
 			   unsigned int keylen);
 	int (*set_priv_key)(struct crypto_akcipher *tfm, const void *key,
 			    unsigned int keylen);
-	int (*max_size)(struct crypto_akcipher *tfm);
+	unsigned int (*max_size)(struct crypto_akcipher *tfm);
 	int (*init)(struct crypto_akcipher *tfm);
 	void (*exit)(struct crypto_akcipher *tfm);
 
@@ -257,13 +257,14 @@ static inline void akcipher_request_set_crypt(struct akcipher_request *req,
 /**
  * crypto_akcipher_maxsize() - Get len for output buffer
  *
- * Function returns the dest buffer size required for a given key
+ * Function returns the dest buffer size required for a given key.
+ * Function assumes that the key is already set in the transformation. If this
+ * function is called without a setkey or with a failed setkey, you will end up
+ * in a NULL dereference.
  *
  * @tfm:	AKCIPHER tfm handle allocated with crypto_alloc_akcipher()
- *
- * Return: minimum len for output buffer or error code in key hasn't been set
  */
-static inline int crypto_akcipher_maxsize(struct crypto_akcipher *tfm)
+static inline unsigned int crypto_akcipher_maxsize(struct crypto_akcipher *tfm)
 {
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
 
-- 
2.7.4
