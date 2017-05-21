From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH] crypto: exynoes-rng: Set cra_ctxsize to 0
Date: Sun, 21 May 2017 11:39:52 +0530
Message-ID: <20170521060952.19055-1-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: krzk@kernel.org, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:36759 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750819AbdEUGLI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 May 2017 02:11:08 -0400
Received: by mail-pg0-f66.google.com with SMTP id h64so14083444pge.3
        for <linux-crypto@vger.kernel.org>; Sat, 20 May 2017 23:11:07 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As cra_ctxsize is set but the allocated space is not used, set it 0.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
 drivers/crypto/exynos-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/exynos-rng.c b/drivers/crypto/exynos-rng.c
index 451620b..d009df6 100644
--- a/drivers/crypto/exynos-rng.c
+++ b/drivers/crypto/exynos-rng.c
@@ -260,7 +260,7 @@ static int exynos_rng_kcapi_init(struct crypto_tfm *tfm)
 		.cra_name		= "stdrng",
 		.cra_driver_name	= "exynos_rng",
 		.cra_priority		= 100,
-		.cra_ctxsize		= sizeof(struct exynos_rng_ctx),
+		.cra_ctxsize		= 0,
 		.cra_module		= THIS_MODULE,
 		.cra_init		= exynos_rng_kcapi_init,
 	}
-- 
1.8.5.6
