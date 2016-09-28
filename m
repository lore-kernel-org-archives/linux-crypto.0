From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH] crypto/caam/jr : Unmap region obtained by of_iomap
Date: Wed, 28 Sep 2016 16:01:42 +0530
Message-ID: <1475058703-9949-1-git-send-email-arvind.yadav.cs@gmail.com>
Cc: alexandru.porosanu@nxp.com, fabio.estevam@nxp.com,
        horia.geanta@nxp.com, cata.vasile@nxp.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arvind Yadav <arvind.yadav.cs@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35870 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751769AbcI1Kcv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Sep 2016 06:32:51 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Arvind Yadav <arvind.yadav.cs@gmail.com>

Free memory mapping, if probe is not successful.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/crypto/caam/jr.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index a81f551..9e7f281 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -513,6 +513,7 @@ static int caam_jr_probe(struct platform_device *pdev)
 	error = caam_jr_init(jrdev); /* now turn on hardware */
 	if (error) {
 		irq_dispose_mapping(jrpriv->irq);
+		iounmap(ctrl);
 		return error;
 	}
 
-- 
1.7.9.5
