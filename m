From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 01/16] crypto: AF_ALG - consolidation of common data  structures
Date: Mon, 31 Jul 2017 14:05:45 +0200
Message-ID: <6423471.q6cUR4juoa@positron.chronox.de>
References: <4570630.RBIQc1aA22@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60866 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752138AbdGaMLk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2017 08:11:40 -0400
In-Reply-To: <4570630.RBIQc1aA22@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Consolidate following data structures:

- skcipher_async_req, aead_async_req -> af_alg_async_req

- skcipher_rsgl, aead_rsql -> af_alg_rsgl

- skcipher_tsgl, aead_tsql -> af_alg_tsgl

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_aead.c     | 89 ++++++++++++++++---------------------------------
 crypto/algif_skcipher.c | 88 +++++++++++++++++-------------------------------
 include/crypto/if_alg.h | 53 +++++++++++++++++++++++++++++
 3 files changed, 112 insertions(+), 118 deletions(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 1f0696dd64f4..42f69a4f87d5 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -41,34 +41,6 @@
 #include <linux/net.h>
 #include <net/sock.h>
 
-struct aead_tsgl {
-	struct list_head list;
-	unsigned int cur;		/* Last processed SG entry */
-	struct scatterlist sg[0];	/* Array of SGs forming the SGL */
-};
-
-struct aead_rsgl {
-	struct af_alg_sgl sgl;
-	struct list_head list;
-	size_t sg_num_bytes;		/* Bytes of data in that SGL */
-};
-
-struct aead_async_req {
-	struct kiocb *iocb;
-	struct sock *sk;
-
-	struct aead_rsgl first_rsgl;	/* First RX SG */
-	struct list_head rsgl_list;	/* Track RX SGs */
-
-	struct scatterlist *tsgl;	/* priv. TX SGL of buffers to process */
-	unsigned int tsgl_entries;	/* number of entries in priv. TX SGL */
-
-	unsigned int outlen;		/* Filled output buf length */
-
-	unsigned int areqlen;		/* Length of this data struct */
-	struct aead_request aead_req;	/* req ctx trails this struct */
-};
-
 struct aead_tfm {
 	struct crypto_aead *aead;
 	bool has_key;
@@ -93,9 +65,6 @@ struct aead_ctx {
 	unsigned int len;	/* Length of allocated memory for this struct */
 };
 
-#define MAX_SGL_ENTS ((4096 - sizeof(struct aead_tsgl)) / \
-		      sizeof(struct scatterlist) - 1)
-
 static inline int aead_sndbuf(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
@@ -145,10 +114,10 @@ static int aead_alloc_tsgl(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct aead_ctx *ctx = ask->private;
-	struct aead_tsgl *sgl;
+	struct af_alg_tsgl *sgl;
 	struct scatterlist *sg = NULL;
 
-	sgl = list_entry(ctx->tsgl_list.prev, struct aead_tsgl, list);
+	sgl = list_entry(ctx->tsgl_list.prev, struct af_alg_tsgl, list);
 	if (!list_empty(&ctx->tsgl_list))
 		sg = sgl->sg;
 
@@ -180,7 +149,7 @@ static unsigned int aead_count_tsgl(struct sock *sk, size_t bytes,
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct aead_ctx *ctx = ask->private;
-	struct aead_tsgl *sgl, *tmp;
+	struct af_alg_tsgl *sgl, *tmp;
 	unsigned int i;
 	unsigned int sgl_count = 0;
 
@@ -230,12 +199,12 @@ static void aead_pull_tsgl(struct sock *sk, size_t used,
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct aead_ctx *ctx = ask->private;
-	struct aead_tsgl *sgl;
+	struct af_alg_tsgl *sgl;
 	struct scatterlist *sg;
 	unsigned int i, j;
 
 	while (!list_empty(&ctx->tsgl_list)) {
-		sgl = list_first_entry(&ctx->tsgl_list, struct aead_tsgl,
+		sgl = list_first_entry(&ctx->tsgl_list, struct af_alg_tsgl,
 				       list);
 		sg = sgl->sg;
 
@@ -289,12 +258,12 @@ static void aead_pull_tsgl(struct sock *sk, size_t used,
 		ctx->merge = 0;
 }
 
-static void aead_free_areq_sgls(struct aead_async_req *areq)
+static void aead_free_areq_sgls(struct af_alg_async_req *areq)
 {
 	struct sock *sk = areq->sk;
 	struct alg_sock *ask = alg_sk(sk);
 	struct aead_ctx *ctx = ask->private;
-	struct aead_rsgl *rsgl, *tmp;
+	struct af_alg_rsgl *rsgl, *tmp;
 	struct scatterlist *tsgl;
 	struct scatterlist *sg;
 	unsigned int i;
@@ -420,7 +389,7 @@ static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	struct aead_tfm *aeadc = pask->private;
 	struct crypto_aead *tfm = aeadc->aead;
 	unsigned int ivsize = crypto_aead_ivsize(tfm);
-	struct aead_tsgl *sgl;
+	struct af_alg_tsgl *sgl;
 	struct af_alg_control con = {};
 	long copied = 0;
 	bool enc = 0;
@@ -470,7 +439,7 @@ static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 		/* use the existing memory in an allocated page */
 		if (ctx->merge) {
 			sgl = list_entry(ctx->tsgl_list.prev,
-					 struct aead_tsgl, list);
+					 struct af_alg_tsgl, list);
 			sg = sgl->sg + sgl->cur - 1;
 			len = min_t(unsigned long, len,
 				    PAGE_SIZE - sg->offset - sg->length);
@@ -503,7 +472,7 @@ static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 		if (err)
 			goto unlock;
 
-		sgl = list_entry(ctx->tsgl_list.prev, struct aead_tsgl,
+		sgl = list_entry(ctx->tsgl_list.prev, struct af_alg_tsgl,
 				 list);
 		sg = sgl->sg;
 		if (sgl->cur)
@@ -559,7 +528,7 @@ static ssize_t aead_sendpage(struct socket *sock, struct page *page,
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
 	struct aead_ctx *ctx = ask->private;
-	struct aead_tsgl *sgl;
+	struct af_alg_tsgl *sgl;
 	int err = -EINVAL;
 
 	if (flags & MSG_SENDPAGE_NOTLAST)
@@ -583,7 +552,7 @@ static ssize_t aead_sendpage(struct socket *sock, struct page *page,
 		goto unlock;
 
 	ctx->merge = 0;
-	sgl = list_entry(ctx->tsgl_list.prev, struct aead_tsgl, list);
+	sgl = list_entry(ctx->tsgl_list.prev, struct af_alg_tsgl, list);
 
 	if (sgl->cur)
 		sg_unmark_end(sgl->sg + sgl->cur - 1);
@@ -608,7 +577,7 @@ static ssize_t aead_sendpage(struct socket *sock, struct page *page,
 
 static void aead_async_cb(struct crypto_async_request *_req, int err)
 {
-	struct aead_async_req *areq = _req->data;
+	struct af_alg_async_req *areq = _req->data;
 	struct sock *sk = areq->sk;
 	struct kiocb *iocb = areq->iocb;
 	unsigned int resultlen;
@@ -654,10 +623,10 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	struct crypto_skcipher *null_tfm = aeadc->null_tfm;
 	unsigned int as = crypto_aead_authsize(tfm);
 	unsigned int areqlen =
-		sizeof(struct aead_async_req) + crypto_aead_reqsize(tfm);
-	struct aead_async_req *areq;
-	struct aead_rsgl *last_rsgl = NULL;
-	struct aead_tsgl *tsgl;
+		sizeof(struct af_alg_async_req) + crypto_aead_reqsize(tfm);
+	struct af_alg_async_req *areq;
+	struct af_alg_rsgl *last_rsgl = NULL;
+	struct af_alg_tsgl *tsgl;
 	struct scatterlist *src;
 	int err = 0;
 	size_t used = 0;		/* [in]  TX bufs to be en/decrypted */
@@ -714,7 +683,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 
 	/* convert iovecs of output buffers into RX SGL */
 	while (outlen > usedpages && msg_data_left(msg)) {
-		struct aead_rsgl *rsgl;
+		struct af_alg_rsgl *rsgl;
 		size_t seglen;
 
 		/* limit the amount of readable buffers */
@@ -778,7 +747,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	}
 
 	processed = used + ctx->aead_assoclen;
-	tsgl = list_first_entry(&ctx->tsgl_list, struct aead_tsgl, list);
+	tsgl = list_first_entry(&ctx->tsgl_list, struct af_alg_tsgl, list);
 
 	/*
 	 * Copy of AAD from source to destination
@@ -861,28 +830,28 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	}
 
 	/* Initialize the crypto operation */
-	aead_request_set_crypt(&areq->aead_req, src,
+	aead_request_set_crypt(&areq->cra_u.aead_req, src,
 			       areq->first_rsgl.sgl.sg, used, ctx->iv);
-	aead_request_set_ad(&areq->aead_req, ctx->aead_assoclen);
-	aead_request_set_tfm(&areq->aead_req, tfm);
+	aead_request_set_ad(&areq->cra_u.aead_req, ctx->aead_assoclen);
+	aead_request_set_tfm(&areq->cra_u.aead_req, tfm);
 
 	if (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb)) {
 		/* AIO operation */
 		areq->iocb = msg->msg_iocb;
-		aead_request_set_callback(&areq->aead_req,
+		aead_request_set_callback(&areq->cra_u.aead_req,
 					  CRYPTO_TFM_REQ_MAY_BACKLOG,
 					  aead_async_cb, areq);
-		err = ctx->enc ? crypto_aead_encrypt(&areq->aead_req) :
-				 crypto_aead_decrypt(&areq->aead_req);
+		err = ctx->enc ? crypto_aead_encrypt(&areq->cra_u.aead_req) :
+				 crypto_aead_decrypt(&areq->cra_u.aead_req);
 	} else {
 		/* Synchronous operation */
-		aead_request_set_callback(&areq->aead_req,
+		aead_request_set_callback(&areq->cra_u.aead_req,
 					  CRYPTO_TFM_REQ_MAY_BACKLOG,
 					  af_alg_complete, &ctx->completion);
 		err = af_alg_wait_for_completion(ctx->enc ?
-					 crypto_aead_encrypt(&areq->aead_req) :
-					 crypto_aead_decrypt(&areq->aead_req),
-					 &ctx->completion);
+				crypto_aead_encrypt(&areq->cra_u.aead_req) :
+				crypto_aead_decrypt(&areq->cra_u.aead_req),
+						 &ctx->completion);
 	}
 
 	/* AIO operation in progress */
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index ce3b5fba2279..844d4cfce371 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -39,32 +39,6 @@
 #include <linux/net.h>
 #include <net/sock.h>
 
-struct skcipher_tsgl {
-	struct list_head list;
-	int cur;
-	struct scatterlist sg[0];
-};
-
-struct skcipher_rsgl {
-	struct af_alg_sgl sgl;
-	struct list_head list;
-	size_t sg_num_bytes;
-};
-
-struct skcipher_async_req {
-	struct kiocb *iocb;
-	struct sock *sk;
-
-	struct skcipher_rsgl first_sgl;
-	struct list_head rsgl_list;
-
-	struct scatterlist *tsgl;
-	unsigned int tsgl_entries;
-
-	unsigned int areqlen;
-	struct skcipher_request req;
-};
-
 struct skcipher_tfm {
 	struct crypto_skcipher *skcipher;
 	bool has_key;
@@ -87,9 +61,6 @@ struct skcipher_ctx {
 	unsigned int len;
 };
 
-#define MAX_SGL_ENTS ((4096 - sizeof(struct skcipher_tsgl)) / \
-		      sizeof(struct scatterlist) - 1)
-
 static inline int skcipher_sndbuf(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
@@ -122,10 +93,10 @@ static int skcipher_alloc_tsgl(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct skcipher_ctx *ctx = ask->private;
-	struct skcipher_tsgl *sgl;
+	struct af_alg_tsgl *sgl;
 	struct scatterlist *sg = NULL;
 
-	sgl = list_entry(ctx->tsgl_list.prev, struct skcipher_tsgl, list);
+	sgl = list_entry(ctx->tsgl_list.prev, struct af_alg_tsgl, list);
 	if (!list_empty(&ctx->tsgl_list))
 		sg = sgl->sg;
 
@@ -152,7 +123,7 @@ static unsigned int skcipher_count_tsgl(struct sock *sk, size_t bytes)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct skcipher_ctx *ctx = ask->private;
-	struct skcipher_tsgl *sgl, *tmp;
+	struct af_alg_tsgl *sgl, *tmp;
 	unsigned int i;
 	unsigned int sgl_count = 0;
 
@@ -179,12 +150,12 @@ static void skcipher_pull_tsgl(struct sock *sk, size_t used,
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct skcipher_ctx *ctx = ask->private;
-	struct skcipher_tsgl *sgl;
+	struct af_alg_tsgl *sgl;
 	struct scatterlist *sg;
 	unsigned int i;
 
 	while (!list_empty(&ctx->tsgl_list)) {
-		sgl = list_first_entry(&ctx->tsgl_list, struct skcipher_tsgl,
+		sgl = list_first_entry(&ctx->tsgl_list, struct af_alg_tsgl,
 				       list);
 		sg = sgl->sg;
 
@@ -225,12 +196,12 @@ static void skcipher_pull_tsgl(struct sock *sk, size_t used,
 		ctx->merge = 0;
 }
 
-static void skcipher_free_areq_sgls(struct skcipher_async_req *areq)
+static void skcipher_free_areq_sgls(struct af_alg_async_req *areq)
 {
 	struct sock *sk = areq->sk;
 	struct alg_sock *ask = alg_sk(sk);
 	struct skcipher_ctx *ctx = ask->private;
-	struct skcipher_rsgl *rsgl, *tmp;
+	struct af_alg_rsgl *rsgl, *tmp;
 	struct scatterlist *tsgl;
 	struct scatterlist *sg;
 	unsigned int i;
@@ -239,7 +210,7 @@ static void skcipher_free_areq_sgls(struct skcipher_async_req *areq)
 		ctx->rcvused -= rsgl->sg_num_bytes;
 		af_alg_free_sg(&rsgl->sgl);
 		list_del(&rsgl->list);
-		if (rsgl != &areq->first_sgl)
+		if (rsgl != &areq->first_rsgl)
 			sock_kfree_s(sk, rsgl, sizeof(*rsgl));
 	}
 
@@ -358,7 +329,7 @@ static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg,
 	struct skcipher_tfm *skc = pask->private;
 	struct crypto_skcipher *tfm = skc->skcipher;
 	unsigned ivsize = crypto_skcipher_ivsize(tfm);
-	struct skcipher_tsgl *sgl;
+	struct af_alg_tsgl *sgl;
 	struct af_alg_control con = {};
 	long copied = 0;
 	bool enc = 0;
@@ -406,7 +377,7 @@ static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg,
 
 		if (ctx->merge) {
 			sgl = list_entry(ctx->tsgl_list.prev,
-					 struct skcipher_tsgl, list);
+					 struct af_alg_tsgl, list);
 			sg = sgl->sg + sgl->cur - 1;
 			len = min_t(unsigned long, len,
 				    PAGE_SIZE - sg->offset - sg->length);
@@ -439,7 +410,7 @@ static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg,
 		if (err)
 			goto unlock;
 
-		sgl = list_entry(ctx->tsgl_list.prev, struct skcipher_tsgl,
+		sgl = list_entry(ctx->tsgl_list.prev, struct af_alg_tsgl,
 				 list);
 		sg = sgl->sg;
 		if (sgl->cur)
@@ -492,7 +463,7 @@ static ssize_t skcipher_sendpage(struct socket *sock, struct page *page,
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
 	struct skcipher_ctx *ctx = ask->private;
-	struct skcipher_tsgl *sgl;
+	struct af_alg_tsgl *sgl;
 	int err = -EINVAL;
 
 	if (flags & MSG_SENDPAGE_NOTLAST)
@@ -516,7 +487,7 @@ static ssize_t skcipher_sendpage(struct socket *sock, struct page *page,
 		goto unlock;
 
 	ctx->merge = 0;
-	sgl = list_entry(ctx->tsgl_list.prev, struct skcipher_tsgl, list);
+	sgl = list_entry(ctx->tsgl_list.prev, struct af_alg_tsgl, list);
 
 	if (sgl->cur)
 		sg_unmark_end(sgl->sg + sgl->cur - 1);
@@ -539,7 +510,7 @@ static ssize_t skcipher_sendpage(struct socket *sock, struct page *page,
 
 static void skcipher_async_cb(struct crypto_async_request *req, int err)
 {
-	struct skcipher_async_req *areq = req->data;
+	struct af_alg_async_req *areq = req->data;
 	struct sock *sk = areq->sk;
 	struct kiocb *iocb = areq->iocb;
 	unsigned int resultlen;
@@ -547,7 +518,7 @@ static void skcipher_async_cb(struct crypto_async_request *req, int err)
 	lock_sock(sk);
 
 	/* Buffer size written by crypto operation. */
-	resultlen = areq->req.cryptlen;
+	resultlen = areq->cra_u.skcipher_req.cryptlen;
 
 	skcipher_free_areq_sgls(areq);
 	sock_kfree_s(sk, areq, areq->areqlen);
@@ -569,10 +540,10 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	struct skcipher_tfm *skc = pask->private;
 	struct crypto_skcipher *tfm = skc->skcipher;
 	unsigned int bs = crypto_skcipher_blocksize(tfm);
-	unsigned int areqlen = sizeof(struct skcipher_async_req) +
+	unsigned int areqlen = sizeof(struct af_alg_async_req) +
 			       crypto_skcipher_reqsize(tfm);
-	struct skcipher_async_req *areq;
-	struct skcipher_rsgl *last_rsgl = NULL;
+	struct af_alg_async_req *areq;
+	struct af_alg_rsgl *last_rsgl = NULL;
 	int err = 0;
 	size_t len = 0;
 
@@ -588,7 +559,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 
 	/* convert iovecs of output buffers into RX SGL */
 	while (msg_data_left(msg)) {
-		struct skcipher_rsgl *rsgl;
+		struct af_alg_rsgl *rsgl;
 		size_t seglen;
 
 		/* limit the amount of readable buffers */
@@ -604,7 +575,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 		seglen = min_t(size_t, ctx->used, msg_data_left(msg));
 
 		if (list_empty(&areq->rsgl_list)) {
-			rsgl = &areq->first_sgl;
+			rsgl = &areq->first_rsgl;
 		} else {
 			rsgl = sock_kmalloc(sk, sizeof(*rsgl), GFP_KERNEL);
 			if (!rsgl) {
@@ -660,28 +631,29 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	skcipher_pull_tsgl(sk, len, areq->tsgl);
 
 	/* Initialize the crypto operation */
-	skcipher_request_set_tfm(&areq->req, tfm);
-	skcipher_request_set_crypt(&areq->req, areq->tsgl,
-				   areq->first_sgl.sgl.sg, len, ctx->iv);
+	skcipher_request_set_tfm(&areq->cra_u.skcipher_req, tfm);
+	skcipher_request_set_crypt(&areq->cra_u.skcipher_req, areq->tsgl,
+				   areq->first_rsgl.sgl.sg, len, ctx->iv);
 
 	if (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb)) {
 		/* AIO operation */
 		areq->iocb = msg->msg_iocb;
-		skcipher_request_set_callback(&areq->req,
+		skcipher_request_set_callback(&areq->cra_u.skcipher_req,
 					      CRYPTO_TFM_REQ_MAY_SLEEP,
 					      skcipher_async_cb, areq);
-		err = ctx->enc ? crypto_skcipher_encrypt(&areq->req) :
-				 crypto_skcipher_decrypt(&areq->req);
+		err = ctx->enc ?
+			crypto_skcipher_encrypt(&areq->cra_u.skcipher_req) :
+			crypto_skcipher_decrypt(&areq->cra_u.skcipher_req);
 	} else {
 		/* Synchronous operation */
-		skcipher_request_set_callback(&areq->req,
+		skcipher_request_set_callback(&areq->cra_u.skcipher_req,
 					      CRYPTO_TFM_REQ_MAY_SLEEP |
 					      CRYPTO_TFM_REQ_MAY_BACKLOG,
 					      af_alg_complete,
 					      &ctx->completion);
 		err = af_alg_wait_for_completion(ctx->enc ?
-					crypto_skcipher_encrypt(&areq->req) :
-					crypto_skcipher_decrypt(&areq->req),
+			crypto_skcipher_encrypt(&areq->cra_u.skcipher_req) :
+			crypto_skcipher_decrypt(&areq->cra_u.skcipher_req),
 						 &ctx->completion);
 	}
 
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index e2b9c6fe2714..66b14b8d067a 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -20,6 +20,9 @@
 #include <linux/types.h>
 #include <net/sock.h>
 
+#include <crypto/aead.h>
+#include <crypto/skcipher.h>
+
 #define ALG_MAX_PAGES			16
 
 struct crypto_async_request;
@@ -68,6 +71,56 @@ struct af_alg_sgl {
 	unsigned int npages;
 };
 
+/* TX SGL entry */
+struct af_alg_tsgl {
+	struct list_head list;
+	unsigned int cur;		/* Last processed SG entry */
+	struct scatterlist sg[0];	/* Array of SGs forming the SGL */
+};
+
+#define MAX_SGL_ENTS ((4096 - sizeof(struct af_alg_tsgl)) / \
+		      sizeof(struct scatterlist) - 1)
+
+/* RX SGL entry */
+struct af_alg_rsgl {
+	struct af_alg_sgl sgl;
+	struct list_head list;
+	size_t sg_num_bytes;		/* Bytes of data in that SGL */
+};
+
+/**
+ * struct af_alg_async_req - definition of crypto request
+ * @iocb:		IOCB for AIO operations
+ * @sk:			Socket the request is associated with
+ * @first_rsgl:		First RX SG
+ * @rsgl_list:		Track RX SGs
+ * @tsgl:		Private, per request TX SGL of buffers to process
+ * @tsgl_entries:	Number of entries in priv. TX SGL
+ * @outlen:		Number of output bytes generated by crypto op
+ * @areqlen:		Length of this data structure
+ * @cra_u:		Cipher request
+ */
+struct af_alg_async_req {
+	struct kiocb *iocb;
+	struct sock *sk;
+
+	struct af_alg_rsgl first_rsgl;
+	struct list_head rsgl_list;
+
+	struct scatterlist *tsgl;
+	unsigned int tsgl_entries;
+
+	unsigned int outlen;
+	unsigned int areqlen;
+
+	union {
+		struct aead_request aead_req;
+		struct skcipher_request skcipher_req;
+	} cra_u;
+
+	/* req ctx trails this struct */
+};
+
 int af_alg_register_type(const struct af_alg_type *type);
 int af_alg_unregister_type(const struct af_alg_type *type);
 
-- 
2.13.3
