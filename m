From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 14/16] crypto: AF_ALG - consolidate sendpage implementation
Date: Mon, 31 Jul 2017 14:10:14 +0200
Message-ID: <8787512.vk6vViJ2Ag@positron.chronox.de>
References: <4570630.RBIQc1aA22@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60848 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751951AbdGaMLf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2017 08:11:35 -0400
In-Reply-To: <4570630.RBIQc1aA22@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Consoliate aead_sendpage, skcipher_sendpage
==> af_alg_sendpage

The following changes to aead_sendpage have been applied:

* remove superfluous err = 0

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c         | 58 +++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/algif_aead.c     | 57 ++----------------------------------------------
 crypto/algif_skcipher.c | 55 ++--------------------------------------------
 include/crypto/if_alg.h |  2 ++
 4 files changed, 64 insertions(+), 108 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 716a73ff5309..5a33d6629a67 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -991,6 +991,64 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 }
 EXPORT_SYMBOL_GPL(af_alg_sendmsg);
 
+/**
+ * af_alg_sendpage - sendpage system call handler
+ *
+ * This is a generic implementation of sendpage to fill ctx->tsgl_list.
+ */
+ssize_t af_alg_sendpage(struct socket *sock, struct page *page,
+			int offset, size_t size, int flags)
+{
+	struct sock *sk = sock->sk;
+	struct alg_sock *ask = alg_sk(sk);
+	struct af_alg_ctx *ctx = ask->private;
+	struct af_alg_tsgl *sgl;
+	int err = -EINVAL;
+
+	if (flags & MSG_SENDPAGE_NOTLAST)
+		flags |= MSG_MORE;
+
+	lock_sock(sk);
+	if (!ctx->more && ctx->used)
+		goto unlock;
+
+	if (!size)
+		goto done;
+
+	if (!af_alg_writable(sk)) {
+		err = af_alg_wait_for_wmem(sk, flags);
+		if (err)
+			goto unlock;
+	}
+
+	err = af_alg_alloc_tsgl(sk);
+	if (err)
+		goto unlock;
+
+	ctx->merge = 0;
+	sgl = list_entry(ctx->tsgl_list.prev, struct af_alg_tsgl, list);
+
+	if (sgl->cur)
+		sg_unmark_end(sgl->sg + sgl->cur - 1);
+
+	sg_mark_end(sgl->sg + sgl->cur);
+
+	get_page(page);
+	sg_set_page(sgl->sg + sgl->cur, page, size, offset);
+	sgl->cur++;
+	ctx->used += size;
+
+done:
+	ctx->more = flags & MSG_MORE;
+
+unlock:
+	af_alg_data_wakeup(sk);
+	release_sock(sk);
+
+	return err ?: size;
+}
+EXPORT_SYMBOL_GPL(af_alg_sendpage);
+
 static int __init af_alg_init(void)
 {
 	int err = proto_register(&alg_proto, 0);
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 9cb934b3175a..f655fadb9075 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -76,59 +76,6 @@ static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	return af_alg_sendmsg(sock, msg, size, ivsize);
 }
 
