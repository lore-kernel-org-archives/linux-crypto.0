From: Haren Myneni <haren@linux.vnet.ibm.com>
Subject: [PATCH V2 3/6] crypto/nx: Create nx842_delete_coprocs function
Date: Mon, 17 Jul 2017 16:47:29 -0700
Message-ID: <1500335249.995.12.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: ddstreet@ieee.org, linuxppc-dev@lists.ozlabs.org,
        linux-crypto@vger.kernel.org, benh@kernel.crashing.org,
        mikey@neuling.org, suka@us.ibm.com, hbabu@us.ibm.com
To: mpe@ellerman.id.au, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37143 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751455AbdGQXri (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jul 2017 19:47:38 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6HNl8mO017462
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jul 2017 19:47:38 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2brsce41gh-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jul 2017 19:47:38 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <haren@linux.vnet.ibm.com>;
        Mon, 17 Jul 2017 19:47:37 -0400
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
