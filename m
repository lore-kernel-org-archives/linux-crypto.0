From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH 3/4] crypto: talitos - fix aead sglen for case 'dst != src'
Date: Thu, 28 Nov 2013 15:11:17 +0200
Message-ID: <1385644278-14928-3-git-send-email-horia.geanta@freescale.com>
References: <5282A387.1020200@iki.fi>
 <1385644278-14928-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:28110
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754867Ab3K1NRx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Nov 2013 08:17:53 -0500
In-Reply-To: <1385644278-14928-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

For aead case when source and destination buffers are different,
there is an incorrect assumption that the source length includes the ICV
length. Fix this, since it leads to an oops when using sg_count() to
find the number of nents in the scatterlist:

Unable to handle kernel paging request for data at address 0x00000004
Faulting instruction address: 0xf2265a28
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=8 P2020 RDB
Modules linked in: talitos(+)
CPU: 1 PID: 2187 Comm: cryptomgr_test Not tainted 3.11.0 #12
task: c4e72e20 ti: ef634000 task.ti: ef634000
NIP: f2265a28 LR: f2266ad8 CTR: c000c900
REGS: ef635bb0 TRAP: 0300   Not tainted  (3.11.0)
MSR: 00029000 <CE,EE,ME>  CR: 42042084  XER: 00000000
DEAR: 00000004, ESR: 00000000

GPR00: f2266e10 ef635c60 c4e72e20 00000001 00000014 ef635c69 00000001 c11f3082
GPR08: 00000010 00000000 00000002 2f635d58 22044084 00000000 00000000 c0755c80
GPR16: c4bf1000 ef784000 00000000 00000000 00000020 00000014 00000010 ef2f6100
GPR24: ef2f6200 00000024 ef143210 ef2f6000 00000000 ef635d58 00000000 2f635d58
NIP [f2265a28] sg_count+0x1c/0xb4 [talitos]
LR [f2266ad8] talitos_edesc_alloc+0x12c/0x410 [talitos]
Call Trace:
[ef635c60] [c0552068] schedule_timeout+0x148/0x1ac (unreliable)
[ef635cc0] [f2266e10] aead_edesc_alloc+0x54/0x64 [talitos]
[ef635ce0] [f22680f0] aead_encrypt+0x24/0x70 [talitos]
[ef635cf0] [c024b948] __test_aead+0x494/0xf68
[ef635e20] [c024d54c] test_aead+0x64/0xcc
[ef635e40] [c024d604] alg_test_aead+0x50/0xc4
[ef635e60] [c024c838] alg_test+0x10c/0x2e4
[ef635ee0] [c0249d1c] cryptomgr_test+0x4c/0x54
[ef635ef0] [c005d598] kthread+0xa8/0xac
[ef635f40] [c000e3bc] ret_from_kernel_thread+0x5c/0x64
Instruction dump:
81230024 552807fe 0f080000 5523003a 4bffff24 39000000 2c040000 99050000
408100a0 7c691b78 38c00001 38600000 <80e90004> 38630001 8109000c 70ea0002
---[ end trace 4498123cd8478591 ]---

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
Please apply the following first (sent 11/19/2013):
crypto: talitos - corrrectly handle zero-length assoc data
https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg09904.html

 drivers/crypto/talitos.c |   47 ++++++++++++++++++++++-----------------------
 1 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index af3e7dc..30c9c93 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1110,7 +1110,8 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 						 unsigned int authsize,
 						 unsigned int ivsize,
 						 int icv_stashing,
-						 u32 cryptoflags)
+						 u32 cryptoflags,
+						 bool encrypt)
 {
 	struct talitos_edesc *edesc;
 	int assoc_nents = 0, src_nents, dst_nents, alloc_len, dma_len;
@@ -1143,19 +1144,17 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 			assoc_nents = assoc_nents ? assoc_nents + 1 : 2;
 	}
 
