From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH] crypto: caam - Staticize caam_jr_shutdown()
Date: Sun, 14 Feb 2016 13:08:21 -0200
Message-ID: <1455462501-18464-1-git-send-email-festevam@gmail.com>
Cc: horia.geanta@freescale.com, linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@nxp.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qg0-f51.google.com ([209.85.192.51]:33116 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbcBNPIf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 14 Feb 2016 10:08:35 -0500
Received: by mail-qg0-f51.google.com with SMTP id b35so95280546qge.0
        for <linux-crypto@vger.kernel.org>; Sun, 14 Feb 2016 07:08:34 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@nxp.com>

caam_jr_shutdown() is only used in this file, so it can be
made static.

This avoids the following sparse warning:

drivers/crypto/caam/jr.c:68:5: warning: symbol 'caam_jr_shutdown' was not declared. Should it be static?

Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
 drivers/crypto/caam/jr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index f7e0d8d..6fd63a6 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -65,7 +65,7 @@ static int caam_reset_hw_jr(struct device *dev)
 /*
  * Shutdown JobR independent of platform property code
  */
-int caam_jr_shutdown(struct device *dev)
+static int caam_jr_shutdown(struct device *dev)
 {
 	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
 	dma_addr_t inpbusaddr, outbusaddr;
-- 
1.9.1
