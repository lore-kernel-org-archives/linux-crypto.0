From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH] crypto: algif_aead - skip SGL entries with NULL page
Date: Fri, 10 Nov 2017 08:29:40 +0100
Message-ID: <3016707.l0K91qkPze@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42220 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750994AbdKJH3m (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Nov 2017 02:29:42 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The TX SGL may contain SGL entries that are assigned a NULL page. This
may happen if a multi-stage AIO operation is performed where the data
for each stage is pointed to by one SGL entry. Upon completion of that
stage, af_alg_pull_tsgl will assign NULL to the SGL entry.

The NULL cipher used to copy the AAD from TX SGL to the destination
buffer, however, cannot handle the case where the SGL starts with an SGL
entry having a NULL page. Thus, the code needs to advance the start
pointer into the SGL to the first non-NULL entry.

This fixes a crash visible on Intel x86 32 bit using the libkcapi test
suite.

Fixes: 72548b093ee38 ("crypto: algif_aead - copy AAD from src to dst")
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_aead.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 6cdd4fb08335..250816971edf 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -101,10 +101,10 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	struct aead_tfm *aeadc = pask->private;
 	struct crypto_aead *tfm = aeadc->aead;
 	struct crypto_skcipher *null_tfm = aeadc->null_tfm;
-	unsigned int as = crypto_aead_authsize(tfm);
+	unsigned int i, as = crypto_aead_authsize(tfm);
 	struct af_alg_async_req *areq;
 	struct af_alg_tsgl *tsgl;
-	struct scatterlist *src;
+	struct scatterlist *rsgl_src, *tsgl_src = NULL;
 	int err = 0;
 	size_t used = 0;		/* [in]  TX bufs to be en/decrypted */
 	size_t outlen = 0;		/* [out] RX bufs produced by kernel */
@@ -179,6 +179,16 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 
 	processed = used + ctx->aead_assoclen;
 	tsgl = list_first_entry(&ctx->tsgl_list, struct af_alg_tsgl, list);
+	for (i = 0; i < tsgl->cur; i++) {
+		if (!sg_page(tsgl->sg + i))
+			continue;
+		tsgl_src = tsgl->sg + i;
+		break;
+	}
+	if (!tsgl_src) {
+		err = -EFAULT;
+		goto free;
+	}
 
 	/*
 	 * Copy of AAD from source to destination
@@ -194,7 +204,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	 */
 
 	/* Use the RX SGL as source (and destination) for crypto op. */
-	src = areq->first_rsgl.sgl.sg;
+	rsgl_src = areq->first_rsgl.sgl.sg;
 
 	if (ctx->enc) {
 		/*
@@ -207,7 +217,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 		 *	    v	   v
 		 * RX SGL: AAD || PT || Tag
 		 */
-		err = crypto_aead_copy_sgl(null_tfm, tsgl->sg,
+		err = crypto_aead_copy_sgl(null_tfm, tsgl_src,
 					   areq->first_rsgl.sgl.sg, processed);
 		if (err)
 			goto free;
@@ -225,7 +235,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 		 */
 
 		 /* Copy AAD || CT to RX SGL buffer for in-place operation. */
-		err = crypto_aead_copy_sgl(null_tfm, tsgl->sg,
+		err = crypto_aead_copy_sgl(null_tfm, tsgl_src,
 					   areq->first_rsgl.sgl.sg, outlen);
 		if (err)
 			goto free;
@@ -257,11 +267,11 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 				 areq->tsgl);
 		} else
 			/* no RX SGL present (e.g. authentication only) */
-			src = areq->tsgl;
+			rsgl_src = areq->tsgl;
 	}
 
 	/* Initialize the crypto operation */
-	aead_request_set_crypt(&areq->cra_u.aead_req, src,
+	aead_request_set_crypt(&areq->cra_u.aead_req, rsgl_src,
 			       areq->first_rsgl.sgl.sg, used, ctx->iv);
 	aead_request_set_ad(&areq->cra_u.aead_req, ctx->aead_assoclen);
 	aead_request_set_tfm(&areq->cra_u.aead_req, tfm);
-- 
2.13.6
