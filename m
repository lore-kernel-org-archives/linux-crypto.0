From: Harald Freudenberger <freude@linux.vnet.ibm.com>
Subject: [PATCH] crypto: s390 - fix concurrency issue in aes-ctr mode
Date: Thu, 16 Jan 2014 16:01:11 +0100
Message-ID: <1389884471-24964-1-git-send-email-freude@linux.vnet.ibm.com>
Cc: linux-crypto@vger.kernel.org,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Ingo Tuchscherer <ingo.tuchscherer@linux.vnet.ibm.com>,
	Gerald Schaefer <gerald.schaefer@de.ibm.com>,
	Harald Freudenberger <freude@de.ibm.com>,
	Harald Freudenberger <freude@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:38698 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaAPPBa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Jan 2014 10:01:30 -0500
Received: from /spool/local
	by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <freude@de.ibm.com>;
	Thu, 16 Jan 2014 15:01:28 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id 3C267219005E
	for <linux-crypto@vger.kernel.org>; Thu, 16 Jan 2014 15:01:25 +0000 (GMT)
Received: from d06av06.portsmouth.uk.ibm.com (d06av06.portsmouth.uk.ibm.com [9.149.37.217])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s0GF1Ekm65798206
	for <linux-crypto@vger.kernel.org>; Thu, 16 Jan 2014 15:01:14 GMT
Received: from d06av06.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av06.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s0GF1PLc015045
	for <linux-crypto@vger.kernel.org>; Thu, 16 Jan 2014 08:01:26 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The aes-ctr mode uses one preallocated page without any concurrency
protection. When multiple threads run aes-ctr encryption or decryption
this can lead to data corruption.

The patch introduces locking for the page and a fallback solution with
slower en/decryption performance in concurrency situations.

Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
---
 arch/s390/crypto/aes_s390.c |   65 ++++++++++++++++++++++++++++++-------------
 1 file changed, 46 insertions(+), 19 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index b3feabd..cf3c008 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -25,6 +25,7 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/spinlock.h>
 #include "crypt_s390.h"
 
 #define AES_KEYLEN_128		1
@@ -32,6 +33,7 @@
 #define AES_KEYLEN_256		4
 
 static u8 *ctrblk;
+static DEFINE_SPINLOCK(ctrblk_lock);
 static char keylen_flag;
 
 struct s390_aes_ctx {
@@ -758,43 +760,67 @@ static int ctr_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	return aes_set_key(tfm, in_key, key_len);
 }
 
+static unsigned int __ctrblk_init(u8 *ctrptr, unsigned int nbytes)
+{
+	unsigned int i, n;
+
+	/* only use complete blocks, max. PAGE_SIZE */
+	n = (nbytes > PAGE_SIZE) ? PAGE_SIZE : nbytes & ~(AES_BLOCK_SIZE - 1);
+	for (i = AES_BLOCK_SIZE; i < n; i += AES_BLOCK_SIZE) {
+		memcpy(ctrptr + i, ctrptr + i - AES_BLOCK_SIZE,
+		       AES_BLOCK_SIZE);
+		crypto_inc(ctrptr + i, AES_BLOCK_SIZE);
+	}
+	return n;
+}
+
 static int ctr_aes_crypt(struct blkcipher_desc *desc, long func,
 			 struct s390_aes_ctx *sctx, struct blkcipher_walk *walk)
 {
 	int ret = blkcipher_walk_virt_block(desc, walk, AES_BLOCK_SIZE);
-	unsigned int i, n, nbytes;
-	u8 buf[AES_BLOCK_SIZE];
-	u8 *out, *in;
+	unsigned int n, nbytes;
+	u8 buf[AES_BLOCK_SIZE], ctrbuf[AES_BLOCK_SIZE];
+	u8 *out, *in, *ctrptr = ctrbuf;
 
 	if (!walk->nbytes)
 		return ret;
 
-	memcpy(ctrblk, walk->iv, AES_BLOCK_SIZE);
+	if (spin_trylock(&ctrblk_lock))
+		ctrptr = ctrblk;
+
+	memcpy(ctrptr, walk->iv, AES_BLOCK_SIZE);
 	while ((nbytes = walk->nbytes) >= AES_BLOCK_SIZE) {
 		out = walk->dst.virt.addr;
 		in = walk->src.virt.addr;
 		while (nbytes >= AES_BLOCK_SIZE) {
-			/* only use complete blocks, max. PAGE_SIZE */
-			n = (nbytes > PAGE_SIZE) ? PAGE_SIZE :
-						 nbytes & ~(AES_BLOCK_SIZE - 1);
-			for (i = AES_BLOCK_SIZE; i < n; i += AES_BLOCK_SIZE) {
-				memcpy(ctrblk + i, ctrblk + i - AES_BLOCK_SIZE,
-				       AES_BLOCK_SIZE);
-				crypto_inc(ctrblk + i, AES_BLOCK_SIZE);
-			}
-			ret = crypt_s390_kmctr(func, sctx->key, out, in, n, ctrblk);
-			if (ret < 0 || ret != n)
+			if (ctrptr == ctrblk)
+				n = __ctrblk_init(ctrptr, nbytes);
+			else
+				n = AES_BLOCK_SIZE;
+			ret = crypt_s390_kmctr(func, sctx->key, out, in,
+					       n, ctrptr);
+			if (ret < 0 || ret != n) {
+				if (ctrptr == ctrblk)
+					spin_unlock(&ctrblk_lock);
 				return -EIO;
+			}
 			if (n > AES_BLOCK_SIZE)
-				memcpy(ctrblk, ctrblk + n - AES_BLOCK_SIZE,
+				memcpy(ctrptr, ctrptr + n - AES_BLOCK_SIZE,
 				       AES_BLOCK_SIZE);
-			crypto_inc(ctrblk, AES_BLOCK_SIZE);
+			crypto_inc(ctrptr, AES_BLOCK_SIZE);
 			out += n;
 			in += n;
 			nbytes -= n;
 		}
 		ret = blkcipher_walk_done(desc, walk, nbytes);
 	}
+	if (ctrptr == ctrblk) {
+		if (nbytes)
+			memcpy(ctrbuf, ctrptr, AES_BLOCK_SIZE);
+		else
+			memcpy(walk->iv, ctrptr, AES_BLOCK_SIZE);
+		spin_unlock(&ctrblk_lock);
+	}
 	/*
 	 * final block may be < AES_BLOCK_SIZE, copy only nbytes
 	 */
@@ -802,14 +828,15 @@ static int ctr_aes_crypt(struct blkcipher_desc *desc, long func,
 		out = walk->dst.virt.addr;
 		in = walk->src.virt.addr;
 		ret = crypt_s390_kmctr(func, sctx->key, buf, in,
-				       AES_BLOCK_SIZE, ctrblk);
+				       AES_BLOCK_SIZE, ctrbuf);
 		if (ret < 0 || ret != AES_BLOCK_SIZE)
 			return -EIO;
 		memcpy(out, buf, nbytes);
-		crypto_inc(ctrblk, AES_BLOCK_SIZE);
+		crypto_inc(ctrbuf, AES_BLOCK_SIZE);
 		ret = blkcipher_walk_done(desc, walk, 0);
+		memcpy(walk->iv, ctrbuf, AES_BLOCK_SIZE);
 	}
-	memcpy(walk->iv, ctrblk, AES_BLOCK_SIZE);
+
 	return ret;
 }
 
-- 
1.7.9.5
