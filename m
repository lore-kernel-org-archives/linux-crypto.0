From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH v4 08/14] crypto: ecdh - comply with crypto_kpp_maxsize()
Date: Thu, 25 May 2017 10:18:10 +0300
Message-ID: <1495696696-22580-9-git-send-email-tudor.ambarus@microchip.com>
References: <1495696696-22580-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <horia.geanta@nxp.com>, <dan.douglass@nxp.com>,
        <giovanni.cabiddu@intel.com>, <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:36345 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933384AbdEYHSz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 May 2017 03:18:55 -0400
In-Reply-To: <1495696696-22580-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto_kpp_maxsize() asks for the output buffer size without
caring for errors. It allways assume that will be called after
a valid setkey. Comply with it and return what he wants.

nbytes has no sense now, remove it and directly return the maxsize.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/ecdh.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index ed1464a..4aa0b0c 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -104,13 +104,12 @@ static int ecdh_compute_value(struct kpp_request *req)
 	return ret;
 }
 
-static int ecdh_max_size(struct crypto_kpp *tfm)
+static unsigned int ecdh_max_size(struct crypto_kpp *tfm)
 {
 	struct ecdh_ctx *ctx = ecdh_get_ctx(tfm);
-	int nbytes = ctx->ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
 
-	/* Public key is made of two coordinates */
-	return 2 * nbytes;
+	/* Public key is made of two coordinates, add one to the left shift */
+	return ctx->ndigits << (ECC_DIGITS_TO_BYTES_SHIFT + 1);
 }
 
 static void no_exit_tfm(struct crypto_kpp *tfm)
-- 
2.7.4
