From: Joy Latten <latten@austin.ibm.com>
Subject: [PATCH]: kernel crashes when ipsec uses xcbc-mac with big data chunk
Date: Tue, 1 Apr 2008 12:23:10 -0500
Message-ID: <200804011723.m31HNAxB008013@faith.austin.ibm.com>
Cc: herbert@gondor.apana.org.au
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:35106 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756056AbYDAR0t (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Apr 2008 13:26:49 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m31HSpIM005553
	for <linux-crypto@vger.kernel.org>; Tue, 1 Apr 2008 13:28:51 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m31HQmZ8206690
	for <linux-crypto@vger.kernel.org>; Tue, 1 Apr 2008 13:26:48 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m31HQl43009077
	for <linux-crypto@vger.kernel.org>; Tue, 1 Apr 2008 13:26:48 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The kernel crashes when ipsec passes a udp packet of about 14XX bytes
of data to aes-xcbc-mac.

It seems the first xxxx bytes of the data are in first sg entry,
and remaining xx bytes are in next sg entry. But we don't 
check next sg entry to see if we need to go look the page up.

I noticed in hmac.c, we do a scatterwalk_sg_next(), to do this check
and possible lookup, thus xcbc.c needs to use this routine too.

A 15-hour run of an ipsec stress test sending streams of tcp and
udp packets of various sizes,  using this patch and 
aes-xcbc-mac completed successfully, so hopefully this fixes the
problem.

regards,
Joy
 
Signed-off-by: Joy Latten <latten@austin.ibm.com>

diff -urpN net-2.6.26/crypto/xcbc.c net-2.6.26.sb/crypto/xcbc.c
--- net-2.6.26/crypto/xcbc.c	2008-03-31 15:27:17.000000000 -0500
+++ net-2.6.26.sb/crypto/xcbc.c	2008-03-31 15:43:53.000000000 -0500
@@ -116,13 +116,11 @@ static int crypto_xcbc_digest_update2(st
 	struct crypto_xcbc_ctx *ctx = crypto_hash_ctx_aligned(parent);
 	struct crypto_cipher *tfm = ctx->child;
 	int bs = crypto_hash_blocksize(parent);
-	unsigned int i = 0;
 
-	do {
