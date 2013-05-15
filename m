From: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 18/39] crypto: ux500/[cryp|hash] - Show successful start-up in the bootlog
Date: Wed, 15 May 2013 10:51:41 +0100
Message-ID: <1368611522-9984-19-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
	srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
	Andreas Westin <andreas.westin@stericsson.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	balbi@ti.com, linux-usb@vger.kernel.org,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	herbert@gondor.apana.org.au, vinod.koul@intel.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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
index d9c863d..4f8b11a 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1541,6 +1541,8 @@ static int ux500_cryp_probe(struct platform_device *pdev)
 		goto out_power;
 	}
 
+	dev_info(dev, "successfully registered\n");
+
 	return 0;
 
 out_power:
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 6269576..9ca6fbb 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -1772,7 +1772,7 @@ static int ux500_hash_probe(struct platform_device *pdev)
 		goto out_power;
 	}
 
-	dev_info(dev, "[%s] successfully probed\n", __func__);
+	dev_info(dev, "successfully registered\n");
 	return 0;
 
 out_power:
-- 
1.7.10.4
