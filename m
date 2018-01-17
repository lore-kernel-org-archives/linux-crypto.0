From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH -next] hwrng: bcm2835 - Remove redundant dev_err call in bcm2835_rng_probe()
Date: Wed, 17 Jan 2018 11:40:34 +0000
Message-ID: <1516189234-11957-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <weiyongjun1@huawei.com>,
        <bcm-kernel-feedback-list@broadcom.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-rpi-kernel@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kernel-janitors@vger.kernel.org>
To: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Ray Jui" <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <stefan.wahren@i2se.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

There is a error message within devm_ioremap_resource
already, so remove the dev_err call to avoid redundant
error message.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/char/hw_random/bcm2835-rng.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index 25e5631..7a84cec 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -158,10 +158,8 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
 
 	/* map peripheral */
 	priv->base = devm_ioremap_resource(dev, r);
-	if (IS_ERR(priv->base)) {
-		dev_err(dev, "failed to remap rng regs");
+	if (IS_ERR(priv->base))
 		return PTR_ERR(priv->base);
-	}
 
 	/* Clock is optional on most platforms */
 	priv->clk = devm_clk_get(dev, NULL);



