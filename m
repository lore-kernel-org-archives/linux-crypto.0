From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: HIFN+IPsec crashes in current -git
Date: Fri, 22 Feb 2008 15:42:14 +0300
Message-ID: <20080222124211.GA15003@2ka.mipt.ru>
References: <20080220005329.GA21565@gondor.apana.org.au> <47BC1E12.9050201@trash.net> <20080220172620.GE27726@gondor.apana.org.au> <20080221091012.GA21291@2ka.mipt.ru> <20080221141013.GB32494@gondor.apana.org.au> <20080221141803.GB24779@2ka.mipt.ru> <47BD88BD.2030305@trash.net> <20080221143721.GB9140@2ka.mipt.ru> <47BD8D93.3070906@trash.net> <47BD98F2.4080305@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:50549 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756285AbYBVMnI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Feb 2008 07:43:08 -0500
Content-Disposition: inline
In-Reply-To: <47BD98F2.4080305@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Patrick.

On Thu, Feb 21, 2008 at 04:29:54PM +0100, Patrick McHardy (kaber@trash.net) wrote:
> Unfortunately still no luck. I got an error from ablkcipher_add()
> because of this condition:

...

> - further down it uses dst->length in the last while-loop,
>   which seems to need a similar change.

Does this patch  (on top of unpatched tree) helps?
I can not test it with real hardware, since I'm sicking at home with
laptop only, but I already know how to make a test case for this problem
without complex setup, so if it does not work, I will investigate it
further as soon as be able to move to office with testing machine :)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index dfbf24c..7807ca9 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -1464,7 +1464,7 @@ static int ablkcipher_walk(struct ablkcipher_request *req,
 		crypto_ablkcipher_alignmask(crypto_ablkcipher_reqtfm(req));
 	struct scatterlist *src, *dst, *t;
 	void *daddr;
-	unsigned int nbytes = req->nbytes, offset, copy, diff;
+	unsigned int nbytes = req->nbytes, offset, copy, diff, nb;
 	int idx, tidx, err;
 
 	tidx = idx = 0;
@@ -1475,11 +1475,13 @@ static int ablkcipher_walk(struct ablkcipher_request *req,
 
 		src = &req->src[idx];
 		dst = &req->dst[idx];
+		
+		nb = min(nbytes, src->length);
 
 		dprintk("\n%s: slen: %u, dlen: %u, soff: %u, doff: %u, offset: %u, "
-				"blocksize: %u, nbytes: %u.\n",
+				"blocksize: %u, nbytes: %u, nb: %u.\n",
 				__func__, src->length, dst->length, src->offset,
-				dst->offset, offset, blocksize, nbytes);
+				dst->offset, offset, blocksize, nbytes, nb);
 
 		if (src->length & (blocksize - 1) ||
 				src->offset & (alignmask - 1) ||
@@ -1492,7 +1494,7 @@ static int ablkcipher_walk(struct ablkcipher_request *req,
 			t = &w->cache[idx];
 
 			daddr = kmap_atomic(sg_page(t), KM_SOFTIRQ0);
-			err = ablkcipher_add(daddr, &dlen, src, slen, &nbytes);
+			err = ablkcipher_add(daddr, &dlen, src, nb, &nbytes);
 			if (err < 0)
 				goto err_out_unmap;
 
@@ -1501,7 +1503,7 @@ static int ablkcipher_walk(struct ablkcipher_request *req,
 			copy = slen & ~(blocksize - 1);
 			diff = slen & (blocksize - 1);
 
-			if (dlen < nbytes) {
+			if (dlen < nb) {
 				/*
 				 * Destination page does not have enough space
 				 * to put there additional blocksized chunk,
@@ -1510,17 +1512,17 @@ static int ablkcipher_walk(struct ablkcipher_request *req,
 				 * 	t->length = (slen & ~(blocksize - 1));
 				 * and increase number of bytes to be processed
 				 * in next chunk:
-				 * 	nbytes += diff;
+				 * 	nb += diff;
 				 */
-				nbytes += diff;
+				nb += diff;
 
 				/*
 				 * Temporary of course...
 				 * Kick author if you will catch this one.
 				 */
 				printk(KERN_ERR "%s: dlen: %u, nbytes: %u,"
-					"slen: %u, offset: %u.\n",
-					__func__, dlen, nbytes, slen, offset);
+					"slen: %u, offset: %u, nb: %u.\n",
+					__func__, dlen, nbytes, slen, offset, nb);
 				printk(KERN_ERR "%s: please contact author to fix this "
 					"issue, generally you should not catch "
 					"this path under any condition but who "
@@ -1528,11 +1530,11 @@ static int ablkcipher_walk(struct ablkcipher_request *req,
 					"Thank you.\n",	__func__);
 				BUG();
 			} else {
-				copy += diff + nbytes;
+				copy += diff + nb;
 
 				src = &req->src[idx];
 
-				err = ablkcipher_add(daddr + slen, &dlen, src, nbytes, &nbytes);
+				err = ablkcipher_add(daddr + slen, &dlen, src, nb, &nbytes);
 				if (err < 0)
 					goto err_out_unmap;
 
@@ -1544,7 +1546,7 @@ static int ablkcipher_walk(struct ablkcipher_request *req,
 
 			kunmap_atomic(daddr, KM_SOFTIRQ0);
 		} else {
-			nbytes -= src->length;
+			nbytes -= nb;
 			idx++;
 		}
 
@@ -1564,7 +1566,7 @@ static int hifn_setup_session(struct ablkcipher_request *req)
 	struct hifn_device *dev = ctx->dev;
 	struct page *spage, *dpage;
 	unsigned long soff, doff, flags;
-	unsigned int nbytes = req->nbytes, idx = 0, len;
+	unsigned int nbytes = req->nbytes, idx = 0, len, nb;
 	int err = -EINVAL, sg_num;
 	struct scatterlist *src, *dst, *t;
 	unsigned blocksize =
@@ -1581,6 +1583,8 @@ static int hifn_setup_session(struct ablkcipher_request *req)
 		src = &req->src[idx];
 		dst = &req->dst[idx];
 
+		nb = min(src->length, nbytes);
+
 		if (src->length & (blocksize - 1) ||
 				src->offset & (alignmask - 1) ||
 				dst->length & (blocksize - 1) ||
@@ -1588,7 +1592,7 @@ static int hifn_setup_session(struct ablkcipher_request *req)
 			ctx->walk.flags |= ASYNC_FLAGS_MISALIGNED;
 		}
 
-		nbytes -= src->length;
+		nbytes -= nb;
 		idx++;
 	}
 
@@ -1602,6 +1606,10 @@ static int hifn_setup_session(struct ablkcipher_request *req)
 	idx = 0;
 
 	sg_num = ablkcipher_walk(req, &ctx->walk);
+	if (sg_num < 0) {
+		err = sg_num;
+		goto err_out_exit;
+	}
 
 	atomic_set(&ctx->sg_num, sg_num);
 
@@ -1632,10 +1640,12 @@ static int hifn_setup_session(struct ablkcipher_request *req)
 
 			len = dst->length;
 		}
+		
+		nb = min(len, nbytes);
 
 		idx++;
 
-		err = hifn_setup_dma(dev, spage, soff, dpage, doff, nbytes,
+		err = hifn_setup_dma(dev, spage, soff, dpage, doff, nb,
 				req, ctx);
 		if (err)
 			goto err_out;
@@ -1652,7 +1662,7 @@ err_out:
 	spin_unlock_irqrestore(&dev->lock, flags);
 err_out_exit:
 	if (err && printk_ratelimit())
-		dprintk("%s: iv: %p [%d], key: %p [%d], mode: %u, op: %u, "
+		printk("%s: iv: %p [%d], key: %p [%d], mode: %u, op: %u, "
 				"type: %u, err: %d.\n",
 			dev->name, ctx->iv, ctx->ivsize,
 			ctx->key, ctx->keysize,
@@ -1786,7 +1796,7 @@ static void hifn_process_ready(struct ablkcipher_request *req, int error)
 		BUG();
 
 	if (atomic_dec_and_test(&ctx->sg_num)) {
-		unsigned int nbytes = req->nbytes;
+		unsigned int nbytes = req->nbytes, nb;
 		int idx = 0, err;
 		struct scatterlist *dst, *t;
 		void *saddr;
@@ -1796,6 +1806,8 @@ static void hifn_process_ready(struct ablkcipher_request *req, int error)
 				t = &ctx->walk.cache[idx];
 				dst = &req->dst[idx];
 
+				nb = min(nbytes, dst->length);
+
 				dprintk("\n%s: sg_page(t): %p, t->length: %u, "
 					"sg_page(dst): %p, dst->length: %u, "
 					"nbytes: %u.\n",
@@ -1803,7 +1815,7 @@ static void hifn_process_ready(struct ablkcipher_request *req, int error)
 					sg_page(dst), dst->length, nbytes);
 
 				if (!t->length) {
-					nbytes -= dst->length;
+					nbytes -= nb;
 					idx++;
 					continue;
 				}
@@ -1811,7 +1823,7 @@ static void hifn_process_ready(struct ablkcipher_request *req, int error)
 				saddr = kmap_atomic(sg_page(t), KM_IRQ1);
 
 				err = ablkcipher_get(saddr, &t->length, t->offset,
-						dst, nbytes, &nbytes);
+						dst, nb, &nbytes);
 				if (err < 0) {
 					kunmap_atomic(saddr, KM_IRQ1);
 					break;


-- 
	Evgeniy Polyakov
