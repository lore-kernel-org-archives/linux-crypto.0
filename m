From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH 2/4] mv_cesa: no need to write to that FPGA_INT_STATUS field
Date: Fri, 25 May 2012 15:54:47 +0200
Message-ID: <1337954089-12702-2-git-send-email-phil.sutter@viprinet.com>
References: <1337954089-12702-1-git-send-email-phil.sutter@viprinet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:45588 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927Ab2EYOCS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 May 2012 10:02:18 -0400
In-Reply-To: <1337954089-12702-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Also drop the whole definition, since it's unused otherwise.

Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 drivers/crypto/mv_cesa.c |    1 -
 drivers/crypto/mv_cesa.h |    7 -------
 2 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 8327bed..4a1f872 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -908,7 +908,6 @@ irqreturn_t crypto_int(int irq, void *priv)
 		       "got an interrupt but no pending timer?\n");
 	}
 	val &= ~SEC_INT_ACCEL0_DONE;
-	writel(val, cpg->reg + FPGA_INT_STATUS);
 	writel(val, cpg->reg + SEC_ACCEL_INT_STATUS);
 	BUG_ON(cpg->eng_st != ENGINE_BUSY);
 	cpg->eng_st = ENGINE_W_DEQUEUE;
diff --git a/drivers/crypto/mv_cesa.h b/drivers/crypto/mv_cesa.h
index 08fcb11..81ce109 100644
--- a/drivers/crypto/mv_cesa.h
+++ b/drivers/crypto/mv_cesa.h
@@ -29,13 +29,6 @@
 #define SEC_ST_ACT_0		(1 << 0)
 #define SEC_ST_ACT_1		(1 << 1)
 
-/*
- * FPGA_INT_STATUS looks like a FPGA leftover and is documented only in Errata
- * 4.12. It looks like that it was part of an IRQ-controller in FPGA and
- * someone forgot to remove  it while switching to the core and moving to
- * SEC_ACCEL_INT_STATUS.
- */
-#define FPGA_INT_STATUS		0xdd68
 #define SEC_ACCEL_INT_STATUS	0xde20
 #define SEC_INT_AUTH_DONE	(1 << 0)
 #define SEC_INT_DES_E_DONE	(1 << 1)
-- 
1.7.3.4
