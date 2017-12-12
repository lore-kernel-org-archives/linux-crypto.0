From: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH v3 2/4] crypto: exynos - Improve performance of PRNG
Date: Tue, 12 Dec 2017 17:36:05 +0100
Message-ID: <20171212163607.2985-3-l.stelmach@samsung.com>
References: <20171212163607.2985-1-l.stelmach@samsung.com>
        <CGME20171212163611eucas1p2bb80c67eb0e0a8411abcc1f65242c362@eucas1p2.samsung.com>
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
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-reply-to: <20171212163607.2985-1-l.stelmach@samsung.com>
In-reply-to: <20171211140623.7673-1-l.stelmach@samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Use memcpy_fromio() instead of custom exynos_rng_copy_random() function
to retrieve generated numbers from the registers of PRNG.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
 drivers/crypto/exynos-rng.c | 31 ++-----------------------------
 1 file changed, 2 insertions(+), 29 deletions(-)

diff --git a/drivers/crypto/exynos-rng.c b/drivers/crypto/exynos-rng.c
index 825c09619eb8..dcdd444d0b3b 100644
--- a/drivers/crypto/exynos-rng.c
+++ b/drivers/crypto/exynos-rng.c
@@ -131,34 +131,6 @@ static int exynos_rng_set_seed(struct exynos_rng_dev *rng,
 }
 
 /*
- * Read from output registers and put the data under 'dst' array,
- * up to dlen bytes.
- *
- * Returns number of bytes actually stored in 'dst' (dlen
- * or EXYNOS_RNG_SEED_SIZE).
- */
-static unsigned int exynos_rng_copy_random(struct exynos_rng_dev *rng,
-					   u8 *dst, unsigned int dlen)
-{
-	unsigned int cnt = 0;
-	int i, j;
-	u32 val;
-
-	for (j = 0; j < EXYNOS_RNG_SEED_REGS; j++) {
-		val = exynos_rng_readl(rng, EXYNOS_RNG_OUT(j));
-
-		for (i = 0; i < 4; i++) {
-			dst[cnt] = val & 0xff;
-			val >>= 8;
-			if (++cnt >= dlen)
-				return cnt;
-		}
-	}
-
-	return cnt;
-}
-
-/*
  * Start the engine and poll for finish.  Then read from output registers
  * filling the 'dst' buffer up to 'dlen' bytes or up to size of generated
  * random data (EXYNOS_RNG_SEED_SIZE).
@@ -190,7 +162,8 @@ static int exynos_rng_get_random(struct exynos_rng_dev *rng,
 	/* Clear status bit */
 	exynos_rng_writel(rng, EXYNOS_RNG_STATUS_RNG_DONE,
 			  EXYNOS_RNG_STATUS);
-	*read = exynos_rng_copy_random(rng, dst, dlen);
+	*read = min_t(size_t, dlen, EXYNOS_RNG_SEED_SIZE);
+	memcpy_fromio(dst, rng->mem + EXYNOS_RNG_OUT_BASE, *read);
 
 	return 0;
 }
-- 
2.11.0
