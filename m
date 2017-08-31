From: Haren Myneni <haren@linux.vnet.ibm.com>
Subject: [PATCH V4 4/7] crypto/nx: Add nx842_add_coprocs_list function
Date: Thu, 31 Aug 2017 00:14:06 -0700
Message-ID: <1504163646.4681.7.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        mikey@neuling.org, ddstreet@ieee.org, linuxram@us.ibm.com,
        npiggin@gmail.com, benh@kernel.crashing.org, suka@us.ibm.com,
        hbabu@us.ibm.com
To: mpe@ellerman.id.au, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58222 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751127AbdHaHOV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Aug 2017 03:14:21 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7V7CxSQ026151
        for <linux-crypto@vger.kernel.org>; Thu, 31 Aug 2017 03:14:21 -0400
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2cpa77xabm-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Thu, 31 Aug 2017 03:14:21 -0400
Received: from localhost
        by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <haren@linux.vnet.ibm.com>;
        Thu, 31 Aug 2017 03:14:20 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Updating coprocessor list is moved to nx842_add_coprocs_list().
This function will be used for both icswx and VAS functions.

Signed-off-by: Haren Myneni <haren@us.ibm.com>
---
 drivers/crypto/nx/nx-842-powernv.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
index 67dc06f9b557..829b5cad0043 100644
--- a/drivers/crypto/nx/nx-842-powernv.c
+++ b/drivers/crypto/nx/nx-842-powernv.c
@@ -550,6 +550,14 @@ static int nx842_powernv_decompress(const unsigned char *in, unsigned int inlen,
 				      wmem, CCW_FC_842_DECOMP_CRC);
 }
 
+static inline void nx842_add_coprocs_list(struct nx842_coproc *coproc,
+					int chipid)
+{
+	coproc->chip_id = chipid;
+	INIT_LIST_HEAD(&coproc->list);
+	list_add(&coproc->list, &nx842_coprocs);
+}
+
 static int __init nx842_powernv_probe(struct device_node *dn)
 {
 	struct nx842_coproc *coproc;
@@ -576,11 +584,9 @@ static int __init nx842_powernv_probe(struct device_node *dn)
 	if (!coproc)
 		return -ENOMEM;
 
-	coproc->chip_id = chip_id;
 	coproc->ct = ct;
 	coproc->ci = ci;
-	INIT_LIST_HEAD(&coproc->list);
-	list_add(&coproc->list, &nx842_coprocs);
+	nx842_add_coprocs_list(coproc, chip_id);
 
 	pr_info("coprocessor found on chip %d, CT %d CI %d\n", chip_id, ct, ci);
 
-- 
2.11.0
