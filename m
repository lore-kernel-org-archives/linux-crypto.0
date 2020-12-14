Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8FF1C4361B
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 16:06:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AADD722583
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 16:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440073AbgLNQFq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Dec 2020 11:05:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:44496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439358AbgLNQFq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Dec 2020 11:05:46 -0500
From:   matthias.bgg@kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     mpm@selenic.com, herbert@gondor.apana.org.au, rjui@broadcom.com,
        sbranden@broadcom.com, f.fainelli@gmail.com
Cc:     linux-kernel@vger.kernel.org, Julia.Lawall@inria.fr,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, nsaenzjulienne@suse.de,
        linux-crypto@vger.kernel.org, Matthias Brugger <mbrugger@suse.com>
Subject: [PATCH 2/2] hwrng: iproc-rng200: Move enable/disable in separate function
Date:   Mon, 14 Dec 2020 17:04:54 +0100
Message-Id: <20201214160454.22769-2-matthias.bgg@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214160454.22769-1-matthias.bgg@kernel.org>
References: <20201214160454.22769-1-matthias.bgg@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Matthias Brugger <mbrugger@suse.com>

We are calling the same code for enable and disable the block in various
parts of the driver. Put that code into a new function to reduce code
duplication.

Signed-off-by: Matthias Brugger <mbrugger@suse.com>

---

 drivers/char/hw_random/iproc-rng200.c | 37 ++++++++++++---------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/char/hw_random/iproc-rng200.c b/drivers/char/hw_random/iproc-rng200.c
index e106ce3c0146..3367b26085e8 100644
--- a/drivers/char/hw_random/iproc-rng200.c
+++ b/drivers/char/hw_random/iproc-rng200.c
@@ -53,15 +53,26 @@ struct iproc_rng200_dev {
 
 #define to_rng_priv(rng)	container_of(rng, struct iproc_rng200_dev, rng)
 
-static void iproc_rng200_restart(void __iomem *rng_base)
+static void iproc_rng200_enable(void __iomem *rng_base, bool enable)
 {
 	uint32_t val;
 
-	/* Disable RBG */
 	val = ioread32(rng_base + RNG_CTRL_OFFSET);
 	val &= ~RNG_CTRL_RNG_RBGEN_MASK;
-	val &= ~RNG_CTRL_RNG_RBGEN_ENABLE;
+
+	if (enable)
+		val |= RNG_CTRL_RNG_RBGEN_ENABLE;
+	else
+		val &= ~RNG_CTRL_RNG_RBGEN_ENABLE;
+
 	iowrite32(val, rng_base + RNG_CTRL_OFFSET);
+}
+
+static void iproc_rng200_restart(void __iomem *rng_base)
+{
+	uint32_t val;
+
+	iproc_rng200_enable(rng_base, false);
 
 	/* Clear all interrupt status */
 	iowrite32(0xFFFFFFFFUL, rng_base + RNG_INT_STATUS_OFFSET);
@@ -83,11 +94,7 @@ static void iproc_rng200_restart(void __iomem *rng_base)
 	val &= ~RBG_SOFT_RESET;
 	iowrite32(val, rng_base + RBG_SOFT_RESET_OFFSET);
 
-	/* Enable RBG */
-	val = ioread32(rng_base + RNG_CTRL_OFFSET);
-	val &= ~RNG_CTRL_RNG_RBGEN_MASK;
-	val |= RNG_CTRL_RNG_RBGEN_ENABLE;
-	iowrite32(val, rng_base + RNG_CTRL_OFFSET);
+	iproc_rng200_enable(rng_base, true);
 }
 
 static int iproc_rng200_read(struct hwrng *rng, void *buf, size_t max,
@@ -154,13 +161,8 @@ static int iproc_rng200_read(struct hwrng *rng, void *buf, size_t max,
 static int iproc_rng200_init(struct hwrng *rng)
 {
 	struct iproc_rng200_dev *priv = to_rng_priv(rng);
-	uint32_t val;
 
-	/* Setup RNG. */
-	val = ioread32(priv->base + RNG_CTRL_OFFSET);
-	val &= ~RNG_CTRL_RNG_RBGEN_MASK;
-	val |= RNG_CTRL_RNG_RBGEN_ENABLE;
-	iowrite32(val, priv->base + RNG_CTRL_OFFSET);
+	iproc_rng200_enable(priv->base, true);
 
 	return 0;
 }
@@ -168,13 +170,8 @@ static int iproc_rng200_init(struct hwrng *rng)
 static void iproc_rng200_cleanup(struct hwrng *rng)
 {
 	struct iproc_rng200_dev *priv = to_rng_priv(rng);
-	uint32_t val;
 
-	/* Disable RNG hardware */
-	val = ioread32(priv->base + RNG_CTRL_OFFSET);
-	val &= ~RNG_CTRL_RNG_RBGEN_MASK;
-	val &= ~RNG_CTRL_RNG_RBGEN_ENABLE;
-	iowrite32(val, priv->base + RNG_CTRL_OFFSET);
+	iproc_rng200_enable(priv->base, false);
 }
 
 static int iproc_rng200_probe(struct platform_device *pdev)
-- 
2.29.2

