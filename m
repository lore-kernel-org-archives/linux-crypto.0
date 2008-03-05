From: Joy Latten <latten@austin.ibm.com>
Subject: kernel crashes when using aes-xcbc-mac with IPsec
Date: Wed, 5 Mar 2008 14:19:21 -0600
Message-ID: <200803052019.m25KJLlF018029@faith.austin.ibm.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:58011 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbYCEUW0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Mar 2008 15:22:26 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m25KMLI5031989
	for <linux-crypto@vger.kernel.org>; Wed, 5 Mar 2008 15:22:21 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m25KMKWM158850
	for <linux-crypto@vger.kernel.org>; Wed, 5 Mar 2008 13:22:20 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m25KMKTF006230
	for <linux-crypto@vger.kernel.org>; Wed, 5 Mar 2008 13:22:20 -0700
Received: from austin.ibm.com (netmail1.austin.ibm.com [9.41.248.175])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m25KMK6E006202
	for <linux-crypto@vger.kernel.org>; Wed, 5 Mar 2008 13:22:20 -0700
Received: from faith.austin.ibm.com (faith.austin.ibm.com [9.53.40.35])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id m25KMKF6031602
	for <linux-crypto@vger.kernel.org>; Wed, 5 Mar 2008 14:22:20 -0600
Received: from faith.austin.ibm.com (localhost.localdomain [127.0.0.1])
	by faith.austin.ibm.com (8.13.4/8.12.8) with ESMTP id m25KJMLv018030
	for <linux-crypto@vger.kernel.org>; Wed, 5 Mar 2008 14:19:22 -0600
Received: (from jml@localhost)
	by faith.austin.ibm.com (8.13.4/8.13.4/Submit) id m25KJLlF018029
	for linux-crypto@vger.kernel.org; Wed, 5 Mar 2008 14:19:21 -0600
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Resending since I typed incorrect email address.

When using aes-xcbc-mac for authentication in IPsec, 
the kernel crashes. It seems this algorithm doesn't 
account for the space IPsec may make in scatterlist for authtag.
Thus when crypto_xcbc_digest_update2() gets called,
nbytes may be less than sg[i].length. 
Since nbytes is an unsigned number, it wraps
at the end of the loop allowing us to go back 
into loop when we shouldn't. 

I used update function in digest.c to model this fix.
Please let me know if it looks ok.

regards,
Joy 

Signed-off-by: Joy Latten <latten@austin.ibm.com>

diff -urpN net-2.6.26/crypto/xcbc.c net-2.6.26.patch/crypto/xcbc.c
--- net-2.6.26/crypto/xcbc.c	2008-03-04 16:11:32.000000000 -0600
+++ net-2.6.26.patch/crypto/xcbc.c	2008-03-04 18:28:51.000000000 -0600
@@ -124,6 +124,11 @@ static int crypto_xcbc_digest_update2(st
 		unsigned int offset = sg[i].offset;
 		unsigned int slen = sg[i].length;
 
+		if (unlikely(slen > nbytes))
+			slen = nbytes;
+
+		nbytes -= slen;
+
 		while (slen > 0) {
 			unsigned int len = min(slen, ((unsigned int)(PAGE_SIZE)) - offset);
 			char *p = crypto_kmap(pg, 0) + offset;
@@ -177,7 +182,6 @@ static int crypto_xcbc_digest_update2(st
 			offset = 0;
 			pg++;
 		}
-		nbytes-=sg[i].length;
 		i++;
 	} while (nbytes>0);
 
