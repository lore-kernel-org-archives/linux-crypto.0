From: Chen-Yu Tsai <wens-jdAy2FN1RRM@public.gmane.org>
Subject: [PATCH 2/3] crypto: sunxi-ss: Add optional reset control support
Date: Tue, 11 Aug 2015 13:32:56 +0800
Message-ID: <1439271177-26523-3-git-send-email-wens@csie.org>
References: <1439271177-26523-1-git-send-email-wens@csie.org>
Cc: Chen-Yu Tsai <wens-jdAy2FN1RRM@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
	Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
	Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1439271177-26523-1-git-send-email-wens-jdAy2FN1RRM@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On sun6i and later platforms, the reset control is split out of the
clock gates. Add support for an optional reset control.

Signed-off-by: Chen-Yu Tsai <wens-jdAy2FN1RRM@public.gmane.org>
---
 drivers/crypto/sunxi-ss/sun4i-ss-core.c | 22 ++++++++++++++++++++++
 drivers/crypto/sunxi-ss/sun4i-ss.h      |  2 ++
 2 files changed, 24 insertions(+)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-core.c b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
index 0b79b58c913b..eab6fe227fa0 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-core.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
@@ -22,6 +22,7 @@
 #include <linux/scatterlist.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
+#include <linux/reset.h>
 
 #include "sun4i-ss.h"
 
@@ -253,6 +254,14 @@ static int sun4i_ss_probe(struct platform_device *pdev)
 	}
 	dev_dbg(&pdev->dev, "clock ahb_ss acquired\n");
 
+	ss->reset = devm_reset_control_get_optional(&pdev->dev, "ahb");
+	if (IS_ERR(ss->reset)) {
+		if (PTR_ERR(ss->reset) == -EPROBE_DEFER)
+			return PTR_ERR(ss->reset);
+		dev_info(&pdev->dev, "no reset control found\n");
+		ss->reset = NULL;
+	}
+
 	/* Enable both clocks */
 	err = clk_prepare_enable(ss->busclk);
 	if (err != 0) {
@@ -275,6 +284,15 @@ static int sun4i_ss_probe(struct platform_device *pdev)
 		goto error_clk;
 	}
 
+	/* Deassert reset if we have a reset control */
+	if (ss->reset) {
+		err = reset_control_deassert(ss->reset);
+		if (err) {
+			dev_err(&pdev->dev, "Cannot deassert reset control\n");
+			goto error_clk;
+		}
+	}
+
 	/*
 	 * The only impact on clocks below requirement are bad performance,
 	 * so do not print "errors"
@@ -352,6 +370,8 @@ error_alg:
 			break;
 		}
 	}
+	if (ss->reset)
+		reset_control_assert(ss->reset);
 error_clk:
 	clk_disable_unprepare(ss->ssclk);
 error_ssclk:
@@ -376,6 +396,8 @@ static int sun4i_ss_remove(struct platform_device *pdev)
 	}
 
 	writel(0, ss->base + SS_CTL);
+	if (ss->reset)
+		reset_control_assert(ss->reset);
 	clk_disable_unprepare(ss->busclk);
 	clk_disable_unprepare(ss->ssclk);
 	return 0;
diff --git a/drivers/crypto/sunxi-ss/sun4i-ss.h b/drivers/crypto/sunxi-ss/sun4i-ss.h
index db18b2554e6f..8e9c05f6e4d4 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss.h
+++ b/drivers/crypto/sunxi-ss/sun4i-ss.h
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/reset.h>
 #include <crypto/scatterwalk.h>
 #include <linux/scatterlist.h>
 #include <linux/interrupt.h>
@@ -129,6 +130,7 @@ struct sun4i_ss_ctx {
 	int irq;
 	struct clk *busclk;
 	struct clk *ssclk;
+	struct reset_control *reset;
 	struct device *dev;
 	struct resource *res;
 	spinlock_t slock; /* control the use of the device */
-- 
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
