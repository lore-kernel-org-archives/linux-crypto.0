From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 2/4] hwrng: exynos - Fix unbalanced PM runtime put on
 timeout error path
Date: Mon, 14 Mar 2016 09:07:13 +0900
Message-ID: <1457914035-26856-2-git-send-email-k.kozlowski@samsung.com>
References: <1457914035-26856-1-git-send-email-k.kozlowski@samsung.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	stable@vger.kernel.org
To: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-reply-to: <1457914035-26856-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In case of timeout during read operation, the exit path lacked PM
runtime put. This could lead to unbalanced runtime PM usage counter thus
leaving the device in an active state.

Fixes: d7fd6075a205 ("hwrng: exynos - Add timeout for waiting on init done")
Cc: <stable@vger.kernel.org> # v4.4+
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

---

Changes since v1:
1. None.
---
 drivers/char/hw_random/exynos-rng.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/exynos-rng.c b/drivers/char/hw_random/exynos-rng.c
index d1fd21e99368..38b80f82ddd2 100644
--- a/drivers/char/hw_random/exynos-rng.c
+++ b/drivers/char/hw_random/exynos-rng.c
@@ -90,6 +90,7 @@ static int exynos_read(struct hwrng *rng, void *buf,
 						struct exynos_rng, rng);
 	u32 *data = buf;
 	int retry = 100;
+	int ret = 4;
 
 	pm_runtime_get_sync(exynos_rng->dev);
 
@@ -98,17 +99,20 @@ static int exynos_read(struct hwrng *rng, void *buf,
 	while (!(exynos_rng_readl(exynos_rng,
 			EXYNOS_PRNG_STATUS_OFFSET) & PRNG_DONE) && --retry)
 		cpu_relax();
-	if (!retry)
-		return -ETIMEDOUT;
+	if (!retry) {
+		ret = -ETIMEDOUT;
+		goto out;
+	}
 
 	exynos_rng_writel(exynos_rng, PRNG_DONE, EXYNOS_PRNG_STATUS_OFFSET);
 
 	*data = exynos_rng_readl(exynos_rng, EXYNOS_PRNG_OUT1_OFFSET);
 
+out:
 	pm_runtime_mark_last_busy(exynos_rng->dev);
 	pm_runtime_put_sync_autosuspend(exynos_rng->dev);
 
-	return 4;
+	return ret;
 }
 
 static int exynos_rng_probe(struct platform_device *pdev)
-- 
2.5.0
