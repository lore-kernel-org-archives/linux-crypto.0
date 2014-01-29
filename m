From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH 2/2] crypto: mxs-dcp: Check the return value of stmp_reset_block()
Date: Tue, 28 Jan 2014 22:36:12 -0200
Message-ID: <1390955772-6936-2-git-send-email-festevam@gmail.com>
References: <1390955772-6936-1-git-send-email-festevam@gmail.com>
Cc: marex@denx.de, linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yk0-f177.google.com ([209.85.160.177]:49689 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbaA2Amc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Jan 2014 19:42:32 -0500
Received: by mail-yk0-f177.google.com with SMTP id 19so5478633ykq.8
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jan 2014 16:42:32 -0800 (PST)
In-Reply-To: <1390955772-6936-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

stmp_reset_block() may fail, so check its return value and propagate it in the
case of error.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/crypto/mxs-dcp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 2d7d497..4d18c40 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -942,7 +942,9 @@ static int mxs_dcp_probe(struct platform_device *pdev)
 	}
 
 	/* Restart the DCP block. */
-	stmp_reset_block(sdcp->base);
+	ret = stmp_reset_block(sdcp->base);
+	if (ret)
+		goto err_mutex;
 
 	/* Initialize control register. */
 	writel(MXS_DCP_CTRL_GATHER_RESIDUAL_WRITES |
-- 
1.8.1.2
