From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 2/4] crypto: caam - fix queue interface detection
Date: Mon, 11 Apr 2011 19:15:21 -0500
Message-ID: <20110411191521.52d6ccc6.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Steve Cornelius <sec@pobox.com>
To: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:5377 "EHLO
	VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756472Ab1DLAPY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Apr 2011 20:15:24 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The presence of a h/w Queue Interface would fail due to this
cut-n-paste snafu.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/regs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index d063a26..aee394e 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -131,7 +131,7 @@ struct caam_perfmon {
 	/* CAAM Hardware Instantiation Parameters		fa0-fbf */
 	u64 cha_rev;		/* CRNR - CHA Revision Number		*/
 #define CTPR_QI_SHIFT		57
-#define CTPR_QI_MASK		(0x1ull << CHA_NUM_DECONUM_SHIFT)
+#define CTPR_QI_MASK		(0x1ull << CTPR_QI_SHIFT)
 	u64 comp_parms;	/* CTPR - Compile Parameters Register	*/
 	u64 rsvd1[2];
 
-- 
1.7.4.3.dirty
