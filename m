Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795508436;
	b=W3cPavHmzr9kvM2LtBcaPV6UgdfqxLjpgs7BGiypVKUfmhftKe9lyPsMHq8YbHNvqhcn
	 aIYzdpdTDhNhy2tNqsoteHgH6Op5sLZ0iIxvm5sRiAZfOkS2IhSATKiHIFYE+HXpc0UvZ
	 v5U9OfKG5bA1tnbd8gazyAX/YZcPriIsbSjkd8NxoCrTMdy+FuvWAa7vQaQKV4/4WpTTu
	 Bo0pG7XtGH5YFoVCEMbM/e9+Nc8SgHvtJujJTHQvPg1d/ZiZUTg9sbH5SAIjiSQ7n6cFT
	 wegxgYTujkr/4TYgBcOmrCZaxZzZ5Zjqn0aXYM1C8ynn6au3H8QwjDg3QlhWEwp53nQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795508436;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=aSK3uZGdL2yKOLTc3rwVRQD1pUWB4xKuWSy7NRpYEdg=;
	b=FaxRNccRWA59Ma1vPLY9YVjsjoM2hz0XyxLy1DsTSwUEYoN0nKJ/rBVOIDp40lIEh0hR
	 x/40LCsEr/RfYDxuI2DU5vjiIhJq264G8fiDrX7YuUNx8FyPViOCqyQg0+1Xv2WJuB2kw
	 DxQkcJPGwZm+sz36MGMpavYSJGWCuWqFcOe5rowOBBS8gz5QKfaMspVzsVG/n1PbTC7Oz
	 QbiRXpas5rvaOv+SNjuzUidgxlBvNS9l9IyF+REQvyEqsp4TbUSB0PNljf86MtqGN6+l8
	 lkPEABSRFc99gqBRSB1AFjZ2s+s7v6Wxc67qo6WUCoYwHp4ddj1T2mEaRpCYrrEgTjQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JzpLzb8T;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D38606A33C;
	Tue, 24 Nov 2026 08:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JzpLzb8T
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795508435;
	b=Om6rhg6u8TKr8HaHx5fPOHRd6opMyx4mHlCrOK24UAIbsmYmToiE+fwYpeoDltS1Y1XQ
	 MPOd7gcFkv81Tt3Xc0TRuBtZAicUIGezdE/pQPU4ohegWpReM8fSIYTT9x89lxSrrlUcU
	 BUmN3agV7JXMsOeRXGE/8o9ofhwcvb7B8f2PMD0uPfmOwErLk0PZ9sd+yKI1xsW2upPeR
	 dmHhDdD6TIZpDjJe5bh1G4j/HA0PBxy8m9vEJ3rZPr9HqEw9XsUwEmr+uInsy3M6W+n99
	 qQliMDXbtBS8ImzLQ2qffAELNLM7EBWmg6XFVc5SOwZXZNThfl6shXQWXrcoTZdT6lQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795508435;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=aSK3uZGdL2yKOLTc3rwVRQD1pUWB4xKuWSy7NRpYEdg=;
	b=3S95cs9WLZxpgFPwIBbFa5lVkenJcV4J82R/aq2dx0K+rhgS85ovUqqUZKJ9QiSmK2rU
	 1rCBvkTFejf0YTITv7vgcs/s7VVwX7Ke4uhQpA4uzrrqEQGfvOtNbGyDV8rAE6Q5ZnIYN
	 0mt9utHtyJhdN9PUJkAfU8SZiugiKgFVUItflLbLkeuGJQn+f5TQcZn8y+78npe2+yfcR
	 Cg+nHeMaDyPjyGhM/228e0K6R9IaVnKsTIR9J1DhOMF9taqreBydZ8SbaeKDUGCLMwZdJ
	 cjXrTUp5YOa10uT06R1TScoGG0U1INHoSbI8w1XLeq/I1txs+vU5ypUchuxBKG4LC5g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 77DE01F000CF;
	Tue, 24 Nov 2026 08:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795508435;
	bh=aSK3uZGdL2yKOLTc3rwVRQD1pUWB4xKuWSy7NRpYEdg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=JzpLzb8TIp/Kj4h7fOs3AnSfOvdCxY/yZi02oWqeW+VpFZE8ZjU+gXybOTU47UZ5r
	 DsIzEMvr2dbF43mmGkQ+b3RnGBXDRu7cBYeOxXsNTXyuWS54CjtPl4qT4Z4r/3OEso
	 UiNPtG1o61Eaw27OyD3nWj6Ck5ELjfuR0O7IeF0ErLNn9QmTI5bB/wmcuoWnQfaEnR
	 SJlh1Kv878YzOYi1P3IbB9W7yxRsThHJ/BCUStRxv99MRCl9dRvw4J+j85XVdl9tTS
	 KyMgC2LLHHVbkuVPe9WNArDR9swIx36FWzhMRXh2ML3DpGMTYM7EVf8y9HcdpBIxck
	 R8H+8Yn1MhVaw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 09F2F4C93D;
	Tue, 24 Nov 2026 08:20:21 +0000 (UTC)
