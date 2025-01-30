Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99F51F03F7;
	Thu, 30 Jan 2025 16:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738254763; cv=pass; b=aJqzJAy3g9um1aIn7EviIok+KsUJLnbJGRdPDktCPSDD5vn6vjmCa/gRSlPTPZyBd94bdQuTHFP7QJ8RiZRIKvXC+SbiGRgLp6f41/nyLjrb8MgSBCfWj+bZOYCsNLeroIgUrXLjoiLjAMxjBldc6p+ePNLTaT5uGAEnW3omRE4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738254763; c=relaxed/simple;
	bh=4UI5jo8QWitjFwhmPQxipFtJpPy9XREW5Te5754aVjA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=s/s+gHAs5BDcZ2G3MxSVsc0q/q+ffMEKeqNo6Z2Q54aFVAUqhfSwfSXsQQJxy+YzsWO8Bs0119eHJTsUihQhW1J0YTDGw67rztmolPPoNrxt2iG5RyDxmnZJX9NqkgSvKZmDl+yGZQ1iI6yWKS31s7tDfDoTZ8I+/bRWjyQxT68=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=cRveWBVX; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="cRveWBVX"
ARC-Seal: i=1; a=rsa-sha256; t=1738254726; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=BTmOT0gVNAvrpJLNBoLkJ8OqkY/CoXwMIGeOCHSjE8e6BWyqnjPOp7iRgll6H5jqmjSWLhAJePGJddwO9rWPd+MughIuReyYTV2HeM192vu2U99lRCDkOxe9k+6njAJvaWJwj9CY6qnMSLdERsaeDIubIckyj6IEk0T1V6TmhAc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1738254726; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=oXEUGmeDTmhvBSXe+dKsV4Yd6t7b7aHta03FjR428QY=; 
	b=iujU3SieLSvhV10QxmKSIHhW3u8RF1aBYfhKcpaMLp3eEFwDgjw5duJlxbZkaYyMOBwl176AxiAiayMS7SwBPu45XAXMIB26ciWfC0Or6ctIvBqvWiirHiJrzMturf28KzmAb4G0uAoeqQtliywVratxaa2fyWJtSDa05QPrj8k=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1738254726;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=oXEUGmeDTmhvBSXe+dKsV4Yd6t7b7aHta03FjR428QY=;
	b=cRveWBVXr30qCrjUP4O6gjYF2aDGOLI2w3JzAzRhfPM7zZY98Ru4cm5EJtQravdw
	FQZ3iWZ3LlUrMmsNUZhZdbrWrv8jrhoIjNND/kyulz+osPUSzp0B2OISZgsa5ALsHmr
	vVH/MYEBL3xAqnbWusoPLGvBGGhG8LVPjzI0Q9J4=
Received: by mx.zohomail.com with SMTPS id 1738254722198430.36549964890287;
	Thu, 30 Jan 2025 08:32:02 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Thu, 30 Jan 2025 17:31:19 +0100
Subject: [PATCH 5/7] hwrng: rockchip: add support for rk3588's standalone
 TRNG
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250130-rk3588-trng-submission-v1-5-97ff76568e49@collabora.com>
References: <20250130-rk3588-trng-submission-v1-0-97ff76568e49@collabora.com>
In-Reply-To: <20250130-rk3588-trng-submission-v1-0-97ff76568e49@collabora.com>
To: Philipp Zabel <p.zabel@pengutronix.de>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Heiko Stuebner <heiko@sntech.de>, 
 Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Daniel Golle <daniel@makrotopia.org>, Aurelien Jarno <aurelien@aurel32.net>
Cc: Sebastian Reichel <sebastian.reichel@collabora.com>, 
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 Lin Jinhan <troy.lin@rock-chips.com>
X-Mailer: b4 0.14.2

The RK3588 SoC includes several TRNGs, one part of the Crypto IP block,
and the other one (referred to as "trngv1") as a standalone new IP.

