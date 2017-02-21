From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v2 3/3] hwrng: meson: add clock handling to driver
Date: Tue, 21 Feb 2017 21:26:20 +0100
Message-ID: <989cf7bf-b7ea-0b41-510b-6eab403f0185@gmail.com>
References: <daf765e2-1a60-8dea-fee0-8af6ddecdf8e@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-clk@vger.kernel.org, devicetree@vger.kernel.org
To: Jerome Brunet <jbrunet@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org, linux-crypto@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Michael Turquette <mturquette@baylibre.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33900 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751161AbdBUU0b (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Feb 2017 15:26:31 -0500
In-Reply-To: <daf765e2-1a60-8dea-fee0-8af6ddecdf8e@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add handling of RNG0 clock to the driver.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
v2:
- consider that clock is optional
- use managed call to clk_disable_unprepare to ensure that
  cleaning up is done in the right order if driver is removed
---
 drivers/char/hw_random/meson-rng.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/char/hw_random/meson-rng.c b/drivers/char/hw_random/meson-rng.c
index 119d6984..2e23be80 100644
--- a/drivers/char/hw_random/meson-rng.c
+++ b/drivers/char/hw_random/meson-rng.c
@@ -62,6 +62,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/of.h>
+#include <linux/clk.h>
 
 #define RNG_DATA 0x00
 
@@ -69,6 +70,7 @@ struct meson_rng_data {
 	void __iomem *base;
 	struct platform_device *pdev;
 	struct hwrng rng;
+	struct clk *core_clk;
 };
 
 static int meson_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
@@ -81,11 +83,17 @@ static int meson_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 	return sizeof(u32);
 }
 
+static void meson_rng_clk_disable(void *clk)
+{
+	clk_disable_unprepare(clk);
+}
+
 static int meson_rng_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct meson_rng_data *data;
 	struct resource *res;
+	int ret;
 
 	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
@@ -98,6 +106,20 @@ static int meson_rng_probe(struct platform_device *pdev)
 	if (IS_ERR(data->base))
 		return PTR_ERR(data->base);
 
+	data->core_clk = devm_clk_get(dev, "core");
+	if (IS_ERR(data->core_clk))
+		data->core_clk = NULL;
+
+	if (data->core_clk) {
+		ret = clk_prepare_enable(data->core_clk);
+		if (ret)
+			return ret;
+		ret = devm_add_action_or_reset(dev, meson_rng_clk_disable,
+					       data->core_clk);
+		if (ret)
+			return ret;
+	}
+
 	data->rng.name = pdev->name;
 	data->rng.read = meson_rng_read;
 
-- 
2.11.1
