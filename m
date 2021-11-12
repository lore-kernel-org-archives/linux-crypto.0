Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E137C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 15:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FE1260F70
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 15:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233843AbhKLPik (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Nov 2021 10:38:40 -0500
Received: from uho.ysoft.cz ([81.19.3.130]:58848 "EHLO uho.ysoft.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229841AbhKLPij (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Nov 2021 10:38:39 -0500
X-Greylist: delayed 474 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Nov 2021 10:38:39 EST
Received: from vokac-Latitude-7410.ysoft.local (unknown [10.0.29.210])
        by uho.ysoft.cz (Postfix) with ESMTP id D0DC3A83B0;
        Fri, 12 Nov 2021 16:27:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ysoft.com;
        s=20160406-ysoft-com; t=1636730874;
        bh=sRyWfWvUhYcLed9k266C2obfp+SxlQfFYRCig9vaidk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d8AQuKw3rK5okAkx2e6HqrGlDVHL4qqGCQLJ+O/ZuPOjiGtQTHqCk5OqDvm++z7m1
         oOwPc3iJ3rPE6Z78hPqGFA4YM7J6jQI6lJXeBWrlEUlkLHdgpvBsC44SNRis5lGu/j
         ndrZfddefIp8JU3IkomGXaqXnIPW9HPaPqXmgNKo=
From:   =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>
To:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        l.stach@pengutronix.de, robert.hancock@calian.com,
        Petr Benes <petr.benes@ysoft.com>, petrben@gmail.com,
        =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>
Subject: [RFC PATCH] crypto: caam - restore retry count after HW RNG failure
Date:   Fri, 12 Nov 2021 16:27:05 +0100
Message-Id: <20211112152705.90513-1-michal.vokac@ysoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <ea3906acc2c8d6fb56eacd94b9531c18fa7cb4dc.camel@calian.com>
References: <ea3906acc2c8d6fb56eacd94b9531c18fa7cb4dc.camel@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Petr Benes <petr.benes@ysoft.com>

Each time TRNG generates entropy, statistical tests are run.
If they fail, RETRY_COUNT value is decremented. Once it
reaches 0, HW RNG returns an error, and needs to be reset.
RETRY_COUNT could be programmed in RTSCMISC register and is
set to 1 by default. Hence, we are left without hwrng after
the first error, which could happen even under normal
conditions.

Cc: petrben@gmail.com
Signed-off-by: Petr Benes <petr.benes@ysoft.com>
Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>
---
Hi,
we are also experiencing this issue:

caam_jr 2101000.jr0: 20003c5b: CCB: desc idx 60: RNG: Hardware error.

It is happening on both i.MX6S and i.MX6DL SoCs we use.
On Solo I can reproduce it really fast. Sometimes it happens right
after the board is NFS booted, sometimes I need to stress the HWRNG
for a while (generate few hundred KBs of random data). On some
DualLite SoCs it is happening at least once a day.

We are using the v5.10 LTS branch but I can confirm that this is
happening on all kernels since v5.7 to the latest linux-next.

We also tried to increase the RTSDCTL_ENT_DLY_MIN delay as suggested
in this thread [1]. It helped and the issue never occurred since then
but we are looking for more universal and permanent solution suitable
for upstream, hence we came up with this patch.

Any comments will be appreciated.
Thanks, Michal

[1] https://lkml.org/lkml/2021/8/30/296

 drivers/crypto/caam/caamrng.c | 42 ++++++++++++++++++++++++++++++++---
 drivers/crypto/caam/ctrl.c    | 13 +++++++++++
 drivers/crypto/caam/ctrl.h    |  2 ++
 3 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 77d048dfe5d0..2be5584ae591 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -21,6 +21,7 @@
 #include "desc_constr.h"
 #include "jr.h"
 #include "error.h"
+#include "ctrl.h"
 
 #define CAAM_RNG_MAX_FIFO_STORE_SIZE	16
 
@@ -113,6 +114,35 @@ static int caam_rng_read_one(struct device *jrdev,
 	return err ?: (ret ?: len);
 }
 
+static void caam_rng_retry_reset(struct caam_rng_ctx *context)
+{
+	struct device *ctrldev = context->ctrldev;
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctrldev);
+	struct caam_ctrl __iomem *ctrl;
+	struct rng4tst __iomem *r4tst;
+	u32 __iomem *rtstatus;
+	u32 retry_count;
+
+	ctrl = (struct caam_ctrl __iomem *)ctrlpriv->ctrl;
+	r4tst = &ctrl->r4tst[0];
+
+	/*
+	 * There is unfortunately no member for RTSTATUS register in
+	 * struct rng4tst and the structure doesn't look stable
+	 */
+	rtstatus = (u32 *)((char *)&ctrl->r4tst[0] + 0x3C);
+	retry_count = (rd_reg32(rtstatus) >> 16) & 0xf;
+	dev_dbg(ctrldev, "CAAM RNG retry count %d\n", retry_count);
+	if (retry_count == 0) {
+		dev_err(ctrldev, "CAAM RNG resetting retry count to 1\n");
+		clrsetbits_32(&r4tst->rtmctl, 0, RTMCTL_PRGM | RTMCTL_ACC);
+		wr_reg32(&r4tst->rtscmisc, (rd_reg32(&r4tst->rtscmisc) & 0x7f) | (1 << 16));
+		clrsetbits_32(&r4tst->rtmctl, RTMCTL_PRGM | RTMCTL_ACC,
+				RTMCTL_SAMP_MODE_RAW_ES_SC);
+		caam_reinstantiate_rng(ctrldev);
+	}
+}
+
 static void caam_rng_fill_async(struct caam_rng_ctx *ctx)
 {
 	struct scatterlist sg[1];
@@ -129,8 +159,10 @@ static void caam_rng_fill_async(struct caam_rng_ctx *ctx)
 				sg[0].length,
 				ctx->desc_async,
 				&done);
-	if (len < 0)
+	if (len < 0) {
+		caam_rng_retry_reset(ctx);
 		return;
+	}
 
 	kfifo_dma_in_finish(&ctx->fifo, len);
 }