Add support for this new standalone TRNG to the driver by both
generalising it to support multiple different rockchip RNGs and then
implementing the required functionality for the new hardware.

This work was partly based on the downstream vendor driver by Rockchip's
Lin Jinhan, which is why they are listed as a Co-author.

While the hardware does support notifying the CPU with an IRQ when the
random data is ready, I've discovered while implementing the code to use
this interrupt that this results in significantly slower throughput of
the TRNG even when under heavy CPU load. I assume this is because with
only 32 bytes of data per invocation, the overhead of reinitialising a
completion, enabling the interrupt, sleeping and then triggering the
completion in the IRQ handler is way more expensive than busylooping.

Speaking of busylooping, the poll interval for reading the ISTAT is an
atomic read with a delay of 0. In my testing, I've found that this gives
us the largest throughput, and it appears the random data is ready
pretty much the moment we begin polling, as increasing the poll delay
leads to a drop in throughput significant enough to not just be due to
the poll interval missing the ideal timing by a microsecond or two.

According to downstream, the IP should take 1024 clock cycles to
generate 56 bits of random data, which at 150MHz should work out to
6.8us. I did not test whether the data really does take 256/56*6.8us
to arrive, though changing the readl to a __raw_readl makes no
difference in throughput, and this data does pass the rngtest FIPS
checks, so I'm not entirely sure what's going on but I presume it's got
something to do with the AHB bus speed and the memory barriers that
mainline's readl/writel functions insert.

The only other current SoC that uses this new IP is the Rockchip RV1106,
but that SoC does not have mainline support as of the time of writing,
so we make no effort to declare it as supported for now.

