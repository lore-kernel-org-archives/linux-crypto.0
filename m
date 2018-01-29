From: Lionel Debieve <lionel.debieve@st.com>
Subject: [PATCH 3/5] hwrng: stm32 - allow disable clock error detection
Date: Mon, 29 Jan 2018 18:05:19 +0100
Message-ID: <20180129170521.1862-4-lionel.debieve@st.com>
References: <20180129170521.1862-1-lionel.debieve@st.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Benjamin Gaignard <benjamin.gaignard@st.com>,
        Ludovic Barre <ludovic.barre@st.com>
To: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:42327 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751249AbeA2RGo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jan 2018 12:06:44 -0500
In-Reply-To: <20180129170521.1862-1-lionel.debieve@st.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add a new property that allow to disable the clock error
detection which is required when the clock source selected
is out of specification (which is not mandatory).

Signed-off-by: Lionel Debieve <lionel.debieve@st.com>
---
 drivers/char/hw_random/stm32-rng.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index 83c695938a2d..709a8d061be3 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -26,6 +26,7 @@
 
 #define RNG_CR 0x00
 #define RNG_CR_RNGEN BIT(2)
+#define RNG_CR_CED BIT(5)
 
 #define RNG_SR 0x04
 #define RNG_SR_SEIS BIT(6)
@@ -48,6 +49,7 @@ struct stm32_rng_private {
 	void __iomem *base;
 	struct clk *clk;
 	struct reset_control *rst;
+	bool ced;
 };
 
 static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
@@ -101,7 +103,11 @@ static int stm32_rng_init(struct hwrng *rng)
 	if (err)
 		return err;
 
-	writel_relaxed(RNG_CR_RNGEN, priv->base + RNG_CR);
+	if (priv->ced)
+		writel_relaxed(RNG_CR_RNGEN, priv->base + RNG_CR);
+	else
+		writel_relaxed(RNG_CR_RNGEN | RNG_CR_CED,
+			       priv->base + RNG_CR);
 
 	/* clear error indicators */
 	writel_relaxed(0, priv->base + RNG_SR);
@@ -149,6 +155,8 @@ static int stm32_rng_probe(struct platform_device *ofdev)
 		reset_control_deassert(priv->rst);
 	}
 
+	priv->ced = of_property_read_bool(np, "clock-error-detect");
+
 	dev_set_drvdata(dev, priv);
 
 	priv->rng.name = dev_driver_string(dev),
-- 
2.15.1
