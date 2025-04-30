Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859942B9A9;
	Wed, 30 Apr 2025 16:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746029877; cv=pass; b=EAy7W6YIFFPaRuHlWP1kOctJtrwdAwzzg2QHXQ0Tbix/zFg0eqxKHNdO8Z9NECY8GeT6DaGq4lrDqy54oY0j3fxU7SmA+JZ5/gvVIHUHC29H/E7AmJEaequ1CMJK3J/WlPxMdLaJLzKLGaFhsdDa4/atHieCIwUlIwJjZoVEjx8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746029877; c=relaxed/simple;
	bh=9Zx9VPrWGrOJSajPyimsxoU+62VPe81hfoB3BpXcp4A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kQ+P8194i6OLJ0BlbesiUCHB4Mk0VPjlmHmRwBTtqzJfMDNumM2DtnpDNkZa278wJiy0d0/vS/CB/eD6wuCUoctn3XHk9I9/H1wKf+f2pdiMzxe2TPm1b+thrOAvkj5ZH9fmrNJitifc/8bEVB2EBY+BnMFxbTxjDIvuw+bRRks=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=VvtqeeQq; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="VvtqeeQq"
ARC-Seal: i=1; a=rsa-sha256; t=1746029818; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=NjUlP1yDA6kYssqar+FvK4IPdZyHyfT1rLih5R3Q39QS1LfByBsOkNb2Q9p957dXFzIdcXKeVLssDrX6dkmGdBos1gDkAEDHPPB47ZkCblX2WZE2Q+44SatT8Igc6iuCUeVK6SaurZCiTFhEZfUNRLmhw3oppKAhoOK5CCrTlTM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1746029818; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=miz3B/I//7xxwp1CvpT8pZXSR6y64zliezCF/FrAZu4=; 
	b=aU1ppuF74vhIj8HW4foewP06s1FANbHflwFaUaRN7LbHPw5kGUmflDc7f+ilDYfZzM8PZc6bAu+Bc+35q41UmVr+1fMNImFbMc0zMiozzD4Ix7sJQ+Sc7lSEMnlMC3K0xMTCytTmQRVhfnyPwh932ucT7xpZtMbfai8SdQpxsgY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1746029818;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=miz3B/I//7xxwp1CvpT8pZXSR6y64zliezCF/FrAZu4=;
	b=VvtqeeQq/nFwp4s3RUz8Oyk51aWbzOpxvXIeXsQR2gvPwk3+hoaI8NkDx4SpiL1d
	SRmV7EnTGhJONqYv6pe4+0fg6Y/hjBldMoBXu77rnLdiTtpuyXrU+kRL97Lz25WMBLw
	+a+lnW92NwPAywDW+LPSOGvfo7qiOANCrtWjaRls=
Received: by mx.zohomail.com with SMTPS id 1746029817715939.6265872431574;
	Wed, 30 Apr 2025 09:16:57 -0700 (PDT)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Wed, 30 Apr 2025 18:16:35 +0200
Subject: [PATCH 2/3] hwrng: rockchip - add support for RK3576's RNG
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250430-rk3576-hwrng-v1-2-480c15b5843e@collabora.com>
References: <20250430-rk3576-hwrng-v1-0-480c15b5843e@collabora.com>
In-Reply-To: <20250430-rk3576-hwrng-v1-0-480c15b5843e@collabora.com>
To: Daniel Golle <daniel@makrotopia.org>, 
 Aurelien Jarno <aurelien@aurel32.net>, Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Heiko Stuebner <heiko@sntech.de>, 
 Jonas Karlman <jonas@kwiboo.se>
Cc: Sebastian Reichel <sebastian.reichel@collabora.com>, 
 kernel@collabora.com, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
X-Mailer: b4 0.14.2

The Rockchip RK3576 SoC uses a new hardware random number generator IP.
It's also used on the Rockchip RK3562 and the Rockchip RK3528.

It has several modes of operation and self-checking features that are
not implemented here. For starters, it has a DRNG output, which is an
AES-CTR pseudo-random number generator that can be reseeded from the
true entropy regularly.

However, it also allows for access of the true entropy generator
directly. This entropy is generated from an oscillator.

There are several configuration registers which we don't touch here. The
oscillator can be switched between a "CRO" and "STR" oscillator, and the
length of the oscillator can be configured.

The hardware also supports some automatic continuous entropy quality
checking, which is also not implemented in this driver for the time
being.

The output as-is has been deemed sufficient to be useful:

  rngtest: starting FIPS tests...
  rngtest: bits received from input: 20000032
  rngtest: FIPS 140-2 successes: 997
  rngtest: FIPS 140-2 failures: 3
  rngtest: FIPS 140-2(2001-10-10) Monobit: 0
  rngtest: FIPS 140-2(2001-10-10) Poker: 1
  rngtest: FIPS 140-2(2001-10-10) Runs: 1
  rngtest: FIPS 140-2(2001-10-10) Long run: 1
  rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
  rngtest: input channel speed: (min=17.050; avg=1897.272;
           max=19531250.000)Kibits/s
  rngtest: FIPS tests speed: (min=44.773; avg=71.179; max=96.820)Mibits/s
  rngtest: Program run time: 11760715 microseconds
  rngtest: bits received from input: 40000032
  rngtest: FIPS 140-2 successes: 1997
  rngtest: FIPS 140-2 failures: 3
  rngtest: FIPS 140-2(2001-10-10) Monobit: 0
  rngtest: FIPS 140-2(2001-10-10) Poker: 1
  rngtest: FIPS 140-2(2001-10-10) Runs: 1
  rngtest: FIPS 140-2(2001-10-10) Long run: 1
  rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
  rngtest: input channel speed: (min=17.050; avg=1798.618;
           max=19531250.000)Kibits/s
  rngtest: FIPS tests speed: (min=44.773; avg=64.561; max=96.820)Mibits/s
  rngtest: Program run time: 23507723 microseconds

