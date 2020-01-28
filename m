Return-Path: <SRS0=0bM2=3R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A74D9C33C9E
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 11:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DAF524684
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 11:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgA1LnS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jan 2020 06:43:18 -0500
Received: from viti.kaiser.cx ([85.214.81.225]:39194 "EHLO viti.kaiser.cx"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726166AbgA1LnS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jan 2020 06:43:18 -0500
Received: from dslb-088-068-095-017.088.068.pools.vodafone-ip.de ([88.68.95.17] helo=martin-debian-1.paytec.ch)
        by viti.kaiser.cx with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <martin@kaiser.cx>)
        id 1iwOcf-0008Dy-Ji; Tue, 28 Jan 2020 12:01:33 +0100
From:   Martin Kaiser <martin@kaiser.cx>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Martin Kaiser <martin@kaiser.cx>
Subject: [PATCH 2/6] hwrng: imx-rngc - use automatic seeding
Date:   Tue, 28 Jan 2020 12:00:58 +0100
Message-Id: <20200128110102.11522-3-martin@kaiser.cx>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200128110102.11522-1-martin@kaiser.cx>
References: <20200128110102.11522-1-martin@kaiser.cx>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The rngc requires a new seed for its prng after generating 2^20 160-bit
words of random data. At the moment, we seed the prng only once during
initalisation.

Set the rngc to auto seed mode so that it kicks off the internal
reseeding operation when a new seed is required.

Keep the manual calculation of the initial seed when the device is
probed and switch to automatic seeding afterwards.

Signed-off-by: Martin Kaiser <martin@kaiser.cx>
---
 drivers/char/hw_random/imx-rngc.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
index 0576801944fd..903894518c8d 100644
--- a/drivers/char/hw_random/imx-rngc.c
+++ b/drivers/char/hw_random/imx-rngc.c
@@ -31,6 +31,7 @@
 
 #define RNGC_CTRL_MASK_ERROR		0x00000040
 #define RNGC_CTRL_MASK_DONE		0x00000020
+#define RNGC_CTRL_AUTO_SEED		0x00000010
 
 #define RNGC_STATUS_ERROR		0x00010000
 #define RNGC_STATUS_FIFO_LEVEL_MASK	0x00000f00
@@ -167,7 +168,7 @@ static irqreturn_t imx_rngc_irq(int irq, void *priv)
 static int imx_rngc_init(struct hwrng *rng)
 {
 	struct imx_rngc *rngc = container_of(rng, struct imx_rngc, rng);
-	u32 cmd;
+	u32 cmd, ctrl;
 	int ret;
 
 	/* clear error */
@@ -192,7 +193,18 @@ static int imx_rngc_init(struct hwrng *rng)
 
 	} while (rngc->err_reg == RNGC_ERROR_STATUS_STAT_ERR);
 
-	return rngc->err_reg ? -EIO : 0;
+	if (rngc->err_reg)
+		return -EIO;
+
+	/*
+	 * enable automatic seeding, the rngc creates a new seed automatically
+	 * after serving 2^20 random 160-bit words
+	 */
+	ctrl = readl(rngc->base + RNGC_CONTROL);
+	ctrl |= RNGC_CTRL_AUTO_SEED;
+	writel(ctrl, rngc->base + RNGC_CONTROL);
+
+	return 0;
 }
 
 static int imx_rngc_probe(struct platform_device *pdev)
-- 
2.20.1

