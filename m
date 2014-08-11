From: Alex Porosanu <alexandru.porosanu@freescale.com>
Subject: [PATCH 3/3] crypto: caam - enable raw data instead of von Neumann data
Date: Mon, 11 Aug 2014 11:40:17 +0300
Message-ID: <1407746417-9134-4-git-send-email-alexandru.porosanu@freescale.com>
References: <1407746417-9134-1-git-send-email-alexandru.porosanu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:36067
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752555AbaHKIlC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Aug 2014 04:41:02 -0400
In-Reply-To: <1407746417-9134-1-git-send-email-alexandru.porosanu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The sampling of the oscillator can be done in multiple modes for
generating the entropy value. By default, this is set to von
Neumann. This patch changes the sampling to raw data, since it
has been discovered that the generated entropy has a better
'quality'.

Signed-off-by: Alex Porosanu <alexandru.porosanu@freescale.com>
---
 drivers/crypto/caam/ctrl.c | 11 ++++++++++-
 drivers/crypto/caam/regs.h | 10 ++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 111ac1f..c621037 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -357,8 +357,17 @@ static void kick_trng(struct platform_device *pdev, int ent_delay)
 	wr_reg32(&r4tst->rtfrqmin, ent_delay >> 2);
 	/* disable maximum frequency count */
 	wr_reg32(&r4tst->rtfrqmax, RTFRQMAX_DISABLE);
+	/* read the control register */
+	val = rd_reg32(&r4tst->rtmctl);
+	/*
+	 * select raw sampling in both entropy shifter
+	 * and statistical checker
+	 */
+	setbits32(&val, RTMCTL_SAMP_MODE_RAW_ES_SC);
 	/* put RNG4 into run mode */
-	clrbits32(&r4tst->rtmctl, RTMCTL_PRGM);
+	clrbits32(&val, RTMCTL_PRGM);
+	/* write back the control register */
+	wr_reg32(&r4tst->rtmctl, val);
 }
 
 /**
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 5fa739c..bc9cd62 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -269,6 +269,16 @@ struct rngtst {
 /* RNG4 TRNG test registers */
 struct rng4tst {
 #define RTMCTL_PRGM	0x00010000	/* 1 -> program mode, 0 -> run mode */
+#define RTMCTL_SAMP_MODE_VON_NEUMANN_ES_SC	0 /* use von Neumann data in
+						     both entropy shifter and
+						     statistical checker */
+#define RTMCTL_SAMP_MODE_RAW_ES_SC		1 /* use raw data in both
+						     entropy shifter and
+						     statistical checker */
+#define RTMCTL_SAMP_MODE_VON_NEUMANN_ES_RAW_SC	2 /* use von Neumann data in
+						     entropy shifter, raw data
+						     in statistical checker */
+#define RTMCTL_SAMP_MODE_INVALID		3 /* invalid combination */
 	u32 rtmctl;		/* misc. control register */
 	u32 rtscmisc;		/* statistical check misc. register */
 	u32 rtpkrrng;		/* poker range register */
-- 
1.8.3.1
