From: Harald Freudenberger <freude@linux.vnet.ibm.com>
Subject: [PATCH] s390/crypto: fix aes ctr concurrency issue
Date: Tue, 19 Nov 2013 11:22:12 +0100
Message-ID: <1384856532-17247-2-git-send-email-freude@linux.vnet.ibm.com>
References: <1384856532-17247-1-git-send-email-freude@linux.vnet.ibm.com>
Cc: linux-crypto@vger.kernel.org,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Ingo Tuchscherer <ingo.tuchscherer@linux.vnet.ibm.com>,
	Gerald Schaefer <gerald.schaefer@de.ibm.com>,
	Harald Freudenberger <freude@de.ibm.com>,
	Harald Freudenberger <freude@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:48032 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab3KSKWm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Nov 2013 05:22:42 -0500
Received: from /spool/local
	by e06smtp16.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <freude@linux.vnet.ibm.com>;
	Tue, 19 Nov 2013 10:22:40 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id CEEC3219005C
	for <linux-crypto@vger.kernel.org>; Tue, 19 Nov 2013 10:22:32 +0000 (GMT)
Received: from d06av06.portsmouth.uk.ibm.com (d06av06.portsmouth.uk.ibm.com [9.149.37.217])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id rAJAMKXH16384176
	for <linux-crypto@vger.kernel.org>; Tue, 19 Nov 2013 10:22:20 GMT
Received: from d06av06.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av06.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id rAJAMWuP017500
	for <linux-crypto@vger.kernel.org>; Tue, 19 Nov 2013 03:22:32 -0700
In-Reply-To: <1384856532-17247-1-git-send-email-freude@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The aes-ctr mode used one preallocated page without any concurrency
protection. When multiple threads run aes-ctr encryption or decryption
this could lead to data corruption.

The patch introduces locking for the preallocated page and alternatively
allocating and freeing of an temp page in concurrency situations.
---
 arch/s390/crypto/aes_s390.c |   55 ++++++++++++++++++++++++++++++++----------
 1 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 4363528..fcb5297 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -25,6 +25,7 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/mutex.h>
 #include "crypt_s390.h"
 
 #define AES_KEYLEN_128		1
@@ -32,6 +33,7 @@
 #define AES_KEYLEN_256		4
 
 static u8 *ctrblk;
+static DEFINE_MUTEX(ctrblk_lock);
 static char keylen_flag;
 
 struct s390_aes_ctx {
@@ -762,11 +764,25 @@ static int ctr_aes_crypt(struct blkcipher_desc *desc, long func,
 	unsigned int i, n, nbytes;
 	u8 buf[AES_BLOCK_SIZE];
 	u8 *out, *in;
+	u8 *ctrpage;
 
 	if (!walk->nbytes)
 		return ret;
 
-	memcpy(ctrblk, walk->iv, AES_BLOCK_SIZE);
+	if (mutex_trylock(&ctrblk_lock)) {
+		/* ctrblk is now reserved for us */
+		ctrpage = ctrblk;
+	} else {
+		/* ctrblk is in use by someone else, alloc our own page */
+		ctrpage = (u8*) __get_free_page(GFP_ATOMIC);
+		if (!ctrpage) {
+			/* gfp failed, wait until ctrblk becomes available */
+			mutex_lock(&ctrblk_lock);
+			ctrpage = ctrblk;
+		}
+	}
+
+	memcpy(ctrpage, walk->iv, AES_BLOCK_SIZE);
 	while ((nbytes = walk->nbytes) >= AES_BLOCK_SIZE) {
 		out = walk->dst.virt.addr;
 		in = walk->src.virt.addr;
@@ -775,17 +791,19 @@ static int ctr_aes_crypt(struct blkcipher_desc *desc, long func,
 			n = (nbytes > PAGE_SIZE) ? PAGE_SIZE :
 						 nbytes & ~(AES_BLOCK_SIZE - 1);
 			for (i = AES_BLOCK_SIZE; i < n; i += AES_BLOCK_SIZE) {
-				memcpy(ctrblk + i, ctrblk + i - AES_BLOCK_SIZE,
+				memcpy(ctrpage + i, ctrpage + i - AES_BLOCK_SIZE,
 				       AES_BLOCK_SIZE);
-				crypto_inc(ctrblk + i, AES_BLOCK_SIZE);
+				crypto_inc(ctrpage + i, AES_BLOCK_SIZE);
+			}
+			ret = crypt_s390_kmctr(func, sctx->key, out, in, n, ctrpage);
+			if (ret < 0 || ret != n) {
+				ret = -EIO;
+				goto out;
 			}
-			ret = crypt_s390_kmctr(func, sctx->key, out, in, n, ctrblk);
-			if (ret < 0 || ret != n)
-				return -EIO;
 			if (n > AES_BLOCK_SIZE)
-				memcpy(ctrblk, ctrblk + n - AES_BLOCK_SIZE,
+				memcpy(ctrpage, ctrpage + n - AES_BLOCK_SIZE,
 				       AES_BLOCK_SIZE);
-			crypto_inc(ctrblk, AES_BLOCK_SIZE);
+			crypto_inc(ctrpage, AES_BLOCK_SIZE);
 			out += n;
 			in += n;
 			nbytes -= n;
@@ -799,14 +817,25 @@ static int ctr_aes_crypt(struct blkcipher_desc *desc, long func,
 		out = walk->dst.virt.addr;
 		in = walk->src.virt.addr;
 		ret = crypt_s390_kmctr(func, sctx->key, buf, in,
-				       AES_BLOCK_SIZE, ctrblk);
-		if (ret < 0 || ret != AES_BLOCK_SIZE)
-			return -EIO;
+				       AES_BLOCK_SIZE, ctrpage);
+		if (ret < 0 || ret != AES_BLOCK_SIZE) {
+			ret = -EIO;
+			goto out;
+		}
 		memcpy(out, buf, nbytes);
-		crypto_inc(ctrblk, AES_BLOCK_SIZE);
+		crypto_inc(ctrpage, AES_BLOCK_SIZE);
 		ret = blkcipher_walk_done(desc, walk, 0);
 	}
-	memcpy(walk->iv, ctrblk, AES_BLOCK_SIZE);
+	memcpy(walk->iv, ctrpage, AES_BLOCK_SIZE);
+
+out:
+	if (ctrpage == ctrblk) {
+		/* free the reservation for ctrblk now */
+		mutex_unlock(&ctrblk_lock);
+	} else {
+		/* free the page allocated above */
+		free_page((unsigned long) ctrpage);
+	}
 	return ret;
 }
 
-- 
1.7.0.4
