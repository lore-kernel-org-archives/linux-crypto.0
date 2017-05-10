From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 1/2] crypto: dh - fix dh_max_size
Date: Wed, 10 May 2017 16:04:28 +0300
Message-ID: <1494421469-17125-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:13324 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751432AbdEJNEj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 May 2017 09:04:39 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The function should return minimum size for output buffer
or error code if key hasn't been set.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/dh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/dh.c b/crypto/dh.c
index 87e3542..53d17ff 100644
--- a/crypto/dh.c
+++ b/crypto/dh.c
@@ -148,7 +148,7 @@ static int dh_max_size(struct crypto_kpp *tfm)
 {
 	struct dh_ctx *ctx = dh_get_ctx(tfm);
 
-	return mpi_get_size(ctx->p);
+	return ctx->p ? mpi_get_size(ctx->p) : -EINVAL;
 }
 
 static void dh_exit_tfm(struct crypto_kpp *tfm)
-- 
2.7.4
