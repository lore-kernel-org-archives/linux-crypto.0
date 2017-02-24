From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [RFC] how to handle AAD copy operation for algif_aead
Date: Fri, 24 Feb 2017 14:24:47 +0100
Message-ID: <13406914.zeok8basum@positron.chronox.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1959844.g3mofz8j4i"
Content-Transfer-Encoding: 7Bit
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59780 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751208AbdBXNYz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Feb 2017 08:24:55 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.

--nextPart1959844.g3mofz8j4i
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Herbert et al,

attached are two patches where each patch has a different approach to copy the 
AAD in the algif_aead operation. I would like to hear your opinion which 
approach should be taken.

The patch 0001-crypto-algif_aead-copy-AAD-from-src-to-dst_separate.patch 
simply copies the AAD over from TX SGL to RX SGL. The pro is that the patch is 
small. The con is that this approach does *not* provide an in-place crypto 
operation.

The patch 0001-crypto-algif_aead-copy-AAD-from-src-to-dst_inplace.patch copies 
the AAD and the PT/CT from TX SGL into the RX SGL. In addition, this patch 
chains the SGL with the tag value part present in the TX SGL to the RX SGL in 
case of decryption. This implies that we have an in-place cipher operation 
operating in the RX SGL. Though, the patch is significantly larger.

(note: the patches are NOT meant for inclusion, but only for discussion -- yet 
both code parts are fully tested with by test framework in libkcapi).

Ciao
Stephan
--nextPart1959844.g3mofz8j4i
Content-Disposition: attachment; filename="0001-crypto-algif_aead-copy-AAD-from-src-to-dst_inplace.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="0001-crypto-algif_aead-copy-AAD-from-src-to-dst_inplace.patch"

>From 2135854799e3c8b2b6ea395941a21a6ab6b72823 Mon Sep 17 00:00:00 2001
From: Stephan Mueller <smueller@chronox.de>
Date: Fri, 24 Feb 2017 14:09:47 +0100
Subject: [PATCH] crypto: algif_aead - copy AAD from src to dst

Use the NULL cipher to copy the AAD and PT/CT from the TX SGL
to the RX SGL. This allows an in-place crypto operation on the
RX SGL for encryption, because the TX data is always smaller or
equal to the RX data (the RX data will hold the tag).

For decryption, a per-request TX SGL is created which will only hold
the tag value. As the RX SGL will have no space for the tag value and
an in-place operation will not write the tag buffer, the TX SGL with the
tag value is chained to the RX SGL. This now allows an in-place
crypto operation.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig      |   2 +
 crypto/algif_aead.c | 106 ++++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 88 insertions(+), 20 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 5a51b87..bfa531d 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1735,6 +1735,8 @@ config CRYPTO_USER_API_AEAD
 	tristate "User-space interface for AEAD cipher algorithms"
 	depends on NET
 	select CRYPTO_AEAD
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_NULL
 	select CRYPTO_USER_API
 	help
 	  This option enables the user-spaces interface for AEAD
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 050a866..cdf7c10 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -30,6 +30,8 @@
 #include <crypto/internal/aead.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/if_alg.h>
+#include <crypto/skcipher.h>
+#include <crypto/null.h>
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/kernel.h>
@@ -82,6 +84,7 @@ struct aead_ctx {
 
 	unsigned int len;	/* Length of allocated memory for this struct */
 	struct crypto_aead *aead_tfm;
+	struct crypto_skcipher *null;
 };
 
 static DECLARE_WAIT_QUEUE_HEAD(aead_aio_finish_wait);
