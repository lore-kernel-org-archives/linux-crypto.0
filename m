From: Matthew Leach <matthew@mattleach.net>
Subject: [RFC PATCH 14/15] hwrng: exynos - fixup IO accesors
Date: Wed,  8 Jun 2016 19:31:09 +0100
Message-ID: <20160608183110.13851-15-matthew@mattleach.net>
References: <20160608183110.13851-1-matthew@mattleach.net>
Cc: linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Ben Dooks <ben.dooks@codethink.co.uk>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <20160608183110.13851-1-matthew@mattleach.net>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Ben Dooks <ben.dooks@codethink.co.uk>

The __raw IO functions are not endian safe, so use the readl_relaxed
and writel_relaxed versions of these.

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
CC: Matt Mackall <mpm@selenic.com>
CC: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: linux-crypto@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org
CC: linux-samsung-soc@vger.kernel.org
---
 drivers/char/hw_random/exynos-rng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/exynos-rng.c b/drivers/char/hw_random/exynos-rng.c
index ed44561..23d3585 100644
--- a/drivers/char/hw_random/exynos-rng.c
+++ b/drivers/char/hw_random/exynos-rng.c
@@ -45,12 +45,12 @@ struct exynos_rng {
 
 static u32 exynos_rng_readl(struct exynos_rng *rng, u32 offset)
 {
-	return	__raw_readl(rng->mem + offset);
+	return	readl_relaxed(rng->mem + offset);
 }
 
 static void exynos_rng_writel(struct exynos_rng *rng, u32 val, u32 offset)
 {
-	__raw_writel(val, rng->mem + offset);
+	writel_relaxed(val, rng->mem + offset);
 }
 
 static int exynos_rng_configure(struct exynos_rng *exynos_rng)
-- 
2.8.3
