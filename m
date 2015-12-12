From: Haren Myneni <haren@linux.vnet.ibm.com>
Subject: Crypto/nx842: Ignore invalid XER[S0] return error
Date: Fri, 11 Dec 2015 19:30:29 -0800
Message-ID: <1449891029.19568.5.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org
To: herbert@gondor.apana.org.au, ddstreet@ieee.org,
	davem@davemloft.net, mpe@ellerman.id.au, pair@us.ibm.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


NX842 coprocessor sets 3rd bit in CR register with XER[S0] which is
nothing to do with NX request. On powerpc, XER[S0] will be set if
overflow in FPU and stays until another floating point operation is
executed. Since this bit can be set with other valuable return status,
ignore this XER[S0] value.

One of other bits (INITIATED, BUSY or REJECTED) will be returned for
any given NX request.

Signed-off-by: Haren Myneni <haren@us.ibm.com>

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
index 9ef51fa..6bc33ae 100644
--- a/drivers/crypto/nx/nx-842-powernv.c
+++ b/drivers/crypto/nx/nx-842-powernv.c
@@ -442,6 +442,16 @@ static int nx842_powernv_function(const unsigned char *in, unsigned int inlen,
 			     (unsigned int)ccw,
 			     (unsigned int)be32_to_cpu(crb->ccw));
 
+	/*
+	 * NX842 coprocessor sets 3rd bit in CR register with XER[S0].
+	 * Setting XER[S0] happens if overflow in FPU and stays until
+	 * other floating operation is executed. XER[S0] value is nothing
+	 * to NX and no use to user. Since this bit can be set with other
+	 * return values, ignore this error.
+	 */
+	if (ret & ICSWX_XERS0)
+		ret &= ~ICSWX_XERS0;
+
 	switch (ret) {
 	case ICSWX_INITIATED:
 		ret = wait_for_csb(wmem, csb);
@@ -454,10 +464,6 @@ static int nx842_powernv_function(const unsigned char *in, unsigned int inlen,
 		pr_err_ratelimited("ICSWX rejected\n");
 		ret = -EPROTO;
 		break;
-	default:
-		pr_err_ratelimited("Invalid ICSWX return code %x\n", ret);
-		ret = -EPROTO;
-		break;
 	}
 
 	if (!ret)
