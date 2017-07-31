From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 07/16] crypto: AF_ALG - consolidate counting TX SG entries
Date: Mon, 31 Jul 2017 14:07:52 +0200
Message-ID: <8891425.KFFGBHUbFA@positron.chronox.de>
References: <4570630.RBIQc1aA22@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60872 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751825AbdGaMLh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2017 08:11:37 -0400
In-Reply-To: <4570630.RBIQc1aA22@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Consoliate aead_pull_tsgl, skcipher_pull_tsgl ==> af_alg_pull_tsgl

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c         | 80 +++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/algif_aead.c     | 79 ++----------------------------------------------
 crypto/algif_skcipher.c | 55 ++--------------------------------
 include/crypto/if_alg.h |  2 ++
 4 files changed, 87 insertions(+), 129 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 861167fc12f7..73d4434df380 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -596,6 +596,86 @@ unsigned int af_alg_count_tsgl(struct sock *sk, size_t bytes, size_t offset)
 }
 EXPORT_SYMBOL_GPL(af_alg_count_tsgl);
 
+/**
+ * aead_pull_tsgl - Release the specified buffers from TX SGL
+ *
+ * If @dst is non-null, reassign the pages to dst. The caller must release
+ * the pages. If @dst_offset is given only reassign the pages to @dst starting
+ * at the @dst_offset (byte). The caller must ensure that @dst is large
+ * enough (e.g. by using af_alg_count_tsgl with the same offset).
+ *
+ * @sk socket of connection to user space
+ * @used Number of bytes to pull from TX SGL
+ * @dst If non-NULL, buffer is reassigned to dst SGL instead of releasing. The
+ *	caller must release the buffers in dst.
+ * @dst_offset Reassign the TX SGL from given offset. All buffers before
+ *	       reaching the offset is released.
+ */
+void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst,
+		      size_t dst_offset)
+{
+	struct alg_sock *ask = alg_sk(sk);
+	struct af_alg_ctx *ctx = ask->private;
+	struct af_alg_tsgl *sgl;
+	struct scatterlist *sg;
+	unsigned int i, j;
+
+	while (!list_empty(&ctx->tsgl_list)) {
+		sgl = list_first_entry(&ctx->tsgl_list, struct af_alg_tsgl,
+				       list);
+		sg = sgl->sg;
+
+		for (i = 0, j = 0; i < sgl->cur; i++) {
+			size_t plen = min_t(size_t, used, sg[i].length);
+			struct page *page = sg_page(sg + i);
+
+			if (!page)
+				continue;
+
+			/*
+			 * Assumption: caller created af_alg_count_tsgl(len)
+			 * SG entries in dst.
+			 */
+			if (dst) {
+				if (dst_offset >= plen) {
+					/* discard page before offset */
+					dst_offset -= plen;
+					put_page(page);
+				} else {
+					/* reassign page to dst after offset */
+					sg_set_page(dst + j, page,
+						    plen - dst_offset,
+						    sg[i].offset + dst_offset);
+					dst_offset = 0;
+					j++;
+				}
+			}
+
+			sg[i].length -= plen;
+			sg[i].offset += plen;
+
+			used -= plen;
+			ctx->used -= plen;
+
+			if (sg[i].length)
+				return;
+
+			if (!dst)
+				put_page(page);
+
+			sg_assign_page(sg + i, NULL);
+		}
+
+		list_del(&sgl->list);
+		sock_kfree_s(sk, sgl, sizeof(*sgl) + sizeof(sgl->sg[0]) *
+						     (MAX_SGL_ENTS + 1));
+	}
+
+	if (!ctx->used)
+		ctx->merge = 0;
+}
+EXPORT_SYMBOL_GPL(af_alg_pull_tsgl);
+
 static int __init af_alg_init(void)
 {
 	int err = proto_register(&alg_proto, 0);
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 78651b26aa77..b78acb3336d6 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -64,79 +64,6 @@ static inline bool aead_sufficient_data(struct sock *sk)
 	return ctx->used >= ctx->aead_assoclen + (ctx->enc ? 0 : as);
 }
 
-/**
- * Release the specified buffers from TX SGL pointed to by ctx->tsgl_list for
- * @used bytes.
- *
- * If @dst is non-null, reassign the pages to dst. The caller must release
- * the pages. If @dst_offset is given only reassign the pages to @dst starting
- * at the @dst_offset (byte). The caller must ensure that @dst is large
- * enough (e.g. by using af_alg_count_tsgl with the same offset).
- */
-static void aead_pull_tsgl(struct sock *sk, size_t used,
-			   struct scatterlist *dst, size_t dst_offset)
-{
-	struct alg_sock *ask = alg_sk(sk);
-	struct af_alg_ctx *ctx = ask->private;
-	struct af_alg_tsgl *sgl;
-	struct scatterlist *sg;
-	unsigned int i, j;
-
-	while (!list_empty(&ctx->tsgl_list)) {
-		sgl = list_first_entry(&ctx->tsgl_list, struct af_alg_tsgl,
-				       list);
-		sg = sgl->sg;
-
-		for (i = 0, j = 0; i < sgl->cur; i++) {
-			size_t plen = min_t(size_t, used, sg[i].length);
-			struct page *page = sg_page(sg + i);
-
-			if (!page)
-				continue;
-
-			/*
-			 * Assumption: caller created af_alg_count_tsgl(len)
-			 * SG entries in dst.
-			 */
-			if (dst) {
-				if (dst_offset >= plen) {
-					/* discard page before offset */
-					dst_offset -= plen;
-					put_page(page);
-				} else {
-					/* reassign page to dst after offset */
-					sg_set_page(dst + j, page,
-						    plen - dst_offset,
-						    sg[i].offset + dst_offset);
-					dst_offset = 0;
-					j++;
-				}
-			}
-
-			sg[i].length -= plen;
-			sg[i].offset += plen;
-
-			used -= plen;
-			ctx->used -= plen;
-
-			if (sg[i].length)
-				return;
-
-			if (!dst)
-				put_page(page);
-
-			sg_assign_page(sg + i, NULL);
-		}
-
-		list_del(&sgl->list);
-		sock_kfree_s(sk, sgl, sizeof(*sgl) + sizeof(sgl->sg[0]) *
-						     (MAX_SGL_ENTS + 1));
-	}
-
-	if (!ctx->used)
-		ctx->merge = 0;
-}
-
 static void aead_free_areq_sgls(struct af_alg_async_req *areq)
 {
 	struct sock *sk = areq->sk;
@@ -659,7 +586,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 					   areq->first_rsgl.sgl.sg, processed);
 		if (err)
 			goto free;
