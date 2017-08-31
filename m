From: Haren Myneni <haren@linux.vnet.ibm.com>
Subject: [PATCH V4 3/7] crypto/nx: Create nx842_delete_coprocs function
Date: Thu, 31 Aug 2017 00:13:15 -0700
Message-ID: <1504163595.4681.6.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        mikey@neuling.org, ddstreet@ieee.org, linuxram@us.ibm.com,
        npiggin@gmail.com, benh@kernel.crashing.org, suka@us.ibm.com,
        hbabu@us.ibm.com
To: mpe@ellerman.id.au, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54720 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750897AbdHaHNb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Aug 2017 03:13:31 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7V79rtI045490
        for <linux-crypto@vger.kernel.org>; Thu, 31 Aug 2017 03:13:31 -0400
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2cpc4g6xxd-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Thu, 31 Aug 2017 03:13:31 -0400
Received: from localhost
        by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <haren@linux.vnet.ibm.com>;
        Thu, 31 Aug 2017 03:13:30 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Move deleting coprocessors info upon exit or failure to
nx842_delete_coprocs().

Signed-off-by: Haren Myneni <haren@us.ibm.com>
---
 drivers/crypto/nx/nx-842-powernv.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
index 1bd19e03eb7d..67dc06f9b557 100644
--- a/drivers/crypto/nx/nx-842-powernv.c
+++ b/drivers/crypto/nx/nx-842-powernv.c
@@ -593,6 +593,16 @@ static int __init nx842_powernv_probe(struct device_node *dn)
 	return 0;
 }
 
+static void nx842_delete_coprocs(void)
+{
+	struct nx842_coproc *coproc, *n;
+
+	list_for_each_entry_safe(coproc, n, &nx842_coprocs, list) {
+		list_del(&coproc->list);
+		kfree(coproc);
+	}
+}
+
 static struct nx842_constraints nx842_powernv_constraints = {
 	.alignment =	DDE_BUFFER_ALIGN,
 	.multiple =	DDE_BUFFER_LAST_MULT,
@@ -652,13 +662,7 @@ static __init int nx842_powernv_init(void)
 
 	ret = crypto_register_alg(&nx842_powernv_alg);
 	if (ret) {
-		struct nx842_coproc *coproc, *n;
-
-		list_for_each_entry_safe(coproc, n, &nx842_coprocs, list) {
-			list_del(&coproc->list);
-			kfree(coproc);
-		}
-
+		nx842_delete_coprocs();
 		return ret;
 	}
 
@@ -668,13 +672,8 @@ module_init(nx842_powernv_init);
 
 static void __exit nx842_powernv_exit(void)
 {
-	struct nx842_coproc *coproc, *n;
-
 	crypto_unregister_alg(&nx842_powernv_alg);
 
-	list_for_each_entry_safe(coproc, n, &nx842_coprocs, list) {
-		list_del(&coproc->list);
-		kfree(coproc);
-	}
+	nx842_delete_coprocs();
 }
 module_exit(nx842_powernv_exit);
-- 
2.11.0
