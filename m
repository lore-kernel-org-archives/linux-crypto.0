From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH v2 12/13] crypto: caam - clean-up in caam_init_rng()
Date: Mon, 10 Jul 2017 08:40:38 +0300
Message-ID: <20170710054039.21555-13-horia.geanta@nxp.com>
References: <20170707130523.32427-1-horia.geanta@nxp.com>
 <20170710054039.21555-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0063.outbound.protection.outlook.com ([104.47.37.63]:7200
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753244AbdGJFl3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Jul 2017 01:41:29 -0400
In-Reply-To: <20170710054039.21555-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Clean up the code, as indicated by Coccinelle.

Cc: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
v2: fix author - replace my Freescale address with
corresponding NXP one

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
