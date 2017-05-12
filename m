From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 6/8] crypto: dh - fix dh_max_size
Date: Fri, 12 May 2017 13:11:44 +0300
Message-ID: <1494583906-15472-7-git-send-email-tudor.ambarus@microchip.com>
References: <1494583906-15472-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:27442 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757671AbdELKMC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 May 2017 06:12:02 -0400
In-Reply-To: <1494583906-15472-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The function should return minimum size for output buffer
or error code if key hasn't been set.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/dh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/dh.c b/crypto/dh.c
index 7cec0498..325a5dd 100644
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
