From: Alex Porosanu <alexandru.porosanu@freescale.com>
Subject: [PATCH 1/3] crypto: caam - disable RNG oscillator maximum frequency check
Date: Mon, 11 Aug 2014 11:40:15 +0300
Message-ID: <1407746417-9134-2-git-send-email-alexandru.porosanu@freescale.com>
References: <1407746417-9134-1-git-send-email-alexandru.porosanu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:8071
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752555AbaHKIlA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Aug 2014 04:41:00 -0400
In-Reply-To: <1407746417-9134-1-git-send-email-alexandru.porosanu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The rtfrqmax & rtfrqmin set the bounds of the expected frequency of the
oscillator, when SEC runs at its maximum frequency. For certain platforms
(f.i. T2080), the oscillator is very fast and thus if the SEC runs at
a lower than normal frequency, the ring oscillator is incorrectly detected
as being out of bounds.

This patch effectively disables the maximum frequency check, by setting a
high enough maximum allowable frequency for the oscillator. The reasoning
behind this is that usually a broken oscillator will run too slow
(i.e. not run at all) rather than run too fast.

Signed-off-by: Alex Porosanu <alexandru.porosanu@freescale.com>
---
 drivers/crypto/caam/ctrl.c | 4 ++--
 drivers/crypto/caam/regs.h | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 3cade79..8908d04 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -355,8 +355,8 @@ static void kick_trng(struct platform_device *pdev, int ent_delay)
 	wr_reg32(&r4tst->rtsdctl, val);
 	/* min. freq. count, equal to 1/4 of the entropy sample length */
 	wr_reg32(&r4tst->rtfrqmin, ent_delay >> 2);
-	/* max. freq. count, equal to 8 times the entropy sample length */
-	wr_reg32(&r4tst->rtfrqmax, ent_delay << 3);
+	/* disable maximum frequency count */
+	wr_reg32(&r4tst->rtfrqmax, RTFRQMAX_DISABLE);
 	/* put RNG4 into run mode */
 	clrbits32(&r4tst->rtmctl, RTMCTL_PRGM);
 }
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index f48e344..b8bd980 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -286,6 +286,7 @@ struct rng4tst {
 		u32 rttotsam;	/* PRGM=0: total samples register */
 	};
 	u32 rtfrqmin;		/* frequency count min. limit register */
+#define RTFRQMAX_DISABLE	(1 << 20)
 	union {
 		u32 rtfrqmax;	/* PRGM=1: freq. count max. limit register */
 		u32 rtfrqcnt;	/* PRGM=0: freq. count register */
-- 
1.8.3.1
