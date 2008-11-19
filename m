From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH] Don't copy src sg list.
Date: Wed, 19 Nov 2008 17:03:29 +0300
Message-ID: <1227103414418-git-send-email-zbr@ioremap.net>
References: <12271034133347-git-send-email-zbr@ioremap.net>
 <12271034132587-git-send-email-zbr@ioremap.net>
 <12271034131753-git-send-email-zbr@ioremap.net>
 <1227103414646-git-send-email-zbr@ioremap.net>
Cc: linux-crypto@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Evgeniy Polyakov <zbr@ioremap.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zbr.yandex.ru ([213.180.219.33]:37383 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753988AbYKSOHz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Nov 2008 09:07:55 -0500
In-Reply-To: <1227103414646-git-send-email-zbr@ioremap.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/crypto/hifn_795x.c |   75 +++++++++++++++++++------------------------
 1 files changed, 33 insertions(+), 42 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 89e2e9a..13152f1 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -1378,32 +1378,40 @@ static int hifn_setup_dma(struct hifn_device *dev, struct hifn_context *ctx,
 	unsigned int soff, doff;
 	unsigned int n, len;
 
+	n = nbytes;
+	while (n) {
+		spage = sg_page(src);
+		soff = src->offset;
+		len = min(src->length, n);
+
+		dprintk("%s: spage: %p, soffset: %u, nbytes: %u, "
+			"priv: %p, ctx: %p.\n",
+			dev->name, spage, soff, nbytes, priv, ctx);
+		hifn_setup_src_desc(dev, spage, soff, len, n - len == 0);
+
+		src++;
+		n -= len;
+	}
+
 	t = &ctx->walk.cache[0];
 	n = nbytes;
 	while (n) {
 		if (t->length) {
-			spage = dpage = sg_page(t);
-			soff = doff = 0;
+			dpage = sg_page(t);
+			doff = 0;
 			len = t->length;
 		} else {
-			spage = sg_page(src);
-			soff = src->offset;
-
 			dpage = sg_page(dst);
 			doff = dst->offset;
-
 			len = dst->length;
 		}
 		len = min(len, n);
 
-		dprintk("%s: spage: %p, soffset: %u, dpage: %p, doffset: %u, "
-			"nbytes: %u, priv: %p, ctx: %p.\n",
-			dev->name, spage, soff, dpage, doff, nbytes, priv, ctx);
-
-		hifn_setup_src_desc(dev, spage, soff, len, n - len == 0);
+		dprintk("%s: dpage: %p, doffset: %u, nbytes: %u, "
+			"priv: %p, ctx: %p.\n",
+			dev->name, dpage, doff, nbytes, priv, ctx);
 		hifn_setup_dst_desc(dev, dpage, doff, len, n - len == 0);
 
-		src++;
 		dst++;
 		t++;
 		n -= len;
@@ -1454,32 +1462,26 @@ static void ablkcipher_walk_exit(struct ablkcipher_walk *w)
 	w->num = 0;
 }
 
-static int ablkcipher_add(void *daddr, unsigned int *drestp, struct scatterlist *src,
+static int ablkcipher_add(unsigned int *drestp, struct scatterlist *dst,
 		unsigned int size, unsigned int *nbytesp)
 {
 	unsigned int copy, drest = *drestp, nbytes = *nbytesp;
 	int idx = 0;
-	void *saddr;
 
 	if (drest < size || size > nbytes)
 		return -EINVAL;
 
 	while (size) {
-		copy = min(drest, min(size, src->length));
-
-		saddr = kmap_atomic(sg_page(src), KM_SOFTIRQ1);
-		memcpy(daddr, saddr + src->offset, copy);
-		kunmap_atomic(saddr, KM_SOFTIRQ1);
+		copy = min(drest, min(size, dst->length));
 
 		size -= copy;
 		drest -= copy;
 		nbytes -= copy;
-		daddr += copy;
 
 		dprintk("%s: copy: %u, size: %u, drest: %u, nbytes: %u.\n",
 				__func__, copy, size, drest, nbytes);
 
-		src++;
+		dst++;
 		idx++;
 	}
 
@@ -1492,8 +1494,7 @@ static int ablkcipher_add(void *daddr, unsigned int *drestp, struct scatterlist
 static int ablkcipher_walk(struct ablkcipher_request *req,
 		struct ablkcipher_walk *w)
 {
-	struct scatterlist *src, *dst, *t;
-	void *daddr;
+	struct scatterlist *dst, *t;
 	unsigned int nbytes = req->nbytes, offset, copy, diff;
 	int idx, tidx, err;
 
@@ -1503,26 +1504,22 @@ static int ablkcipher_walk(struct ablkcipher_request *req,
 		if (idx >= w->num && (w->flags & ASYNC_FLAGS_MISALIGNED))
 			return -EINVAL;
 
-		src = &req->src[idx];
 		dst = &req->dst[idx];
 
-		dprintk("\n%s: slen: %u, dlen: %u, soff: %u, doff: %u, offset: %u, "
-				"nbytes: %u.\n",
-				__func__, src->length, dst->length, src->offset,
-				dst->offset, offset, nbytes);
+		dprintk("\n%s: dlen: %u, doff: %u, offset: %u, nbytes: %u.\n",
+			__func__, dst->length, dst->offset, offset, nbytes);
 
 		if (!IS_ALIGNED(dst->offset, HIFN_D_DST_DALIGN) ||
 		    !IS_ALIGNED(dst->length, HIFN_D_DST_DALIGN) ||
 		    offset) {
-			unsigned slen = min(src->length - offset, nbytes);
+			unsigned slen = min(dst->length - offset, nbytes);
 			unsigned dlen = PAGE_SIZE;
 
 			t = &w->cache[idx];
 
-			daddr = kmap_atomic(sg_page(t), KM_SOFTIRQ0);
-			err = ablkcipher_add(daddr, &dlen, src, slen, &nbytes);
+			err = ablkcipher_add(&dlen, dst, slen, &nbytes);
 			if (err < 0)
-				goto err_out_unmap;
+				return err;
 
 			idx += err;
 
@@ -1558,21 +1555,19 @@ static int ablkcipher_walk(struct ablkcipher_request *req,
 			} else {
 				copy += diff + nbytes;
 
-				src = &req->src[idx];
+				dst = &req->dst[idx];
 
-				err = ablkcipher_add(daddr + slen, &dlen, src, nbytes, &nbytes);
+				err = ablkcipher_add(&dlen, dst, nbytes, &nbytes);
 				if (err < 0)
-					goto err_out_unmap;
+					return err;
 
 				idx += err;
 			}
 
 			t->length = copy;
 			t->offset = offset;
-
-			kunmap_atomic(daddr, KM_SOFTIRQ0);
 		} else {
-			nbytes -= min(src->length, nbytes);
+			nbytes -= min(dst->length, nbytes);
 			idx++;
 		}
 
@@ -1580,10 +1575,6 @@ static int ablkcipher_walk(struct ablkcipher_request *req,
 	}
 
 	return tidx;
