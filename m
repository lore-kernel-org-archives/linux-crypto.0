Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCD23C74A5B
	for <linux-crypto@archiver.kernel.org>; Sun, 26 Mar 2023 14:14:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbjCZOOi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 26 Mar 2023 10:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbjCZOOh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Mar 2023 10:14:37 -0400
Received: from smtp.smtpout.orange.fr (smtp-25.smtpout.orange.fr [80.12.242.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68C1272B
        for <linux-crypto@vger.kernel.org>; Sun, 26 Mar 2023 07:14:35 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id gR8fpDUyw985CgR8fpq2Ia; Sun, 26 Mar 2023 16:14:34 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 26 Mar 2023 16:14:34 +0200
X-ME-IP: 86.243.2.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] crypto: mxs-dcp - Use the devm_clk_get_optional_enabled() helper
Date:   Sun, 26 Mar 2023 16:14:25 +0200
Message-Id: <c1049046280d78d92c7d0342e354e2429ce0176a.1679840050.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use devm_clk_get_optional_enabled() instead of hand writing it.
This saves some loC and improves the semantic.

update the error handling path and the remove function accordingly.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/crypto/mxs-dcp.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 1c11946a4f0b..f6b7bce0e656 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -1022,21 +1022,15 @@ static int mxs_dcp_probe(struct platform_device *pdev)
 	sdcp->coh = PTR_ALIGN(sdcp->coh, DCP_ALIGNMENT);
 
 	/* DCP clock is optional, only used on some SOCs */
-	sdcp->dcp_clk = devm_clk_get(dev, "dcp");
-	if (IS_ERR(sdcp->dcp_clk)) {
-		if (sdcp->dcp_clk != ERR_PTR(-ENOENT))
-			return PTR_ERR(sdcp->dcp_clk);
-		sdcp->dcp_clk = NULL;
-	}
-	ret = clk_prepare_enable(sdcp->dcp_clk);
-	if (ret)
-		return ret;
+	sdcp->dcp_clk = devm_clk_get_optional_enabled(dev, "dcp");
+	if (IS_ERR(sdcp->dcp_clk))
+		return PTR_ERR(sdcp->dcp_clk);
 
 	/* Restart the DCP block. */
 	ret = stmp_reset_block(sdcp->base);
 	if (ret) {
 		dev_err(dev, "Failed reset\n");
-		goto err_disable_unprepare_clk;
+		return ret;
 	}
 
 	/* Initialize control register. */
@@ -1076,7 +1070,7 @@ static int mxs_dcp_probe(struct platform_device *pdev)
 	if (IS_ERR(sdcp->thread[DCP_CHAN_HASH_SHA])) {
 		dev_err(dev, "Error starting SHA thread!\n");
 		ret = PTR_ERR(sdcp->thread[DCP_CHAN_HASH_SHA]);
-		goto err_disable_unprepare_clk;
+		return ret;
 	}
 
 	sdcp->thread[DCP_CHAN_CRYPTO] = kthread_run(dcp_chan_thread_aes,
@@ -1134,9 +1128,6 @@ static int mxs_dcp_probe(struct platform_device *pdev)
 err_destroy_sha_thread:
 	kthread_stop(sdcp->thread[DCP_CHAN_HASH_SHA]);
 
-err_disable_unprepare_clk:
-	clk_disable_unprepare(sdcp->dcp_clk);
-
 	return ret;
 }
 
@@ -1156,8 +1147,6 @@ static int mxs_dcp_remove(struct platform_device *pdev)
 	kthread_stop(sdcp->thread[DCP_CHAN_HASH_SHA]);
 	kthread_stop(sdcp->thread[DCP_CHAN_CRYPTO]);
 
-	clk_disable_unprepare(sdcp->dcp_clk);
-
 	platform_set_drvdata(pdev, NULL);
 
 	global_sdcp = NULL;
-- 
2.34.1

