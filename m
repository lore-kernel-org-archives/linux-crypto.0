Received: from akranes.kaiser.cx (akranes.kaiser.cx [152.53.16.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216CF182;
	Sat,  1 Feb 2025 19:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=152.53.16.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738437544; cv=none; b=Spsk5W+gJwGHMC1kgU+QE4VZcf/rw3+DsWTF1ntV1lqwBjm3z/OhDzySdgu5Vd+9NKsrLV0oxk5hqnvy9AeNXrMtxHxI35flrmvh3aVngXcIMHDJHFrBTEf73NH+QhvLqksrdG2nyc4E6nlZqDdok68kp66H+km1CsT3FasyBR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738437544; c=relaxed/simple;
	bh=lp0QGKLKUGfNNosyKXN0Q73Mzcbu/P4DmB5Aecyw7QM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eOOHzK++hTbe+ud3jhM1YlLlq5p94Uyu88er2b7Ny/5OVZ2NvzOJG+J7PPmtS3Sh6W8RAwvODWqjCFsbglXrMko6fdUd5wiRZhThBYrGmuEVaNeSWYnuMSEo1QPIZuBek5Pkr+xo0zWT5299neCmkU1jIeA5PtCBucc6j98sVMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kaiser.cx; spf=pass smtp.mailfrom=kaiser.cx; arc=none smtp.client-ip=152.53.16.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kaiser.cx
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kaiser.cx
Received: from ip-037-201-212-008.um10.pools.vodafone-ip.de ([37.201.212.8] helo=martin-debian-3.kaiser.cx)
	by akranes.kaiser.cx with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <martin@kaiser.cx>)
	id 1teIOe-002cWg-2j;
	Sat, 01 Feb 2025 19:39:12 +0100
From: Martin Kaiser <martin@kaiser.cx>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Martin Kaiser <martin@kaiser.cx>
Subject: [PATCH v2] hwrng: imx-rngc - add runtime pm
Date: Sat,  1 Feb 2025 19:39:07 +0100
Message-Id: <20250201183907.82570-1-martin@kaiser.cx>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250118160701.32624-1-martin@kaiser.cx>
References: <20250118160701.32624-1-martin@kaiser.cx>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add runtime power management to the imx-rngc driver. Disable the
peripheral clock when the rngc is idle.

The callback functions from struct hwrng wake the rngc up when they're
called and set it to idle on exit. Helper functions which are invoked
from the callbacks assume that the rngc is active.

Device init and probe are done before runtime pm is enabled. The
peripheral clock will be handled manually during these steps. Do not use
devres any more to enable/disable the peripheral clock, this conflicts
with runtime pm.

Signed-off-by: Martin Kaiser <martin@kaiser.cx>
---
v2:
 - remove unnecessary err = 0; assignment

 drivers/char/hw_random/imx-rngc.c | 69 +++++++++++++++++++++++--------
 1 file changed, 52 insertions(+), 17 deletions(-)

diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
index 5adc4946d60f..9e42571f743f 100644
--- a/drivers/char/hw_random/imx-rngc.c
+++ b/drivers/char/hw_random/imx-rngc.c
@@ -13,6 +13,8 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
+#include <linux/pm.h>
+#include <linux/pm_runtime.h>
 #include <linux/interrupt.h>
 #include <linux/hw_random.h>
 #include <linux/completion.h>
@@ -53,6 +55,7 @@
 
 #define RNGC_SELFTEST_TIMEOUT 2500 /* us */
 #define RNGC_SEED_TIMEOUT      200 /* ms */
+#define RNGC_PM_TIMEOUT        500 /* ms */
 
 static bool self_test = true;
 module_param(self_test, bool, 0);
@@ -123,7 +126,11 @@ static int imx_rngc_read(struct hwrng *rng, void *data, size_t max, bool wait)
 {
 	struct imx_rngc *rngc = container_of(rng, struct imx_rngc, rng);
 	unsigned int status;
-	int retval = 0;
+	int err, retval = 0;
+
+	err = pm_runtime_resume_and_get(rngc->dev);
+	if (err)
+		return err;
 
 	while (max >= sizeof(u32)) {
 		status = readl(rngc->base + RNGC_STATUS);
@@ -141,6 +148,8 @@ static int imx_rngc_read(struct hwrng *rng, void *data, size_t max, bool wait)
 			max -= sizeof(u32);
 		}
 	}
+	pm_runtime_mark_last_busy(rngc->dev);
+	pm_runtime_put(rngc->dev);
 
 	return retval ? retval : -EIO;
 }
