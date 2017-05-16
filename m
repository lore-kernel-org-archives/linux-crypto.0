From: Cosar Dindar <cosardindar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] crypto: stm32 - Add CRC32 support for STM32F4XX
Date: Wed, 17 May 2017 00:18:50 +0300
Message-ID: <1494969530-91589-1-git-send-email-cosardindar@gmail.com>
Cc: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org,
        mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, alexandre.torgue-qxv4g6HH51o@public.gmane.org,
        linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org,
        fabien.dessenne-qxv4g6HH51o@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cosar Dindar <cosardindar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

This patch series add hardware CRC32 ("Ethernet") calculation support
for STMicroelectronics STM32F4XX series devices.

As an hardware limitation polynomial and key setting are not supported
as they are fixed as 0x4C11DB7 (poly) and 0xFFFFFFFF (key).

CRC32C Castagnoli algorithm is not supported also.
Module is tested on STM32F429-disco board with crypto testmgr using
cases within the key 0xFFFFFFFF.

Signed-off-by: Cosar Dindar <cosardindar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 .../devicetree/bindings/crypto/st,stm32-crc.txt    |  4 +-
 arch/arm/boot/dts/stm32429i-eval.dts               |  4 ++
 arch/arm/boot/dts/stm32f429-disco.dts              |  4 ++
 arch/arm/boot/dts/stm32f429.dtsi                   |  7 +++
 arch/arm/boot/dts/stm32f469-disco.dts              |  4 ++
 drivers/crypto/stm32/stm32_crc32.c                 | 68 ++++++++++++++++++----
 6 files changed, 79 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt b/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt
index 3ba92a5..7b30f1e 100644
--- a/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt
+++ b/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt
@@ -1,7 +1,7 @@
 * STMicroelectronics STM32 CRC
 
 Required properties:
-- compatible: Should be "st,stm32f7-crc".
+- compatible: Can be either "st,stm32f7-crc" or "st,srm32f4-crc".
 - reg: The address and length of the peripheral registers space
 - clocks: The input clock of the CRC instance
 
@@ -10,7 +10,7 @@ Optional properties: none
 Example:
 
 crc: crc@40023000 {
-	compatible = "st,stm32f7-crc";
+	compatible = "st,stm32f7-crc", "st,stm32f4-crc";
 	reg = <0x40023000 0x400>;
 	clocks = <&rcc 0 12>;
 };
diff --git a/arch/arm/boot/dts/stm32429i-eval.dts b/arch/arm/boot/dts/stm32429i-eval.dts
index b633114..360fb19 100644
--- a/arch/arm/boot/dts/stm32429i-eval.dts
+++ b/arch/arm/boot/dts/stm32429i-eval.dts
@@ -141,6 +141,10 @@
 	clock-frequency = <25000000>;
 };
 
+&crc {
+	status = "okay";
+};
+
 &i2c1 {
 	pinctrl-0 = <&i2c1_pins>;
 	pinctrl-names = "default";
diff --git a/arch/arm/boot/dts/stm32f429-disco.dts b/arch/arm/boot/dts/stm32f429-disco.dts
index 191fa50..ae47cde 100644
--- a/arch/arm/boot/dts/stm32f429-disco.dts
+++ b/arch/arm/boot/dts/stm32f429-disco.dts
@@ -102,6 +102,10 @@
 	clock-frequency = <8000000>;
 };
 
+&crc {
+	status = "okay";
+};
+
 &rtc {
 	assigned-clocks = <&rcc 1 CLK_RTC>;
 	assigned-clock-parents = <&rcc 1 CLK_LSI>;
diff --git a/arch/arm/boot/dts/stm32f429.dtsi b/arch/arm/boot/dts/stm32f429.dtsi
index b2a2b5c..18343de 100644
--- a/arch/arm/boot/dts/stm32f429.dtsi
+++ b/arch/arm/boot/dts/stm32f429.dtsi
@@ -766,6 +766,13 @@
 			};
 		};
 
+		crc: crc@40023000 {
+			compatible = "st,stm32f4-crc";
+			reg = <0x40023000 0x400>;
+			clocks = <&rcc 0 STM32F4_AHB1_CLOCK(CRC)>;
+			status = "disabled";
+		};
+
 		rcc: rcc@40023810 {
 			#reset-cells = <1>;
 			#clock-cells = <2>;
diff --git a/arch/arm/boot/dts/stm32f469-disco.dts b/arch/arm/boot/dts/stm32f469-disco.dts
index 75470c3..8cb8b73 100644
--- a/arch/arm/boot/dts/stm32f469-disco.dts
+++ b/arch/arm/boot/dts/stm32f469-disco.dts
@@ -87,6 +87,10 @@
 	clock-frequency = <8000000>;
 };
 
+&crc {
+	status = "okay";
+};
+
 &rtc {
 	status = "okay";
 };
diff --git a/drivers/crypto/stm32/stm32_crc32.c b/drivers/crypto/stm32/stm32_crc32.c
index ec83b1e..12fbd98 100644
--- a/drivers/crypto/stm32/stm32_crc32.c
+++ b/drivers/crypto/stm32/stm32_crc32.c
@@ -7,6 +7,7 @@
 #include <linux/bitrev.h>
 #include <linux/clk.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 
 #include <crypto/internal/hash.h>
