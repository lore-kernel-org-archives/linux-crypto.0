From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/5] hwrng: exynos - Runtime suspend device after init
Date: Fri, 11 Mar 2016 16:49:19 +0900
Message-ID: <1457682562-21219-2-git-send-email-k.kozlowski@samsung.com>
References: <1457682562-21219-1-git-send-email-k.kozlowski@samsung.com>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-reply-to: <1457682562-21219-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The driver uses pm_runtime_put_noidle() after initialization so the
device might remain in active state if the core does not read from it
(the read callback contains regular runtime put). The put_noidle() was
chosen probably to avoid unneeded suspend and resume cycle after the
initialization.

However for this purpose autosuspend is enabled so it is safe to runtime
put just after the initialization.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/char/hw_random/exynos-rng.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/exynos-rng.c b/drivers/char/hw_random/exynos-rng.c
index ada081232528..d1fd21e99368 100644
--- a/drivers/char/hw_random/exynos-rng.c
+++ b/drivers/char/hw_random/exynos-rng.c
@@ -77,7 +77,8 @@ static int exynos_init(struct hwrng *rng)
 
 	pm_runtime_get_sync(exynos_rng->dev);
 	ret = exynos_rng_configure(exynos_rng);
-	pm_runtime_put_noidle(exynos_rng->dev);
+	pm_runtime_mark_last_busy(exynos_rng->dev);
+	pm_runtime_put_autosuspend(exynos_rng->dev);
 
 	return ret;
 }
-- 
2.5.0
