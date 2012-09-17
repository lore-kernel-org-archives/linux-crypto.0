From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH] crypto: caam - increase TRNG clocks per sample
Date: Mon, 17 Sep 2012 18:21:55 -0500
Message-ID: <20120917182155.ef1d5aab06d07e5db9dcd6cc@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.hengli.com.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:3981
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754975Ab2IQXYU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Sep 2012 19:24:20 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

we need to configure the TRNG to use more clocks per sample
to handle the two back-to-back 64KiB random descriptor requests
on higher frequency P5040s.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
fixes booting on the p5040, but since p5040 support isn't in
3.6, this can wait for 3.7.

Also, Herbert, this:

http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg07586.html

got dropped on the floor.

 drivers/crypto/caam/ctrl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 414ba20..bf20dd8 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -129,7 +129,7 @@ static int instantiate_rng(struct device *jrdev)
 
 /*
  * By default, the TRNG runs for 200 clocks per sample;
- * 800 clocks per sample generates better entropy.
+ * 1600 clocks per sample generates better entropy.
  */
 static void kick_trng(struct platform_device *pdev)
 {
@@ -144,9 +144,9 @@ static void kick_trng(struct platform_device *pdev)
 
 	/* put RNG4 into program mode */
 	setbits32(&r4tst->rtmctl, RTMCTL_PRGM);
-	/* 800 clocks per sample */
+	/* 1600 clocks per sample */
 	val = rd_reg32(&r4tst->rtsdctl);
-	val = (val & ~RTSDCTL_ENT_DLY_MASK) | (800 << RTSDCTL_ENT_DLY_SHIFT);
+	val = (val & ~RTSDCTL_ENT_DLY_MASK) | (1600 << RTSDCTL_ENT_DLY_SHIFT);
 	wr_reg32(&r4tst->rtsdctl, val);
 	/* min. freq. count */
 	wr_reg32(&r4tst->rtfrqmin, 400);
-- 
1.7.12