From: Fil Dunsky via B4 Relay <devnull+filipp.dunsky.gmail.com@kernel.org>
Date: Tue, 24 Nov 2026 11:20:20 +0300
Subject: [PATCH v2 2/3] hwrng: Add Cortina Systems CS7542 TRNG driver
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261124-b4-cs7542-trng-v2-2-0192937b44be@gmail.com>
References: <20261124-b4-cs7542-trng-v2-0-0192937b44be@gmail.com>
In-Reply-To: <20261124-b4-cs7542-trng-v2-0-0192937b44be@gmail.com>
To: Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>
Cc: =?utf-8?q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>, 
 linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795508418; l=7579;
 i=filipp.dunsky@gmail.com; s=20260930; h=from:subject:message-id;
 bh=EbhGuW4MhEmmYMpCueJmo2Q0TXeXTrLb12lTWkCu7Fk=;
 b=2ENFilAs7BivhuX0dExb/hOBvlkya5wFsxKdbYO2u9XEpXkyXH5E/vpkEUOaLnQIniqdGnsb1
 AGTdcLjbBaTAVLKot6Arch91JtKQMwjw2RZascgOSqMe0tX0VUW8LTp
X-Developer-Key: i=filipp.dunsky@gmail.com; a=ed25519;
 pk=JAYP8e2rJ54DHOmhNtXud8rl1igAaAXoOHxtJmVXI1g=
X-Endpoint-Received: by B4 Relay for filipp.dunsky@gmail.com/20260930 with
 auth_id=1085
X-Original-From: Fil Dunsky <filipp.dunsky@gmail.com>
Reply-To: filipp.dunsky@gmail.com
Content-Transfer-Encoding: 7bit

From: Fil Dunsky <filipp.dunsky@gmail.com>

Adapt the OpenWrt implementation to use a syscon regmap for the shared
scratch bit. Bound polling and retain a pending request across
nonblocking calls instead of entering a blocking poll when wait=false.
Handle partial output and wipe the temporary data on error paths.

Retain the existing OpenWrt entropy quality setting of 512 for review.
Hardware output smoke tests do not establish an entropy estimate.

Restrict hardware reseeding to the documented CS7542 A1 revision, using
identification bits read through the global syscon before registration.
The vendor driver avoids ring reseeding on A0 for erratum 28891; its
RTC/timer-derived nonce workaround is not a replacement entropy source.
Propagate identification errors and reject unsupported revisions.

Signed-off-by: Fil Dunsky <filipp.dunsky@gmail.com>
---
 drivers/char/hw_random/Kconfig       |  11 +++
 drivers/char/hw_random/Makefile      |   1 +
 drivers/char/hw_random/cs75xx-trng.c | 187 +++++++++++++++++++++++++++++++++++
 3 files changed, 199 insertions(+)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index d3108991c..1c6a3f9f8 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -648,6 +648,17 @@ config HW_RANDOM_QCOM
 	  To compile this driver as a module, choose M here. The
 	  module will be called qcom-rng. If unsure, say N.
 
