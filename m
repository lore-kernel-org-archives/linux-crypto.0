From: Vinod Koul <vinod.koul@linaro.org>
Subject: [PATCH 1/3] hwrng: msm - Move hwrng to a table
Date: Mon, 18 Jun 2018 19:42:57 +0530
Message-ID: <20180618141259.23141-2-vkoul@kernel.org>
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

Future versions of msm-prng require bit differs callbacks so move
driver to use a table for hwrng.

No functional change.

Signed-off-by: Vinod Koul <vkoul@kernel.org>
---
 drivers/char/hw_random/msm-rng.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/char/hw_random/msm-rng.c b/drivers/char/hw_random/msm-rng.c
index 841fee845ec9..7644474035e5 100644
--- a/drivers/char/hw_random/msm-rng.c
+++ b/drivers/char/hw_random/msm-rng.c
@@ -38,14 +38,12 @@
 struct msm_rng {
 	void __iomem *base;
 	struct clk *clk;
-	struct hwrng hwrng;
+	struct hwrng *hwrng;
 };
 
-#define to_msm_rng(p)	container_of(p, struct msm_rng, hwrng)
-
 static int msm_rng_enable(struct hwrng *hwrng, int enable)
 {
-	struct msm_rng *rng = to_msm_rng(hwrng);
+	struct msm_rng *rng = (struct msm_rng *)hwrng->priv;
 	u32 val;
 	int ret;
 
@@ -80,7 +78,7 @@ static int msm_rng_enable(struct hwrng *hwrng, int enable)
 
 static int msm_rng_read(struct hwrng *hwrng, void *data, size_t max, bool wait)
 {
-	struct msm_rng *rng = to_msm_rng(hwrng);
+	struct msm_rng *rng = (struct msm_rng *)hwrng->priv;
 	size_t currsize = 0;
 	u32 *retdata = data;
 	size_t maxsize;
@@ -127,6 +125,13 @@ static void msm_rng_cleanup(struct hwrng *hwrng)
 	msm_rng_enable(hwrng, 0);
 }
 
+static struct hwrng msm_rng = {
+	.name = KBUILD_MODNAME,
+	.init = msm_rng_init,
+	.cleanup = msm_rng_cleanup,
+	.read = msm_rng_read,
+};
+
 static int msm_rng_probe(struct platform_device *pdev)
 {
 	struct resource *res;
@@ -148,12 +153,10 @@ static int msm_rng_probe(struct platform_device *pdev)
 	if (IS_ERR(rng->clk))
 		return PTR_ERR(rng->clk);
 
-	rng->hwrng.name = KBUILD_MODNAME,
-	rng->hwrng.init = msm_rng_init,
-	rng->hwrng.cleanup = msm_rng_cleanup,
-	rng->hwrng.read = msm_rng_read,
+	rng->hwrng = &msm_rng;
 
-	ret = devm_hwrng_register(&pdev->dev, &rng->hwrng);
+	rng->hwrng->priv = (unsigned long)rng;
+	ret = devm_hwrng_register(&pdev->dev, rng->hwrng);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register hwrng\n");
 		return ret;
-- 
2.14.4
