From: Lars Persson <lars.persson@axis.com>
Subject: [PATCH v2] crypto: artpec6: set correct iv size for gcm(aes)
Date: Tue, 12 Dec 2017 12:40:22 +0100
Message-ID: <20171212114022.11327-1-larper@axis.com>
Cc: Lars Persson <larper@axis.com>
To: linux-arm-kernel@axis.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bastet.se.axis.com ([195.60.68.11]:36183 "EHLO
        bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751566AbdLLLkt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Dec 2017 06:40:49 -0500
Received: from localhost (localhost [127.0.0.1])
        by bastet.se.axis.com (Postfix) with ESMTP id D01DE18355
        for <linux-crypto@vger.kernel.org>; Tue, 12 Dec 2017 12:40:47 +0100 (CET)
Received: from bastet.se.axis.com ([IPv6:::ffff:127.0.0.1])
        by localhost (bastet.se.axis.com [::ffff:127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id R747NO5vkt2i for <linux-crypto@vger.kernel.org>;
        Tue, 12 Dec 2017 12:40:47 +0100 (CET)
Received: from boulder03.se.axis.com (boulder03.se.axis.com [10.0.8.17])
        by bastet.se.axis.com (Postfix) with ESMTPS id F20051834E
        for <linux-crypto@vger.kernel.org>; Tue, 12 Dec 2017 12:40:46 +0100 (CET)
Received: from boulder03.se.axis.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF4511E081
        for <linux-crypto@vger.kernel.org>; Tue, 12 Dec 2017 12:40:46 +0100 (CET)
Received: from boulder03.se.axis.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D40C51E080
        for <linux-crypto@vger.kernel.org>; Tue, 12 Dec 2017 12:40:46 +0100 (CET)
Received: from thoth.se.axis.com (unknown [10.0.2.173])
        by boulder03.se.axis.com (Postfix) with ESMTP
        for <linux-crypto@vger.kernel.org>; Tue, 12 Dec 2017 12:40:46 +0100 (CET)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The IV size should not include the 32 bit counter. Because we had the
IV size set as 16 the transform only worked when the IV input was zero
padded.

Fixes: a21eb94fc4d3 ("crypto: axis - add ARTPEC-6/7 crypto accelerator driver")
Signed-off-by: Lars Persson <larper@axis.com>
---
v2: Use GCM_AES_IV_SIZE instead of 12.
---
 drivers/crypto/axis/artpec6_crypto.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index 456278440863..22df6b55e172 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -22,6 +22,7 @@
 #include <linux/slab.h>
 
 #include <crypto/aes.h>
+#include <crypto/gcm.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
@@ -1934,7 +1935,7 @@ static int artpec6_crypto_prepare_aead(struct aead_request *areq)
 
 	memcpy(req_ctx->hw_ctx.J0, areq->iv, crypto_aead_ivsize(cipher));
 	// The HW omits the initial increment of the counter field.
-	crypto_inc(req_ctx->hw_ctx.J0+12, 4);
+	memcpy(req_ctx->hw_ctx.J0 + GCM_AES_IV_SIZE, "\x00\x00\x00\x01", 4);
 
 	ret = artpec6_crypto_setup_out_descr(common, &req_ctx->hw_ctx,
 		sizeof(struct artpec6_crypto_aead_hw_ctx), false, false);
@@ -2956,7 +2957,7 @@ static struct aead_alg aead_algos[] = {
 		.setkey = artpec6_crypto_aead_set_key,
 		.encrypt = artpec6_crypto_aead_encrypt,
 		.decrypt = artpec6_crypto_aead_decrypt,
-		.ivsize = AES_BLOCK_SIZE,
+		.ivsize = GCM_AES_IV_SIZE,
 		.maxauthsize = AES_BLOCK_SIZE,
 
 		.base = {
-- 
2.11.0
