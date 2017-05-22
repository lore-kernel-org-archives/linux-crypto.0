From: Cosar Dindar <cosardindar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 2/5] crypto : stm32 - Add STM32F4 CRC32 support
Date: Mon, 22 May 2017 17:34:24 +0300
Message-ID: <3c520bbef98c630ca7de609f8ec27405e2ac07d4.1495463449.git.cosardindar@gmail.com>
References: <cover.1495463449.git.cosardindar@gmail.com>
Cc: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org,
        mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, alexandre.torgue-qxv4g6HH51o@public.gmane.org,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        fabien.dessenne-qxv4g6HH51o@public.gmane.org, Cosar Dindar <cosardindar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1495463449.git.cosardindar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

This patch adds CRC (CRC32 Crypto) support for STM32F4 series.

As an hardware limitation polynomial and key setting are not supported.
They are fixed as 0x4C11DB7 (poly) and 0xFFFFFFFF (key).
CRC32C Castagnoli algorithm is not used.

Signed-off-by: Cosar Dindar <cosardindar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/crypto/stm32/stm32_crc32.c | 68 ++++++++++++++++++++++++++++++++------
 1 file changed, 58 insertions(+), 10 deletions(-)

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
