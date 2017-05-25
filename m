From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH v4 13/14] crypto: qat - comply with crypto_akcipher_maxsize()
Date: Thu, 25 May 2017 10:18:15 +0300
Message-ID: <1495696696-22580-14-git-send-email-tudor.ambarus@microchip.com>
References: <1495696696-22580-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <horia.geanta@nxp.com>, <dan.douglass@nxp.com>,
        <giovanni.cabiddu@intel.com>, <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:32482 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964949AbdEYHTP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 May 2017 03:19:15 -0400
In-Reply-To: <1495696696-22580-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto_akcipher_maxsize() asks for the output buffer size without
caring for errors. It allways assume that will be called after
a valid setkey. Comply with it and return what he wants.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 1d882a7..6f5dd68 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -1256,11 +1256,11 @@ static int qat_rsa_setprivkey(struct crypto_akcipher *tfm, const void *key,
 	return qat_rsa_setkey(tfm, key, keylen, true);
 }
 
-static int qat_rsa_max_size(struct crypto_akcipher *tfm)
+static unsigned int qat_rsa_max_size(struct crypto_akcipher *tfm)
 {
 	struct qat_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
 
-	return (ctx->n) ? ctx->key_sz : -EINVAL;
+	return ctx->key_sz;
 }
 
 static int qat_rsa_init_tfm(struct crypto_akcipher *tfm)
-- 
2.7.4