@@ -171,7 +174,7 @@ static unsigned int aead_count_tsgl(struct sock *sk, size_t bytes)
 }
 
 static void aead_pull_tsgl(struct sock *sk, size_t used,
-			   struct scatterlist *dst)
+			   struct scatterlist *dst, size_t dst_offset)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct aead_ctx *ctx = ask->private;
@@ -195,8 +198,16 @@ static void aead_pull_tsgl(struct sock *sk, size_t used,
 			 * Assumption: caller created aead_count_tsgl(len)
 			 * SG entries in dst.
 			 */
-			if (dst)
-				sg_set_page(dst + i, page, plen, sg[i].offset);
+			if (dst) {
+				if (dst_offset > plen)
+					dst_offset -= plen;
+				else {
+					sg_set_page(dst + i, page,
+						    plen - dst_offset,
+						    sg[i].offset + dst_offset);
+					dst_offset = 0;
+				}
+			}
 
 			sg[i].length -= plen;
 			sg[i].offset += plen;
@@ -207,7 +218,7 @@ static void aead_pull_tsgl(struct sock *sk, size_t used,
 			if (sg[i].length)
 				return;
 
-			if (!dst)
+			if (!dst || dst_offset)
 				put_page(page);
 			sg_assign_page(sg + i, NULL);
 		}
@@ -559,6 +570,20 @@ static void aead_async_cb(struct crypto_async_request *_req, int err)
 	wake_up_interruptible(&aead_aio_finish_wait);
 }
 