+
+config HW_RANDOM_CS75XX
+	tristate "Cortina Systems CS7542 random number generator"
+	depends on OF && HAS_IOMEM
+	select MFD_SYSCON
+	help
+	  Support the Elliptic random number generator in the CS7542 SoC.
+	  Access the shared global control block through a syscon regmap.
+	  Provide polled reads through the hardware RNG framework.
+	  The module will be named cs75xx-trng.
+
 endif # HW_RANDOM
 
 config UML_RANDOM
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index 8fce2aa6c..b7b5fdaa7 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -55,3 +55,4 @@ obj-$(CONFIG_HW_RANDOM_ROCKCHIP) += rockchip-rng.o
 obj-$(CONFIG_HW_RANDOM_JH7110) += jh7110-trng.o
 obj-$(CONFIG_HW_RANDOM_XILINX) += xilinx-trng.o
 obj-$(CONFIG_HW_RANDOM_QCOM) += qcom-rng.o
+obj-$(CONFIG_HW_RANDOM_CS75XX)		+= cs75xx-trng.o
diff --git a/drivers/char/hw_random/cs75xx-trng.c b/drivers/char/hw_random/cs75xx-trng.c
new file mode 100644
index 000000000..588a01aae
--- /dev/null
+++ b/drivers/char/hw_random/cs75xx-trng.c
@@ -0,0 +1,187 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Cortina CS75xx (Goldengate) true random number generator
+ *
+ * The block is an Elliptic TRNG: control at 0x00, interrupt status at 0x04,
+ * interrupt enable at 0x08 and four data words from 0x10. A new value is
+ * requested with GEN_NEW and is ready when the DONE status bit is set.
+ * The vendor driver also sets bit 5 of the GLOBAL_SCRATCH register before
+ * using the block, so does this one.
+ */
+
+#include <linux/bitfield.h>
+#include <linux/bits.h>
+#include <linux/hw_random.h>
+#include <linux/io.h>
+#include <linux/iopoll.h>
+#include <linux/mfd/syscon.h>
+#include <linux/of.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#define TRNG_CTRL		0x00
+#define TRNG_CTRL_GEN_NEW	BIT(0)
+#define TRNG_CTRL_RESEED	BIT(31)
+#define TRNG_IRQ_STAT		0x04
+#define TRNG_IRQ_EN		0x08
+#define TRNG_IRQ_DONE		BIT(27)
+#define TRNG_DATA		0x10
+#define TRNG_WORDS		4
+
+#define GLOBAL_JTAG_ID		0x00
+#define GLOBAL_JTAG_ID_SOC	GENMASK(15, 12)
+#define GLOBAL_JTAG_ID_CS7542_A1	8
+
+#define GLOBAL_SCRATCH		0xc0
+#define GLOBAL_SCRATCH_TRNG	BIT(5)
+
+#define TRNG_TIMEOUT_US		10000
+
+struct cs75xx_trng {
+	struct hwrng rng;
+	void __iomem *base;
+	struct regmap *global;
+	bool pending;
+};
+
+static int cs75xx_trng_wait(struct cs75xx_trng *t)
+{
+	u32 val;
+	int ret;
+
+	ret = readl_poll_timeout(t->base + TRNG_IRQ_STAT, val,
+				 val & TRNG_IRQ_DONE, 1, TRNG_TIMEOUT_US);
+	writel(TRNG_IRQ_DONE, t->base + TRNG_IRQ_STAT);
+	return ret;
+}
+
+static int cs75xx_trng_init(struct hwrng *rng)
+{
+	struct cs75xx_trng *t = container_of(rng, struct cs75xx_trng, rng);
+	int ret;
+
+	ret = regmap_update_bits(t->global, GLOBAL_SCRATCH,
+				 GLOBAL_SCRATCH_TRNG, GLOBAL_SCRATCH_TRNG);
+	if (ret)
+		return ret;
+	writel(0, t->base + TRNG_IRQ_EN);
+	writel(TRNG_IRQ_DONE, t->base + TRNG_IRQ_STAT);
+	t->pending = false;
+	writel(TRNG_CTRL_RESEED, t->base + TRNG_CTRL);
+	return cs75xx_trng_wait(t);
+}
+
+static int cs75xx_trng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
+{
+	struct cs75xx_trng *t = container_of(rng, struct cs75xx_trng, rng);
+	u32 data[TRNG_WORDS];
+	size_t done = 0;
+	int i, ret;
+
+	while (done < max) {
+		size_t n = min(max - done, sizeof(data));
+
+		if (!t->pending) {
+			writel(TRNG_IRQ_DONE, t->base + TRNG_IRQ_STAT);
+			writel(TRNG_CTRL_GEN_NEW, t->base + TRNG_CTRL);
+			t->pending = true;
+		}
+
+		if (wait) {
+			ret = cs75xx_trng_wait(t);
+		} else {
+			if (!(readl(t->base + TRNG_IRQ_STAT) & TRNG_IRQ_DONE))
+				break;
+			writel(TRNG_IRQ_DONE, t->base + TRNG_IRQ_STAT);
+			ret = 0;
+		}
+		t->pending = false;
+		if (ret) {
+			memzero_explicit(data, sizeof(data));
+			return done ? done : ret;
+		}
+
+		for (i = 0; i < TRNG_WORDS; i++)
+			data[i] = readl(t->base + TRNG_DATA + 4 * i);
+		memcpy((u8 *)buf + done, data, n);
+		done += n;
+
+		if (!wait)
+			break;
+	}
+
+	memzero_explicit(data, sizeof(data));
+	return done;
+}
+
+/* A0 ring reseeding is affected by vendor erratum 28891. Do not replace
+ * the entropy source with the vendor's RTC/timer-derived nonce workaround.
+ */
+static int cs75xx_trng_check_revision(struct device *dev, struct regmap *global)
+{
+	u32 id;
+	int ret;
+
+	ret = regmap_read(global, GLOBAL_JTAG_ID, &id);
+	if (ret)
+		return dev_err_probe(dev, ret, "cannot read SoC revision\n");
+
+	if (FIELD_GET(GLOBAL_JTAG_ID_SOC, id) != GLOBAL_JTAG_ID_CS7542_A1)
+		return dev_err_probe(dev, -ENODEV,
+				     "hardware reseeding requires CS7542 A1\n");
+
+	return 0;
+}
+
+static int cs75xx_trng_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct cs75xx_trng *t;
+	int ret;
+
+	t = devm_kzalloc(dev, sizeof(*t), GFP_KERNEL);
+	if (!t)
+		return -ENOMEM;
+
+	t->base = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(t->base))
+		return PTR_ERR(t->base);
+
+	t->global = syscon_regmap_lookup_by_phandle(dev->of_node,
+						    "cortina,syscon");
+	if (IS_ERR(t->global))
+		return dev_err_probe(dev, PTR_ERR(t->global),
+				     "cannot get global control regmap\n");
+
+	ret = cs75xx_trng_check_revision(dev, t->global);
+	if (ret)
+		return ret;
+
+	t->rng.name = dev_name(dev);
+	t->rng.init = cs75xx_trng_init;
+	t->rng.read = cs75xx_trng_read;
+	t->rng.quality = 512;
+
+	return devm_hwrng_register(dev, &t->rng);
+}
+
+static const struct of_device_id cs75xx_trng_of_match[] = {
+	{ .compatible = "cortina,cs7542-trng" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, cs75xx_trng_of_match);
+
+static struct platform_driver cs75xx_trng_driver = {
+	.probe = cs75xx_trng_probe,
+	.driver = {
+		.name = "cs75xx-trng",
+		.of_match_table = cs75xx_trng_of_match,
+	},
+};
+module_platform_driver(cs75xx_trng_driver);
+
+MODULE_DESCRIPTION("Cortina CS75xx TRNG driver");
+MODULE_LICENSE("GPL");

-- 
2.53.0


