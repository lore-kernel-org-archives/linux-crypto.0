From: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 42/63] crypto: ux500/[cryp|hash] - Show successful start-up in the bootlog
Date: Fri,  3 May 2013 15:32:28 +0100
Message-ID: <1367591569-32197-43-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
	srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Westin <andreas.westin@stericsson.com>,
	linux-crypto@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:54474 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933712Ab3ECOex (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 May 2013 10:34:53 -0400
Received: by mail-wg0-f47.google.com with SMTP id e11so1628457wgh.2
        for <linux-crypto@vger.kernel.org>; Fri, 03 May 2013 07:34:52 -0700 (PDT)
In-Reply-To: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The Cryp driver is currently silent and the Hash driver prints the
name of its probe function unnecessarily. Let's just put a nice
descriptive one-liner there instead.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Westin <andreas.westin@stericsson.com>
Cc: linux-crypto@vger.kernel.org
Acked-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/crypto/ux500/cryp/cryp_core.c |    2 ++
 drivers/crypto/ux500/hash/hash_core.c |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 4b90493..78d7463 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1542,6 +1542,8 @@ static int ux500_cryp_probe(struct platform_device *pdev)
 		goto out_power;
 	}
 
+	dev_info(dev, "successfully registered\n");
+
 	return 0;
 
 out_power:
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 5d8a7f3..ac606b6 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -1773,7 +1773,7 @@ static int ux500_hash_probe(struct platform_device *pdev)
 		goto out_power;
 	}
 
-	dev_info(dev, "[%s] successfully probed\n", __func__);
+	dev_info(dev, "successfully registered\n");
 	return 0;
 
 out_power:
-- 
1.7.10.4
