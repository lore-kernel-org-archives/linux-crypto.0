From: Lionel Debieve <lionel.debieve@st.com>
Subject: [PATCH 1/3] crypto: stm32/cryp - Add power management support
Date: Tue, 26 Jun 2018 14:52:44 +0200
Message-ID: <1530017566-14779-2-git-send-email-lionel.debieve@st.com>
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

Adding pm and pm_runtime support to STM32 CRYP.

Signed-off-by: Lionel Debieve <lionel.debieve@st.com>
---
 drivers/crypto/stm32/stm32-cryp.c | 62 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index c5d3efc..23b0b7b 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/reset.h>
 
 #include <crypto/aes.h>
@@ -105,6 +106,7 @@
 #define GCM_CTR_INIT            2
 #define _walked_in              (cryp->in_walk.offset - cryp->in_sg->offset)
 #define _walked_out             (cryp->out_walk.offset - cryp->out_sg->offset)
+#define CRYP_AUTOSUSPEND_DELAY	50
 
 struct stm32_cryp_caps {
 	bool                    swap_final;
@@ -519,6 +521,8 @@ static int stm32_cryp_hw_init(struct stm32_cryp *cryp)
 	int ret;
 	u32 cfg, hw_mode;
 
+	pm_runtime_get_sync(cryp->dev);
+
 	/* Disable interrupt */
 	stm32_cryp_write(cryp, CRYP_IMSCR, 0);
 
@@ -638,6 +642,9 @@ static void stm32_cryp_finish_req(struct stm32_cryp *cryp, int err)
 		free_pages((unsigned long)buf_out, pages);
 	}
 
+	pm_runtime_mark_last_busy(cryp->dev);
+	pm_runtime_put_autosuspend(cryp->dev);
+
 	if (is_gcm(cryp) || is_ccm(cryp)) {
 		crypto_finalize_aead_request(cryp->engine, cryp->areq, err);
 		cryp->areq = NULL;
@@ -1969,6 +1976,13 @@ static int stm32_cryp_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	pm_runtime_set_autosuspend_delay(dev, CRYP_AUTOSUSPEND_DELAY);
+	pm_runtime_use_autosuspend(dev);
+
+	pm_runtime_get_noresume(dev);
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
 	rst = devm_reset_control_get(dev, NULL);
 	if (!IS_ERR(rst)) {
 		reset_control_assert(rst);
@@ -2008,6 +2022,8 @@ static int stm32_cryp_probe(struct platform_device *pdev)
 
 	dev_info(dev, "Initialized\n");
 
+	pm_runtime_put_sync(dev);
+
 	return 0;
 
 err_aead_algs:
@@ -2020,6 +2036,11 @@ static int stm32_cryp_probe(struct platform_device *pdev)
 	list_del(&cryp->list);
 	spin_unlock(&cryp_list.lock);
 
+	pm_runtime_disable(dev);
+	pm_runtime_put_noidle(dev);
+	pm_runtime_disable(dev);
+	pm_runtime_put_noidle(dev);
+
 	clk_disable_unprepare(cryp->clk);
 
 	return ret;
@@ -2028,10 +2049,15 @@ static int stm32_cryp_probe(struct platform_device *pdev)
 static int stm32_cryp_remove(struct platform_device *pdev)
 {
 	struct stm32_cryp *cryp = platform_get_drvdata(pdev);
+	int ret;
 
 	if (!cryp)
 		return -ENODEV;
 
+	ret = pm_runtime_get_sync(cryp->dev);
+	if (ret < 0)
+		return ret;
+
 	crypto_unregister_aeads(aead_algs, ARRAY_SIZE(aead_algs));
 	crypto_unregister_algs(crypto_algs, ARRAY_SIZE(crypto_algs));
 
@@ -2041,16 +2067,52 @@ static int stm32_cryp_remove(struct platform_device *pdev)
 	list_del(&cryp->list);
 	spin_unlock(&cryp_list.lock);
 
+	pm_runtime_disable(cryp->dev);
+	pm_runtime_put_noidle(cryp->dev);
+
+	clk_disable_unprepare(cryp->clk);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int stm32_cryp_runtime_suspend(struct device *dev)
+{
+	struct stm32_cryp *cryp = dev_get_drvdata(dev);
+
 	clk_disable_unprepare(cryp->clk);
 
 	return 0;
 }
 
+static int stm32_cryp_runtime_resume(struct device *dev)
+{
+	struct stm32_cryp *cryp = dev_get_drvdata(dev);
+	int ret;
+
+	ret = clk_prepare_enable(cryp->clk);
+	if (ret) {
+		dev_err(cryp->dev, "Failed to prepare_enable clock\n");
+		return ret;
+	}
+
+	return 0;
+}
+#endif
+
+static const struct dev_pm_ops stm32_cryp_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
+				pm_runtime_force_resume)
+	SET_RUNTIME_PM_OPS(stm32_cryp_runtime_suspend,
+			   stm32_cryp_runtime_resume, NULL)
+};
+
 static struct platform_driver stm32_cryp_driver = {
 	.probe  = stm32_cryp_probe,
 	.remove = stm32_cryp_remove,
 	.driver = {
 		.name           = DRIVER_NAME,
+		.pm		= &stm32_cryp_pm_ops,
 		.of_match_table = stm32_dt_ids,
 	},
 };
-- 
2.7.4
