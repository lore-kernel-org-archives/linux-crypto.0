From: Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH v1] crypto: caam - set hwrng quality level
Date: Wed, 19 Jul 2017 09:44:58 +0200
Message-ID: <20170719074458.9247-1-o.rempel@pengutronix.de>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
To: kernel@pengutronix.de,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:52923 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752190AbdGSHpX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jul 2017 03:45:23 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

According documentation, it is NIST certified TRNG.
So, set high quality to let the HWRNG framework automatically use it.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/crypto/caam/caamrng.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 41398da3edf4..684c0bc88dfd 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -292,10 +292,16 @@ static int caam_init_rng(struct caam_rng_ctx *ctx, struct device *jrdev)
 	return 0;
 }
 
+/*
+ * hwrng register struct
+ * The trng is suppost to have 100% entropy, and thus
+ * we register with a very high quality value.
+ */
 static struct hwrng caam_rng = {
 	.name		= "rng-caam",
 	.cleanup	= caam_cleanup,
 	.read		= caam_read,
+	.quality	= 999,
 };
 
 static void __exit caam_rng_exit(void)
-- 
2.11.0
