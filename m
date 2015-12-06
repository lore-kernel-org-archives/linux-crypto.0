From: Haren Myneni <haren@linux.vnet.ibm.com>
Subject: crypto/nx842: Ignore queue overflow informative error
Date: Sat, 05 Dec 2015 23:46:44 -0800
Message-ID: <1449388004.2096.12.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: hbabu@us.ibm.com
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	ddstreet@ieee.org, mpe@ellerman.id.au, pair@us.ibm.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:52077 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbbLFHqw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 6 Dec 2015 02:46:52 -0500
Received: from localhost
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <haren@linux.vnet.ibm.com>;
	Sun, 6 Dec 2015 00:46:52 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


NX842 coprocessor sets bit 3 if queue is overflow. It is just for
information to the user. So the driver prints this informative message
and ignores it.
    
Signed-off-by: Haren Myneni <haren@us.ibm.com>

diff --git a/arch/powerpc/include/asm/icswx.h b/arch/powerpc/include/asm/icswx.h
index 9f8402b..d1a2a2d 100644
--- a/arch/powerpc/include/asm/icswx.h
+++ b/arch/powerpc/include/asm/icswx.h
@@ -164,6 +164,7 @@ struct coprocessor_request_block {
 #define ICSWX_INITIATED		(0x8)
 #define ICSWX_BUSY		(0x4)
 #define ICSWX_REJECTED		(0x2)
+#define ICSWX_BIT3		(0x1)	/* undefined or set from XERSO. */
 
 static inline int icswx(__be32 ccw, struct coprocessor_request_block *crb)
 {
diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
index 9ef51fa..321b8e8 100644
--- a/drivers/crypto/nx/nx-842-powernv.c
+++ b/drivers/crypto/nx/nx-842-powernv.c
@@ -442,6 +442,15 @@ static int nx842_powernv_function(const unsigned char *in, unsigned int inlen,
 			     (unsigned int)ccw,
 			     (unsigned int)be32_to_cpu(crb->ccw));
 
+	/*
+	 * NX842 coprocessor uses 3rd bit to report queue overflow which is
+	 * not an error, just for information to user. So, ignore this bit.
+	 */
+	if (ret & ICSWX_BIT3) {
+		pr_info_ratelimited("842 coprocessor queue overflow\n");
+		ret &= ~ICSWX_BIT3;
+	}
+
 	switch (ret) {
 	case ICSWX_INITIATED:
 		ret = wait_for_csb(wmem, csb);
