From: Haren Myneni <haren@linux.vnet.ibm.com>
Subject: [PATCH 2/5] crypto/nx: Create nx842_cfg_crb function
Date: Sat, 01 Apr 2017 10:00:00 -0700
Message-ID: <1491066000.29552.27.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        benh@kernel.crashing.org, mikey@neuling.org, suka@us.ibm.com,
        hbabu@us.ibm.com
To: herbert@gondor.apana.org.au, mpe@ellerman.id.au, ddstreet@ieee.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48446 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751752AbdDARAI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Apr 2017 13:00:08 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v31GwkoS051694
        for <linux-crypto@vger.kernel.org>; Sat, 1 Apr 2017 13:00:07 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29j97eq4gp-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Sat, 01 Apr 2017 13:00:07 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <haren@linux.vnet.ibm.com>;
        Sat, 1 Apr 2017 11:00:06 -0600
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[PATCH 2/5] crypto/nx: Create nx842_cfg_crb function

Configure CRB is moved to nx842_cfg_crb() so that it can be
used for icswx function and VAS function which will be added
later.

Signed-off-by: Haren Myneni <haren@us.ibm.com>
---
 drivers/crypto/nx/nx-842-powernv.c | 57 +++++++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
index 125f1dc..4cd6a6f 100644
--- a/drivers/crypto/nx/nx-842-powernv.c
+++ b/drivers/crypto/nx/nx-842-powernv.c
@@ -362,6 +362,40 @@ static int wait_for_csb(struct nx842_workmem *wmem,
 	return 0;
 }
 
+static int nx842_cfg_crb(const unsigned char *in, unsigned int inlen,
+			unsigned char *out, unsigned int outlen,
+			struct nx842_workmem *wmem)
+{
+	struct coprocessor_request_block *crb;
+	struct coprocessor_status_block *csb;
+	u64 csb_addr;
+	int ret;
+
+	crb = &wmem->crb;
+	csb = &crb->csb;
+
+	/* Clear any previous values */
+	memset(crb, 0, sizeof(*crb));
+
+	/* set up DDLs */
+	ret = setup_ddl(&crb->source, wmem->ddl_in,
+			(unsigned char *)in, inlen, true);
+	if (ret)
+		return ret;
+
+	ret = setup_ddl(&crb->target, wmem->ddl_out,
+			out, outlen, false);
+	if (ret)
+		return ret;
+
+	/* set up CRB's CSB addr */
+	csb_addr = nx842_get_pa(csb) & CRB_CSB_ADDRESS;
+	csb_addr |= CRB_CSB_AT; /* Addrs are phys */
+	crb->csb_addr = cpu_to_be64(csb_addr);
+
+	return 0;
+}
+
 /**
  * nx842_icswx_function - compress/decompress data using the 842 algorithm
  *
@@ -401,7 +435,6 @@ static int nx842_icswx_function(const unsigned char *in, unsigned int inlen,
 	struct coprocessor_status_block *csb;
 	struct nx842_workmem *wmem;
 	int ret;
-	u64 csb_addr;
 	u32 ccw;
 	unsigned int outlen = *outlenp;
 
@@ -415,33 +448,19 @@ static int nx842_icswx_function(const unsigned char *in, unsigned int inlen,
 		return -ENODEV;
 	}
 
-	crb = &wmem->crb;
-	csb = &crb->csb;
-
-	/* Clear any previous values */
-	memset(crb, 0, sizeof(*crb));
-
-	/* set up DDLs */
-	ret = setup_ddl(&crb->source, wmem->ddl_in,
-			(unsigned char *)in, inlen, true);
-	if (ret)
-		return ret;
-	ret = setup_ddl(&crb->target, wmem->ddl_out,
-			out, outlen, false);
+	ret = nx842_cfg_crb(in, inlen, out, outlen, wmem);
 	if (ret)
 		return ret;
 
+	crb = &wmem->crb;
+	csb = &crb->csb;
+
 	/* set up CCW */
 	ccw = 0;
 	ccw = SET_FIELD(CCW_CT, ccw, nx842_ct);
 	ccw = SET_FIELD(CCW_CI_842, ccw, 0); /* use 0 for hw auto-selection */
 	ccw = SET_FIELD(CCW_FC_842, ccw, fc);
 
-	/* set up CRB's CSB addr */
-	csb_addr = nx842_get_pa(csb) & CRB_CSB_ADDRESS;
-	csb_addr |= CRB_CSB_AT; /* Addrs are phys */
-	crb->csb_addr = cpu_to_be64(csb_addr);
-
 	wmem->start = ktime_get();
 
 	/* do ICSWX */
-- 
1.8.3.1
