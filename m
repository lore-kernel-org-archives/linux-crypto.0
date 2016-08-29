From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH] char: hw_random: bcm2835: handle of_iomap failures in bcm2835 driver
Date: Mon, 29 Aug 2016 22:40:16 +0530
Message-ID: <1472490616-9597-1-git-send-email-arvind.yadav.cs@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mpm@selenic.com, herbert@gondor.apana.org.au,
        Arvind Yadav <arvind.yadav.cs@gmail.com>
To: f.fainelli@gmail.com, rjui@broadcom.com, sbranden@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, lee@kernel.org,
        eric@anholt.net, yendapally.reddy@broadcom.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Check return value of of_iomap and handle errors correctly.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/char/hw_random/bcm2835-rng.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index af21492..574211a 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -92,9 +92,10 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
 	bcm2835_rng_ops.priv = (unsigned long)rng_base;
 
 	rng_id = of_match_node(bcm2835_rng_of_match, np);
-	if (!rng_id)
+	if (!rng_id) {
+		iounmap(rng_base);
 		return -EINVAL;
-
+	}
 	/* Check for rng init function, execute it */
 	rng_setup = rng_id->data;
 	if (rng_setup)
-- 
2.7.4
