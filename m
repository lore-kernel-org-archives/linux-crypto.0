From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH v4 12/14] crypto: caampkc - comply with crypto_akcipher_maxsize()
Date: Thu, 25 May 2017 10:18:14 +0300
Message-ID: <1495696696-22580-13-git-send-email-tudor.ambarus@microchip.com>
References: <1495696696-22580-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <horia.geanta@nxp.com>, <dan.douglass@nxp.com>,
        <giovanni.cabiddu@intel.com>, <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:3988 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933384AbdEYHTK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 May 2017 03:19:10 -0400
In-Reply-To: <1495696696-22580-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto_akcipher_maxsize() asks for the output buffer size without
caring for errors. It allways assume that will be called after
a valid setkey. Comply with it and return what he wants.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/caam/caampkc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 57f399c..9c508ba 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -911,12 +911,11 @@ static int caam_rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
 	return -ENOMEM;
 }
 
-static int caam_rsa_max_size(struct crypto_akcipher *tfm)
+static unsigned int caam_rsa_max_size(struct crypto_akcipher *tfm)
 {
 	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
-	struct caam_rsa_key *key = &ctx->key;
 
-	return (key->n) ? key->n_sz : -EINVAL;
+	return ctx->key.n_sz;
 }
 
 /* Per session pkc's driver context creation function */
-- 
2.7.4
