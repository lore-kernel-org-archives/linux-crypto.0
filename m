From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH] Re: Broken userspace crypto in linux-4.1.18
Date: Sun, 21 Feb 2016 17:40:05 +0100
Message-ID: <56C9E865.3050500@gmail.com>
References: <56C47DF9.6030704@whissi.de> <20160217233353.GC31125@1wt.eu>
 <56C50725.6080408@whissi.de> <4580306.arupsYiYbb@positron.chronox.de>
 <56C591E7.5080808@suse.cz> <56C5A66E.5010905@whissi.de>
 <56C87929.8040304@whissi.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Willy Tarreau <w@1wt.eu>, Sasha Levin <sasha.levin@oracle.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"dvyukov@google.com" <dvyukov@google.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	Ondrej Kozina <okozina@redhat.com>
To: "Thomas D." <whissi@whissi.de>, Jiri Slaby <jslaby@suse.cz>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <56C87929.8040304@whissi.de>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 02/20/2016 03:33 PM, Thomas D. wrote:
> Hi,
> 
> FYI: v3.10.97, v3.14.61 and 3.18.27 are also affected.
> 
> v4.3.6 works. Looks like the patch set is only compatible with >=linux-4.3.
> 
> v3.12.54 works because it doesn't contain the patch in question.

Hi,

indeed, because whoever backported this patchset skipped two patches
from series (because of skcipher interface file was introduced later).

I tried to backport it (on 4.1.18 tree, see patch below) and it fixes the problem
for me.

Anyway, it is just quick test what is the problem, patch need proper review or
backport from someone who knows the code better.

I will release stable cryptsetup soon that will work with new kernel even without
this patch but I would strongly recommend that stable kernels get these compatibility
backports as well to avoid breaking existing userspace.

Thanks,
Milan
-

This patch backports missing parts of crypto API compatibility changes:

  dd504589577d8e8e70f51f997ad487a4cb6c026f
  crypto: algif_skcipher - Require setkey before accept(2)

  a0fa2d037129a9849918a92d91b79ed6c7bd2818
  crypto: algif_skcipher - Add nokey compatibility path

--- crypto/algif_skcipher.c.orig	2016-02-21 16:44:27.172312990 +0100
+++ crypto/algif_skcipher.c	2016-02-21 17:03:58.555785347 +0100
@@ -31,6 +31,11 @@
 	struct scatterlist sg[0];
 };
 
+struct skcipher_tfm {
+	struct crypto_ablkcipher *skcipher;
+	bool has_key;
+};
+
 struct skcipher_ctx {
 	struct list_head tsgl;
 	struct af_alg_sgl rsgl;
@@ -750,19 +755,136 @@
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
-	return crypto_alloc_ablkcipher(name, type, mask);
+	struct skcipher_tfm *tfm;
+	struct crypto_ablkcipher *skcipher;
+
+	tfm = kzalloc(sizeof(*tfm), GFP_KERNEL);
+	if (!tfm)
+		return ERR_PTR(-ENOMEM);
+
+	skcipher = crypto_alloc_ablkcipher(name, type, mask);
+	if (IS_ERR(skcipher)) {
+		kfree(tfm);
+		return ERR_CAST(skcipher);
+	}
+
+	tfm->skcipher = skcipher;
+
+	return tfm;
 }
 
 static void skcipher_release(void *private)
 {
-	crypto_free_ablkcipher(private);
+	struct skcipher_tfm *tfm = private;
+
+	crypto_free_ablkcipher(tfm->skcipher);
+	kfree(tfm);
 }
 
 static int skcipher_setkey(void *private, const u8 *key, unsigned int keylen)
 {
-	return crypto_ablkcipher_setkey(private, key, keylen);
+	struct skcipher_tfm *tfm = private;
+	int err;
+
+	err = crypto_ablkcipher_setkey(tfm->skcipher, key, keylen);
+	tfm->has_key = !err;
+
+	return err;
 }
 
 static void skcipher_wait(struct sock *sk)
@@ -775,7 +897,7 @@
 		msleep(100);
 }
 
-static void skcipher_sock_destruct(struct sock *sk)
+static void skcipher_sock_destruct_common(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct skcipher_ctx *ctx = ask->private;
@@ -790,24 +912,50 @@
 	af_alg_release_parent(sk);
 }
 
-static int skcipher_accept_parent(void *private, struct sock *sk)
+static void skcipher_sock_destruct(struct sock *sk)
+{
+	skcipher_sock_destruct_common(sk);
+	af_alg_release_parent(sk);
+}
+
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
-	unsigned int len = sizeof(*ctx) + crypto_ablkcipher_reqsize(private);
+	struct skcipher_tfm *tfm = private;
+	struct crypto_ablkcipher *skcipher = tfm->skcipher;
+	unsigned int len = sizeof(*ctx) + crypto_ablkcipher_reqsize(skcipher);
 
 	ctx = sock_kmalloc(sk, len, GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
 
-	ctx->iv = sock_kmalloc(sk, crypto_ablkcipher_ivsize(private),
+	ctx->iv = sock_kmalloc(sk, crypto_ablkcipher_ivsize(skcipher),
 			       GFP_KERNEL);
 	if (!ctx->iv) {
 		sock_kfree_s(sk, ctx, len);
 		return -ENOMEM;
 	}
 
-	memset(ctx->iv, 0, crypto_ablkcipher_ivsize(private));
+	memset(ctx->iv, 0, crypto_ablkcipher_ivsize(skcipher));
 
 	INIT_LIST_HEAD(&ctx->tsgl);
 	ctx->len = len;
@@ -820,7 +968,7 @@
 
 	ask->private = ctx;
 
-	ablkcipher_request_set_tfm(&ctx->req, private);
+	ablkcipher_request_set_tfm(&ctx->req, skcipher);
 	ablkcipher_request_set_callback(&ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 					af_alg_complete, &ctx->completion);
 
@@ -829,12 +977,38 @@
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