Co-developed-by: Lin Jinhan <troy.lin@rock-chips.com>
Signed-off-by: Lin Jinhan <troy.lin@rock-chips.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/char/hw_random/Kconfig        |   3 +-
 drivers/char/hw_random/rockchip-rng.c | 248 ++++++++++++++++++++++++++++++----
 2 files changed, 224 insertions(+), 27 deletions(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 17854f052386efa0cf3e4c83d60dd9d6d64755ea..6abf832abeba372d2152bd4905447f4b8fbfb6a0 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -606,7 +606,8 @@ config HW_RANDOM_ROCKCHIP
 	default HW_RANDOM
 	help
 	  This driver provides kernel-side support for the True Random Number
-	  Generator hardware found on some Rockchip SoC like RK3566 or RK3568.
+	  Generator hardware found on some Rockchip SoCs like RK3566, RK3568
+	  or RK3588.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called rockchip-rng.
diff --git a/drivers/char/hw_random/rockchip-rng.c b/drivers/char/hw_random/rockchip-rng.c
index 082daea27e937e147195070454f9511a71c8c67e..f0c8a09a67406726a43866001ed09515eeeba03e 100644
--- a/drivers/char/hw_random/rockchip-rng.c
+++ b/drivers/char/hw_random/rockchip-rng.c
@@ -1,12 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * rockchip-rng.c True Random Number Generator driver for Rockchip RK3568 SoC
+ * rockchip-rng.c True Random Number Generator driver for Rockchip SoCs
  *
  * Copyright (c) 2018, Fuzhou Rockchip Electronics Co., Ltd.
  * Copyright (c) 2022, Aurelien Jarno
+ * Copyright (c) 2025, Collabora Ltd.
  * Authors:
  *  Lin Jinhan <troy.lin@rock-chips.com>
  *  Aurelien Jarno <aurelien@aurel32.net>
+ *  Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
  */
 #include <linux/clk.h>
 #include <linux/hw_random.h>
@@ -32,6 +34,9 @@
  */
 #define RK_RNG_SAMPLE_CNT		1000
 
+/* after how many bytes of output TRNGv1 implementations should be reseeded */
+#define RK_TRNG_V1_AUTO_RESEED_CNT	16000
+
 /* TRNG registers from RK3568 TRM-Part2, section 5.4.1 */
 #define TRNG_RST_CTL			0x0004
 #define TRNG_RNG_CTL			0x0400
@@ -49,25 +54,85 @@
 #define TRNG_RNG_SAMPLE_CNT		0x0404
 #define TRNG_RNG_DOUT			0x0410
 
+/*
+ * TRNG V1 register definitions
+ * The TRNG V1 IP is a stand-alone TRNG implementation (not part of a crypto IP)
+ * and can be found in the Rockchip RK3588 SoC
+ */
+#define TRNG_V1_CTRL				0x0000
+#define TRNG_V1_CTRL_NOP			0x00
+#define TRNG_V1_CTRL_RAND			0x01
+#define TRNG_V1_CTRL_SEED			0x02
+
+#define TRNG_V1_STAT				0x0004
+#define TRNG_V1_STAT_SEEDED			BIT(9)
+#define TRNG_V1_STAT_GENERATING			BIT(30)
+#define TRNG_V1_STAT_RESEEDING			BIT(31)
+
+#define TRNG_V1_MODE				0x0008
+#define TRNG_V1_MODE_128_BIT			(0x00 << 3)
+#define TRNG_V1_MODE_256_BIT			(0x01 << 3)
+
+/* Interrupt Enable register; unused because polling is faster */
+#define TRNG_V1_IE				0x0010
+#define TRNG_V1_IE_GLBL_EN			BIT(31)
+#define TRNG_V1_IE_SEED_DONE_EN			BIT(1)
+#define TRNG_V1_IE_RAND_RDY_EN			BIT(0)
+
+#define TRNG_V1_ISTAT				0x0014
+#define TRNG_V1_ISTAT_RAND_RDY			BIT(0)
+
+/* RAND0 ~ RAND7 */
+#define TRNG_V1_RAND0				0x0020
+#define TRNG_V1_RAND7				0x003C
+
+/* Auto Reseed Register */
+#define TRNG_V1_AUTO_RQSTS			0x0060
+
+#define TRNG_V1_VERSION				0x00F0
+#define TRNG_v1_VERSION_CODE			0x46bc
+/* end of TRNG_V1 register definitions */
+
+/* Before removing this assert, give rk3588_rng_read an upper bound of 32 */
+static_assert(RK_RNG_MAX_BYTE <= (TRNG_V1_RAND7 + 4 - TRNG_V1_RAND0),
+	      "You raised RK_RNG_MAX_BYTE and broke rk3588-rng, congrats.");
+
 struct rk_rng {
 	struct hwrng rng;
 	void __iomem *base;
 	int clk_num;
 	struct clk_bulk_data *clk_bulks;
+	struct rk_rng_soc_data	*soc_data;
 	struct device *dev;
 };
 
+struct rk_rng_soc_data {
+	int (*rk_rng_init)(struct hwrng *rng);
+	int (*rk_rng_read)(struct hwrng *rng, void *buf, size_t max, bool wait);
+	void (*rk_rng_cleanup)(struct hwrng *rng);
+	unsigned short quality;
+	bool reset_optional;
+};
+
 /* The mask in the upper 16 bits determines the bits that are updated */
 static void rk_rng_write_ctl(struct rk_rng *rng, u32 val, u32 mask)
 {
 	writel((mask << 16) | val, rng->base + TRNG_RNG_CTL);
 }
 
-static int rk_rng_init(struct hwrng *rng)
+static inline void rk_rng_writel(struct rk_rng *rng, u32 val, u32 offset)
 {
-	struct rk_rng *rk_rng = container_of(rng, struct rk_rng, rng);
-	int ret;
+	writel(val, rng->base + offset);
+}
+
+static inline u32 rk_rng_readl(struct rk_rng *rng, u32 offset)
+{
+	return readl(rng->base + offset);
+}
 
+static int rk_rng_enable_clks(struct rk_rng *rk_rng)
+{
+	int ret;
 	/* start clocks */
 	ret = clk_bulk_prepare_enable(rk_rng->clk_num, rk_rng->clk_bulks);
 	if (ret < 0) {
@@ -75,6 +140,18 @@ static int rk_rng_init(struct hwrng *rng)
 		return ret;
 	}
 
+	return 0;
+}
+
+static int rk3568_rng_init(struct hwrng *rng)
+{
+	struct rk_rng *rk_rng = container_of(rng, struct rk_rng, rng);
+	int ret;
+
+	ret = rk_rng_enable_clks(rk_rng);
+	if (ret < 0)
+		return ret;
+
 	/* set the sample period */
 	writel(RK_RNG_SAMPLE_CNT, rk_rng->base + TRNG_RNG_SAMPLE_CNT);
 
@@ -87,7 +164,7 @@ static int rk_rng_init(struct hwrng *rng)
 	return 0;
 }
 
-static void rk_rng_cleanup(struct hwrng *rng)
+static void rk3568_rng_cleanup(struct hwrng *rng)
 {
 	struct rk_rng *rk_rng = container_of(rng, struct rk_rng, rng);
 
@@ -98,7 +175,7 @@ static void rk_rng_cleanup(struct hwrng *rng)
 	clk_bulk_disable_unprepare(rk_rng->clk_num, rk_rng->clk_bulks);
 }
 
-static int rk_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
+static int rk3568_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 {
 	struct rk_rng *rk_rng = container_of(rng, struct rk_rng, rng);
 	size_t to_read = min_t(size_t, max, RK_RNG_MAX_BYTE);
@@ -128,9 +205,126 @@ static int rk_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 	return (ret < 0) ? ret : to_read;
 }
 
+static int rk3588_rng_init(struct hwrng *rng)
+{
+	struct rk_rng *rk_rng = container_of(rng, struct rk_rng, rng);
+	u32 version, status, mask, istat;
+	int ret;
+
+	ret = rk_rng_enable_clks(rk_rng);
+	if (ret < 0)
+		return ret;
+
+	version = rk_rng_readl(rk_rng, TRNG_V1_VERSION);
+	if (version != TRNG_v1_VERSION_CODE) {
+		dev_err(rk_rng->dev,
+			"wrong trng version, expected = %08x, actual = %08x\n",
+			TRNG_V1_VERSION, version);
+		ret = -EFAULT;
+		goto err_disable_clk;
+	}
+
+	mask = TRNG_V1_STAT_SEEDED | TRNG_V1_STAT_GENERATING |
+	       TRNG_V1_STAT_RESEEDING;
+	if (readl_poll_timeout(rk_rng->base + TRNG_V1_STAT, status,
+			       (status & mask) == TRNG_V1_STAT_SEEDED,
+			       RK_RNG_POLL_PERIOD_US, RK_RNG_POLL_TIMEOUT_US) < 0) {
+		dev_err(rk_rng->dev, "timed out waiting for hwrng to reseed\n");
+		ret = -ETIMEDOUT;
+		goto err_disable_clk;
+	}
+
+	/*
+	 * clear ISTAT flag, downstream advises to do this to avoid
+	 * auto-reseeding "on power on"
+	 */
+	istat = rk_rng_readl(rk_rng, TRNG_V1_ISTAT);
+	rk_rng_writel(rk_rng, istat, TRNG_V1_ISTAT);
+
+	/* auto reseed after RK_TRNG_V1_AUTO_RESEED_CNT bytes */
+	rk_rng_writel(rk_rng, RK_TRNG_V1_AUTO_RESEED_CNT / 16, TRNG_V1_AUTO_RQSTS);
+
+	return 0;
+err_disable_clk:
+	clk_bulk_disable_unprepare(rk_rng->clk_num, rk_rng->clk_bulks);
+	return ret;
+}
+
+static void rk3588_rng_cleanup(struct hwrng *rng)
+{
+	struct rk_rng *rk_rng = container_of(rng, struct rk_rng, rng);
+
+	clk_bulk_disable_unprepare(rk_rng->clk_num, rk_rng->clk_bulks);
+}
+
+static int rk3588_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
+{
+	struct rk_rng *rk_rng = container_of(rng, struct rk_rng, rng);
+	size_t to_read = min_t(size_t, max, RK_RNG_MAX_BYTE);
+	int ret = 0;
+	u32 reg;
+
+	ret = pm_runtime_resume_and_get(rk_rng->dev);
+	if (ret < 0)
+		return ret;
+
+	/* Clear ISTAT, even without interrupts enabled, this will be updated */
+	reg = rk_rng_readl(rk_rng, TRNG_V1_ISTAT);
+	rk_rng_writel(rk_rng, reg, TRNG_V1_ISTAT);
+
+	/* generate 256 bits of random data */
+	rk_rng_writel(rk_rng, TRNG_V1_MODE_256_BIT, TRNG_V1_MODE);
+	rk_rng_writel(rk_rng, TRNG_V1_CTRL_RAND, TRNG_V1_CTRL);
+
+	ret = readl_poll_timeout_atomic(rk_rng->base + TRNG_V1_ISTAT, reg,
+					(reg & TRNG_V1_ISTAT_RAND_RDY), 0,
+					RK_RNG_POLL_TIMEOUT_US);
+	if (ret < 0)
+		goto out;
+
+	/* Read random data that's in registers TRNG_V1_RAND0 through RAND7 */
+	memcpy_fromio(buf, rk_rng->base + TRNG_V1_RAND0, to_read);
+
+out:
+	/* Clear ISTAT */
+	rk_rng_writel(rk_rng, reg, TRNG_V1_ISTAT);
+	/* close the TRNG */
+	rk_rng_writel(rk_rng, TRNG_V1_CTRL_NOP, TRNG_V1_CTRL);
+
+	pm_runtime_mark_last_busy(rk_rng->dev);
+	pm_runtime_put_sync_autosuspend(rk_rng->dev);
+
+	return (ret < 0) ? ret : to_read;
+}
+
+static const struct rk_rng_soc_data rk3568_soc_data = {
+	.rk_rng_init = rk3568_rng_init,
+	.rk_rng_read = rk3568_rng_read,
+	.rk_rng_cleanup = rk3568_rng_cleanup,
+	.quality = 900,
+	.reset_optional = false,
+};
+
+static const struct rk_rng_soc_data rk3588_soc_data = {
+	.rk_rng_init = rk3588_rng_init,
+	.rk_rng_read = rk3588_rng_read,
+	.rk_rng_cleanup = rk3588_rng_cleanup,
+	.quality = 999,		/* as determined by actual testing */
+	.reset_optional = true,
+};
+
+static const struct of_device_id rk_rng_dt_match[] = {
+	{ .compatible = "rockchip,rk3568-rng", .data = (void *)&rk3568_soc_data },
+	{ .compatible = "rockchip,rk3588-rng", .data = (void *)&rk3588_soc_data },
+	{ /* sentinel */ },
+};
+
+MODULE_DEVICE_TABLE(of, rk_rng_dt_match);
+
 static int rk_rng_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
+	const struct of_device_id *match;
 	struct reset_control *rst;
 	struct rk_rng *rk_rng;
 	int ret;
@@ -139,6 +333,8 @@ static int rk_rng_probe(struct platform_device *pdev)
 	if (!rk_rng)
 		return -ENOMEM;
 
+	match = of_match_node(rk_rng_dt_match, dev->of_node);
+	rk_rng->soc_data = (struct rk_rng_soc_data *)match->data;
 	rk_rng->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(rk_rng->base))
 		return PTR_ERR(rk_rng->base);
