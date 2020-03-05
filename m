Return-Path: <SRS0=yJek=4W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0072C3F2D1
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Mar 2020 20:59:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB20920801
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Mar 2020 20:59:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgCEU71 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Mar 2020 15:59:27 -0500
Received: from viti.kaiser.cx ([85.214.81.225]:43276 "EHLO viti.kaiser.cx"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbgCEU71 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Mar 2020 15:59:27 -0500
Received: from 250.57.4.146.static.wline.lns.sme.cust.swisscom.ch ([146.4.57.250] helo=martin-debian-2.paytec.ch)
        by viti.kaiser.cx with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <martin@kaiser.cx>)
        id 1j9xaU-0000e9-QU; Thu, 05 Mar 2020 21:59:22 +0100
From:   Martin Kaiser <martin@kaiser.cx>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Martin Kaiser <martin@kaiser.cx>
Subject: [PATCH v2 2/5] hwrng: imx-rngc - use automatic seeding
Date:   Thu,  5 Mar 2020 21:58:21 +0100
Message-Id: <20200305205824.4371-3-martin@kaiser.cx>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305205824.4371-1-martin@kaiser.cx>
References: <20200128110102.11522-1-martin@kaiser.cx>
 <20200305205824.4371-1-martin@kaiser.cx>
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

Reviewed-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
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

