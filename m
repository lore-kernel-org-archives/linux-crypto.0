Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6463D230242
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 10:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744020186; cv=none; b=K+U5dckFaq+oEy6cCllo0atbD7hYCJ1OfnXCphurr+X3tbEc/FJ59Br68YIXLzldbFcAXn90YzuNUzDU7+hZ7SknWmpvIyOPTBTZDZxNWKthx7u0UPBix7CjVx6vimFTiNyLfW4rNiLnGPfFAbkDc3xwLK52/qSFN13yT9Wi55Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744020186; c=relaxed/simple;
	bh=g95fOCGWeqQIuuDrbfQW/2NTkWXWUtfJg9u3vRGQZSA=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=GUUhRsu/hlpeIS08Es8Jg/mNLoYj2hpPaokSM/OcfxBTkIeoT53PVk1Xse1O27Y/U8xkfCbITgxgS3IzMOcjrKMMWsRfL08pWYpStkQtU2nEd/e16CLq/G+ME/pB8J2OyM+j4wxckMeON2mHgyleJcNEJa9mzb2xy5o0QmBim/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=dCYPBL/K; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="dCYPBL/K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Cs4FQRl6EvMojc3T3B3xIezvpCgWvmdn7fNz4ncQaHc=; b=dCYPBL/KfpbXlPe+4eWjESqOEA
	QW6D2VuCWnUK489WDvGX3dXlTwkeQ5Ui9QYuWCSSpvWfhoGkk29BCrtKs18QXfHaDJkppyhk3ZRym
	PokAKXQzMxtTvXETyKa/9AoYqLM9RrQxPxP0t+tgOIMTPlVxzkCYMnYaKmksWYwUReso9eXa1qMdo
	iduTs5Wo/tcSrU4AJmP/sXKkVBeRdZaIQG7h8smgFH0SLcUAOKtY8FZk1lrHPOviszoiGl2GnDCmp
	tT9L/at1qbscBsA2sKYuTZP0Xk6kaAVMjQXpGIrszrDRvVU7V+iaUd8UNeEi7391vkbIjeKXOLbqo
	+11UNCVA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1jJk-00DTI1-1L;
	Mon, 07 Apr 2025 18:03:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 18:03:00 +0800
