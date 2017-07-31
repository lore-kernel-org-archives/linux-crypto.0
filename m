From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 02/16] crypto: AF_ALG - consolidation of context data  structure
Date: Mon, 31 Jul 2017 14:06:02 +0200
Message-ID: <2011469.z9KrvLVHZl@positron.chronox.de>
References: <4570630.RBIQc1aA22@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60882 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752197AbdGaMLi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2017 08:11:38 -0400
In-Reply-To: <4570630.RBIQc1aA22@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Consolidate skcipher_ctx, aead_ctx ==> af_alg_ctx

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_aead.c     | 48 +++++++++++++++---------------------------------
 crypto/algif_skcipher.c | 45 ++++++++++++++-------------------------------
 include/crypto/if_alg.h | 41 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+), 64 deletions(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 42f69a4f87d5..adbf87a0eeee 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -47,28 +47,10 @@ struct aead_tfm {
 	struct crypto_skcipher *null_tfm;
 };
 
-struct aead_ctx {
-	struct list_head tsgl_list;	/* Link to TX SGL */
-
-	void *iv;
-	size_t aead_assoclen;
-
-	struct af_alg_completion completion;	/* sync work queue */
-
-	size_t used;		/* TX bytes sent to kernel */
-	size_t rcvused;		/* total RX bytes to be processed by kernel */
-
-	bool more;		/* More data to be expected? */
-	bool merge;		/* Merge new data into existing SG */
-	bool enc;		/* Crypto operation: enc, dec */
-
-	unsigned int len;	/* Length of allocated memory for this struct */
-};
-
 static inline int aead_sndbuf(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
-	struct aead_ctx *ctx = ask->private;
+	struct af_alg_ctx *ctx = ask->private;
 
 	return max_t(int, max_t(int, sk->sk_sndbuf & PAGE_MASK, PAGE_SIZE) -
 			  ctx->used, 0);
@@ -82,7 +64,7 @@ static inline bool aead_writable(struct sock *sk)
 static inline int aead_rcvbuf(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
-	struct aead_ctx *ctx = ask->private;
+	struct af_alg_ctx *ctx = ask->private;
 
 	return max_t(int, max_t(int, sk->sk_rcvbuf & PAGE_MASK, PAGE_SIZE) -
 			  ctx->rcvused, 0);
@@ -98,7 +80,7 @@ static inline bool aead_sufficient_data(struct sock *sk)
 	struct alg_sock *ask = alg_sk(sk);
 	struct sock *psk = ask->parent;
 	struct alg_sock *pask = alg_sk(psk);
-	struct aead_ctx *ctx = ask->private;
+	struct af_alg_ctx *ctx = ask->private;
 	struct aead_tfm *aeadc = pask->private;
 	struct crypto_aead *tfm = aeadc->aead;
 	unsigned int as = crypto_aead_authsize(tfm);
@@ -113,7 +95,7 @@ static inline bool aead_sufficient_data(struct sock *sk)
 static int aead_alloc_tsgl(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
-	struct aead_ctx *ctx = ask->private;
+	struct af_alg_ctx *ctx = ask->private;
 	struct af_alg_tsgl *sgl;
 	struct scatterlist *sg = NULL;
 
@@ -148,7 +130,7 @@ static unsigned int aead_count_tsgl(struct sock *sk, size_t bytes,
 				    size_t offset)
 {
 	struct alg_sock *ask = alg_sk(sk);
-	struct aead_ctx *ctx = ask->private;
+	struct af_alg_ctx *ctx = ask->private;
 	struct af_alg_tsgl *sgl, *tmp;
 	unsigned int i;
 	unsigned int sgl_count = 0;
@@ -198,7 +180,7 @@ static void aead_pull_tsgl(struct sock *sk, size_t used,
 			   struct scatterlist *dst, size_t dst_offset)
 {
 	struct alg_sock *ask = alg_sk(sk);
-	struct aead_ctx *ctx = ask->private;
+	struct af_alg_ctx *ctx = ask->private;
 	struct af_alg_tsgl *sgl;
 	struct scatterlist *sg;
 	unsigned int i, j;
@@ -262,7 +244,7 @@ static void aead_free_areq_sgls(struct af_alg_async_req *areq)
 {
 	struct sock *sk = areq->sk;
 	struct alg_sock *ask = alg_sk(sk);
-	struct aead_ctx *ctx = ask->private;
+	struct af_alg_ctx *ctx = ask->private;
 	struct af_alg_rsgl *rsgl, *tmp;
 	struct scatterlist *tsgl;
 	struct scatterlist *sg;
@@ -334,7 +316,7 @@ static int aead_wait_for_data(struct sock *sk, unsigned flags)
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	struct alg_sock *ask = alg_sk(sk);
-	struct aead_ctx *ctx = ask->private;
+	struct af_alg_ctx *ctx = ask->private;
 	long timeout;
 	int err = -ERESTARTSYS;
 
@@ -363,7 +345,7 @@ static int aead_wait_for_data(struct sock *sk, unsigned flags)
 static void aead_data_wakeup(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
-	struct aead_ctx *ctx = ask->private;
+	struct af_alg_ctx *ctx = ask->private;
 	struct socket_wq *wq;
 
 	if (!ctx->used)
@@ -385,7 +367,7 @@ static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	struct alg_sock *ask = alg_sk(sk);
 	struct sock *psk = ask->parent;
 	struct alg_sock *pask = alg_sk(psk);
-	struct aead_ctx *ctx = ask->private;
+	struct af_alg_ctx *ctx = ask->private;
 	struct aead_tfm *aeadc = pask->private;
 	struct crypto_aead *tfm = aeadc->aead;
 	unsigned int ivsize = crypto_aead_ivsize(tfm);
@@ -527,7 +509,7 @@ static ssize_t aead_sendpage(struct socket *sock, struct page *page,
 {
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
-	struct aead_ctx *ctx = ask->private;
+	struct af_alg_ctx *ctx = ask->private;
 	struct af_alg_tsgl *sgl;
 	int err = -EINVAL;
 
@@ -617,7 +599,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	struct alg_sock *ask = alg_sk(sk);
 	struct sock *psk = ask->parent;
 	struct alg_sock *pask = alg_sk(psk);
-	struct aead_ctx *ctx = ask->private;
+	struct af_alg_ctx *ctx = ask->private;
 	struct aead_tfm *aeadc = pask->private;
 	struct crypto_aead *tfm = aeadc->aead;
 	struct crypto_skcipher *null_tfm = aeadc->null_tfm;
@@ -910,7 +892,7 @@ static unsigned int aead_poll(struct file *file, struct socket *sock,
 {
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
-	struct aead_ctx *ctx = ask->private;
+	struct af_alg_ctx *ctx = ask->private;
 	unsigned int mask;
 
 	sock_poll_wait(file, sk_sleep(sk), wait);
@@ -1101,7 +1083,7 @@ static int aead_setkey(void *private, const u8 *key, unsigned int keylen)
 static void aead_sock_destruct(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
-	struct aead_ctx *ctx = ask->private;
+	struct af_alg_ctx *ctx = ask->private;
 	struct sock *psk = ask->parent;
 	struct alg_sock *pask = alg_sk(psk);
 	struct aead_tfm *aeadc = pask->private;
@@ -1117,7 +1099,7 @@ static void aead_sock_destruct(struct sock *sk)
 
 static int aead_accept_parent_nokey(void *private, struct sock *sk)
 {
-	struct aead_ctx *ctx;
+	struct af_alg_ctx *ctx;
 	struct alg_sock *ask = alg_sk(sk);
 	struct aead_tfm *tfm = private;
 	struct crypto_aead *aead = tfm->aead;
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 844d4cfce371..0256959b0925 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -44,27 +44,10 @@ struct skcipher_tfm {
 	bool has_key;
 };
 
-struct skcipher_ctx {
-	struct list_head tsgl_list;
-
-	void *iv;
-
-	struct af_alg_completion completion;
-
-	size_t used;
-	size_t rcvused;
-
-	bool more;
-	bool merge;
-	bool enc;
-
-	unsigned int len;
-};
-
 static inline int skcipher_sndbuf(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
-	struct skcipher_ctx *ctx = ask->private;
+	struct af_alg_ctx *ctx = ask->private;
 
 	return max_t(int, max_t(int, sk->sk_sndbuf & PAGE_MASK, PAGE_SIZE) -
 			  ctx->used, 0);
@@ -78,7 +61,7 @@ static inline bool skcipher_writable(struct sock *sk)
 static inline int skcipher_rcvbuf(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
-	struct skcipher_ctx *ctx = ask->private;
+	struct af_alg_ctx *ctx = ask->private;
 
 	return max_t(int, max_t(int, sk->sk_rcvbuf & PAGE_MASK, PAGE_SIZE) -
 			  ctx->rcvused, 0);
@@ -92,7 +75,7 @@ static inline bool skcipher_readable(struct sock *sk)
 static int skcipher_alloc_tsgl(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
-	struct skcipher_ctx *ctx = ask->private;
+	struct af_alg_ctx *ctx = ask->private;
 	struct af_alg_tsgl *sgl;
 	struct scatterlist *sg = NULL;
 
@@ -122,7 +105,7 @@ static int skcipher_alloc_tsgl(struct sock *sk)
 static unsigned int skcipher_count_tsgl(struct sock *sk, size_t bytes)
 {
 	struct alg_sock *ask = alg_sk(sk);
-	struct skcipher_ctx *ctx = ask->private;
+	struct af_alg_ctx *ctx = ask->private;
 	struct af_alg_tsgl *sgl, *tmp;
 	unsigned int i;
 	unsigned int sgl_count = 0;
@@ -149,7 +132,7 @@ static void skcipher_pull_tsgl(struct sock *sk, size_t used,
 			       struct scatterlist *dst)
 {
 	struct alg_sock *ask = alg_sk(sk);
-	struct skcipher_ctx *ctx = ask->private;
+	struct af_alg_ctx *ctx = ask->private;
 	struct af_alg_tsgl *sgl;
 	struct scatterlist *sg;
 	unsigned int i;
@@ -200,7 +183,7 @@ static void skcipher_free_areq_sgls(struct af_alg_async_req *areq)
 {
 	struct sock *sk = areq->sk;
 	struct alg_sock *ask = alg_sk(sk);
-	struct skcipher_ctx *ctx = ask->private;
+	struct af_alg_ctx *ctx = ask->private;
 	struct af_alg_rsgl *rsgl, *tmp;
 	struct scatterlist *tsgl;
 	struct scatterlist *sg;
@@ -272,7 +255,7 @@ static int skcipher_wait_for_data(struct sock *sk, unsigned flags)
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	struct alg_sock *ask = alg_sk(sk);
-	struct skcipher_ctx *ctx = ask->private;
+	struct af_alg_ctx *ctx = ask->private;
 	long timeout;
 	int err = -ERESTARTSYS;
 
@@ -302,7 +285,7 @@ static int skcipher_wait_for_data(struct sock *sk, unsigned flags)
 static void skcipher_data_wakeup(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
-	struct skcipher_ctx *ctx = ask->private;
+	struct af_alg_ctx *ctx = ask->private;
 	struct socket_wq *wq;
 
 	if (!ctx->used)
@@ -325,7 +308,7 @@ static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg,
 	struct alg_sock *ask = alg_sk(sk);
 	struct sock *psk = ask->parent;
 	struct alg_sock *pask = alg_sk(psk);
-	struct skcipher_ctx *ctx = ask->private;
+	struct af_alg_ctx *ctx = ask->private;
 	struct skcipher_tfm *skc = pask->private;
 	struct crypto_skcipher *tfm = skc->skcipher;
 	unsigned ivsize = crypto_skcipher_ivsize(tfm);
@@ -462,7 +445,7 @@ static ssize_t skcipher_sendpage(struct socket *sock, struct page *page,
 {
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
-	struct skcipher_ctx *ctx = ask->private;
+	struct af_alg_ctx *ctx = ask->private;
 	struct af_alg_tsgl *sgl;
 	int err = -EINVAL;
 
@@ -536,7 +519,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	struct alg_sock *ask = alg_sk(sk);
 	struct sock *psk = ask->parent;
 	struct alg_sock *pask = alg_sk(psk);
-	struct skcipher_ctx *ctx = ask->private;
+	struct af_alg_ctx *ctx = ask->private;
 	struct skcipher_tfm *skc = pask->private;
 	struct crypto_skcipher *tfm = skc->skcipher;
 	unsigned int bs = crypto_skcipher_blocksize(tfm);
@@ -709,7 +692,7 @@ static unsigned int skcipher_poll(struct file *file, struct socket *sock,
 {
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
-	struct skcipher_ctx *ctx = ask->private;
+	struct af_alg_ctx *ctx = ask->private;
 	unsigned int mask;
 
 	sock_poll_wait(file, sk_sleep(sk), wait);
@@ -884,7 +867,7 @@ static int skcipher_setkey(void *private, const u8 *key, unsigned int keylen)
 static void skcipher_sock_destruct(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
-	struct skcipher_ctx *ctx = ask->private;
+	struct af_alg_ctx *ctx = ask->private;
 	struct sock *psk = ask->parent;
 	struct alg_sock *pask = alg_sk(psk);
 	struct skcipher_tfm *skc = pask->private;
@@ -898,7 +881,7 @@ static void skcipher_sock_destruct(struct sock *sk)
 
 static int skcipher_accept_parent_nokey(void *private, struct sock *sk)
 {
-	struct skcipher_ctx *ctx;
+	struct af_alg_ctx *ctx;
 	struct alg_sock *ask = alg_sk(sk);
 	struct skcipher_tfm *tfm = private;
 	struct crypto_skcipher *skcipher = tfm->skcipher;
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 66b14b8d067a..b3ab34ff9d35 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -121,6 +121,47 @@ struct af_alg_async_req {
 	/* req ctx trails this struct */
 };
 
+/**
+ * struct af_alg_ctx - definition of the crypto context
+ *
+ * The crypto context tracks the input data during the lifetime of an AF_ALG
+ * socket.
+ *
+ * @tsgl_list:		Link to TX SGL
+ * @iv:			IV for cipher operation
+ * @aead_assoclen:	Length of AAD for AEAD cipher operations
+ * @completion:		Work queue for synchronous operation
+ * @used:		TX bytes sent to kernel. This variable is used to
+ *			ensure that user space cannot cause the kernel
+ *			to allocate too much memory in sendmsg operation.
+ * @rcvused:		Total RX bytes to be filled by kernel. This variable
+ *			is used to ensure user space cannot cause the kernel
+ *			to allocate too much memory in a recvmsg operation.
+ * @more:		More data to be expected from user space?
+ * @merge:		Shall new data from user space be merged into existing
+ *			SG?
+ * @enc:		Cryptographic operation to be performed when
+ *			recvmsg is invoked.
+ * @len:		Length of memory allocated for this data structure.
+ */
+struct af_alg_ctx {
+	struct list_head tsgl_list;
+
+	void *iv;
+	size_t aead_assoclen;
+
+	struct af_alg_completion completion;
+
+	size_t used;
+	size_t rcvused;
+
+	bool more;
+	bool merge;
+	bool enc;
+
+	unsigned int len;
+};
+
 int af_alg_register_type(const struct af_alg_type *type);
 int af_alg_unregister_type(const struct af_alg_type *type);
 
-- 
2.13.3