+static int crypto_aead_copy_sgl(struct crypto_skcipher *null,
+				struct scatterlist *src,
+				struct scatterlist *dst, unsigned int len)
+{
+	SKCIPHER_REQUEST_ON_STACK(skreq, null);
+
+	skcipher_request_set_tfm(skreq, null);
+	skcipher_request_set_callback(skreq, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				      NULL, NULL);
+	skcipher_request_set_crypt(skreq, src, dst, len, NULL);
+
+	return crypto_skcipher_encrypt(skreq);
+}
+
 static int aead_recvmsg(struct socket *sock, struct msghdr *msg, size_t ignored,
 			int flags)
 {
@@ -571,6 +596,7 @@ static int aead_recvmsg(struct socket *sock, struct msghdr *msg, size_t ignored,
 		sizeof(struct aead_async_req) + crypto_aead_reqsize(tfm);
 	struct aead_async_req *areq;
 	struct aead_rsgl *last_rsgl = NULL;
+	struct aead_tsgl *tsgl;
 	int err = -EINVAL;
 	size_t used = 0;		/* [in]  TX bufs to be en/decrypted */
 	size_t outlen = 0;		/* [out] RX bufs produced by kernel */
@@ -687,25 +713,55 @@ static int aead_recvmsg(struct socket *sock, struct msghdr *msg, size_t ignored,
 		outlen -= less;
 	}
 
-	/*
-	 * Create a per request TX SGL for this request which tracks the
-	 * SG entries from the global TX SGL.
-	 */
 	processed = used + ctx->aead_assoclen;
-	areq->tsgl_entries = aead_count_tsgl(sk, processed);
-	if (!areq->tsgl_entries)
-		areq->tsgl_entries = 1;
-	areq->tsgl = sock_kmalloc(sk, sizeof(*areq->tsgl) * areq->tsgl_entries,
-				  GFP_KERNEL);
-	if (!areq->tsgl) {
-		err = -ENOMEM;
-		goto free;
+	tsgl = list_first_entry(&ctx->tsgl_list, struct aead_tsgl, list);
+	if (ctx->enc) {
+		/* Copy AAD || PT to RX SGL buffer for in-place operation. */
+		err = crypto_aead_copy_sgl(ctx->null, tsgl->sg,
+					   areq->first_rsgl.sgl.sg, processed);
+		if (err)
+			goto free;
+		aead_pull_tsgl(sk, processed, NULL, 0);
+	} else {
+		/* Copy AAD || CT to RX SGL buffer for in-place operation. */
+		err = crypto_aead_copy_sgl(ctx->null, tsgl->sg,
+					   areq->first_rsgl.sgl.sg, outlen);
+		if (err)
+			goto free;
+
+		/* Create TX SGL for tag and chain it to RX SGL. */
+		areq->tsgl_entries = aead_count_tsgl(sk, processed);
+		if (!areq->tsgl_entries)
+			areq->tsgl_entries = 1;
+		areq->tsgl = sock_kmalloc(sk, sizeof(*areq->tsgl) *
+					      areq->tsgl_entries,
+					  GFP_KERNEL);
+		if (!areq->tsgl) {
+			err = -ENOMEM;
+			goto free;
+		}
+		sg_init_table(areq->tsgl, areq->tsgl_entries);
+
+		/* Release TX SGL, except for tag data. */
+		aead_pull_tsgl(sk, processed, areq->tsgl, processed - as);
+
+		/* chain the areq TX SGL holding the tag with RX SGL */
+		if (!last_rsgl) {
+			/* no RX SGL present (e.g. only authentication) */
+			sg_init_table(areq->first_rsgl.sgl.sg, 2);
+			sg_chain(areq->first_rsgl.sgl.sg, 2, areq->tsgl);
+		} else {
+			/* RX SGL present */
+			struct af_alg_sgl *sgl_prev = &last_rsgl->sgl;
+
+			sg_unmark_end(sgl_prev->sg + sgl_prev->npages - 1);
+			sg_chain(sgl_prev->sg, sgl_prev->npages + 1, areq->tsgl);
+		}
 	}
-	sg_init_table(areq->tsgl, areq->tsgl_entries);
-	aead_pull_tsgl(sk, processed, areq->tsgl);
+
 
 	/* Initialize the crypto operation */
-	aead_request_set_crypt(&areq->aead_req, areq->tsgl,
+	aead_request_set_crypt(&areq->aead_req, areq->first_rsgl.sgl.sg,
 			       areq->first_rsgl.sgl.sg, used, ctx->iv);
 	aead_request_set_ad(&areq->aead_req, ctx->aead_assoclen);
 	aead_request_set_tfm(&areq->aead_req, tfm);
@@ -824,7 +880,8 @@ static void aead_sock_destruct(struct sock *sk)
 	/* Suspend caller if AIO operations are in flight. */
 	wait_event_interruptible(aead_aio_finish_wait, (ctx->inflight == 0));
 
-	aead_pull_tsgl(sk, ctx->used, NULL);
+	aead_pull_tsgl(sk, ctx->used, NULL, 0);
+	crypto_put_default_null_skcipher2();
 	sock_kzfree_s(sk, ctx->iv, ivlen);
 	sock_kfree_s(sk, ctx, ctx->len);
 	af_alg_release_parent(sk);
@@ -836,6 +893,7 @@ static int aead_accept_parent(void *private, struct sock *sk)
 	struct alg_sock *ask = alg_sk(sk);
 	unsigned int len = sizeof(*ctx);
 	unsigned int ivlen = crypto_aead_ivsize(private);
+	struct crypto_skcipher *null;
 
 	ctx = sock_kmalloc(sk, len, GFP_KERNEL);
 	if (!ctx)
@@ -849,6 +907,14 @@ static int aead_accept_parent(void *private, struct sock *sk)
 	}
 	memset(ctx->iv, 0, ivlen);
 
+	null = crypto_get_default_null_skcipher2();
+	if (IS_ERR(null)) {
+		sock_kfree_s(sk, ctx->iv, ivlen);
+		sock_kfree_s(sk, ctx, len);
+		return PTR_ERR(null);
+	}
+	ctx->null = null;
+
 	INIT_LIST_HEAD(&ctx->tsgl_list);
 	ctx->len = len;
 	ctx->used = 0;
-- 
2.9.3


--nextPart1959844.g3mofz8j4i
Content-Disposition: attachment; filename="0001-crypto-algif_aead-copy-AAD-from-src-to-dst_separate.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="0001-crypto-algif_aead-copy-AAD-from-src-to-dst_separate.patch"

>From cbd8a171c56008ce4932de9f0a54926279c6061d Mon Sep 17 00:00:00 2001
From: Stephan Mueller <smueller@chronox.de>
Date: Wed, 22 Feb 2017 17:22:02 +0100
Subject: [PATCH] crypto: algif_aead - copy AAD from src to dst

Use the NULL cipher to copy the AAD from the TX SGL to the RX SGL.

The required null cipher is allocated when allocating other components
used by algif_aead and released when those components are deallocated.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig      |  2 ++
 crypto/algif_aead.c | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 5a51b87..bfa531d 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1735,6 +1735,8 @@ config CRYPTO_USER_API_AEAD
 	tristate "User-space interface for AEAD cipher algorithms"
 	depends on NET
 	select CRYPTO_AEAD
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_NULL
 	select CRYPTO_USER_API
 	help
 	  This option enables the user-spaces interface for AEAD
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 050a866..98c988b 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -30,6 +30,8 @@
 #include <crypto/internal/aead.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/if_alg.h>
+#include <crypto/skcipher.h>
+#include <crypto/null.h>
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/kernel.h>
@@ -82,6 +84,7 @@ struct aead_ctx {
 
 	unsigned int len;	/* Length of allocated memory for this struct */
 	struct crypto_aead *aead_tfm;
+	struct crypto_skcipher *null;
 };
 
 static DECLARE_WAIT_QUEUE_HEAD(aead_aio_finish_wait);
@@ -559,6 +562,20 @@ static void aead_async_cb(struct crypto_async_request *_req, int err)
 	wake_up_interruptible(&aead_aio_finish_wait);
 }
 
+static int crypto_aead_copy_sgl(struct crypto_skcipher *null,
+				struct scatterlist *src,
+				struct scatterlist *dst, unsigned int len)
+{
+	SKCIPHER_REQUEST_ON_STACK(skreq, null);
+
+	skcipher_request_set_tfm(skreq, null);
+	skcipher_request_set_callback(skreq, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				      NULL, NULL);
+	skcipher_request_set_crypt(skreq, src, dst, len, NULL);
+
+	return crypto_skcipher_encrypt(skreq);
+}
+
 static int aead_recvmsg(struct socket *sock, struct msghdr *msg, size_t ignored,
 			int flags)
 {
@@ -704,6 +721,12 @@ static int aead_recvmsg(struct socket *sock, struct msghdr *msg, size_t ignored,
 	sg_init_table(areq->tsgl, areq->tsgl_entries);
 	aead_pull_tsgl(sk, processed, areq->tsgl);
 
+	/* copy AAD from src to dst */
+	err = crypto_aead_copy_sgl(ctx->null, areq->tsgl,
+				   areq->first_rsgl.sgl.sg, ctx->aead_assoclen);
+	if (err)
+		goto free;
+
 	/* Initialize the crypto operation */
 	aead_request_set_crypt(&areq->aead_req, areq->tsgl,
 			       areq->first_rsgl.sgl.sg, used, ctx->iv);
@@ -825,6 +848,7 @@ static void aead_sock_destruct(struct sock *sk)
 	wait_event_interruptible(aead_aio_finish_wait, (ctx->inflight == 0));
 
 	aead_pull_tsgl(sk, ctx->used, NULL);
+	crypto_put_default_null_skcipher2();
 	sock_kzfree_s(sk, ctx->iv, ivlen);
 	sock_kfree_s(sk, ctx, ctx->len);
 	af_alg_release_parent(sk);
@@ -836,6 +860,7 @@ static int aead_accept_parent(void *private, struct sock *sk)
 	struct alg_sock *ask = alg_sk(sk);
 	unsigned int len = sizeof(*ctx);
 	unsigned int ivlen = crypto_aead_ivsize(private);
+	struct crypto_skcipher *null;
 
 	ctx = sock_kmalloc(sk, len, GFP_KERNEL);
 	if (!ctx)
@@ -849,6 +874,14 @@ static int aead_accept_parent(void *private, struct sock *sk)
 	}
 	memset(ctx->iv, 0, ivlen);
 
+	null = crypto_get_default_null_skcipher2();
+	if (IS_ERR(null)) {
+		sock_kfree_s(sk, ctx->iv, ivlen);
+		sock_kfree_s(sk, ctx, len);
+		return PTR_ERR(null);
+	}
+	ctx->null = null;
+
 	INIT_LIST_HEAD(&ctx->tsgl_list);
 	ctx->len = len;
 	ctx->used = 0;
-- 
2.9.3


--nextPart1959844.g3mofz8j4i--
