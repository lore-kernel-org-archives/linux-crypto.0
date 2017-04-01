From: Haren Myneni <haren@linux.vnet.ibm.com>
Subject: [PATCH 1/5] crypto/nx: Rename nx842_powernv_function as icswx
 function
Date: Sat, 01 Apr 2017 09:59:01 -0700
Message-ID: <1491065941.29552.26.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        benh@kernel.crashing.org, mikey@neuling.org, suka@us.ibm.com,
        hbabu@us.ibm.com
To: herbert@gondor.apana.org.au, mpe@ellerman.id.au, ddstreet@ieee.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52179 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751752AbdDAQ7L (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Apr 2017 12:59:11 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v31GwjhP015084
        for <linux-crypto@vger.kernel.org>; Sat, 1 Apr 2017 12:59:10 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29j8c08qva-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Sat, 01 Apr 2017 12:59:10 -0400
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <haren@linux.vnet.ibm.com>;
        Sat, 1 Apr 2017 10:59:09 -0600
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[PATCH 1/5] crypto/nx: Rename nx842_powernv_function as icswx function

nx842_powernv_function is points to nx842_icswx_function and
will be point to VAS function which will be added later for
P9 NX support.

Signed-off-by: Haren Myneni <haren@us.ibm.com>
---
 drivers/crypto/nx/nx-842-powernv.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
index 3abb045..125f1dc 100644
--- a/drivers/crypto/nx/nx-842-powernv.c
+++ b/drivers/crypto/nx/nx-842-powernv.c
@@ -47,14 +47,22 @@ struct nx842_workmem {
 
 struct nx842_coproc {
 	unsigned int chip_id;
-	unsigned int ct;
-	unsigned int ci;
+	union {
+		struct {
+			unsigned int ct;
+			unsigned int ci;
+		} icswx;
+	};
 	struct list_head list;
 };
 
 /* no cpu hotplug on powernv, so this list never changes after init */
 static LIST_HEAD(nx842_coprocs);
-static unsigned int nx842_ct;
+static unsigned int nx842_ct;	/* use with icswx function */
+
+static int (*nx842_powernv_function)(const unsigned char *in,
+				unsigned int inlen, unsigned char *out,
+				unsigned int *outlenp, void *workmem, int fc);
 
 /**
  * setup_indirect_dde - Setup an indirect DDE
@@ -355,7 +363,7 @@ static int wait_for_csb(struct nx842_workmem *wmem,
 }
 
 /**
- * nx842_powernv_function - compress/decompress data using the 842 algorithm
+ * nx842_icswx_function - compress/decompress data using the 842 algorithm
  *
  * (De)compression provided by the NX842 coprocessor on IBM PowerNV systems.
  * This compresses or decompresses the provided input buffer into the provided
@@ -385,7 +393,7 @@ static int wait_for_csb(struct nx842_workmem *wmem,
  *   -ETIMEDOUT	hardware did not complete operation in reasonable time
  *   -EINTR	operation was aborted
  */
-static int nx842_powernv_function(const unsigned char *in, unsigned int inlen,
+static int nx842_icswx_function(const unsigned char *in, unsigned int inlen,
 				  unsigned char *out, unsigned int *outlenp,
 				  void *workmem, int fc)
 {
@@ -554,8 +562,8 @@ static int __init nx842_powernv_probe(struct device_node *dn)
 		return -ENOMEM;
 
 	coproc->chip_id = chip_id;
-	coproc->ct = ct;
-	coproc->ci = ci;
+	coproc->icswx.ct = ct;
+	coproc->icswx.ci = ci;
 	INIT_LIST_HEAD(&coproc->list);
 	list_add(&coproc->list, &nx842_coprocs);
 
@@ -625,6 +633,8 @@ static __init int nx842_powernv_init(void)
 	if (!nx842_ct)
 		return -ENODEV;
 
+	nx842_powernv_function = nx842_icswx_function;
+
 	ret = crypto_register_alg(&nx842_powernv_alg);
 	if (ret) {
 		struct nx842_coproc *coproc, *n;
-- 
1.8.3.1
