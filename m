From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH] crypto: ecdh - remove empty exit()
Date: Thu, 2 Nov 2017 16:46:47 +0200
Message-ID: <20171102144647.11847-1-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:5327 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933411AbdKBOrA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Nov 2017 10:47:00 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Pointer members of an object with static storage duration, if not
explicitly initialized, will be initialized to a NULL pointer. The crypto
API checks if this pointer is not NULL before using it, we are safe to
remove the function.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/ecdh.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index 4271fc7..3aca093 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -131,17 +131,11 @@ static unsigned int ecdh_max_size(struct crypto_kpp *tfm)
 	return ctx->ndigits << (ECC_DIGITS_TO_BYTES_SHIFT + 1);
 }
 
-static void no_exit_tfm(struct crypto_kpp *tfm)
-{
-	return;
-}
-
 static struct kpp_alg ecdh = {
 	.set_secret = ecdh_set_secret,
 	.generate_public_key = ecdh_compute_value,
 	.compute_shared_secret = ecdh_compute_value,
 	.max_size = ecdh_max_size,
-	.exit = no_exit_tfm,
 	.base = {
 		.cra_name = "ecdh",
 		.cra_driver_name = "ecdh-generic",
-- 
2.9.4
