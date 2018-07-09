From: Vinod Koul <vkoul@kernel.org>
Subject: [PATCH v5 5/6] crypto: qcom: Add support for prng-ee
Date: Mon,  9 Jul 2018 11:49:24 +0530
Message-ID: <20180709061925.20276-6-vkoul@kernel.org>
References: <20180709061925.20276-1-vkoul@kernel.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-msm@vger.kernel.org,
        Stephen Boyd <swboyd@chromium.org>,
        Timur Tabi <timur@codeaurora.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Vinod Koul <vkoul@kernel.org>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180709061925.20276-1-vkoul@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Qcom 8996 and later chips features multiple Execution Environments
(EE) and secure world is typically responsible for configuring the
prng.

Add driver data for qcom,prng as 0 and qcom,prng-ee as 1 and use
that to skip initialization routine.

Signed-off-by: Vinod Koul <vkoul@kernel.org>
---
 drivers/crypto/qcom-rng.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qcom-rng.c b/drivers/crypto/qcom-rng.c
index 53e1d276e05e..f1bd86acaf9d 100644
--- a/drivers/crypto/qcom-rng.c
+++ b/drivers/crypto/qcom-rng.c
@@ -28,6 +28,7 @@ struct qcom_rng {
 	struct mutex lock;
 	void __iomem *base;
 	struct clk *clk;
+	unsigned int skip_init;
 };
 
 struct qcom_rng_ctx {
@@ -128,7 +129,10 @@ static int qcom_rng_init(struct crypto_tfm *tfm)
 
 	ctx->rng = qcom_rng_dev;
 
-	return qcom_rng_enable(ctx->rng);
+	if (!ctx->rng->skip_init)
+		return qcom_rng_enable(ctx->rng);
+
+	return 0;
 }
 
 static struct rng_alg qcom_rng_alg = {
@@ -168,6 +172,8 @@ static int qcom_rng_probe(struct platform_device *pdev)
 	if (IS_ERR(rng->clk))
 		return PTR_ERR(rng->clk);
 
+	rng->skip_init = (unsigned long)of_device_get_match_data(&pdev->dev);
+
 	qcom_rng_dev = rng;
 	ret = crypto_register_rng(&qcom_rng_alg);
 	if (ret) {
@@ -188,7 +194,8 @@ static int qcom_rng_remove(struct platform_device *pdev)
 }
 
 static const struct of_device_id qcom_rng_of_match[] = {
-	{ .compatible = "qcom,prng" },
+	{ .compatible = "qcom,prng", .data = (void *)0},
+	{ .compatible = "qcom,prng-ee", .data = (void *)1},
 	{}
 };
 MODULE_DEVICE_TABLE(of, qcom_rng_of_match);
-- 
2.14.4