@@ -169,7 +178,11 @@ static int imx_rngc_init(struct hwrng *rng)
 {
 	struct imx_rngc *rngc = container_of(rng, struct imx_rngc, rng);
 	u32 cmd, ctrl;
-	int ret;
+	int ret, err;
+
+	err = pm_runtime_resume_and_get(rngc->dev);
+	if (err)
+		return err;
 
 	/* clear error */
 	cmd = readl(rngc->base + RNGC_COMMAND);
@@ -186,15 +199,15 @@ static int imx_rngc_init(struct hwrng *rng)
 		ret = wait_for_completion_timeout(&rngc->rng_op_done,
 						  msecs_to_jiffies(RNGC_SEED_TIMEOUT));
 		if (!ret) {
-			ret = -ETIMEDOUT;
-			goto err;
+			err = -ETIMEDOUT;
+			goto out;
 		}
 
 	} while (rngc->err_reg == RNGC_ERROR_STATUS_STAT_ERR);
 
 	if (rngc->err_reg) {
-		ret = -EIO;
-		goto err;
+		err = -EIO;
+		goto out;
 	}
 
 	/*
@@ -205,23 +218,29 @@ static int imx_rngc_init(struct hwrng *rng)
 	ctrl |= RNGC_CTRL_AUTO_SEED;
 	writel(ctrl, rngc->base + RNGC_CONTROL);
 
+out:
 	/*
 	 * if initialisation was successful, we keep the interrupt
 	 * unmasked until imx_rngc_cleanup is called
 	 * we mask the interrupt ourselves if we return an error
 	 */
-	return 0;
+	if (err)
+		imx_rngc_irq_mask_clear(rngc);
 
-err:
-	imx_rngc_irq_mask_clear(rngc);
-	return ret;
+	pm_runtime_put(rngc->dev);
+	return err;
 }
 
 static void imx_rngc_cleanup(struct hwrng *rng)
 {
 	struct imx_rngc *rngc = container_of(rng, struct imx_rngc, rng);
+	int err;
 
-	imx_rngc_irq_mask_clear(rngc);
+	err = pm_runtime_resume_and_get(rngc->dev);
+	if (!err) {
+		imx_rngc_irq_mask_clear(rngc);
+		pm_runtime_put(rngc->dev);
+	}
 }
 
 static int __init imx_rngc_probe(struct platform_device *pdev)
@@ -240,7 +259,7 @@ static int __init imx_rngc_probe(struct platform_device *pdev)
 	if (IS_ERR(rngc->base))
 		return PTR_ERR(rngc->base);
 
-	rngc->clk = devm_clk_get_enabled(&pdev->dev, NULL);
+	rngc->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(rngc->clk))
 		return dev_err_probe(&pdev->dev, PTR_ERR(rngc->clk), "Cannot get rng_clk\n");
 
@@ -248,14 +267,18 @@ static int __init imx_rngc_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
+	clk_prepare_enable(rngc->clk);
+
 	ver_id = readl(rngc->base + RNGC_VER_ID);
 	rng_type = FIELD_GET(RNG_TYPE, ver_id);
 	/*
 	 * This driver supports only RNGC and RNGB. (There's a different
 	 * driver for RNGA.)
 	 */
-	if (rng_type != RNGC_TYPE_RNGC && rng_type != RNGC_TYPE_RNGB)
+	if (rng_type != RNGC_TYPE_RNGC && rng_type != RNGC_TYPE_RNGB) {
+		clk_disable_unprepare(rngc->clk);
 		return -ENODEV;
+	}
 
 	init_completion(&rngc->rng_op_done);
 
@@ -271,15 +294,24 @@ static int __init imx_rngc_probe(struct platform_device *pdev)
 
 	ret = devm_request_irq(&pdev->dev,
 			irq, imx_rngc_irq, 0, pdev->name, (void *)rngc);
-	if (ret)
+	if (ret) {
+		clk_disable_unprepare(rngc->clk);
 		return dev_err_probe(&pdev->dev, ret, "Can't get interrupt working.\n");
+	}
 
 	if (self_test) {
 		ret = imx_rngc_self_test(rngc);
-		if (ret)
+		if (ret) {
+			clk_disable_unprepare(rngc->clk);
 			return dev_err_probe(&pdev->dev, ret, "self test failed\n");
+		}
 	}
 
+	pm_runtime_set_autosuspend_delay(&pdev->dev, RNGC_PM_TIMEOUT);
+	pm_runtime_use_autosuspend(&pdev->dev);
+	pm_runtime_set_active(&pdev->dev);
+	devm_pm_runtime_enable(&pdev->dev);
+
 	ret = devm_hwrng_register(&pdev->dev, &rngc->rng);
 	if (ret)
 		return dev_err_probe(&pdev->dev, ret, "hwrng registration failed\n");
@@ -309,7 +341,10 @@ static int imx_rngc_resume(struct device *dev)
 	return 0;
 }
 
-static DEFINE_SIMPLE_DEV_PM_OPS(imx_rngc_pm_ops, imx_rngc_suspend, imx_rngc_resume);
+static const struct dev_pm_ops imx_rngc_pm_ops = {
+	SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend, pm_runtime_force_resume)
+	RUNTIME_PM_OPS(imx_rngc_suspend, imx_rngc_resume, NULL)
+};
 
 static const struct of_device_id imx_rngc_dt_ids[] = {
 	{ .compatible = "fsl,imx25-rngb" },
@@ -320,7 +355,7 @@ MODULE_DEVICE_TABLE(of, imx_rngc_dt_ids);
 static struct platform_driver imx_rngc_driver = {
 	.driver = {
 		.name = KBUILD_MODNAME,
-		.pm = pm_sleep_ptr(&imx_rngc_pm_ops),
+		.pm = pm_ptr(&imx_rngc_pm_ops),
 		.of_match_table = imx_rngc_dt_ids,
 	},
 };
-- 
2.39.5

