From: Heiner Kallweit <hkallweit1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 4/4] hwrng: meson: add clock handling to driver
Date: Wed, 22 Feb 2017 08:02:31 +0100
Message-ID: <a561e156-f735-7a26-120b-e6c1ba13affd@gmail.com>
References: <4e2d12e5-f75b-3ac6-a3f7-18e8a8b7283b@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-clk-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jerome Brunet <jbrunet-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>,
        Kevin Hilman <khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        Neil Armstrong <narmstrong-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>,
        linux-amlogic-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>,
        Michael Turquette <mturquette-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4e2d12e5-f75b-3ac6-a3f7-18e8a8b7283b-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Add handling of RNG0 clock to the driver.

Signed-off-by: Heiner Kallweit <hkallweit1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
v2:
- consider that clock is optional
- use managed call to clk_disable_unprepare to ensure that
  cleaning up is done in the right order if driver is removed
v3:
- no changes
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
 
+static void meson_rng_clk_disable(void *data)
+{
+	clk_disable_unprepare(data);
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


--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
