From: Haren Myneni <haren@linux.vnet.ibm.com>
Subject: [PATCH V4 1/7] crypto/nx: Rename nx842_powernv_function as icswx
 function
Date: Thu, 31 Aug 2017 00:11:29 -0700
Message-ID: <1504163489.4681.4.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        mikey@neuling.org, ddstreet@ieee.org, linuxram@us.ibm.com,
        npiggin@gmail.com, benh@kernel.crashing.org, suka@us.ibm.com,
        hbabu@us.ibm.com
To: mpe@ellerman.id.au, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48148 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751057AbdHaHLp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Aug 2017 03:11:45 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7V79bEC104450
        for <linux-crypto@vger.kernel.org>; Thu, 31 Aug 2017 03:11:45 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2cpbh894kg-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Thu, 31 Aug 2017 03:11:44 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <haren@linux.vnet.ibm.com>;
        Thu, 31 Aug 2017 03:11:44 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Rename nx842_powernv_function to nx842_powernv_exec.
nx842_powernv_exec points to nx842_exec_icswx and
will be point to VAS exec function which will be added later
for P9 NX support.

Signed-off-by: Haren Myneni <haren@us.ibm.com>
---
 drivers/crypto/nx/nx-842-powernv.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
index 3abb045cdba7..161987698bbc 100644
--- a/drivers/crypto/nx/nx-842-powernv.c
+++ b/drivers/crypto/nx/nx-842-powernv.c
@@ -54,7 +54,11 @@ struct nx842_coproc {
 
 /* no cpu hotplug on powernv, so this list never changes after init */
 static LIST_HEAD(nx842_coprocs);
-static unsigned int nx842_ct;
+static unsigned int nx842_ct;	/* used in icswx function */
+
+static int (*nx842_powernv_exec)(const unsigned char *in,
+				unsigned int inlen, unsigned char *out,
+				unsigned int *outlenp, void *workmem, int fc);
 
 /**
  * setup_indirect_dde - Setup an indirect DDE
@@ -355,7 +359,7 @@ static int wait_for_csb(struct nx842_workmem *wmem,
 }
 
 /**
- * nx842_powernv_function - compress/decompress data using the 842 algorithm
+ * nx842_exec_icswx - compress/decompress data using the 842 algorithm
  *
  * (De)compression provided by the NX842 coprocessor on IBM PowerNV systems.
  * This compresses or decompresses the provided input buffer into the provided
@@ -385,7 +389,7 @@ static int wait_for_csb(struct nx842_workmem *wmem,
  *   -ETIMEDOUT	hardware did not complete operation in reasonable time
  *   -EINTR	operation was aborted
  */
-static int nx842_powernv_function(const unsigned char *in, unsigned int inlen,
+static int nx842_exec_icswx(const unsigned char *in, unsigned int inlen,
 				  unsigned char *out, unsigned int *outlenp,
 				  void *workmem, int fc)
 {
@@ -489,13 +493,13 @@ static int nx842_powernv_function(const unsigned char *in, unsigned int inlen,
  * @workmem: working memory buffer pointer, size determined by
  *           nx842_powernv_driver.workmem_size
  *
- * Returns: see @nx842_powernv_function()
+ * Returns: see @nx842_powernv_exec()
  */
 static int nx842_powernv_compress(const unsigned char *in, unsigned int inlen,
 				  unsigned char *out, unsigned int *outlenp,
 				  void *wmem)
 {
-	return nx842_powernv_function(in, inlen, out, outlenp,
+	return nx842_powernv_exec(in, inlen, out, outlenp,
 				      wmem, CCW_FC_842_COMP_CRC);
 }
 
@@ -517,13 +521,13 @@ static int nx842_powernv_compress(const unsigned char *in, unsigned int inlen,
  * @workmem: working memory buffer pointer, size determined by
  *           nx842_powernv_driver.workmem_size
  *
- * Returns: see @nx842_powernv_function()
+ * Returns: see @nx842_powernv_exec()
  */
 static int nx842_powernv_decompress(const unsigned char *in, unsigned int inlen,
 				    unsigned char *out, unsigned int *outlenp,
 				    void *wmem)
 {
-	return nx842_powernv_function(in, inlen, out, outlenp,
+	return nx842_powernv_exec(in, inlen, out, outlenp,
 				      wmem, CCW_FC_842_DECOMP_CRC);
 }
 
@@ -625,6 +629,8 @@ static __init int nx842_powernv_init(void)
 	if (!nx842_ct)
 		return -ENODEV;
 
+	nx842_powernv_exec = nx842_exec_icswx;
+
 	ret = crypto_register_alg(&nx842_powernv_alg);
 	if (ret) {
 		struct nx842_coproc *coproc, *n;
-- 
2.11.0
