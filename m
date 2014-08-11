From: Alex Porosanu <alexandru.porosanu@freescale.com>
Subject: [PATCH 2/3] crypto: caam - change starting entropy delay value
Date: Mon, 11 Aug 2014 11:40:16 +0300
Message-ID: <1407746417-9134-3-git-send-email-alexandru.porosanu@freescale.com>
References: <1407746417-9134-1-git-send-email-alexandru.porosanu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:23727
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752557AbaHKIlB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Aug 2014 04:41:01 -0400
In-Reply-To: <1407746417-9134-1-git-send-email-alexandru.porosanu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The entropy delay (the length in system clocks of each
entropy sample) for the RNG4 block of CAAM is dependent
on the frequency of the SoC. By elaborate methods, it
has been determined that a good starting value for all
platforms integrating the CAAM IP is 3200. Using a
higher value has additional benefit of  speeding up
the process of instantiating the RNG, since the entropy
delay will be increased and instantiation of the RNG
state handles will be reattempted by the driver. If the
starting value is low, for certain platforms, this can
lead to a quite lengthy process.
This patch changes the starting value of the length of
the entropy sample to 3200 system clocks.
In addition to this change, the attempted entropy delay
values are now printed on the console upon initialization
of the RNG block.
While here, a safeguard for yielding the processor was
added for ensuring that in very adverse cases,
the CPU isn't hogged by the instantiation loop.

Signed-off-by: Alex Porosanu <alexandru.porosanu@freescale.com>
---
 drivers/crypto/caam/ctrl.c | 9 +++++++++
 drivers/crypto/caam/regs.h | 2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 8908d04..111ac1f 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -544,6 +544,9 @@ static int caam_probe(struct platform_device *pdev)
 			 * the TRNG parameters.
 			 */
 			if (!(ctrlpriv->rng4_sh_init || inst_handles)) {
+				dev_info(dev,
+					 "Entropy delay = %u\n",
+					 ent_delay);
 				kick_trng(pdev, ent_delay);
 				ent_delay += 400;
 			}
@@ -556,6 +559,12 @@ static int caam_probe(struct platform_device *pdev)
 			 */
 			ret = instantiate_rng(dev, inst_handles,
 					      gen_sk);
+			if (ret == -EAGAIN)
+				/*
+				 * if here, the loop will rerun,
+				 * so don't hog the CPU
+				 */
+				cpu_relax();
 		} while ((ret == -EAGAIN) && (ent_delay < RTSDCTL_ENT_DLY_MAX));
 		if (ret) {
 			dev_err(dev, "failed to instantiate RNG");
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index b8bd980..5fa739c 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -278,7 +278,7 @@ struct rng4tst {
 	};
 #define RTSDCTL_ENT_DLY_SHIFT 16
 #define RTSDCTL_ENT_DLY_MASK (0xffff << RTSDCTL_ENT_DLY_SHIFT)
-#define RTSDCTL_ENT_DLY_MIN 1200
+#define RTSDCTL_ENT_DLY_MIN 3200
 #define RTSDCTL_ENT_DLY_MAX 12800
 	u32 rtsdctl;		/* seed control register */
 	union {
-- 
1.8.3.1
