From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH] crypto/xor: skip speed test if the xor function is selected automatically
Date: Fri, 19 Aug 2016 14:19:30 +0200
Message-ID: <1471609170-18816-1-git-send-email-schwidefsky@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56396 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750889AbcHSMTu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Aug 2016 08:19:50 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u7JCEbtt100611
        for <linux-crypto@vger.kernel.org>; Fri, 19 Aug 2016 08:19:49 -0400
Received: from e06smtp08.uk.ibm.com (e06smtp08.uk.ibm.com [195.75.94.104])
        by mx0a-001b2d01.pphosted.com with ESMTP id 24wfj5gwma-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Fri, 19 Aug 2016 08:19:49 -0400
Received: from localhost
        by e06smtp08.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <schwidefsky@de.ibm.com>;
        Fri, 19 Aug 2016 13:19:46 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by d06dlp03.portsmouth.uk.ibm.com (Postfix) with ESMTP id D0B671B08074
        for <linux-crypto@vger.kernel.org>; Fri, 19 Aug 2016 13:21:21 +0100 (BST)
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u7JCJieF9044306
        for <linux-crypto@vger.kernel.org>; Fri, 19 Aug 2016 12:19:44 GMT
Received: from d06av01.portsmouth.uk.ibm.com (localhost [127.0.0.1])
        by d06av01.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u7JCJhds009649
        for <linux-crypto@vger.kernel.org>; Fri, 19 Aug 2016 06:19:44 -0600
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If the architecture selected the xor function with XOR_SELECT_TEMPLATE
the speed result of the do_xor_speed benchmark is of limited value.
The speed measurement increases the bootup time a little, which can
makes a difference for kernels used in container like virtual machines.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 crypto/xor.c | 40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/crypto/xor.c b/crypto/xor.c
index 35d6b3a..b8975d9 100644
--- a/crypto/xor.c
+++ b/crypto/xor.c
@@ -109,6 +109,18 @@ calibrate_xor_blocks(void)
 	void *b1, *b2;
 	struct xor_block_template *f, *fastest;
 
+	fastest = NULL;
+
+#ifdef XOR_SELECT_TEMPLATE
+	fastest = XOR_SELECT_TEMPLATE(fastest);
+	if (fastest) {
+		printk(KERN_INFO "xor: automatically using best "
+				 "checksumming function   %-10s\n",
+		       fastest->name);
+		goto out;
+	}
+#endif
+
 	/*
 	 * Note: Since the memory is not actually used for _anything_ but to
 	 * test the XOR speed, we don't really want kmemcheck to warn about
@@ -126,36 +138,22 @@ calibrate_xor_blocks(void)
 	 * all the possible functions, just test the best one
 	 */
 
-	fastest = NULL;
-
-#ifdef XOR_SELECT_TEMPLATE
-		fastest = XOR_SELECT_TEMPLATE(fastest);
-#endif
-
 #define xor_speed(templ)	do_xor_speed((templ), b1, b2)
 
-	if (fastest) {
-		printk(KERN_INFO "xor: automatically using best "
-				 "checksumming function:\n");
-		xor_speed(fastest);
-		goto out;
-	} else {
-		printk(KERN_INFO "xor: measuring software checksum speed\n");
-		XOR_TRY_TEMPLATES;
-		fastest = template_list;
-		for (f = fastest; f; f = f->next)
-			if (f->speed > fastest->speed)
-				fastest = f;
-	}
+	printk(KERN_INFO "xor: measuring software checksum speed\n");
+	XOR_TRY_TEMPLATES;
+	fastest = template_list;
+	for (f = fastest; f; f = f->next)
+		if (f->speed > fastest->speed)
+			fastest = f;
 
 	printk(KERN_INFO "xor: using function: %s (%d.%03d MB/sec)\n",
 	       fastest->name, fastest->speed / 1000, fastest->speed % 1000);
 
 #undef xor_speed
 
- out:
 	free_pages((unsigned long)b1, 2);
-
+out:
 	active_template = fastest;
 	return 0;
 }
-- 
1.9.1
