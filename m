From: Harald Freudenberger <freude@linux.vnet.ibm.com>
Subject: [PATCH] crypto: s390 - fix des and des3_ede ctr concurrency issue
Date: Wed, 22 Jan 2014 13:01:33 +0100
Message-ID: <1390392093-5002-1-git-send-email-freude@linux.vnet.ibm.com>
Cc: linux-crypto@vger.kernel.org,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Ingo Tuchscherer <ingo.tuchscherer@linux.vnet.ibm.com>,
	Gerald Schaefer <gerald.schaefer@de.ibm.com>,
	Harald Freudenberger <freude@de.ibm.com>,
	Harald Freudenberger <freude@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:35854 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161AbaAVMBk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jan 2014 07:01:40 -0500
Received: from /spool/local
	by e06smtp17.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <freude@de.ibm.com>;
	Wed, 22 Jan 2014 12:01:39 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
	by d06dlp01.portsmouth.uk.ibm.com (Postfix) with ESMTP id 14F2617D8062
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jan 2014 12:01:52 +0000 (GMT)
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by b06cxnps4076.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s0MC1Nv362980226
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jan 2014 12:01:23 GMT
Received: from d06av02.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s0MC1WWs013271
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jan 2014 05:01:34 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In s390 des and 3des ctr mode there is one preallocated page
used to speed up the en/decryption. This page is not protected
against concurrent usage and thus there is a potential of data
corruption with multiple threads.

The fix introduces locking/unlocking the ctr page and a slower
fallback solution at concurrency situations.

Cc: stable@vger.kernel.org
Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
---
 arch/s390/crypto/des_s390.c |   69 ++++++++++++++++++++++++++++++-------------
 1 file changed, 48 insertions(+), 21 deletions(-)

diff --git a/arch/s390/crypto/des_s390.c b/arch/s390/crypto/des_s390.c
index 82a0a2a..0a5aac8 100644
--- a/arch/s390/crypto/des_s390.c
+++ b/arch/s390/crypto/des_s390.c
@@ -25,6 +25,7 @@
 #define DES3_KEY_SIZE	(3 * DES_KEY_SIZE)
 
 static u8 *ctrblk;
+static DEFINE_SPINLOCK(ctrblk_lock);
 
 struct s390_des_ctx {
 	u8 iv[DES_BLOCK_SIZE];
@@ -368,54 +369,80 @@ static struct crypto_alg cbc_des3_alg = {
 	}
 };
 
+static unsigned int __ctrblk_init(u8 *ctrptr, unsigned int nbytes)
+{
+	unsigned int i, n;
+
+	/* align to block size, max. PAGE_SIZE */
+	n = (nbytes > PAGE_SIZE) ? PAGE_SIZE : nbytes & ~(DES_BLOCK_SIZE - 1);
+	for (i = DES_BLOCK_SIZE; i < n; i += DES_BLOCK_SIZE) {
+		memcpy(ctrptr + i, ctrptr + i - DES_BLOCK_SIZE, DES_BLOCK_SIZE);
+		crypto_inc(ctrptr + i, DES_BLOCK_SIZE);
+	}
+	return n;
+}
+
 static int ctr_desall_crypt(struct blkcipher_desc *desc, long func,
-			    struct s390_des_ctx *ctx, struct blkcipher_walk *walk)
+			    struct s390_des_ctx *ctx,
+			    struct blkcipher_walk *walk)
 {
 	int ret = blkcipher_walk_virt_block(desc, walk, DES_BLOCK_SIZE);
-	unsigned int i, n, nbytes;
-	u8 buf[DES_BLOCK_SIZE];
-	u8 *out, *in;
+	unsigned int n, nbytes;
+	u8 buf[DES_BLOCK_SIZE], ctrbuf[DES_BLOCK_SIZE];
+	u8 *out, *in, *ctrptr = ctrbuf;
+
+	if (!walk->nbytes)
+		return ret;
 
-	memcpy(ctrblk, walk->iv, DES_BLOCK_SIZE);
+	if (spin_trylock(&ctrblk_lock))
+		ctrptr = ctrblk;
+
+	memcpy(ctrptr, walk->iv, DES_BLOCK_SIZE);
 	while ((nbytes = walk->nbytes) >= DES_BLOCK_SIZE) {
 		out = walk->dst.virt.addr;
 		in = walk->src.virt.addr;
 		while (nbytes >= DES_BLOCK_SIZE) {
-			/* align to block size, max. PAGE_SIZE */
-			n = (nbytes > PAGE_SIZE) ? PAGE_SIZE :
-				nbytes & ~(DES_BLOCK_SIZE - 1);
-			for (i = DES_BLOCK_SIZE; i < n; i += DES_BLOCK_SIZE) {
-				memcpy(ctrblk + i, ctrblk + i - DES_BLOCK_SIZE,
-				       DES_BLOCK_SIZE);
-				crypto_inc(ctrblk + i, DES_BLOCK_SIZE);
-			}
-			ret = crypt_s390_kmctr(func, ctx->key, out, in, n, ctrblk);
-			if (ret < 0 || ret != n)
+			if (ctrptr == ctrblk)
+				n = __ctrblk_init(ctrptr, nbytes);
+			else
+				n = DES_BLOCK_SIZE;
+			ret = crypt_s390_kmctr(func, ctx->key, out, in,
+					       n, ctrptr);
+			if (ret < 0 || ret != n) {
+				if (ctrptr == ctrblk)
+					spin_unlock(&ctrblk_lock);
 				return -EIO;
+			}
 			if (n > DES_BLOCK_SIZE)
-				memcpy(ctrblk, ctrblk + n - DES_BLOCK_SIZE,
+				memcpy(ctrptr, ctrptr + n - DES_BLOCK_SIZE,
 				       DES_BLOCK_SIZE);
-			crypto_inc(ctrblk, DES_BLOCK_SIZE);
+			crypto_inc(ctrptr, DES_BLOCK_SIZE);
 			out += n;
 			in += n;
 			nbytes -= n;
 		}
 		ret = blkcipher_walk_done(desc, walk, nbytes);
 	}
-
+	if (ctrptr == ctrblk) {
+		if (nbytes)
+			memcpy(ctrbuf, ctrptr, DES_BLOCK_SIZE);
+		else
+			memcpy(walk->iv, ctrptr, DES_BLOCK_SIZE);
+		spin_unlock(&ctrblk_lock);
+	}
 	/* final block may be < DES_BLOCK_SIZE, copy only nbytes */
 	if (nbytes) {
 		out = walk->dst.virt.addr;
 		in = walk->src.virt.addr;
 		ret = crypt_s390_kmctr(func, ctx->key, buf, in,
-				       DES_BLOCK_SIZE, ctrblk);
+				       DES_BLOCK_SIZE, ctrbuf);
 		if (ret < 0 || ret != DES_BLOCK_SIZE)
 			return -EIO;
 		memcpy(out, buf, nbytes);
-		crypto_inc(ctrblk, DES_BLOCK_SIZE);
+		crypto_inc(ctrbuf, DES_BLOCK_SIZE);
 		ret = blkcipher_walk_done(desc, walk, 0);
+		memcpy(walk->iv, ctrbuf, DES_BLOCK_SIZE);
 	}
-	memcpy(walk->iv, ctrblk, DES_BLOCK_SIZE);
 	return ret;
 }
 
-- 
1.7.9.5
