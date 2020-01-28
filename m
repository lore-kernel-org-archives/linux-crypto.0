Return-Path: <SRS0=0bM2=3R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FA32C33C9E
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 11:43:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D05224684
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 11:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgA1LnJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jan 2020 06:43:09 -0500
Received: from viti.kaiser.cx ([85.214.81.225]:38742 "EHLO viti.kaiser.cx"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgA1LnJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jan 2020 06:43:09 -0500
X-Greylist: delayed 2496 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jan 2020 06:43:07 EST
Received: from dslb-088-068-095-017.088.068.pools.vodafone-ip.de ([88.68.95.17] helo=martin-debian-1.paytec.ch)
        by viti.kaiser.cx with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <martin@kaiser.cx>)
        id 1iwOcl-0008Dy-Sz; Tue, 28 Jan 2020 12:01:39 +0100
From:   Martin Kaiser <martin@kaiser.cx>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Martin Kaiser <martin@kaiser.cx>
Subject: [PATCH 6/6] hwrng: imx-rngc - simplify interrupt mask/unmask
Date:   Tue, 28 Jan 2020 12:01:02 +0100
Message-Id: <20200128110102.11522-7-martin@kaiser.cx>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200128110102.11522-1-martin@kaiser.cx>
References: <20200128110102.11522-1-martin@kaiser.cx>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use a simpler approach for masking / unmasking the rngc interrupt:
The interrupt is unmasked while self-test is running and when the rngc
driver is used by the hwrng core.

Mask the interrupt again when self test is finished, regardless of
self test success or failure.

Unmask the interrupt in the init function. Add a cleanup function where
the rngc interrupt is masked again.

Signed-off-by: Martin Kaiser <martin@kaiser.cx>
---
 drivers/char/hw_random/imx-rngc.c | 43 ++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 15 deletions(-)

diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
index 27d85fced30b..3363cbe18a8d 100644
--- a/drivers/char/hw_random/imx-rngc.c
+++ b/drivers/char/hw_random/imx-rngc.c
@@ -111,17 +111,11 @@ static int imx_rngc_self_test(struct imx_rngc *rngc)
 	writel(cmd | RNGC_CMD_SELF_TEST, rngc->base + RNGC_COMMAND);
 
 	ret = wait_for_completion_timeout(&rngc->rng_op_done, RNGC_TIMEOUT);
-	if (!ret) {
-		imx_rngc_irq_mask_clear(rngc);
+	imx_rngc_irq_mask_clear(rngc);
+	if (!ret)
 		return -ETIMEDOUT;
-	}
-
-	if (rngc->err_reg != 0) {
-		imx_rngc_irq_mask_clear(rngc);
-		return -EIO;
-	}
 
-	return 0;
+	return rngc->err_reg ? -EIO : 0;
 }
 
 static int imx_rngc_read(struct hwrng *rng, void *data, size_t max, bool wait)
@@ -185,10 +179,10 @@ static int imx_rngc_init(struct hwrng *rng)
 	cmd = readl(rngc->base + RNGC_COMMAND);
 	writel(cmd | RNGC_CMD_CLR_ERR, rngc->base + RNGC_COMMAND);
 
+	imx_rngc_irq_unmask(rngc);
+
 	/* create seed, repeat while there is some statistical error */
 	do {
-		imx_rngc_irq_unmask(rngc);
-
 		/* seed creation */
 		cmd = readl(rngc->base + RNGC_COMMAND);
 		writel(cmd | RNGC_CMD_SEED, rngc->base + RNGC_COMMAND);
@@ -197,14 +191,16 @@ static int imx_rngc_init(struct hwrng *rng)
 				RNGC_TIMEOUT);
 
 		if (!ret) {
-			imx_rngc_irq_mask_clear(rngc);
-			return -ETIMEDOUT;
+			ret = -ETIMEDOUT;
+			goto err;
 		}
 
 	} while (rngc->err_reg == RNGC_ERROR_STATUS_STAT_ERR);
 
-	if (rngc->err_reg)
-		return -EIO;
+	if (rngc->err_reg) {
+		ret = -EIO;
+		goto err;
+	}
 
 	/*
 	 * enable automatic seeding, the rngc creates a new seed automatically
@@ -214,7 +210,23 @@ static int imx_rngc_init(struct hwrng *rng)
 	ctrl |= RNGC_CTRL_AUTO_SEED;
 	writel(ctrl, rngc->base + RNGC_CONTROL);
 
+	/*
+	 * if initialisation was successful, we keep the interrupt
+	 * unmasked until imx_rngc_cleanup is called
+	 * we mask the interrupt ourselves if we return an error
+	 */
 	return 0;
+
+err:
+	imx_rngc_irq_mask_clear(rngc);
+	return ret;
+}
+
+static void imx_rngc_cleanup(struct hwrng *rng)
+{
+	struct imx_rngc *rngc = container_of(rng, struct imx_rngc, rng);
+
+	imx_rngc_irq_mask_clear(rngc);
 }
 
 static int imx_rngc_probe(struct platform_device *pdev)
@@ -272,6 +284,7 @@ static int imx_rngc_probe(struct platform_device *pdev)
 	rngc->rng.name = pdev->name;
 	rngc->rng.init = imx_rngc_init;
 	rngc->rng.read = imx_rngc_read;
+	rngc->rng.cleanup = imx_rngc_cleanup;
 
 	rngc->dev = &pdev->dev;
 	platform_set_drvdata(pdev, rngc);
-- 
2.20.1

