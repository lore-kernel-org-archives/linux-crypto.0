From: Lionel Debieve <lionel.debieve@st.com>
Subject: [PATCH 2/3] crypto: stm32/hash - Add power management support
Date: Tue, 26 Jun 2018 14:52:45 +0200
Message-ID: <1530017566-14779-3-git-send-email-lionel.debieve@st.com>
References: <1530017566-14779-1-git-send-email-lionel.debieve@st.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Benjamin Gaignard <benjamin.gaignard@st.com>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        Ludovic Barre <ludovic.barre@st.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Alexandre Torgue" <alexandre.torgue@st.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1530017566-14779-1-git-send-email-lionel.debieve@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Adding pm and pm_runtime support to STM32 HASH.

Signed-off-by: Lionel Debieve <lionel.debieve@st.com>
---
 drivers/crypto/stm32/stm32-hash.c | 71 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index cdc96f1..d1d7233 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/reset.h>
 
 #include <crypto/engine.h>
@@ -121,6 +122,8 @@ enum stm32_hash_data_format {
 #define HASH_QUEUE_LENGTH		16
 #define HASH_DMA_THRESHOLD		50
 
+#define HASH_AUTOSUSPEND_DELAY		50
+
 struct stm32_hash_ctx {
 	struct crypto_engine_ctx enginectx;
 	struct stm32_hash_dev	*hdev;
@@ -814,12 +817,17 @@ static void stm32_hash_finish_req(struct ahash_request *req, int err)
 		rctx->flags |= HASH_FLAGS_ERRORS;
 	}
 
+	pm_runtime_mark_last_busy(hdev->dev);
+	pm_runtime_put_autosuspend(hdev->dev);
+
 	crypto_finalize_hash_request(hdev->engine, req, err);
 }
 
 static int stm32_hash_hw_init(struct stm32_hash_dev *hdev,
 			      struct stm32_hash_request_ctx *rctx)
 {
+	pm_runtime_get_sync(hdev->dev);
+
 	if (!(HASH_FLAGS_INIT & hdev->flags)) {
 		stm32_hash_write(hdev, HASH_CR, HASH_CR_INIT);
 		stm32_hash_write(hdev, HASH_STR, 0);
@@ -967,6 +975,8 @@ static int stm32_hash_export(struct ahash_request *req, void *out)
 	u32 *preg;
 	unsigned int i;
 
+	pm_runtime_get_sync(hdev->dev);
+
 	while (!(stm32_hash_read(hdev, HASH_SR) & HASH_SR_DATA_INPUT_READY))
 		cpu_relax();
 
@@ -982,6 +992,9 @@ static int stm32_hash_export(struct ahash_request *req, void *out)
 	for (i = 0; i < HASH_CSR_REGISTER_NUMBER; i++)
 		*preg++ = stm32_hash_read(hdev, HASH_CSR(i));
 
+	pm_runtime_mark_last_busy(hdev->dev);
+	pm_runtime_put_autosuspend(hdev->dev);
+
 	memcpy(out, rctx, sizeof(*rctx));
 
 	return 0;
@@ -1000,6 +1013,8 @@ static int stm32_hash_import(struct ahash_request *req, const void *in)
 
 	preg = rctx->hw_context;
 
+	pm_runtime_get_sync(hdev->dev);
+
 	stm32_hash_write(hdev, HASH_IMR, *preg++);
 	stm32_hash_write(hdev, HASH_STR, *preg++);
 	stm32_hash_write(hdev, HASH_CR, *preg);
@@ -1009,6 +1024,9 @@ static int stm32_hash_import(struct ahash_request *req, const void *in)
 	for (i = 0; i < HASH_CSR_REGISTER_NUMBER; i++)
 		stm32_hash_write(hdev, HASH_CSR(i), *preg++);
 
+	pm_runtime_mark_last_busy(hdev->dev);
+	pm_runtime_put_autosuspend(hdev->dev);
+
 	kfree(rctx->hw_context);
 
 	return 0;
@@ -1482,6 +1500,13 @@ static int stm32_hash_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	pm_runtime_set_autosuspend_delay(dev, HASH_AUTOSUSPEND_DELAY);
+	pm_runtime_use_autosuspend(dev);
+
+	pm_runtime_get_noresume(dev);
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
 	hdev->rst = devm_reset_control_get(&pdev->dev, NULL);
 	if (!IS_ERR(hdev->rst)) {
 		reset_control_assert(hdev->rst);
@@ -1522,6 +1547,8 @@ static int stm32_hash_probe(struct platform_device *pdev)
 	dev_info(dev, "Init HASH done HW ver %x DMA mode %u\n",
 		 stm32_hash_read(hdev, HASH_VER), hdev->dma_mode);
 
+	pm_runtime_put_sync(dev);
+
 	return 0;
 
 err_algs:
@@ -1535,6 +1562,9 @@ static int stm32_hash_probe(struct platform_device *pdev)
 	if (hdev->dma_lch)
 		dma_release_channel(hdev->dma_lch);
 
+	pm_runtime_disable(dev);
+	pm_runtime_put_noidle(dev);
+
 	clk_disable_unprepare(hdev->clk);
 
 	return ret;
@@ -1543,11 +1573,16 @@ static int stm32_hash_probe(struct platform_device *pdev)
 static int stm32_hash_remove(struct platform_device *pdev)
 {
 	static struct stm32_hash_dev *hdev;
+	int ret;
 
 	hdev = platform_get_drvdata(pdev);
 	if (!hdev)
 		return -ENODEV;
 
+	ret = pm_runtime_get_sync(hdev->dev);
+	if (ret < 0)
+		return ret;
+
 	stm32_hash_unregister_algs(hdev);
 
 	crypto_engine_exit(hdev->engine);
@@ -1559,16 +1594,52 @@ static int stm32_hash_remove(struct platform_device *pdev)
 	if (hdev->dma_lch)
 		dma_release_channel(hdev->dma_lch);
 
+	pm_runtime_disable(hdev->dev);
+	pm_runtime_put_noidle(hdev->dev);
+
 	clk_disable_unprepare(hdev->clk);
 
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int stm32_hash_runtime_suspend(struct device *dev)
+{
+	struct stm32_hash_dev *hdev = dev_get_drvdata(dev);
+
+	clk_disable_unprepare(hdev->clk);
+
+	return 0;
+}
+
+static int stm32_hash_runtime_resume(struct device *dev)
+{
+	struct stm32_hash_dev *hdev = dev_get_drvdata(dev);
+	int ret;
+
+	ret = clk_prepare_enable(hdev->clk);
+	if (ret) {
+		dev_err(hdev->dev, "Failed to prepare_enable clock\n");
+		return ret;
+	}
+
+	return 0;
+}
+#endif
+
+static const struct dev_pm_ops stm32_hash_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
+				pm_runtime_force_resume)
+	SET_RUNTIME_PM_OPS(stm32_hash_runtime_suspend,
+			   stm32_hash_runtime_resume, NULL)
+};
+
 static struct platform_driver stm32_hash_driver = {
 	.probe		= stm32_hash_probe,
 	.remove		= stm32_hash_remove,
 	.driver		= {
 		.name	= "stm32-hash",
+		.pm = &stm32_hash_pm_ops,
 		.of_match_table	= stm32_hash_of_match,
 	}
 };
-- 
2.7.4
