From: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH] crypto: exynos - Icrease the priority of the driver
Date: Tue, 05 Dec 2017 17:20:46 +0100
Message-ID: <20171205162046.11621-1-l.stelmach@samsung.com>
References: <CGME20171205162048eucas1p241590a1f62f8c49af8a7fb9282daed80@eucas1p2.samsung.com>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36398 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750810AbdLEQUv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Dec 2017 11:20:51 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

exynos-rng is one of many implementations of stdrng. With priority as
low as 100 it isn't selected, if software implementations (DRBG) are
available. The value 300 was selected to give the PRNG priority before
software implementations, but allow them to be selected in FIPS-mode
(fips=1 in the kernel command line).

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---

Thank you Stephan Mueller for explanations.

 drivers/crypto/exynos-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/exynos-rng.c b/drivers/crypto/exynos-rng.c
index 4b2ed1d178af..5a37397fb1c5 100644
--- a/drivers/crypto/exynos-rng.c
+++ b/drivers/crypto/exynos-rng.c
@@ -256,7 +256,7 @@ static struct rng_alg exynos_rng_alg = {
 	.base			= {
 		.cra_name		= "stdrng",
 		.cra_driver_name	= "exynos_rng",
-		.cra_priority		= 100,
+		.cra_priority		= 300,
 		.cra_ctxsize		= sizeof(struct exynos_rng_ctx),
 		.cra_module		= THIS_MODULE,
 		.cra_init		= exynos_rng_kcapi_init,
-- 
2.11.0