-		aead_pull_tsgl(sk, processed, NULL, 0);
+		af_alg_pull_tsgl(sk, processed, NULL, 0);
 	} else {
 		/*
 		 * Decryption operation - To achieve an in-place cipher
@@ -693,7 +620,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 		sg_init_table(areq->tsgl, areq->tsgl_entries);
 
 		/* Release TX SGL, except for tag data and reassign tag data. */
-		aead_pull_tsgl(sk, processed, areq->tsgl, processed - as);
+		af_alg_pull_tsgl(sk, processed, areq->tsgl, processed - as);
 
 		/* chain the areq TX SGL holding the tag with RX SGL */
 		if (last_rsgl) {
@@ -987,7 +914,7 @@ static void aead_sock_destruct(struct sock *sk)
 	struct crypto_aead *tfm = aeadc->aead;
 	unsigned int ivlen = crypto_aead_ivsize(tfm);
 
-	aead_pull_tsgl(sk, ctx->used, NULL, 0);
+	af_alg_pull_tsgl(sk, ctx->used, NULL, 0);
 	crypto_put_default_null_skcipher2();
 	sock_kzfree_s(sk, ctx->iv, ivlen);
 	sock_kfree_s(sk, ctx, ctx->len);
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 8e086d9f7b71..bc7bbd16f2eb 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -44,57 +44,6 @@ struct skcipher_tfm {
 	bool has_key;
 };
 
-static void skcipher_pull_tsgl(struct sock *sk, size_t used,
-			       struct scatterlist *dst)
-{
-	struct alg_sock *ask = alg_sk(sk);
-	struct af_alg_ctx *ctx = ask->private;
-	struct af_alg_tsgl *sgl;
-	struct scatterlist *sg;
-	unsigned int i;
-
-	while (!list_empty(&ctx->tsgl_list)) {
-		sgl = list_first_entry(&ctx->tsgl_list, struct af_alg_tsgl,
-				       list);
-		sg = sgl->sg;
-
-		for (i = 0; i < sgl->cur; i++) {
-			size_t plen = min_t(size_t, used, sg[i].length);
-			struct page *page = sg_page(sg + i);
-
-			if (!page)
-				continue;
-
-			/*
-			 * Assumption: caller created af_alg_count_tsgl(len)
-			 * SG entries in dst.
-			 */
-			if (dst)
-				sg_set_page(dst + i, page, plen, sg[i].offset);
-
-			sg[i].length -= plen;
-			sg[i].offset += plen;
-
-			used -= plen;
-			ctx->used -= plen;
-
-			if (sg[i].length)
-				return;
-
-			if (!dst)
-				put_page(page);
-			sg_assign_page(sg + i, NULL);
-		}
-
-		list_del(&sgl->list);
-		sock_kfree_s(sk, sgl, sizeof(*sgl) + sizeof(sgl->sg[0]) *
-						     (MAX_SGL_ENTS + 1));
-	}
-
-	if (!ctx->used)
-		ctx->merge = 0;
-}
-
 static void skcipher_free_areq_sgls(struct af_alg_async_req *areq)
 {
 	struct sock *sk = areq->sk;
@@ -527,7 +476,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 		goto free;
 	}
 	sg_init_table(areq->tsgl, areq->tsgl_entries);
-	skcipher_pull_tsgl(sk, len, areq->tsgl);
+	af_alg_pull_tsgl(sk, len, areq->tsgl, 0);
 
 	/* Initialize the crypto operation */
 	skcipher_request_set_tfm(&areq->cra_u.skcipher_req, tfm);
@@ -789,7 +738,7 @@ static void skcipher_sock_destruct(struct sock *sk)
 	struct skcipher_tfm *skc = pask->private;
 	struct crypto_skcipher *tfm = skc->skcipher;
 
-	skcipher_pull_tsgl(sk, ctx->used, NULL);
+	af_alg_pull_tsgl(sk, ctx->used, NULL, 0);
 	sock_kzfree_s(sk, ctx->iv, crypto_skcipher_ivsize(tfm));
 	sock_kfree_s(sk, ctx, ctx->len);
 	af_alg_release_parent(sk);
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 3029cf4f2890..534aa3810c6b 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -242,5 +242,7 @@ static inline bool af_alg_readable(struct sock *sk)
 
 int af_alg_alloc_tsgl(struct sock *sk);
 unsigned int af_alg_count_tsgl(struct sock *sk, size_t bytes, size_t offset);
+void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst,
+		      size_t dst_offset);
 
 #endif	/* _CRYPTO_IF_ALG_H */
-- 
2.13.3
