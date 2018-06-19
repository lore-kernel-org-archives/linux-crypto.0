From: Vinod Koul <vinod.koul@linaro.org>
Subject: [PATCH v2 2/2] hwrng: msm - Add support for prng v2
Date: Tue, 19 Jun 2018 15:24:30 +0530
Message-ID: <20180619095430.26358-3-vkoul@kernel.org>
References: <20180619095430.26358-1-vkoul@kernel.org>
Cc: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        vinod.koul@linaro.org, Vinod Koul <vkoul@kernel.org>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180619095430.26358-1-vkoul@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Qcom 8996 and later chips support prng v2 which requires to
implement only .read callback for hwrng.

This version of chip has multiple Execution Environments (EE) and
secure world is typically responsible for configuring the prng.

Add driver data for qcom,prng as 0 and qcom,prng-v2 as 1 and use
that to skip initialization and cleanup routines.

Signed-off-by: Vinod Koul <vkoul@kernel.org>
---
 drivers/char/hw_random/msm-rng.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/msm-rng.c b/drivers/char/hw_random/msm-rng.c
index 841fee845ec9..4676520e1f16 100644
--- a/drivers/char/hw_random/msm-rng.c
+++ b/drivers/char/hw_random/msm-rng.c
@@ -17,6 +17,7 @@
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 
 /* Device specific register offsets */
@@ -131,6 +132,7 @@ static int msm_rng_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct msm_rng *rng;
+	unsigned int skip_init;
 	int ret;
 
 	rng = devm_kzalloc(&pdev->dev, sizeof(*rng), GFP_KERNEL);
@@ -149,9 +151,12 @@ static int msm_rng_probe(struct platform_device *pdev)
 		return PTR_ERR(rng->clk);
 
 	rng->hwrng.name = KBUILD_MODNAME,
-	rng->hwrng.init = msm_rng_init,
-	rng->hwrng.cleanup = msm_rng_cleanup,
-	rng->hwrng.read = msm_rng_read,
+	rng->hwrng.read = msm_rng_read;
+	skip_init = (unsigned long)of_device_get_match_data(&pdev->dev);
+	if (!skip_init) {
+		rng->hwrng.init = msm_rng_init;
+		rng->hwrng.cleanup = msm_rng_cleanup;
+	}
 
 	ret = devm_hwrng_register(&pdev->dev, &rng->hwrng);
 	if (ret) {
@@ -163,7 +168,8 @@ static int msm_rng_probe(struct platform_device *pdev)
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
