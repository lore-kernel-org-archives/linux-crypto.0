From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 08/16] crypto: AF_ALG - consolidate freeing TX/RX SGLs
Date: Mon, 31 Jul 2017 14:08:18 +0200
Message-ID: <1869699.yODLSgWhqH@positron.chronox.de>
References: <4570630.RBIQc1aA22@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60870 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752186AbdGaMLh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2017 08:11:37 -0400
In-Reply-To: <4570630.RBIQc1aA22@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Consoliate aead_free_areq_sgls, skcipher_free_areq_sgls
==> af_alg_free_areq_sgls

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c         | 35 +++++++++++++++++++++++++++++++++++
 crypto/algif_aead.c     | 33 ++-------------------------------
 crypto/algif_skcipher.c | 33 ++-------------------------------
 include/crypto/if_alg.h |  1 +
 4 files changed, 40 insertions(+), 62 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 73d4434df380..07c0e965c336 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -676,6 +676,41 @@ void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst,
 }
 EXPORT_SYMBOL_GPL(af_alg_pull_tsgl);
 
+/**
+ * af_alg_free_areq_sgls - Release TX and RX SGLs of the request
+ *
+ * @areq Request holding the TX and RX SGL
+ */
+void af_alg_free_areq_sgls(struct af_alg_async_req *areq)
+{
+	struct sock *sk = areq->sk;
+	struct alg_sock *ask = alg_sk(sk);
+	struct af_alg_ctx *ctx = ask->private;
+	struct af_alg_rsgl *rsgl, *tmp;
+	struct scatterlist *tsgl;
+	struct scatterlist *sg;
+	unsigned int i;
+
+	list_for_each_entry_safe(rsgl, tmp, &areq->rsgl_list, list) {
+		ctx->rcvused -= rsgl->sg_num_bytes;
+		af_alg_free_sg(&rsgl->sgl);
+		list_del(&rsgl->list);
+		if (rsgl != &areq->first_rsgl)
+			sock_kfree_s(sk, rsgl, sizeof(*rsgl));
+	}
+
+	tsgl = areq->tsgl;
+	for_each_sg(tsgl, sg, areq->tsgl_entries, i) {
+		if (!sg_page(sg))
+			continue;
+		put_page(sg_page(sg));
+	}
+
+	if (areq->tsgl && areq->tsgl_entries)
+		sock_kfree_s(sk, tsgl, areq->tsgl_entries * sizeof(*tsgl));
+}
+EXPORT_SYMBOL_GPL(af_alg_free_areq_sgls);
+
 static int __init af_alg_init(void)
 {
 	int err = proto_register(&alg_proto, 0);
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index b78acb3336d6..5ccac7f0047e 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -64,35 +64,6 @@ static inline bool aead_sufficient_data(struct sock *sk)
 	return ctx->used >= ctx->aead_assoclen + (ctx->enc ? 0 : as);
 }
 
-static void aead_free_areq_sgls(struct af_alg_async_req *areq)
-{
-	struct sock *sk = areq->sk;
-	struct alg_sock *ask = alg_sk(sk);
-	struct af_alg_ctx *ctx = ask->private;
-	struct af_alg_rsgl *rsgl, *tmp;
-	struct scatterlist *tsgl;
-	struct scatterlist *sg;
-	unsigned int i;
-
-	list_for_each_entry_safe(rsgl, tmp, &areq->rsgl_list, list) {
-		ctx->rcvused -= rsgl->sg_num_bytes;
-		af_alg_free_sg(&rsgl->sgl);
-		list_del(&rsgl->list);
-		if (rsgl != &areq->first_rsgl)
-			sock_kfree_s(sk, rsgl, sizeof(*rsgl));
-	}
-
-	tsgl = areq->tsgl;
-	for_each_sg(tsgl, sg, areq->tsgl_entries, i) {
-		if (!sg_page(sg))
-			continue;
-		put_page(sg_page(sg));
-	}
-
-	if (areq->tsgl && areq->tsgl_entries)
-		sock_kfree_s(sk, tsgl, areq->tsgl_entries * sizeof(*tsgl));
-}
-
 static int aead_wait_for_wmem(struct sock *sk, unsigned int flags)
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
@@ -393,7 +364,7 @@ static void aead_async_cb(struct crypto_async_request *_req, int err)
 	/* Buffer size written by crypto operation. */
 	resultlen = areq->outlen;
 
-	aead_free_areq_sgls(areq);
+	af_alg_free_areq_sgls(areq);
 	sock_kfree_s(sk, areq, areq->areqlen);
 	__sock_put(sk);
 
@@ -671,7 +642,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	}
 
 free:
-	aead_free_areq_sgls(areq);
+	af_alg_free_areq_sgls(areq);
 	if (areq)
 		sock_kfree_s(sk, areq, areqlen);
 
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index bc7bbd16f2eb..ea7cfe7c1971 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -44,35 +44,6 @@ struct skcipher_tfm {
 	bool has_key;
 };
 
-static void skcipher_free_areq_sgls(struct af_alg_async_req *areq)
-{
-	struct sock *sk = areq->sk;
-	struct alg_sock *ask = alg_sk(sk);
-	struct af_alg_ctx *ctx = ask->private;
-	struct af_alg_rsgl *rsgl, *tmp;
-	struct scatterlist *tsgl;
-	struct scatterlist *sg;
-	unsigned int i;
-
-	list_for_each_entry_safe(rsgl, tmp, &areq->rsgl_list, list) {
-		ctx->rcvused -= rsgl->sg_num_bytes;
-		af_alg_free_sg(&rsgl->sgl);
-		list_del(&rsgl->list);
-		if (rsgl != &areq->first_rsgl)
-			sock_kfree_s(sk, rsgl, sizeof(*rsgl));
-	}
-
-	tsgl = areq->tsgl;
-	for_each_sg(tsgl, sg, areq->tsgl_entries, i) {
-		if (!sg_page(sg))
-			continue;
-		put_page(sg_page(sg));
-	}
-
-	if (areq->tsgl && areq->tsgl_entries)
-		sock_kfree_s(sk, tsgl, areq->tsgl_entries * sizeof(*tsgl));
-}
-
 static int skcipher_wait_for_wmem(struct sock *sk, unsigned flags)
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
@@ -368,7 +339,7 @@ static void skcipher_async_cb(struct crypto_async_request *req, int err)
 	/* Buffer size written by crypto operation. */
 	resultlen = areq->cra_u.skcipher_req.cryptlen;
 
-	skcipher_free_areq_sgls(areq);
+	af_alg_free_areq_sgls(areq);
 	sock_kfree_s(sk, areq, areq->areqlen);
 	__sock_put(sk);
 
@@ -512,7 +483,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	}
 
 free:
-	skcipher_free_areq_sgls(areq);
+	af_alg_free_areq_sgls(areq);
 	if (areq)
 		sock_kfree_s(sk, areq, areqlen);
 
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 534aa3810c6b..93379804a0ee 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -244,5 +244,6 @@ int af_alg_alloc_tsgl(struct sock *sk);
 unsigned int af_alg_count_tsgl(struct sock *sk, size_t bytes, size_t offset);
 void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst,
 		      size_t dst_offset);
+void af_alg_free_areq_sgls(struct af_alg_async_req *areq);
 
 #endif	/* _CRYPTO_IF_ALG_H */
-- 
2.13.3
