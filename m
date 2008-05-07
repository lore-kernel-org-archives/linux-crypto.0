From: Patrick McHardy <kaber@trash.net>
Subject: [HIFN 06/n]: Properly handle requests for less than the full scatterlist
Date: Wed, 07 May 2008 14:30:28 +0200
Message-ID: <4821A0E4.8070904@trash.net>
References: <48219D24.1040702@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020300040209050402000408"
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62636 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680AbYEGMbH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 08:31:07 -0400
In-Reply-To: <48219D24.1040702@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020300040209050402000408
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit



--------------020300040209050402000408
Content-Type: text/x-diff;
 name="06.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="06.diff"

commit 4f3353b225b7123cf9c04cb9ae3b987f0671ee26
Author: Patrick McHardy <kaber@trash.net>
Date:   Wed May 7 12:52:53 2008 +0200

    [HIFN]: Properly handle requests for less than the full scatterlist
    
    The scatterlist may contain more data than the crypto request, causing
    an underflow of the remaining byte count while walking the list.
    
    Use the minimum of the scatterlist element size and the remaining byte
    count specified in the crypto request to avoid this.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 7706461..650523c 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -1433,7 +1433,7 @@ static int ablkcipher_add(void *daddr, unsigned int *drestp, struct scatterlist
 		return -EINVAL;
 
 	while (size) {
-		copy = min(drest, src->length);
+		copy = min(drest, min(size, src->length));
 
 		saddr = kmap_atomic(sg_page(src), KM_SOFTIRQ1);
 		memcpy(daddr, saddr + src->offset, copy);
@@ -1482,7 +1482,7 @@ static int ablkcipher_walk(struct ablkcipher_request *req,
 		if (!IS_ALIGNED(dst->offset, HIFN_D_DST_DALIGN) ||
 		    !IS_ALIGNED(dst->length, HIFN_D_DST_DALIGN) ||
 		    offset) {
-			unsigned slen = src->length - offset;
+			unsigned slen = min(src->length - offset, nbytes);
 			unsigned dlen = PAGE_SIZE;
 
 			t = &w->cache[idx];
@@ -1540,7 +1540,7 @@ static int ablkcipher_walk(struct ablkcipher_request *req,
 
 			kunmap_atomic(daddr, KM_SOFTIRQ0);
 		} else {
-			nbytes -= src->length;
+			nbytes -= min(src->length, nbytes);
 			idx++;
 		}
 
@@ -1559,7 +1559,7 @@ static int hifn_setup_session(struct ablkcipher_request *req)
 	struct hifn_context *ctx = crypto_tfm_ctx(req->base.tfm);
 	struct hifn_device *dev = ctx->dev;
 	struct page *spage, *dpage;
-	unsigned long soff, doff, flags;
+	unsigned long soff, doff, dlen, flags;
 	unsigned int nbytes = req->nbytes, idx = 0, len;
 	int err = -EINVAL, sg_num;
 	struct scatterlist *src, *dst, *t;
@@ -1571,12 +1571,13 @@ static int hifn_setup_session(struct ablkcipher_request *req)
 
 	while (nbytes) {
 		dst = &req->dst[idx];
+		dlen = min(dst->length, nbytes);
 
 		if (!IS_ALIGNED(dst->offset, HIFN_D_DST_DALIGN) ||
-		    !IS_ALIGNED(dst->length, HIFN_D_DST_DALIGN))
+		    !IS_ALIGNED(dlen, HIFN_D_DST_DALIGN))
 			ctx->walk.flags |= ASYNC_FLAGS_MISALIGNED;
 
-		nbytes -= dst->length;
+		nbytes -= dlen;
 		idx++;
 	}
 
@@ -1631,7 +1632,7 @@ static int hifn_setup_session(struct ablkcipher_request *req)
 		if (err)
 			goto err_out;
 
-		nbytes -= len;
+		nbytes -= min(len, nbytes);
 	}
 
 	dev->active = HIFN_DEFAULT_ACTIVE_NUM;
@@ -1736,8 +1737,7 @@ static int ablkcipher_get(void *saddr, unsigned int *srestp, unsigned int offset
 		return -EINVAL;
 
 	while (size) {
--------------020300040209050402000408--
