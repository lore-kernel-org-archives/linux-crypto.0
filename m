From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH stable 3.10.y 04/18] crypto: algif_skcipher - Add nokey compatibility path
Date: Thu, 27 Oct 2016 17:29:37 +0300
Message-ID: <1477578591-28924-5-git-send-email-aryabinin@virtuozzo.com>
References: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>
To: Willy Tarreau <w@1wt.eu>, <stable@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ve1eur01on0094.outbound.protection.outlook.com ([104.47.1.94]:45888
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S936397AbcJ0SCf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Oct 2016 14:02:35 -0400
In-Reply-To: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>

commit a0fa2d037129a9849918a92d91b79ed6c7bd2818 upstream.

This patch adds a compatibility path to support old applications
that do acept(2) before setkey.

Cc: stable@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
---
 crypto/algif_skcipher.c | 149 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 144 insertions(+), 5 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index c4c121a..db5f0f0 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -549,6 +549,99 @@ static struct proto_ops algif_skcipher_ops = {
 	.poll		=	skcipher_poll,
 };
 
+static int skcipher_check_key(struct socket *sock)
+{
+	int err;
+	struct sock *psk;
+	struct alg_sock *pask;
+	struct skcipher_tfm *tfm;
+	struct sock *sk = sock->sk;
+	struct alg_sock *ask = alg_sk(sk);
+
+	if (ask->refcnt)
+		return 0;
+
+	psk = ask->parent;
+	pask = alg_sk(ask->parent);
+	tfm = pask->private;
+
+	err = -ENOKEY;
+	lock_sock(psk);
+	if (!tfm->has_key)
+		goto unlock;
+
+	if (!pask->refcnt++)
+		sock_hold(psk);
+
+	ask->refcnt = 1;
+	sock_put(psk);
+
+	err = 0;
+
+unlock:
+	release_sock(psk);
+
+	return err;
+}
+
+static int skcipher_sendmsg_nokey(struct kiocb *unused, struct socket *sock,
+				  struct msghdr *msg, size_t size)
+{
+	int err;
+
+	err = skcipher_check_key(sock);
+	if (err)
+		return err;
+
+	return skcipher_sendmsg(unused, sock, msg, size);
+}
+
+static ssize_t skcipher_sendpage_nokey(struct socket *sock, struct page *page,
+				       int offset, size_t size, int flags)
+{
+	int err;
+
+	err = skcipher_check_key(sock);
+	if (err)
+		return err;
+
+	return skcipher_sendpage(sock, page, offset, size, flags);
+}
+
+static int skcipher_recvmsg_nokey(struct kiocb *unused, struct socket *sock,
+				  struct msghdr *msg, size_t ignored, int flags)
+{
+	int err;
+
+	err = skcipher_check_key(sock);
+	if (err)
+		return err;
+
+	return skcipher_recvmsg(unused, sock, msg, ignored, flags);
+}
+
+static struct proto_ops algif_skcipher_ops_nokey = {
+	.family		=	PF_ALG,
+
+	.connect	=	sock_no_connect,
+	.socketpair	=	sock_no_socketpair,
+	.getname	=	sock_no_getname,
+	.ioctl		=	sock_no_ioctl,
+	.listen		=	sock_no_listen,
+	.shutdown	=	sock_no_shutdown,
+	.getsockopt	=	sock_no_getsockopt,
+	.mmap		=	sock_no_mmap,
+	.bind		=	sock_no_bind,
+	.accept		=	sock_no_accept,
+	.setsockopt	=	sock_no_setsockopt,
+
+	.release	=	af_alg_release,
+	.sendmsg	=	skcipher_sendmsg_nokey,
+	.sendpage	=	skcipher_sendpage_nokey,
+	.recvmsg	=	skcipher_recvmsg_nokey,
+	.poll		=	skcipher_poll,
+};
+
 static void *skcipher_bind(const char *name, u32 type, u32 mask)
 {
 	struct skcipher_tfm *tfm;
@@ -588,7 +681,7 @@ static int skcipher_setkey(void *private, const u8 *key, unsigned int keylen)
 	return err;
 }
 
-static void skcipher_sock_destruct(struct sock *sk)
+static void skcipher_sock_destruct_common(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct skcipher_ctx *ctx = ask->private;
@@ -597,10 +690,33 @@ static void skcipher_sock_destruct(struct sock *sk)
 	skcipher_free_sgl(sk);
 	sock_kfree_s(sk, ctx->iv, crypto_ablkcipher_ivsize(tfm));
 	sock_kfree_s(sk, ctx, ctx->len);
+}
+
+static void skcipher_sock_destruct(struct sock *sk)
+{
+	skcipher_sock_destruct_common(sk);
 	af_alg_release_parent(sk);
 }
 
-static int skcipher_accept_parent(void *private, struct sock *sk)
+static void skcipher_release_parent_nokey(struct sock *sk)
+{
+	struct alg_sock *ask = alg_sk(sk);
+
+	if (!ask->refcnt) {
+		sock_put(ask->parent);
+		return;
+	}
+
+	af_alg_release_parent(sk);
+}
+
+static void skcipher_sock_destruct_nokey(struct sock *sk)
+{
+	skcipher_sock_destruct_common(sk);
+	skcipher_release_parent_nokey(sk);
+}
+
+static int skcipher_accept_parent_common(void *private, struct sock *sk)
 {
 	struct skcipher_ctx *ctx;
 	struct alg_sock *ask = alg_sk(sk);
@@ -608,9 +724,6 @@ static int skcipher_accept_parent(void *private, struct sock *sk)
 	struct crypto_ablkcipher *skcipher = tfm->skcipher;
 	unsigned int len = sizeof(*ctx) + crypto_ablkcipher_reqsize(skcipher);
 
-	if (!tfm->has_key)
-		return -ENOKEY;
-
 	ctx = sock_kmalloc(sk, len, GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
@@ -642,12 +755,38 @@ static int skcipher_accept_parent(void *private, struct sock *sk)
 	return 0;
 }
 
+static int skcipher_accept_parent(void *private, struct sock *sk)
+{
+	struct skcipher_tfm *tfm = private;
+
+	if (!tfm->has_key)
+		return -ENOKEY;
+
+	return skcipher_accept_parent_common(private, sk);
+}
+
+static int skcipher_accept_parent_nokey(void *private, struct sock *sk)
+{
+	int err;
+
+	err = skcipher_accept_parent_common(private, sk);
+	if (err)
+		goto out;
+
+	sk->sk_destruct = skcipher_sock_destruct_nokey;
+
+out:
+	return err;
+}
+
 static const struct af_alg_type algif_type_skcipher = {
 	.bind		=	skcipher_bind,
 	.release	=	skcipher_release,
 	.setkey		=	skcipher_setkey,
 	.accept		=	skcipher_accept_parent,
+	.accept_nokey	=	skcipher_accept_parent_nokey,
 	.ops		=	&algif_skcipher_ops,
+	.ops_nokey	=	&algif_skcipher_ops_nokey,
 	.name		=	"skcipher",
 	.owner		=	THIS_MODULE
 };
-- 
2.7.3