Date: Mon, 07 Apr 2025 18:03:00 +0800
Message-Id: <043f54180138940db2dce180f192e240a81771bd.1744019630.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744019630.git.herbert@gondor.apana.org.au>
References: <cover.1744019630.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/7] crypto: acomp - Add ACOMP_REQUEST_CLONE
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>, linux-mtd@lists.infradead.org
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add a new helper ACOMP_REQUEST_CLONE that will transform a stack
request into a dynamically allocated one if possible, and otherwise
switch it over to the sycnrhonous fallback transform.  The intended
usage is:

	ACOMP_STACK_ON_REQUEST(req, tfm);

	...
	err = crypto_acomp_compress(req);
	/* The request cannot complete synchronously. */
	if (err == -EAGAIN) {
		/* This will not fail. */
		req = ACOMP_REQUEST_CLONE(req, gfp);

		/* Redo operation. */
		err = crypto_acomp_compress(req);
	}

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/acompress.c                  | 23 ++++++++++++++++++++++
 include/crypto/acompress.h          | 30 +++++++++++++++++++++++++----
 include/crypto/internal/acompress.h | 11 +++--------
 3 files changed, 52 insertions(+), 12 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 85cef01bd638..9eed20ad0f24 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -316,6 +316,8 @@ int crypto_acomp_compress(struct acomp_req *req)
 {
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
 
+	if (acomp_req_on_stack(req) && acomp_is_async(tfm))
+		return -EAGAIN;
 	if (crypto_acomp_req_chain(tfm) || acomp_request_issg(req))
 		crypto_acomp_reqtfm(req)->compress(req);
 	return acomp_do_req_chain(req, true);
@@ -326,6 +328,8 @@ int crypto_acomp_decompress(struct acomp_req *req)
 {
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
 
+	if (acomp_req_on_stack(req) && acomp_is_async(tfm))
+		return -EAGAIN;
 	if (crypto_acomp_req_chain(tfm) || acomp_request_issg(req))
 		crypto_acomp_reqtfm(req)->decompress(req);
 	return acomp_do_req_chain(req, false);
@@ -599,5 +603,24 @@ int acomp_walk_virt(struct acomp_walk *__restrict walk,
 }
 EXPORT_SYMBOL_GPL(acomp_walk_virt);
 
+struct acomp_req *acomp_request_clone(struct acomp_req *req,
+				      size_t total, gfp_t gfp)
+{
+	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
+	struct acomp_req *nreq;
+
+	nreq = kmalloc(total, gfp);
+	if (!nreq) {
+		acomp_request_set_tfm(req, tfm->fb);
+		req->base.flags = CRYPTO_TFM_REQ_ON_STACK;
+		return req;
+	}
+
+	memcpy(nreq, req, total);
+	acomp_request_set_tfm(req, tfm);
+	return req;
+}
+EXPORT_SYMBOL_GPL(acomp_request_clone);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Asynchronous compression type");
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index f383a4008854..93cee67c27c0 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -49,10 +49,19 @@
 #define	MAX_SYNC_COMP_REQSIZE		0
 
 #define ACOMP_REQUEST_ALLOC(name, tfm, gfp) \
+        char __##name##_req[sizeof(struct acomp_req) + \
+                            MAX_SYNC_COMP_REQSIZE] CRYPTO_MINALIGN_ATTR; \
+        struct acomp_req *name = acomp_request_alloc_init( \
+                __##name##_req, (tfm), (gfp))
+
+#define ACOMP_REQUEST_ON_STACK(name, tfm) \
         char __##name##_req[sizeof(struct acomp_req) + \
                             MAX_SYNC_COMP_REQSIZE] CRYPTO_MINALIGN_ATTR; \
         struct acomp_req *name = acomp_request_on_stack_init( \
-                __##name##_req, (tfm), (gfp), false)
+                __##name##_req, (tfm))
+
+#define ACOMP_REQUEST_CLONE(name, gfp) \
+	acomp_request_clone(name, sizeof(__##name##_req), gfp)
 
 struct acomp_req;
 struct folio;
@@ -571,12 +580,12 @@ int crypto_acomp_compress(struct acomp_req *req);
  */
 int crypto_acomp_decompress(struct acomp_req *req);
 
-static inline struct acomp_req *acomp_request_on_stack_init(
-	char *buf, struct crypto_acomp *tfm, gfp_t gfp, bool stackonly)
+static inline struct acomp_req *acomp_request_alloc_init(
+	char *buf, struct crypto_acomp *tfm, gfp_t gfp)
 {
 	struct acomp_req *req;
 
-	if (!stackonly && (req = acomp_request_alloc(tfm, gfp)))
+	if ((req = acomp_request_alloc(tfm, gfp)))
 		return req;
 
 	req = (void *)buf;
@@ -586,4 +595,17 @@ static inline struct acomp_req *acomp_request_on_stack_init(
 	return req;
 }
 
+static inline struct acomp_req *acomp_request_on_stack_init(
+	char *buf, struct crypto_acomp *tfm)
+{
+	struct acomp_req *req = (void *)buf;
+
+	acomp_request_set_tfm(req, tfm);
+	req->base.flags = CRYPTO_TFM_REQ_ON_STACK;
+	return req;
+}
+
+struct acomp_req *acomp_request_clone(struct acomp_req *req,
+				      size_t total, gfp_t gfp);
+
 #endif
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 8840fd2c1db5..b51d66633935 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -17,12 +17,6 @@
 #include <linux/spinlock.h>
 #include <linux/workqueue_types.h>
 
-#define ACOMP_REQUEST_ON_STACK(name, tfm) \
-        char __##name##_req[sizeof(struct acomp_req) + \
-                            MAX_SYNC_COMP_REQSIZE] CRYPTO_MINALIGN_ATTR; \
-        struct acomp_req *name = acomp_request_on_stack_init( \
-                __##name##_req, (tfm), 0, true)
-
 #define ACOMP_FBREQ_ON_STACK(name, req) \
         char __##name##_req[sizeof(struct acomp_req) + \
                             MAX_SYNC_COMP_REQSIZE] CRYPTO_MINALIGN_ATTR; \
@@ -245,9 +239,10 @@ static inline struct acomp_req *acomp_fbreq_on_stack_init(
 	char *buf, struct acomp_req *old)
 {
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(old);
-	struct acomp_req *req;
+	struct acomp_req *req = (void *)buf;
 
-	req = acomp_request_on_stack_init(buf, tfm, 0, true);
+	acomp_request_set_tfm(req, tfm->fb);
+	req->base.flags = CRYPTO_TFM_REQ_ON_STACK;
 	acomp_request_set_callback(req, acomp_request_flags(old), NULL, NULL);
 	req->base.flags &= ~CRYPTO_ACOMP_REQ_PRIVATE;
 	req->base.flags |= old->base.flags & CRYPTO_ACOMP_REQ_PRIVATE;
-- 
2.39.5

