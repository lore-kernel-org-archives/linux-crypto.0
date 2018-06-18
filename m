From: Vinod Koul <vinod.koul@linaro.org>
Subject: [PATCH 3/3] hwrng: msm - Add support for prng v2
Date: Mon, 18 Jun 2018 19:42:59 +0530
Message-ID: <20180618141259.23141-4-vkoul@kernel.org>
References: <20180618141259.23141-1-vkoul@kernel.org>
Cc: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Vinod Koul <vkoul@kernel.org>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180618141259.23141-1-vkoul@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Qcom 8996 and later chips support prng v2 where we need to only
implement .read callback for hwrng.

Add a new table for v2 which supports this and get version required for
driver data.

Signed-off-by: Vinod Koul <vkoul@kernel.org>
---
 drivers/char/hw_random/msm-rng.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/msm-rng.c b/drivers/char/hw_random/msm-rng.c
index 7644474035e5..3f509072a6c6 100644
--- a/drivers/char/hw_random/msm-rng.c
+++ b/drivers/char/hw_random/msm-rng.c
@@ -17,6 +17,7 @@
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 
 /* Device specific register offsets */
@@ -132,10 +133,16 @@ static struct hwrng msm_rng = {
 	.read = msm_rng_read,
 };
 
+static struct hwrng msm_rng_v2 = {
+	.name = KBUILD_MODNAME,
+	.read = msm_rng_read,
+};
+
 static int msm_rng_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct msm_rng *rng;
+	unsigned int version;
 	int ret;
 
 	rng = devm_kzalloc(&pdev->dev, sizeof(*rng), GFP_KERNEL);
@@ -154,6 +161,9 @@ static int msm_rng_probe(struct platform_device *pdev)
 		return PTR_ERR(rng->clk);
 
 	rng->hwrng = &msm_rng;
+	version = (unsigned long)of_device_get_match_data(&pdev->dev);
+	if (version)
+		rng->hwrng = &msm_rng_v2;
 
 	rng->hwrng->priv = (unsigned long)rng;
 	ret = devm_hwrng_register(&pdev->dev, rng->hwrng);
@@ -166,7 +176,8 @@ static int msm_rng_probe(struct platform_device *pdev)
 }
 
 static const struct of_device_id msm_rng_of_match[] = {
-	{ .compatible = "qcom,prng", },
+	{ .compatible = "qcom,prng", .data = (void *)0},
+	{ .compatible = "qcom,prng-v2", .data = (void *)1},
 	{}
 };
 MODULE_DEVICE_TABLE(of, msm_rng_of_match);
-- 
2.14.4