Stretching the entropy can then be left up to Linux's actual entropy
pool.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/char/hw_random/rockchip-rng.c | 73 +++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/drivers/char/hw_random/rockchip-rng.c b/drivers/char/hw_random/rockchip-rng.c
index 161050591663d9ed61ca013631c86f40db7d348f..fb4a30b955075889191d960cf03364af7f5b7069 100644
--- a/drivers/char/hw_random/rockchip-rng.c
+++ b/drivers/char/hw_random/rockchip-rng.c
@@ -93,6 +93,30 @@
 #define TRNG_v1_VERSION_CODE			0x46bc
 /* end of TRNG_V1 register definitions */
 
+/*
+ * RKRNG register definitions
+ * The RKRNG IP is a stand-alone TRNG implementation (not part of a crypto IP)
+ * and can be found in the Rockchip RK3576, Rockchip RK3562 and Rockchip RK3528
+ * SoCs. It can either output true randomness (TRNG) or "deterministic"
+ * randomness derived from hashing the true entropy (DRNG). This driver
+ * implementation uses just the true entropy, and leaves stretching the entropy
+ * up to Linux.
+ */
+#define RKRNG_CFG				0x0000
+#define RKRNG_CTRL				0x0010
+#define RKRNG_CTRL_REQ_TRNG			BIT(4)
+#define RKRNG_STATE				0x0014
+#define RKRNG_STATE_TRNG_RDY			BIT(4)
+#define RKRNG_TRNG_DATA0			0x0050
+#define RKRNG_TRNG_DATA1			0x0054
+#define RKRNG_TRNG_DATA2			0x0058
+#define RKRNG_TRNG_DATA3			0x005C
+#define RKRNG_TRNG_DATA4			0x0060
+#define RKRNG_TRNG_DATA5			0x0064
+#define RKRNG_TRNG_DATA6			0x0068
+#define RKRNG_TRNG_DATA7			0x006C
+#define RKRNG_READ_LEN				32
+
 /* Before removing this assert, give rk3588_rng_read an upper bound of 32 */
 static_assert(RK_RNG_MAX_BYTE <= (TRNG_V1_RAND7 + 4 - TRNG_V1_RAND0),
 	      "You raised RK_RNG_MAX_BYTE and broke rk3588-rng, congrats.");
@@ -205,6 +229,46 @@ static int rk3568_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 	return (ret < 0) ? ret : to_read;
 }
 
+static int rk3576_rng_init(struct hwrng *rng)
+{
+	struct rk_rng *rk_rng = container_of(rng, struct rk_rng, rng);
+
+	return rk_rng_enable_clks(rk_rng);
+}
+
+static int rk3576_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
+{
+	struct rk_rng *rk_rng = container_of(rng, struct rk_rng, rng);
+	size_t to_read = min_t(size_t, max, RKRNG_READ_LEN);
+	int ret = 0;
+	u32 val;
+
+	ret = pm_runtime_resume_and_get(rk_rng->dev);
+	if (ret < 0)
+		return ret;
+
+	rk_rng_writel(rk_rng, RKRNG_CTRL_REQ_TRNG | (RKRNG_CTRL_REQ_TRNG << 16),
+		      RKRNG_CTRL);
+
+	if (readl_poll_timeout(rk_rng->base + RKRNG_STATE, val,
+			       (val & RKRNG_STATE_TRNG_RDY), RK_RNG_POLL_PERIOD_US,
+			       RK_RNG_POLL_TIMEOUT_US)) {
+		dev_err(rk_rng->dev, "timed out waiting for data\n");
+		ret = -ETIMEDOUT;
+		goto out;
+	}
+
+	rk_rng_writel(rk_rng, RKRNG_STATE_TRNG_RDY, RKRNG_STATE);
+
+	memcpy_fromio(buf, rk_rng->base + RKRNG_TRNG_DATA0, to_read);
+
+out:
+	pm_runtime_mark_last_busy(rk_rng->dev);
+	pm_runtime_put_sync_autosuspend(rk_rng->dev);
+
+	return (ret < 0) ? ret : to_read;
+}
+
 static int rk3588_rng_init(struct hwrng *rng)
 {
 	struct rk_rng *rk_rng = container_of(rng, struct rk_rng, rng);
@@ -305,6 +369,14 @@ static const struct rk_rng_soc_data rk3568_soc_data = {
 	.reset_optional = false,
 };
 
+static const struct rk_rng_soc_data rk3576_soc_data = {
+	.rk_rng_init = rk3576_rng_init,
+	.rk_rng_read = rk3576_rng_read,
+	.rk_rng_cleanup = rk3588_rng_cleanup,
+	.quality = 999,		/* as determined by actual testing */
+	.reset_optional = true,
+};
+
 static const struct rk_rng_soc_data rk3588_soc_data = {
 	.rk_rng_init = rk3588_rng_init,
 	.rk_rng_read = rk3588_rng_read,
@@ -397,6 +469,7 @@ static const struct dev_pm_ops rk_rng_pm_ops = {
 
 static const struct of_device_id rk_rng_dt_match[] = {
 	{ .compatible = "rockchip,rk3568-rng", .data = (void *)&rk3568_soc_data },
+	{ .compatible = "rockchip,rk3576-rng", .data = (void *)&rk3576_soc_data },
 	{ .compatible = "rockchip,rk3588-rng", .data = (void *)&rk3588_soc_data },
 	{ /* sentinel */ },
 };

-- 
2.49.0

