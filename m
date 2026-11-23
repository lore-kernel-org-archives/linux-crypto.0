Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795459315;
	b=d+e6hu0KcBtqivegaUjx7so9lwc/Fqp2rYgV8AqH2df5ndpKt1dMZMi5LUkvb8gbHlUm
	 e/C/Cou0magPvN9ExaKWg0cEsk5hORW1JnUs+3rPUvn5IwWPi78FSUFFpbfaE4wkt5TB9
	 t/Ty8wsHjRkai4ilCYmXASdeXFmLU1y/7PDeDofzHqI+OARoYKmlOaYyI+TI1eCIOegA2
	 VXFmDc59itOLNylI2+wlv1iZlOVuS6jZjIs2DrLvGA7G4lBnZykqLG66JndIsVJKhP7Ud
	 J1R6Sp6DqrRbDsBH3BnWH9ePdkbs3yfD9oYX7J50ObviVC8FvI8cHvgjLmJgtsSQ0sw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795459315;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=HEGGQVuIBFkEhUMA1Ueybmyt4JoPDl4tjH9NOl/AzyM=;
	b=4MdCOhjP4a4jjEQ7nkrjNGbEfnEG2mwFPbrc9cyD9BKKyfRAWNEETU2OwaIYNT/QOO8k
	 MwXWaaQ9XAMbzBvm1VTHfOsQe/UARE0bvZpoiFqE5KTPrKMelkwVWFpZzCBlIn9xlmdmF
	 BT2oAbrL7L97ctLTb6lIraigZuAxkis43hMQzpMS+7vgDGtsPM2PYmU77VBjyD5QfAcXC
	 azTSzs2rxw7WC7XYMUi8mxFkontl6ZcaFUhaTCf1OrD151+F+2mG819VTbEOTLyAhtVcR
	 eIbTfZmSE7KP55tocGhLkpxhwZgwJqJN4bhI/ADf3pDBoqpvJFY/7bqCDW/BzXqhuzg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U1NqD8MW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBDF606A683;
	Mon, 23 Nov 2026 18:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U1NqD8MW
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795459314;
	b=OkxialD/LHBTeP+ofSFD3hVU1/DTDX4w1VbCotDZZH9LOeUQS25MW3EDThZuD4Uy+teg
	 Sm4jJnnmL36ul7qlYYki8M9bq5r/4GCiGS5gXPtIee8JVcgmcIZ8RW3yIebeGNjn8a59z
	 flYMcIiW8Kj1V/tKdqjxyfGk4CQLDQG5eRmWmUBcBaiaUs3PVFVC5pcovG0X19Qkd2qn3
	 P7VutNuo2rWW5F6ed1M+8lI4m2OT46HXxiJs35as2ElYZrlk5JIx8JWailkh/zMUdw9f7
	 rSBC2aLVWsSnjiye/kjo8DRC/OzDsw2idHNYmmnrZx6xgTQCv8t2qts85kGnaTRSD0Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795459314;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=HEGGQVuIBFkEhUMA1Ueybmyt4JoPDl4tjH9NOl/AzyM=;
	b=TkMNtCbJH611XEBsO2CLHi9sc89yFSHqB1/jkpfZCRkhMGQWMwuxL+cxfHhWcB1wBIX5
	 7sVOxZoyteEYQ++NnvW/uYquyoqBqy5PvD4p3bORPZSuzvMEfdjR7Chomj6R/UFhD03G/
	 9xdKgTyT3yVWt3xHiWvzaTsgNAM1mhLw9/Ek9M6elW9SGJ1QfgvmQ1Tma/mwmCW5pCab2
	 9Bw/mGnOLdYJAA7TL18rNwsdEJsb4YHYBRuHnD0/F2YM2zgy9uEzrSuwjgbxn4/pQG8c/
	 cY5VhMbIHSDkVzDbeStph1EUVBU8WXe7uXoIIsVOmX6bNGFVzIhIoseZOWaCaXlpp5A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 794BE1F000D3;
	Mon, 23 Nov 2026 18:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795459314;
	bh=HEGGQVuIBFkEhUMA1Ueybmyt4JoPDl4tjH9NOl/AzyM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=U1NqD8MWeXpLIvMNCSAAYU9vcvCE/lsrTKpgm+GcTRM9IIMfJCpi2XLmKNPFh9Urv
	 vYudcRD+hxZOrXvGJtFrBogeSlrLPzafP5e7DJ8ms+yr3HGez2Pv160uSlUM0fsipv
	 0PPHoIoM/vd3UU3cWWA6wqzydyw96yEba2eqy1GuuRCgFEbylyaHYT77gFWXpHWw5u
	 rFvP4v7uE0uoaEfsZDlE+jYPWy7xt2Sh38DortiIlEv6+8+SCWbrQ8nJWKmDoh4/N+
	 X6GZugg0KtpC2aTzdhKgGwKMJVdXka+mcl/NVMtQOFQz1HWvXzbQ/9LvOHfSceTgXJ
	 xoFr4Wb22fkLA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 550364C5D5;
	Mon, 23 Nov 2026 18:41:35 +0000 (UTC)
From: Fil Dunsky via B4 Relay <devnull+filipp.dunsky.gmail.com@kernel.org>
Date: Mon, 23 Nov 2026 21:41:35 +0300
Subject: [PATCH 2/3] hwrng: Add Cortina Systems CS7542 TRNG driver
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
Message-Id: <20261123-b4-cs7542-trng-v1-2-92d9ffcee531@gmail.com>
References: <20261123-b4-cs7542-trng-v1-0-92d9ffcee531@gmail.com>
In-Reply-To: <20261123-b4-cs7542-trng-v1-0-92d9ffcee531@gmail.com>
To: Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795459294; l=6425;
 i=filipp.dunsky@gmail.com; s=20260930; h=from:subject:message-id;
 bh=CejmhadnINs86sI3uuQCpiGMjWxvRmque4I7XB53Ot4=;
 b=/mF0/7U7u87NRBflb7R5E4A221BOZ0XmRS/f0yI/Up5OecriUR3Q4vfEr+r0XZjrrcp1yELoF
 Pbusqw00garBqjEwA82DrwLB0WgCshIeF1HdjCplyH9jlFaGIiHJtgQ
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

Signed-off-by: Fil Dunsky <filipp.dunsky@gmail.com>
---
 drivers/char/hw_random/Kconfig       |  11 +++
 drivers/char/hw_random/Makefile      |   1 +
 drivers/char/hw_random/cs75xx-trng.c | 159 +++++++++++++++++++++++++++++++++++
 3 files changed, 171 insertions(+)

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
index 000000000..38a1958df
--- /dev/null
+++ b/drivers/char/hw_random/cs75xx-trng.c
@@ -0,0 +1,159 @@
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
+#include <linux/bits.h>
+#include <linux/hw_random.h>
+#include <linux/io.h>
+#include <linux/iopoll.h>
+#include <linux/mfd/syscon.h>
+#include <linux/mod_devicetable.h>
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
+static int cs75xx_trng_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct cs75xx_trng *t;
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


