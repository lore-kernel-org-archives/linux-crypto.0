From: Patrick McHardy <kaber@trash.net>
Subject: [HIFN 05/n]: Fix data alignment checks
Date: Wed, 07 May 2008 14:26:30 +0200
Message-ID: <48219FF6.2090009@trash.net>
References: <48219D24.1040702@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060408060606020507090003"
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62524 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbYEGM1M (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 08:27:12 -0400
In-Reply-To: <48219D24.1040702@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060408060606020507090003
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

I'm not entirely sure about the alignmask change at the end of
this patch, is an alignmask of 1 correct if no source buffer
alignment is required, but the destination buffer should be
(doesn't have to be though) 4 byte aligned?



--------------060408060606020507090003
Content-Type: text/x-diff;
 name="05.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="05.diff"

commit f76618d53e82c8905214e889a3f79f1816c680fb
Author: Patrick McHardy <kaber@trash.net>
Date:   Wed May 7 12:44:15 2008 +0200

    [HIFN]: Fix data alignment checks
    
    The check for misalignment of the scatterlist data has two bugs:
    
    - the source buffer doesn't need to be aligned at all
    - the destination buffer and its size needs to be aligned to a multiple
      of 4, not to the crypto alg blocksize
    
    Introduce symbolic constant for destination buffer alignment requirements,
    use it instead of the crypto alg blocksize and remove the unnecessary
    checks for source buffer alignment and change cra_alignmask to 1.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 4e89cd8..7706461 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -369,6 +369,8 @@ static atomic_t hifn_dev_number;
 #define	HIFN_D_DST_RSIZE		80*4
 #define	HIFN_D_RES_RSIZE		24*4
 
+#define HIFN_D_DST_DALIGN		4
+
 #define HIFN_QUEUE_LENGTH		HIFN_D_CMD_RSIZE-5
 
 #define AES_MIN_KEY_SIZE		16
@@ -1458,10 +1460,6 @@ static int ablkcipher_add(void *daddr, unsigned int *drestp, struct scatterlist
 static int ablkcipher_walk(struct ablkcipher_request *req,
 		struct ablkcipher_walk *w)
 {
-	unsigned blocksize =
-		crypto_ablkcipher_blocksize(crypto_ablkcipher_reqtfm(req));
-	unsigned alignmask =
-		crypto_ablkcipher_alignmask(crypto_ablkcipher_reqtfm(req));
 	struct scatterlist *src, *dst, *t;
 	void *daddr;
 	unsigned int nbytes = req->nbytes, offset, copy, diff;
@@ -1477,15 +1475,13 @@ static int ablkcipher_walk(struct ablkcipher_request *req,
 		dst = &req->dst[idx];
 
 		dprintk("\n%s: slen: %u, dlen: %u, soff: %u, doff: %u, offset: %u, "
-				"blocksize: %u, nbytes: %u.\n",
+				"nbytes: %u.\n",
 				__func__, src->length, dst->length, src->offset,
-				dst->offset, offset, blocksize, nbytes);
+				dst->offset, offset, nbytes);
 
-		if (src->length & (blocksize - 1) ||
-				src->offset & (alignmask - 1) ||
-				dst->length & (blocksize - 1) ||
-				dst->offset & (alignmask - 1) ||
-				offset) {
+		if (!IS_ALIGNED(dst->offset, HIFN_D_DST_DALIGN) ||
+		    !IS_ALIGNED(dst->length, HIFN_D_DST_DALIGN) ||
+		    offset) {
 			unsigned slen = src->length - offset;
 			unsigned dlen = PAGE_SIZE;
 
@@ -1498,8 +1494,8 @@ static int ablkcipher_walk(struct ablkcipher_request *req,
 
 			idx += err;
 
-			copy = slen & ~(blocksize - 1);
-			diff = slen & (blocksize - 1);
+			copy = slen & ~(HIFN_D_DST_DALIGN - 1);
+			diff = slen & (HIFN_D_DST_DALIGN - 1);
 
 			if (dlen < nbytes) {
 				/*
@@ -1507,7 +1503,7 @@ static int ablkcipher_walk(struct ablkcipher_request *req,
 				 * to put there additional blocksized chunk,
 				 * so we mark that page as containing only
 				 * blocksize aligned chunks:
-				 * 	t->length = (slen & ~(blocksize - 1));
+				 * 	t->length = (slen & ~(HIFN_D_DST_DALIGN - 1));
 				 * and increase number of bytes to be processed
 				 * in next chunk:
 				 * 	nbytes += diff;
@@ -1567,10 +1563,6 @@ static int hifn_setup_session(struct ablkcipher_request *req)
 	unsigned int nbytes = req->nbytes, idx = 0, len;
 	int err = -EINVAL, sg_num;
 	struct scatterlist *src, *dst, *t;
-	unsigned blocksize =
-		crypto_ablkcipher_blocksize(crypto_ablkcipher_reqtfm(req));
-	unsigned alignmask =
-		crypto_ablkcipher_alignmask(crypto_ablkcipher_reqtfm(req));
 
 	if (ctx->iv && !ctx->ivsize && ctx->mode != ACRYPTO_MODE_ECB)
 		goto err_out_exit;
@@ -1578,17 +1570,13 @@ static int hifn_setup_session(struct ablkcipher_request *req)
 	ctx->walk.flags = 0;
 
 	while (nbytes) {
-		src = &req->src[idx];
 		dst = &req->dst[idx];
 
-		if (src->length & (blocksize - 1) ||
-				src->offset & (alignmask - 1) ||
-				dst->length & (blocksize - 1) ||
-				dst->offset & (alignmask - 1)) {
+		if (!IS_ALIGNED(dst->offset, HIFN_D_DST_DALIGN) ||
+		    !IS_ALIGNED(dst->length, HIFN_D_DST_DALIGN))
 			ctx->walk.flags |= ASYNC_FLAGS_MISALIGNED;
-		}
 
-		nbytes -= src->length;
+		nbytes -= dst->length;
 		idx++;
 	}
 
@@ -2523,9 +2511,7 @@ static int hifn_alg_alloc(struct hifn_device *dev, struct hifn_alg_template *t)
 	alg->alg.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC;
 	alg->alg.cra_blocksize = t->bsize;
 	alg->alg.cra_ctxsize = sizeof(struct hifn_context);
-	alg->alg.cra_alignmask = 15;
-	if (t->bsize == 8)
-		alg->alg.cra_alignmask = 3;
+	alg->alg.cra_alignmask = 1;
 	alg->alg.cra_type = &crypto_ablkcipher_type;
 	alg->alg.cra_module = THIS_MODULE;
 	alg->alg.cra_u.ablkcipher = t->ablkcipher;

--------------060408060606020507090003--