@@ -39,6 +40,9 @@ struct stm32_crc {
 	struct clk       *clk;
 	u8               pending_data[sizeof(u32)];
 	size_t           nb_pending_bytes;
+	bool             key_support;
+	bool             poly_support;
+	bool             reverse_support;
 };
 
 struct stm32_crc_list {
@@ -106,13 +110,31 @@ static int stm32_crc_init(struct shash_desc *desc)
 	}
 	spin_unlock_bh(&crc_list.lock);
 
-	/* Reset, set key, poly and configure in bit reverse mode */
-	writel(bitrev32(mctx->key), ctx->crc->regs + CRC_INIT);
-	writel(bitrev32(mctx->poly), ctx->crc->regs + CRC_POL);
-	writel(CRC_CR_RESET | CRC_CR_REVERSE, ctx->crc->regs + CRC_CR);
+	/* set key */
+	if (ctx->crc->key_support) {
+		writel(bitrev32(mctx->key), ctx->crc->regs + CRC_INIT);
+	} else if (mctx->key != CRC_INIT_DEFAULT) {
+		dev_err(ctx->crc->dev, "Unsupported key value! Should be: 0x%x\n",
+			CRC_INIT_DEFAULT);
+		return -EINVAL;
+	}
+
+	/* set poly */
+	if (ctx->crc->poly_support)
+		writel(bitrev32(mctx->poly), ctx->crc->regs + CRC_POL);
+
+	/* reset and configure in bit reverse mode if supported */
+	if (ctx->crc->reverse_support)
+		writel(CRC_CR_RESET | CRC_CR_REVERSE, ctx->crc->regs + CRC_CR);
+	else
+		writel(CRC_CR_RESET, ctx->crc->regs + CRC_CR);
+
+	/* store partial result */
+	if (!ctx->crc->reverse_support)
+		ctx->partial = bitrev32(readl(crc->regs + CRC_DR));
+	else
+		ctx->partial = readl(ctx->crc->regs + CRC_DR);
 
-	/* Store partial result */
-	ctx->partial = readl(ctx->crc->regs + CRC_DR);
 	ctx->crc->nb_pending_bytes = 0;
 
 	return 0;
@@ -135,7 +157,12 @@ static int stm32_crc_update(struct shash_desc *desc, const u8 *d8,
 
 		if (crc->nb_pending_bytes == sizeof(u32)) {
 			/* Process completed pending data */
-			writel(*(u32 *)crc->pending_data, crc->regs + CRC_DR);
+			if (!ctx->crc->reverse_support)
+				writel(bitrev32(*(u32 *)crc->pending_data),
+				       crc->regs + CRC_DR);
+			else
+				writel(*(u32 *)crc->pending_data,
+				       crc->regs + CRC_DR);
 			crc->nb_pending_bytes = 0;
 		}
 	}
@@ -143,10 +170,16 @@ static int stm32_crc_update(struct shash_desc *desc, const u8 *d8,
 	d32 = (u32 *)d8;
 	for (i = 0; i < length >> 2; i++)
 		/* Process 32 bits data */
-		writel(*(d32++), crc->regs + CRC_DR);
+		if (!ctx->crc->reverse_support)
+			writel(bitrev32(*(d32++)), crc->regs + CRC_DR);
+		else
+			writel(*(d32++), crc->regs + CRC_DR);
 
 	/* Store partial result */
-	ctx->partial = readl(crc->regs + CRC_DR);
+	if (!ctx->crc->reverse_support)
+		ctx->partial = bitrev32(readl(crc->regs + CRC_DR));
+	else
+		ctx->partial = readl(crc->regs + CRC_DR);
 
 	/* Check for pending data (non 32 bits) */
 	length &= 3;
@@ -243,6 +276,7 @@ static int stm32_crc_probe(struct platform_device *pdev)
 	struct stm32_crc *crc;
 	struct resource *res;
 	int ret;
+	int algs_size;
 
 	crc = devm_kzalloc(dev, sizeof(*crc), GFP_KERNEL);
 	if (!crc)
@@ -269,13 +303,26 @@ static int stm32_crc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	/* set key, poly and reverse support if device is of F7 series */
+	if (of_device_is_compatible(crc->dev->of_node, "st,stm32f7-crc")) {
+		crc->key_support = true;
+		crc->poly_support = true;
+		crc->reverse_support = true;
+	}
+
 	platform_set_drvdata(pdev, crc);
 
 	spin_lock(&crc_list.lock);
 	list_add(&crc->list, &crc_list.dev_list);
 	spin_unlock(&crc_list.lock);
 
-	ret = crypto_register_shashes(algs, ARRAY_SIZE(algs));
+	/* For F4 series only CRC32 algorithm will be used */
+	if (of_device_is_compatible(crc->dev->of_node, "st,stm32f4-crc"))
+		algs_size = 1;
+	else
+		algs_size = ARRAY_SIZE(algs);
+
+	ret = crypto_register_shashes(algs, algs_size);
 	if (ret) {
 		dev_err(dev, "Failed to register\n");
 		clk_disable_unprepare(crc->clk);
@@ -304,6 +351,7 @@ static int stm32_crc_remove(struct platform_device *pdev)
 
 static const struct of_device_id stm32_dt_ids[] = {
 	{ .compatible = "st,stm32f7-crc", },
+	{ .compatible = "st,stm32f4-crc", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, stm32_dt_ids);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