-static ssize_t aead_sendpage(struct socket *sock, struct page *page,
-			     int offset, size_t size, int flags)
-{
-	struct sock *sk = sock->sk;
-	struct alg_sock *ask = alg_sk(sk);
-	struct af_alg_ctx *ctx = ask->private;
-	struct af_alg_tsgl *sgl;
-	int err = -EINVAL;
-
-	if (flags & MSG_SENDPAGE_NOTLAST)
-		flags |= MSG_MORE;
-
-	lock_sock(sk);
-	if (!ctx->more && ctx->used)
-		goto unlock;
-
-	if (!size)
-		goto done;
-
-	if (!af_alg_writable(sk)) {
-		err = af_alg_wait_for_wmem(sk, flags);
-		if (err)
-			goto unlock;
-	}
-
-	err = af_alg_alloc_tsgl(sk);
-	if (err)
-		goto unlock;
-
-	ctx->merge = 0;
-	sgl = list_entry(ctx->tsgl_list.prev, struct af_alg_tsgl, list);
-
-	if (sgl->cur)
-		sg_unmark_end(sgl->sg + sgl->cur - 1);
-
-	sg_mark_end(sgl->sg + sgl->cur);
-
-	get_page(page);
-	sg_set_page(sgl->sg + sgl->cur, page, size, offset);
-	sgl->cur++;
-	ctx->used += size;
-
-	err = 0;
-
-done:
-	ctx->more = flags & MSG_MORE;
-unlock:
-	af_alg_data_wakeup(sk);
-	release_sock(sk);
-
-	return err ?: size;
-}
-
 static void aead_async_cb(struct crypto_async_request *_req, int err)
 {
 	struct af_alg_async_req *areq = _req->data;
@@ -496,7 +443,7 @@ static struct proto_ops algif_aead_ops = {
 
 	.release	=	af_alg_release,
 	.sendmsg	=	aead_sendmsg,
-	.sendpage	=	aead_sendpage,
+	.sendpage	=	af_alg_sendpage,
 	.recvmsg	=	aead_recvmsg,
 	.poll		=	aead_poll,
 };
@@ -560,7 +507,7 @@ static ssize_t aead_sendpage_nokey(struct socket *sock, struct page *page,
 	if (err)
 		return err;
 
-	return aead_sendpage(sock, page, offset, size, flags);
+	return af_alg_sendpage(sock, page, offset, size, flags);
 }
 
 static int aead_recvmsg_nokey(struct socket *sock, struct msghdr *msg,
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index d5bc5de7a8a1..c577aaaa9fd8 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -57,57 +57,6 @@ static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg,
 	return af_alg_sendmsg(sock, msg, size, ivsize);
 }
 
-static ssize_t skcipher_sendpage(struct socket *sock, struct page *page,
-				 int offset, size_t size, int flags)
-{
-	struct sock *sk = sock->sk;
-	struct alg_sock *ask = alg_sk(sk);
-	struct af_alg_ctx *ctx = ask->private;
-	struct af_alg_tsgl *sgl;
-	int err = -EINVAL;
-
-	if (flags & MSG_SENDPAGE_NOTLAST)
-		flags |= MSG_MORE;
-
-	lock_sock(sk);
-	if (!ctx->more && ctx->used)
-		goto unlock;
-
-	if (!size)
-		goto done;
-
-	if (!af_alg_writable(sk)) {
-		err = af_alg_wait_for_wmem(sk, flags);
-		if (err)
-			goto unlock;
-	}
-
-	err = af_alg_alloc_tsgl(sk);
-	if (err)
-		goto unlock;
-
-	ctx->merge = 0;
-	sgl = list_entry(ctx->tsgl_list.prev, struct af_alg_tsgl, list);
-
-	if (sgl->cur)
-		sg_unmark_end(sgl->sg + sgl->cur - 1);
-
-	sg_mark_end(sgl->sg + sgl->cur);
-	get_page(page);
-	sg_set_page(sgl->sg + sgl->cur, page, size, offset);
-	sgl->cur++;
-	ctx->used += size;
-
-done:
-	ctx->more = flags & MSG_MORE;
-
-unlock:
-	af_alg_data_wakeup(sk);
-	release_sock(sk);
-
-	return err ?: size;
-}
-
 static void skcipher_async_cb(struct crypto_async_request *req, int err)
 {
 	struct af_alg_async_req *areq = req->data;
@@ -341,7 +290,7 @@ static struct proto_ops algif_skcipher_ops = {
 
 	.release	=	af_alg_release,
 	.sendmsg	=	skcipher_sendmsg,
-	.sendpage	=	skcipher_sendpage,
+	.sendpage	=	af_alg_sendpage,
 	.recvmsg	=	skcipher_recvmsg,
 	.poll		=	skcipher_poll,
 };
@@ -405,7 +354,7 @@ static ssize_t skcipher_sendpage_nokey(struct socket *sock, struct page *page,
 	if (err)
 		return err;
 
-	return skcipher_sendpage(sock, page, offset, size, flags);
+	return af_alg_sendpage(sock, page, offset, size, flags);
 }
 
 static int skcipher_recvmsg_nokey(struct socket *sock, struct msghdr *msg,
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index c67d9a35ffd3..d271af60bfaf 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -251,5 +251,7 @@ int af_alg_wait_for_data(struct sock *sk, unsigned flags);
 void af_alg_data_wakeup(struct sock *sk);
 int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		   unsigned int ivsize);
+ssize_t af_alg_sendpage(struct socket *sock, struct page *page,
+			int offset, size_t size, int flags);
 
 #endif	/* _CRYPTO_IF_ALG_H */
-- 
2.13.3
