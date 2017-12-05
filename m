From: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [RFC] crypto: exynos - Icrease the priority of the driver
Date: Tue, 05 Dec 2017 13:42:14 +0100
Message-ID: <20171205124214.31263-1-l.stelmach@samsung.com>
References: <CGME20171205124216eucas1p17f46fc23ea35f7f2fcacc49d88e40a15@eucas1p1.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        m.szyprowski@samsung.com, b.zolnierkie@samsung.com
To: Krzysztof Kozlowski <krzk@kernel.org>, robh+dt@kernel.org,
        Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

exynos-rng is one of many implementations of stdrng. With priority as
low as 100 it isn't selected, if software implementations (DRBG) are
available.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---

If not 1000, what is the best value, what is the policy?


 drivers/crypto/exynos-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/exynos-rng.c b/drivers/crypto/exynos-rng.c
index 0bf07a655813..3c514eaae9dc 100644
--- a/drivers/crypto/exynos-rng.c
+++ b/drivers/crypto/exynos-rng.c
@@ -259,7 +259,7 @@ static struct rng_alg exynos_rng_alg = {
 	.base			= {
 		.cra_name		= "stdrng",
 		.cra_driver_name	= "exynos_rng",
-		.cra_priority		= 100,
+		.cra_priority		= 1000,
 		.cra_ctxsize		= sizeof(struct exynos_rng_ctx),
 		.cra_module		= THIS_MODULE,
 		.cra_init		= exynos_rng_kcapi_init,
-- 
2.11.0
