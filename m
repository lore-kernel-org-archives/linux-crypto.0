From: Joy Latten <latten@austin.ibm.com>
Subject: scatterwalk_map_and_copy may cause kernel oops
Date: Thu, 6 Dec 2007 00:25:57 -0600
Message-ID: <200712060625.lB66Pv3P006826@faith.austin.ibm.com>
Cc: herbert@gondor.apana.org.au
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:54656 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbXLFG06 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Dec 2007 01:26:58 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id lB66Qqih026038
	for <linux-crypto@vger.kernel.org>; Thu, 6 Dec 2007 01:26:52 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lB66QqJU116532
	for <linux-crypto@vger.kernel.org>; Wed, 5 Dec 2007 23:26:52 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lB66QqXK013381
	for <linux-crypto@vger.kernel.org>; Wed, 5 Dec 2007 23:26:52 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In scatterwalk_map_and_copy(), sg_next(sg) is called, 
loop goes back to top and scatterwalk_start() gets called
again. When next sg is NULL, BUG_ON may occur in next call to
scatterwalk_start().

Please let me know if following patch takes
right approach to fix this.

regards,
Joy 

Signed-off-by: Joy Latten <latten@austin.ibm.com>


diff -urpN cryptodev-2.6.2/crypto/scatterwalk.c cryptodev-2.6.2.sandbox/crypto/scatterwalk.c
--- cryptodev-2.6.2/crypto/scatterwalk.c	2007-12-05 00:23:37.000000000 -0600
+++ cryptodev-2.6.2.sandbox/crypto/scatterwalk.c	2007-12-06 00:10:56.000000000 -0600
@@ -106,7 +106,7 @@ void scatterwalk_map_and_copy(void *buf,
 	struct scatter_walk walk;
 	unsigned int offset = 0;
 
-	for (;;) {
+	do {
 		scatterwalk_start(&walk, sg);
 
 		if (start < offset + sg->length)
@@ -114,7 +114,7 @@ void scatterwalk_map_and_copy(void *buf,
 
 		offset += sg->length;
 		sg = sg_next(sg);
-	}
+	} while (sg != NULL);
 
 	scatterwalk_advance(&walk, start - offset);
 	scatterwalk_copychunks(buf, &walk, nbytes, out);