@@ -148,24 +344,30 @@ static int rk_rng_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, rk_rng->clk_num,
 				     "Failed to get clks property\n");
 
-	rst = devm_reset_control_array_get_exclusive(dev);
-	if (IS_ERR(rst))
-		return dev_err_probe(dev, PTR_ERR(rst), "Failed to get reset property\n");
+	if (rk_rng->soc_data->reset_optional)
+		rst = devm_reset_control_array_get_optional_exclusive(dev);
+	else
+		rst = devm_reset_control_array_get_exclusive(dev);
+
+	if (rst) {
+		if (IS_ERR(rst))
+			return dev_err_probe(dev, PTR_ERR(rst), "Failed to get reset property\n");
 
-	reset_control_assert(rst);
-	udelay(2);
-	reset_control_deassert(rst);
+		reset_control_assert(rst);
+		udelay(2);
+		reset_control_deassert(rst);
+	}
 
 	platform_set_drvdata(pdev, rk_rng);
 
 	rk_rng->rng.name = dev_driver_string(dev);
 	if (!IS_ENABLED(CONFIG_PM)) {
-		rk_rng->rng.init = rk_rng_init;
-		rk_rng->rng.cleanup = rk_rng_cleanup;
+		rk_rng->rng.init = rk_rng->soc_data->rk_rng_init;
+		rk_rng->rng.cleanup = rk_rng->soc_data->rk_rng_cleanup;
 	}
