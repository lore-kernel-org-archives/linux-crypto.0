From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [CRYPTO] hifn_795x: Update for new scatterlist API
Date: Fri, 26 Oct 2007 20:10:41 +0800
Message-ID: <20071026121041.GA12241@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1073 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751186AbXJZMKr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Oct 2007 08:10:47 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Evgeniy:

I've updated the HIFN driver to work with the new scatterlist
API.  Please have a look to see if I've done anything stupid.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 984f333..391c20a 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -1225,6 +1225,7 @@ static int ablkcipher_walk_init(struct ablkcipher_walk *w,
 	int i;
 
 	num = min(ASYNC_SCATTERLIST_CACHE, num);
+	sg_init_table(w->cache, num);
 
 	w->num = 0;
 	for (i=0; i<num; ++i) {
@@ -1236,9 +1237,7 @@ static int ablkcipher_walk_init(struct ablkcipher_walk *w,
 
 		s = &w->cache[i];
 
-		s->page = page;
-		s->length = PAGE_SIZE;
-		s->offset = 0;
+		sg_set_page(s, page, PAGE_SIZE, 0);
 		w->num++;
 	}
 
@@ -1252,11 +1251,9 @@ static void ablkcipher_walk_exit(struct ablkcipher_walk *w)
 	for (i=0; i<w->num; ++i) {
 		struct scatterlist *s = &w->cache[i];
 
-		__free_page(s->page);
+		__free_page(sg_page(s));
 
 		s->length = 0;
-		s->offset = 0;
-		s->page = NULL;
 	}
 
 	w->num = 0;
@@ -1275,7 +1272,7 @@ static int ablkcipher_add(void *daddr, unsigned int *drestp, struct scatterlist
 	while (size) {
 		copy = min(drest, src->length);
 
-		saddr = kmap_atomic(src->page, KM_SOFTIRQ1);
+		saddr = kmap_atomic(sg_page(src), KM_SOFTIRQ1);
 		memcpy(daddr, saddr + src->offset, copy);
 		kunmap_atomic(saddr, KM_SOFTIRQ1);
 
@@ -1333,7 +1330,7 @@ static int ablkcipher_walk(struct ablkcipher_request *req,
 
 			t = &w->cache[idx];
 
-			daddr = kmap_atomic(t->page, KM_SOFTIRQ0);
+			daddr = kmap_atomic(sg_page(t), KM_SOFTIRQ0);
 			err = ablkcipher_add(daddr, &dlen, src, slen, &nbytes);
 			if (err < 0)
 				goto err_out_unmap;
@@ -1462,14 +1459,14 @@ static int hifn_setup_session(struct ablkcipher_request *req)
 		t = &ctx->walk.cache[idx];
 
 		if (t->length) {
-			spage = dpage = t->page;
+			spage = dpage = sg_page(t);
 			soff = doff = 0;
 			len = t->length;
 		} else {
-			spage = src->page;
+			spage = sg_page(src);
 			soff = src->offset;
 
-			dpage = dst->page;
+			dpage = sg_page(dst);
 			doff = dst->offset;
 
 			len = dst->length;
@@ -1590,7 +1587,7 @@ static int ablkcipher_get(void *saddr, unsigned int *srestp, unsigned int offset
 
 		copy = min(dst->length, srest);
 
-		daddr = kmap_atomic(dst->page, KM_IRQ0);
+		daddr = kmap_atomic(sg_page(dst), KM_IRQ0);
 		memcpy(daddr + dst->offset + offset, saddr, copy);
 		kunmap_atomic(daddr, KM_IRQ0);
 
@@ -1638,11 +1635,11 @@ static void hifn_process_ready(struct ablkcipher_request *req, int error)
 				t = &ctx->walk.cache[idx];
 				dst = &req->dst[idx];
 
-				dprintk("\n%s: t->page: %p, t->length: %u, "
-					"dst->page: %p, dst->length: %u, "
+				dprintk("\n%s: sg_page(t): %p, t->length: %u, "
+					"sg_page(dst): %p, dst->length: %u, "
 					"nbytes: %u.\n",
-					__func__, t->page, t->length, dst->page,
-					dst->length, nbytes);
+					__func__, sg_page(t), t->length,
+					sg_page(dst), dst->length, nbytes);
 
 				if (!t->length) {
 					nbytes -= dst->length;
@@ -1650,7 +1647,7 @@ static void hifn_process_ready(struct ablkcipher_request *req, int error)
 					continue;
 				}
 
-				saddr = kmap_atomic(t->page, KM_IRQ1);
+				saddr = kmap_atomic(sg_page(t), KM_IRQ1);
 
 				err = ablkcipher_get(saddr, &t->length, t->offset,
 						dst, nbytes, &nbytes);