@@ -145,13 +177,17 @@ static void caam_rng_worker(struct work_struct *work)
 static int caam_read(struct hwrng *rng, void *dst, size_t max, bool wait)
 {
 	struct caam_rng_ctx *ctx = to_caam_rng_ctx(rng);
-	int out;
+	int out, ret;
 
 	if (wait) {
 		struct completion done;
 
-		return caam_rng_read_one(ctx->jrdev, dst, max,
+		ret = caam_rng_read_one(ctx->jrdev, dst, max,
 					 ctx->desc_sync, &done);
+		if (ret < 0)
+			caam_rng_retry_reset(ctx);
+
+		return ret;
 	}
 
 	out = kfifo_out(&ctx->fifo, dst, max);
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index ca0361b2dbb0..e421f8d1982b 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -339,6 +339,19 @@ static int instantiate_rng(struct device *ctrldev, int state_handle_mask,
 	return devm_add_action_or_reset(ctrldev, devm_deinstantiate_rng, ctrldev);
 }
 
+/*
+ * caam_reinstantiate_rng - reinstantiates RNG. Intended for a case when RNG falls into
+ *			    HW error condition. That happens if TRNG fails statistical
+ *			    check and RTY_CNT value set in RTSCMISC decrements to zero.
+ *			    It is exported to caamrng.c
+ * @ctrldev - pointer to device
+ */
+
+int caam_reinstantiate_rng(struct device *ctrldev)
+{
+	return instantiate_rng(ctrldev, 0, 0);
+}
+
 /*
  * kick_trng - sets the various parameters for enabling the initialization
  *	       of the RNG4 block in CAAM
diff --git a/drivers/crypto/caam/ctrl.h b/drivers/crypto/caam/ctrl.h
index f3ecd67922a7..26ff5a49a865 100644
--- a/drivers/crypto/caam/ctrl.h
+++ b/drivers/crypto/caam/ctrl.h
@@ -8,6 +8,8 @@
 #ifndef CTRL_H
 #define CTRL_H
 
+int caam_reinstantiate_rng(struct device *ctrldev);
+
 /* Prototypes for backend-level services exposed to APIs */
 extern bool caam_dpaa2;
 
-- 
2.25.1

