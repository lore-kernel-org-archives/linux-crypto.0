From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/2] crypto: algif_skcipher - Add nokey compatibility path
Date: Mon, 4 Jan 2016 13:36:12 +0900
Message-ID: <20160104043612.GA4477@gondor.apana.org.au>
References: <CACT4Y+YOwOfRHOwJ=FA9aaL2cZ-PRhTvd_mCzxx2nnN_L3tygw@mail.gmail.com>
 <5687BA0F.3020104@gmail.com>
 <5687E19E.2070801@gmail.com>
 <1647086.cdlVYfuqk1@myon.chronox.de>
 <56883096.1020009@gmail.com>
 <20160103013126.GA30385@gondor.apana.org.au>
 <5688ED04.4090802@gmail.com>
 <20160104043518.GA4411@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>,
	Dmitry Vyukov <dvyukov@google.com>, syzkaller@googlegroups.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kcc@google.com, glider@google.com,
	edumazet@google.com, sasha.levin@oracle.com, keescook@google.com
To: Milan Broz <gmazyland@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54327 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbcADEgV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 3 Jan 2016 23:36:21 -0500
Content-Disposition: inline
In-Reply-To: <20160104043518.GA4411@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds a compatibility path to support old applications
that do acept(2) before setkey.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index f4431bc..110bab4 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -753,6 +753,99 @@ static struct proto_ops algif_skcipher_ops = {
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
+static int skcipher_sendmsg_nokey(struct socket *sock, struct msghdr *msg,
+				  size_t size)
+{
+	int err;
+
+	err = skcipher_check_key(sock);
+	if (err)
+		return err;
+
+	return skcipher_sendmsg(sock, msg, size);
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
+static int skcipher_recvmsg_nokey(struct socket *sock, struct msghdr *msg,
+				  size_t ignored, int flags)
+{
+	int err;
+
+	err = skcipher_check_key(sock);
+	if (err)
+		return err;
+
+	return skcipher_recvmsg(sock, msg, ignored, flags);
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
@@ -802,7 +895,7 @@ static void skcipher_wait(struct sock *sk)
 		msleep(100);
 }
 
-static void skcipher_sock_destruct(struct sock *sk)
+static void skcipher_sock_destruct_common(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct skcipher_ctx *ctx = ask->private;
@@ -814,10 +907,33 @@ static void skcipher_sock_destruct(struct sock *sk)
 	skcipher_free_sgl(sk);
 	sock_kzfree_s(sk, ctx->iv, crypto_skcipher_ivsize(tfm));
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
@@ -825,9 +941,6 @@ static int skcipher_accept_parent(void *private, struct sock *sk)
 	struct crypto_skcipher *skcipher = tfm->skcipher;
 	unsigned int len = sizeof(*ctx) + crypto_skcipher_reqsize(skcipher);
 
-	if (!tfm->has_key)
-		return -ENOKEY;
-
 	ctx = sock_kmalloc(sk, len, GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
@@ -861,12 +974,38 @@ static int skcipher_accept_parent(void *private, struct sock *sk)
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
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
