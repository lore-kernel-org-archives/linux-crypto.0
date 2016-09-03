From: Iaroslav Gridin <voker57@gmail.com>
Subject: [PATCH] crypto: qce: Initialize core src clock @100Mhz
Date: Sat,  3 Sep 2016 19:45:35 +0300
Message-ID: <20160903164535.1118-1-voker57@gmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.gross@linaro.org,
        david.brown@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-soc@vger.kernel.org, Iaroslav Gridin <voker57@gmail.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36152 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754082AbcICQp5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 3 Sep 2016 12:45:57 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Without that, QCE performance is about 2x less.

Signed-off-by: Iaroslav Gridin <voker57@gmail.com>
---
 drivers/crypto/qce/core.c | 18 +++++++++++++++++-
 drivers/crypto/qce/core.h |  2 +-
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index 0cde513..657354c 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -193,6 +193,10 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
+	qce->core_src = devm_clk_get(qce->dev, "core_src");
+	if (IS_ERR(qce->core_src))
+		return PTR_ERR(qce->core_src);
+
 	qce->core = devm_clk_get(qce->dev, "core");
 	if (IS_ERR(qce->core))
 		return PTR_ERR(qce->core);
@@ -205,10 +209,20 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	if (IS_ERR(qce->bus))
 		return PTR_ERR(qce->bus);
 
-	ret = clk_prepare_enable(qce->core);
+	ret = clk_prepare_enable(qce->core_src);
 	if (ret)
 		return ret;
 
+	ret = clk_set_rate(qce->core_src, 100000000);
+	if (ret) {
+		dev_warn(qce->dev, "Unable to set QCE core src clk @100Mhz, performance might be degraded\n");
+		goto err_clks_core_src;
+	}
+
+	ret = clk_prepare_enable(qce->core);
+	if (ret)
+		goto err_clks_core_src;
+
 	ret = clk_prepare_enable(qce->iface);
 	if (ret)
 		goto err_clks_core;
@@ -247,6 +261,8 @@ err_clks_iface:
 	clk_disable_unprepare(qce->iface);
 err_clks_core:
 	clk_disable_unprepare(qce->core);
+err_clks_core_src:
+	clk_disable_unprepare(qce->core_src);
 	return ret;
 }
 
diff --git a/drivers/crypto/qce/core.h b/drivers/crypto/qce/core.h
index 549965d..c5f8d08 100644
--- a/drivers/crypto/qce/core.h
+++ b/drivers/crypto/qce/core.h
@@ -42,7 +42,7 @@ struct qce_device {
 	int result;
 	void __iomem *base;
 	struct device *dev;
-	struct clk *core, *iface, *bus;
+	struct clk *core, *iface, *bus, *core_src;
 	struct qce_dma_data dma;
 	int burst_size;
 	unsigned int pipe_pair_id;
-- 
2.9.3
