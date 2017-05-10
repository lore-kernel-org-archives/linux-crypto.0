From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 2/2] crypto: ecdh - fix ecdh_max_size
Date: Wed, 10 May 2017 16:04:29 +0300
Message-ID: <1494421469-17125-2-git-send-email-tudor.ambarus@microchip.com>
References: <1494421469-17125-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:27550 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751432AbdEJNEl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 May 2017 09:04:41 -0400
In-Reply-To: <1494421469-17125-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The function should return minimum size for output buffer
or error code if key hasn't been set.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/ecdh.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index 63ca337..01bfd13 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -109,10 +109,10 @@ static int ecdh_compute_value(struct kpp_request *req)
 static int ecdh_max_size(struct crypto_kpp *tfm)
 {
 	struct ecdh_ctx *ctx = ecdh_get_ctx(tfm);
-	int nbytes = ctx->ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
 
-	/* Public key is made of two coordinates */
-	return 2 * nbytes;
+	/* Public key is made of two coordinates, add one to the left shift  */
+	return ctx->ndigits ? ctx->ndigits << (ECC_DIGITS_TO_BYTES_SHIFT + 1) :
+			      -EINVAL;
 }
 
 static void no_exit_tfm(struct crypto_kpp *tfm)
-- 
2.7.4
