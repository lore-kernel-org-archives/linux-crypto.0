From: Haren Myneni <haren@linux.vnet.ibm.com>
Subject: [PATCH] crypto/nx842: Mask XERS0 bit in return value
Date: Sun, 13 Dec 2015 03:30:41 -0800
Message-ID: <1450006242.19568.11.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au, segher@kernel.crashing.org,
	ddstreet@ieee.org, davem@davemloft.net, pair@us.ibm.com,
	mpe@ellerman.id.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:42198 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbbLMLaz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 13 Dec 2015 06:30:55 -0500
Received: from localhost
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <haren@linux.vnet.ibm.com>;
	Sun, 13 Dec 2015 04:30:54 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


NX842 coprocessor sets 3rd bit in CR register with XER[S0] which is
nothing to do with NX request. Since this bit can be set with other
valuable return status, mast this bit.

One of other bits (INITIATED, BUSY or REJECTED) will be returned for
any given NX request.

Signed-off-by: Haren Myneni <haren@us.ibm.com>
---
 arch/powerpc/include/asm/icswx.h   |    1 +
 drivers/crypto/nx/nx-842-powernv.c |   12 ++++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/icswx.h b/arch/powerpc/include/asm/icswx.h
index 9f8402b..27e588f 100644
--- a/arch/powerpc/include/asm/icswx.h
+++ b/arch/powerpc/include/asm/icswx.h
@@ -164,6 +164,7 @@ struct coprocessor_request_block {
 #define ICSWX_INITIATED		(0x8)
 #define ICSWX_BUSY		(0x4)
 #define ICSWX_REJECTED		(0x2)
+#define ICSWX_XERS0		(0x1)	/* undefined or set from XERSO. */
 
 static inline int icswx(__be32 ccw, struct coprocessor_request_block *crb)
 {
diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
index 9ef51fa..6e105e8 100644
--- a/drivers/crypto/nx/nx-842-powernv.c
+++ b/drivers/crypto/nx/nx-842-powernv.c
@@ -442,6 +442,14 @@ static int nx842_powernv_function(const unsigned char *in, unsigned int inlen,
 			     (unsigned int)ccw,
 			     (unsigned int)be32_to_cpu(crb->ccw));
 
+	/*
+	 * NX842 coprocessor sets 3rd bit in CR register with XER[S0].
+	 * XER[S0] is the integer summary overflow bit which is nothing
+	 * to do NX. Since this bit can be set with other return values,
+	 * mask this bit.
+	 */
+	ret &= ~ICSWX_XERS0;
+
 	switch (ret) {
 	case ICSWX_INITIATED:
 		ret = wait_for_csb(wmem, csb);
@@ -454,10 +462,6 @@ static int nx842_powernv_function(const unsigned char *in, unsigned int inlen,
 		pr_err_ratelimited("ICSWX rejected\n");
 		ret = -EPROTO;
 		break;
-	default:
-		pr_err_ratelimited("Invalid ICSWX return code %x\n", ret);
-		ret = -EPROTO;
-		break;
 	}
 
 	if (!ret)
-- 
1.7.0.4
