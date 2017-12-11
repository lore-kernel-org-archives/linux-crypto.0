From: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH v2 3/4] crypto: exynos - Reseed PRNG after generating 2^16
 random bytes
Date: Mon, 11 Dec 2017 15:06:22 +0100
Message-ID: <20171211140623.7673-4-l.stelmach@samsung.com>
References: <20171211140623.7673-1-l.stelmach@samsung.com>
        <CGME20171211140638eucas1p239085a27ce0501beb8b42be94ed61b34@eucas1p2.samsung.com>
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
In-reply-to: <20171211140623.7673-1-l.stelmach@samsung.com>
In-reply-to: <20171205123558.31087-1-l.stelmach@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Reseed PRNG after reading 65 kB of randomness. Although this may reduce
performance, in most cases the loss is not noticeable.

Reseeding of a PRNG does not increase entropy, but it helps preventing
backtracking the internal state of the device from its output sequence,
and hence, prevents potential attacker from predicting numbers to be
generated.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
Reviewed-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/crypto/exynos-rng.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/exynos-rng.c b/drivers/crypto/exynos-rng.c
index 7d8f658480d3..c72a838f1932 100644
--- a/drivers/crypto/exynos-rng.c
+++ b/drivers/crypto/exynos-rng.c
@@ -55,12 +55,14 @@ enum exynos_prng_type {
 };
 
 /*
- * Driver re-seeds itself with generated random numbers to increase
- * the randomness.
+ * Driver re-seeds itself with generated random numbers to hinder
+ * backtracking of the original seed.
  *
  * Time for next re-seed in ms.
  */
-#define EXYNOS_RNG_RESEED_TIME		100
+#define EXYNOS_RNG_RESEED_TIME		1000
+#define EXYNOS_RNG_RESEED_BYTES		65536
+
 /*
  * In polling mode, do not wait infinitely for the engine to finish the work.
  */
@@ -82,6 +84,8 @@ struct exynos_rng_dev {
 	unsigned int			seed_save_len;
 	/* Time of last seeding in jiffies */
 	unsigned long			last_seeding;
+	/* Bytes generated since last seeding */
+	unsigned long			bytes_seeding;
 };
 
 static struct exynos_rng_dev *exynos_rng_dev;
@@ -126,6 +130,7 @@ static int exynos_rng_set_seed(struct exynos_rng_dev *rng,
 	}
 
 	rng->last_seeding = jiffies;
+	rng->bytes_seeding = 0;
 
 	return 0;
 }
@@ -165,6 +170,7 @@ static int exynos_rng_get_random(struct exynos_rng_dev *rng,
 			  EXYNOS_RNG_STATUS);
 	*read = min_t(size_t, dlen, EXYNOS_RNG_SEED_SIZE);
 	memcpy_fromio(dst, rng->mem + EXYNOS_RNG_OUT_BASE, *read);
+	rng->bytes_seeding += *read;
 
 	return 0;
 }
@@ -178,7 +184,8 @@ static void exynos_rng_reseed(struct exynos_rng_dev *rng)
 	unsigned int read = 0;
 	u8 seed[EXYNOS_RNG_SEED_SIZE];
 
-	if (time_before(now, next_seeding))
+	if (time_before(now, next_seeding) &&
+	    rng->bytes_seeding < EXYNOS_RNG_RESEED_BYTES)
 		return;
 
 	if (exynos_rng_get_random(rng, seed, sizeof(seed), &read))
-- 
2.11.0