-	rk_rng->rng.read = rk_rng_read;
+	rk_rng->rng.read = rk_rng->soc_data->rk_rng_read;
 	rk_rng->dev = dev;
-	rk_rng->rng.quality = 900;
+	rk_rng->rng.quality = rk_rng->soc_data->quality;
 
 	pm_runtime_set_autosuspend_delay(dev, RK_RNG_AUTOSUSPEND_DELAY);
 	pm_runtime_use_autosuspend(dev);
@@ -184,7 +386,7 @@ static int __maybe_unused rk_rng_runtime_suspend(struct device *dev)
 {
 	struct rk_rng *rk_rng = dev_get_drvdata(dev);
 
-	rk_rng_cleanup(&rk_rng->rng);
+	rk_rng->soc_data->rk_rng_cleanup(&rk_rng->rng);
 
 	return 0;
 }
@@ -193,7 +395,7 @@ static int __maybe_unused rk_rng_runtime_resume(struct device *dev)
 {
 	struct rk_rng *rk_rng = dev_get_drvdata(dev);
 
-	return rk_rng_init(&rk_rng->rng);
+	return rk_rng->soc_data->rk_rng_init(&rk_rng->rng);
 }
 
 static const struct dev_pm_ops rk_rng_pm_ops = {
@@ -203,13 +405,6 @@ static const struct dev_pm_ops rk_rng_pm_ops = {
 				pm_runtime_force_resume)
 };
 
-static const struct of_device_id rk_rng_dt_match[] = {
-	{ .compatible = "rockchip,rk3568-rng", },
-	{ /* sentinel */ },
-};
-
-MODULE_DEVICE_TABLE(of, rk_rng_dt_match);
-
 static struct platform_driver rk_rng_driver = {
 	.driver	= {
 		.name	= "rockchip-rng",
@@ -221,8 +416,9 @@ static struct platform_driver rk_rng_driver = {
 
 module_platform_driver(rk_rng_driver);
 
-MODULE_DESCRIPTION("Rockchip RK3568 True Random Number Generator driver");
+MODULE_DESCRIPTION("Rockchip True Random Number Generator driver");
 MODULE_AUTHOR("Lin Jinhan <troy.lin@rock-chips.com>");
 MODULE_AUTHOR("Aurelien Jarno <aurelien@aurel32.net>");
 MODULE_AUTHOR("Daniel Golle <daniel@makrotopia.org>");
+MODULE_AUTHOR("Nicolas Frattaroli <nicolas.frattaroli@collabora.com>");
 MODULE_LICENSE("GPL");

-- 
2.48.1

