From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 12/13] crypto: caam - clean-up in caam_init_rng()
Date: Fri, 7 Jul 2017 16:05:22 +0300
Message-ID: <20170707130523.32427-13-horia.geanta@nxp.com>
References: <20170707130523.32427-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam03on0054.outbound.protection.outlook.com ([104.47.42.54]:35625
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751981AbdGGNGI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Jul 2017 09:06:08 -0400
In-Reply-To: <20170707130523.32427-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Horia Geantă <horia.geanta@freescale.com>

Clean up the code, as indicated by Coccinelle.

Cc: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Horia Geantă <horia.geanta@freescale.com>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamrng.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 41398da3edf4..fde07d4ff019 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -285,11 +285,7 @@ static int caam_init_rng(struct caam_rng_ctx *ctx, struct device *jrdev)
 	if (err)
 		return err;
 
-	err = caam_init_buf(ctx, 1);
-	if (err)
-		return err;
-
-	return 0;
+	return caam_init_buf(ctx, 1);
 }
 
 static struct hwrng caam_rng = {
-- 
2.12.0.264.gd6db3f216544