-	src_nents = sg_count(src, cryptlen + authsize, &src_chained);
-	src_nents = (src_nents == 1) ? 0 : src_nents;
-
-	if (!dst) {
-		dst_nents = 0;
-	} else {
-		if (dst == src) {
-			dst_nents = src_nents;
-		} else {
-			dst_nents = sg_count(dst, cryptlen + authsize,
-					     &dst_chained);
-			dst_nents = (dst_nents == 1) ? 0 : dst_nents;
-		}
+	if (!dst || dst == src) {
+		src_nents = sg_count(src, cryptlen + authsize, &src_chained);
+		src_nents = (src_nents == 1) ? 0 : src_nents;
+		dst_nents = dst ? src_nents : 0;
+	} else { /* dst && dst != src*/
+		src_nents = sg_count(src, cryptlen + (encrypt ? 0 : authsize),
+				     &src_chained);
+		src_nents = (src_nents == 1) ? 0 : src_nents;
+		dst_nents = sg_count(dst, cryptlen + (encrypt ? authsize : 0),
+				     &dst_chained);
+		dst_nents = (dst_nents == 1) ? 0 : dst_nents;
 	}
 
 	/*
@@ -1206,7 +1205,7 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 }
 
 static struct talitos_edesc *aead_edesc_alloc(struct aead_request *areq, u8 *iv,
-					      int icv_stashing)
+					      int icv_stashing, bool encrypt)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
@@ -1215,7 +1214,7 @@ static struct talitos_edesc *aead_edesc_alloc(struct aead_request *areq, u8 *iv,
 	return talitos_edesc_alloc(ctx->dev, areq->assoc, areq->src, areq->dst,
 				   iv, areq->assoclen, areq->cryptlen,
 				   ctx->authsize, ivsize, icv_stashing,
-				   areq->base.flags);
+				   areq->base.flags, encrypt);
 }
 
 static int aead_encrypt(struct aead_request *req)
@@ -1225,7 +1224,7 @@ static int aead_encrypt(struct aead_request *req)
 	struct talitos_edesc *edesc;
 
 	/* allocate extended descriptor */
-	edesc = aead_edesc_alloc(req, req->iv, 0);
+	edesc = aead_edesc_alloc(req, req->iv, 0, true);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
@@ -1248,7 +1247,7 @@ static int aead_decrypt(struct aead_request *req)
 	req->cryptlen -= authsize;
 
 	/* allocate extended descriptor */
-	edesc = aead_edesc_alloc(req, req->iv, 1);
+	edesc = aead_edesc_alloc(req, req->iv, 1, false);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
@@ -1294,7 +1293,7 @@ static int aead_givencrypt(struct aead_givcrypt_request *req)
 	struct talitos_edesc *edesc;
 
 	/* allocate extended descriptor */
-	edesc = aead_edesc_alloc(areq, req->giv, 0);
+	edesc = aead_edesc_alloc(areq, req->giv, 0, true);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
@@ -1450,7 +1449,7 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 }
 
 static struct talitos_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request *
-						    areq)
+						    areq, bool encrypt)
 {
 	struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
@@ -1458,7 +1457,7 @@ static struct talitos_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request *
 
 	return talitos_edesc_alloc(ctx->dev, NULL, areq->src, areq->dst,
 				   areq->info, 0, areq->nbytes, 0, ivsize, 0,
-				   areq->base.flags);
+				   areq->base.flags, encrypt);
 }
 
 static int ablkcipher_encrypt(struct ablkcipher_request *areq)
@@ -1468,7 +1467,7 @@ static int ablkcipher_encrypt(struct ablkcipher_request *areq)
 	struct talitos_edesc *edesc;
 
 	/* allocate extended descriptor */
-	edesc = ablkcipher_edesc_alloc(areq);
+	edesc = ablkcipher_edesc_alloc(areq, true);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
@@ -1485,7 +1484,7 @@ static int ablkcipher_decrypt(struct ablkcipher_request *areq)
 	struct talitos_edesc *edesc;
 
 	/* allocate extended descriptor */
-	edesc = ablkcipher_edesc_alloc(areq);
+	edesc = ablkcipher_edesc_alloc(areq, false);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
@@ -1637,7 +1636,7 @@ static struct talitos_edesc *ahash_edesc_alloc(struct ahash_request *areq,
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 
 	return talitos_edesc_alloc(ctx->dev, NULL, req_ctx->psrc, NULL, NULL, 0,
-				   nbytes, 0, 0, 0, areq->base.flags);
+				   nbytes, 0, 0, 0, areq->base.flags, false);
 }
 
 static int ahash_init(struct ahash_request *areq)
-- 
1.7.7.6
