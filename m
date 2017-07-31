From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 05/16] crypto: AF_ALG - consolidate TX SGL allocation
Date: Mon, 31 Jul 2017 14:07:09 +0200
Message-ID: <3228902.lXnppEh3cP@positron.chronox.de>
References: <4570630.RBIQc1aA22@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60876 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752191AbdGaMLh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2017 08:11:37 -0400
In-Reply-To: <4570630.RBIQc1aA22@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Consoliate aead_alloc_tsgl, skcipher_alloc_tsgl ==> af_alg_alloc_tsgl

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c         | 37 +++++++++++++++++++++++++++++++++++++
 crypto/algif_aead.c     | 34 ++--------------------------------
 crypto/algif_skcipher.c | 34 ++--------------------------------
 include/crypto/if_alg.h |  2 ++
 4 files changed, 43 insertions(+), 64 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 92a3d540d920..87138c4b5a0f 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -507,6 +507,43 @@ void af_alg_complete(struct crypto_async_request *req, int err)
 }
 EXPORT_SYMBOL_GPL(af_alg_complete);
 
+/**
+ * af_alg_alloc_tsgl - allocate the TX SGL
+ *
+ * @sk socket of connection to user space
+ * @return: 0 upon success, < 0 upon error
+ */
+int af_alg_alloc_tsgl(struct sock *sk)
+{
+	struct alg_sock *ask = alg_sk(sk);
+	struct af_alg_ctx *ctx = ask->private;
+	struct af_alg_tsgl *sgl;
+	struct scatterlist *sg = NULL;
+
+	sgl = list_entry(ctx->tsgl_list.prev, struct af_alg_tsgl, list);
+	if (!list_empty(&ctx->tsgl_list))
+		sg = sgl->sg;
+
+	if (!sg || sgl->cur >= MAX_SGL_ENTS) {
+		sgl = sock_kmalloc(sk, sizeof(*sgl) +
+				       sizeof(sgl->sg[0]) * (MAX_SGL_ENTS + 1),
+				   GFP_KERNEL);
+		if (!sgl)
+			return -ENOMEM;
+
+		sg_init_table(sgl->sg, MAX_SGL_ENTS + 1);
+		sgl->cur = 0;
+
+		if (sg)
+			sg_chain(sg, MAX_SGL_ENTS + 1, sgl->sg);
+
+		list_add_tail(&sgl->list, &ctx->tsgl_list);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(af_alg_alloc_tsgl);
+
 static int __init af_alg_init(void)
 {
 	int err = proto_register(&alg_proto, 0);
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index cdcf186296bd..a722df95e55c 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -64,36 +64,6 @@ static inline bool aead_sufficient_data(struct sock *sk)
 	return ctx->used >= ctx->aead_assoclen + (ctx->enc ? 0 : as);
 }
 
-static int aead_alloc_tsgl(struct sock *sk)
-{
-	struct alg_sock *ask = alg_sk(sk);
-	struct af_alg_ctx *ctx = ask->private;
-	struct af_alg_tsgl *sgl;
-	struct scatterlist *sg = NULL;
-
-	sgl = list_entry(ctx->tsgl_list.prev, struct af_alg_tsgl, list);
-	if (!list_empty(&ctx->tsgl_list))
-		sg = sgl->sg;
-
-	if (!sg || sgl->cur >= MAX_SGL_ENTS) {
-		sgl = sock_kmalloc(sk, sizeof(*sgl) +
-				       sizeof(sgl->sg[0]) * (MAX_SGL_ENTS + 1),
-				   GFP_KERNEL);
-		if (!sgl)
-			return -ENOMEM;
-
-		sg_init_table(sgl->sg, MAX_SGL_ENTS + 1);
-		sgl->cur = 0;
-
-		if (sg)
-			sg_chain(sg, MAX_SGL_ENTS + 1, sgl->sg);
-
-		list_add_tail(&sgl->list, &ctx->tsgl_list);
-	}
-
-	return 0;
-}
-
 /**
  * Count number of SG entries from the beginning of the SGL to @bytes. If
  * an offset is provided, the counting of the SG entries starts at the offset.
@@ -422,7 +392,7 @@ static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 		/* allocate a new page */
 		len = min_t(unsigned long, size, af_alg_sndbuf(sk));
 
-		err = aead_alloc_tsgl(sk);
+		err = af_alg_alloc_tsgl(sk);
 		if (err)
 			goto unlock;
 
@@ -501,7 +471,7 @@ static ssize_t aead_sendpage(struct socket *sock, struct page *page,
 			goto unlock;
 	}
 
-	err = aead_alloc_tsgl(sk);
+	err = af_alg_alloc_tsgl(sk);
 	if (err)
 		goto unlock;
 
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 081df927fb8b..d511f665a190 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -44,36 +44,6 @@ struct skcipher_tfm {
 	bool has_key;
 };
 
-static int skcipher_alloc_tsgl(struct sock *sk)
-{
-	struct alg_sock *ask = alg_sk(sk);
-	struct af_alg_ctx *ctx = ask->private;
-	struct af_alg_tsgl *sgl;
-	struct scatterlist *sg = NULL;
-
-	sgl = list_entry(ctx->tsgl_list.prev, struct af_alg_tsgl, list);
-	if (!list_empty(&ctx->tsgl_list))
-		sg = sgl->sg;
-
-	if (!sg || sgl->cur >= MAX_SGL_ENTS) {
-		sgl = sock_kmalloc(sk, sizeof(*sgl) +
-				       sizeof(sgl->sg[0]) * (MAX_SGL_ENTS + 1),
-				   GFP_KERNEL);
-		if (!sgl)
-			return -ENOMEM;
-
-		sg_init_table(sgl->sg, MAX_SGL_ENTS + 1);
-		sgl->cur = 0;
-
-		if (sg)
-			sg_chain(sg, MAX_SGL_ENTS + 1, sgl->sg);
-
-		list_add_tail(&sgl->list, &ctx->tsgl_list);
-	}
-
-	return 0;
-}
-
 static unsigned int skcipher_count_tsgl(struct sock *sk, size_t bytes)
 {
 	struct alg_sock *ask = alg_sk(sk);
@@ -361,7 +331,7 @@ static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg,
 
 		len = min_t(unsigned long, len, af_alg_sndbuf(sk));
 
-		err = skcipher_alloc_tsgl(sk);
+		err = af_alg_alloc_tsgl(sk);
 		if (err)
 			goto unlock;
 
@@ -437,7 +407,7 @@ static ssize_t skcipher_sendpage(struct socket *sock, struct page *page,
 			goto unlock;
 	}
 
-	err = skcipher_alloc_tsgl(sk);
+	err = af_alg_alloc_tsgl(sk);
 	if (err)
 		goto unlock;
 
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index e1ac57c32d85..cfebf65303c7 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -240,4 +240,6 @@ static inline bool af_alg_readable(struct sock *sk)
 	return PAGE_SIZE <= af_alg_rcvbuf(sk);
 }
 
+int af_alg_alloc_tsgl(struct sock *sk);
+
 #endif	/* _CRYPTO_IF_ALG_H */
-- 
2.13.3
