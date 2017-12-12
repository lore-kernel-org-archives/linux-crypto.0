From: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH v3 4/4] crypto: exynos - Introduce mutex to prevent
 concurrent access to hardware
Date: Tue, 12 Dec 2017 17:36:07 +0100
Message-ID: <20171212163607.2985-5-l.stelmach@samsung.com>
References: <20171212163607.2985-1-l.stelmach@samsung.com>
        <CGME20171212163613eucas1p2f27c9c0924f94ad9a26b6870fcf5fe45@eucas1p2.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Krzysztof Kozlowski <krzk@kernel.org>, robh+dt@kernel.org,
        Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20171212163607.2985-1-l.stelmach@samsung.com>
In-reply-to: <20171211140623.7673-1-l.stelmach@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hardware operations like reading random numbers and setting a seed need
to be conducted in a single thread. Therefore a mutex is required to
prevent multiple threads (processes) from accessing the hardware at the
same time.

The sequence of mutex_lock() and mutex_unlock() in the exynos_rng_reseed()
function enables switching between different threads waiting for the
driver to generate random numbers for them.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/crypto/exynos-rng.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/crypto/exynos-rng.c b/drivers/crypto/exynos-rng.c
index 825ed7bfd881..4a06092074b9 100644
--- a/drivers/crypto/exynos-rng.c
+++ b/drivers/crypto/exynos-rng.c
@@ -22,6 +22,7 @@
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 
@@ -79,6 +80,7 @@ struct exynos_rng_dev {
 	enum exynos_prng_type		type;
 	void __iomem			*mem;
 	struct clk			*clk;
+	struct mutex 			lock;
 	/* Generated numbers stored for seeding during resume */
 	u8				seed_save[EXYNOS_RNG_SEED_SIZE];
 	unsigned int			seed_save_len;
@@ -191,6 +193,10 @@ static void exynos_rng_reseed(struct exynos_rng_dev *rng)
 		return;
 
 	exynos_rng_set_seed(rng, seed, read);
+
+	/* Let others do some of their job. */
+	mutex_unlock(&rng->lock);
+	mutex_lock(&rng->lock);
 }
 
 static int exynos_rng_generate(struct crypto_rng *tfm,
@@ -206,6 +212,7 @@ static int exynos_rng_generate(struct crypto_rng *tfm,
 	if (ret)
 		return ret;
 
+	mutex_lock(&rng->lock);
 	do {
 		ret = exynos_rng_get_random(rng, dst, dlen, &read);
 		if (ret)
@@ -216,6 +223,7 @@ static int exynos_rng_generate(struct crypto_rng *tfm,
 
 		exynos_rng_reseed(rng);
 	} while (dlen > 0);
+	mutex_unlock(&rng->lock);
 
 	clk_disable_unprepare(rng->clk);
 
@@ -233,7 +241,9 @@ static int exynos_rng_seed(struct crypto_rng *tfm, const u8 *seed,
 	if (ret)
 		return ret;
 
+	mutex_lock(&rng->lock);
 	ret = exynos_rng_set_seed(ctx->rng, seed, slen);
+	mutex_unlock(&rng->lock);
 
 	clk_disable_unprepare(rng->clk);
 
@@ -278,6 +288,8 @@ static int exynos_rng_probe(struct platform_device *pdev)
 
 	rng->type = (enum exynos_prng_type)of_device_get_match_data(&pdev->dev);
 
+	mutex_init(&rng->lock);
+
 	rng->dev = &pdev->dev;
 	rng->clk = devm_clk_get(&pdev->dev, "secss");
 	if (IS_ERR(rng->clk)) {
@@ -328,9 +340,14 @@ static int __maybe_unused exynos_rng_suspend(struct device *dev)
 	if (ret)
 		return ret;
 
+	mutex_lock(&rng->lock);
+
 	/* Get new random numbers and store them for seeding on resume. */
 	exynos_rng_get_random(rng, rng->seed_save, sizeof(rng->seed_save),
 			      &(rng->seed_save_len));
+
+	mutex_unlock(&rng->lock);
+
 	dev_dbg(rng->dev, "Stored %u bytes for seeding on system resume\n",
 		rng->seed_save_len);
 
@@ -353,8 +370,12 @@ static int __maybe_unused exynos_rng_resume(struct device *dev)
 	if (ret)
 		return ret;
 
+	mutex_lock(&rng->lock);
+
 	ret = exynos_rng_set_seed(rng, rng->seed_save, rng->seed_save_len);
 
+	mutex_unlock(&rng->lock);
+
 	clk_disable_unprepare(rng->clk);
 
 	return ret;
-- 
2.11.0
