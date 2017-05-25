From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH v4 06/14] crypto: kpp: maxsize() - assume key is already set
Date: Thu, 25 May 2017 10:18:08 +0300
Message-ID: <1495696696-22580-7-git-send-email-tudor.ambarus@microchip.com>
References: <1495696696-22580-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <horia.geanta@nxp.com>, <dan.douglass@nxp.com>,
        <giovanni.cabiddu@intel.com>, <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:14671 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933384AbdEYHSr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 May 2017 03:18:47 -0400
In-Reply-To: <1495696696-22580-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As of now, crypto_kpp_maxsize() can not be reached without successfully
setting the key for the transformation. kpp algorithm implementations
check if the key was set and then return the output buffer size
required for the given key.

Change the return type to unsigned int and always assume that this
function is called after a successful setkey of the transformation.
kpp algorithm implementations will remove the check if key is not NULL
and directly return the max size.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 include/crypto/kpp.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/crypto/kpp.h b/include/crypto/kpp.h
index c190825..2133d17 100644
--- a/include/crypto/kpp.h
+++ b/include/crypto/kpp.h
@@ -79,7 +79,7 @@ struct kpp_alg {
 	int (*generate_public_key)(struct kpp_request *req);
 	int (*compute_shared_secret)(struct kpp_request *req);
 
-	int (*max_size)(struct crypto_kpp *tfm);
+	unsigned int (*max_size)(struct crypto_kpp *tfm);
 
 	int (*init)(struct crypto_kpp *tfm);
 	void (*exit)(struct crypto_kpp *tfm);
@@ -323,13 +323,14 @@ static inline int crypto_kpp_compute_shared_secret(struct kpp_request *req)
 /**
  * crypto_kpp_maxsize() - Get len for output buffer
  *
- * Function returns the output buffer size required
+ * Function returns the output buffer size required for a given key.
+ * Function assumes that the key is already set in the transformation. If this
+ * function is called without a setkey or with a failed setkey, you will end up
+ * in a NULL dereference.
  *
  * @tfm:	KPP tfm handle allocated with crypto_alloc_kpp()
- *
- * Return: minimum len for output buffer or error code if key hasn't been set
  */
-static inline int crypto_kpp_maxsize(struct crypto_kpp *tfm)
+static inline unsigned int crypto_kpp_maxsize(struct crypto_kpp *tfm)
 {
 	struct kpp_alg *alg = crypto_kpp_alg(tfm);
 
-- 
2.7.4
