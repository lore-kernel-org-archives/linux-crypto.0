From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: crypto: use-after-free in alg_bind
Date: Wed, 30 Dec 2015 11:19:45 +0100
Message-ID: <CACT4Y+ZUiiXUY06MEGQfz3FN8pugrNpSJb2QjMQ9CyRCP6kojw@mail.gmail.com>
References: <CACT4Y+aDcwAn0NQmSnwa4CFCYHcyHu_5UqPNmUZ21b-B-gpZbw@mail.gmail.com>
 <20151230012436.GA8173@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Eric Dumazet <edumazet@google.com>,
	syzkaller <syzkaller@googlegroups.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35084 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbbL3KUG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 30 Dec 2015 05:20:06 -0500
Received: by mail-wm0-f47.google.com with SMTP id f206so33116999wmf.0
        for <linux-crypto@vger.kernel.org>; Wed, 30 Dec 2015 02:20:05 -0800 (PST)
In-Reply-To: <20151230012436.GA8173@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 30, 2015 at 2:24 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Dec 29, 2015 at 09:19:22PM +0100, Dmitry Vyukov wrote:
>> Hello,
>>
>> On commit 8513342170278468bac126640a5d2d12ffbff106
>> + crypto: algif_skcipher - Use new skcipher interface
>> + crypto: algif_skcipher - Require setkey before accept(2)
>> + crypto: af_alg - Disallow bind/setkey/... after accept(2)
>>
>> The following program causes use-after-free in alg_bind and later
>> terminates kernel:
>
> Please double-check that you have the last patch applied correctly,
> as I cannot reproduce the crash with your program.

I am pretty sure I have the last patch applied. The use-after-frees
that it was supposed to fix have gone. Below are combined changed to
crypto/ files that I have on top of
8513342170278468bac126640a5d2d12ffbff106.

This use-after-free does not reproduce on every run. It seems to be
triggered by some race. Try to run the program in a parallel loop.
I use stress tool for this:
https://github.com/golang/tools/blob/master/cmd/stress/stress.go
If you have Go toolchain installed, then then following will do:
$ go get golang.org/x/tools/cmd/stress
$ stress -p 16 ./a.out


diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index a8e7aa3..82a7dcd 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -125,6 +125,23 @@ int af_alg_release(struct socket *sock)
 }
 EXPORT_SYMBOL_GPL(af_alg_release);

+void af_alg_release_parent(struct sock *sk)
+{
+        struct alg_sock *ask = alg_sk(sk);
+        bool last;
+
+        sk = ask->parent;
+        ask = alg_sk(sk);
+
+        lock_sock(sk);
+        last = !--ask->refcnt;
+        release_sock(sk);
+
+        if (last)
+                sock_put(sk);
+}
+EXPORT_SYMBOL_GPL(af_alg_release_parent);
+
 static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 {
         const u32 forbidden = CRYPTO_ALG_INTERNAL;
@@ -133,6 +150,7 @@ static int alg_bind(struct socket *sock, struct
sockaddr *uaddr, int addr_len)
         struct sockaddr_alg *sa = (void *)uaddr;
         const struct af_alg_type *type;
         void *private;
+        int err;

         if (sock->state == SS_CONNECTED)
                 return -EINVAL;
@@ -160,16 +178,22 @@ static int alg_bind(struct socket *sock, struct
sockaddr *uaddr, int addr_len)
                 return PTR_ERR(private);
         }

+        err = -EBUSY;
         lock_sock(sk);
+        if (ask->refcnt)
+                goto unlock;

         swap(ask->type, type);
         swap(ask->private, private);

+        err = 0;
+
+unlock:
         release_sock(sk);

         alg_do_release(type, private);

-        return 0;
+        return err;
 }

 static int alg_setkey(struct sock *sk, char __user *ukey,
@@ -196,6 +220,16 @@ out:
         return err;
 }

+static int alg_setauthsize(struct sock *sk, unsigned int size)
+{
+        int err;
+        struct alg_sock *ask = alg_sk(sk);
+        const struct af_alg_type *type = ask->type;
+
+        err = type->setauthsize(ask->private, size);
+        return err;
+}
+
 static int alg_setsockopt(struct socket *sock, int level, int optname,
                           char __user *optval, unsigned int optlen)
 {
@@ -210,6 +244,11 @@ static int alg_setsockopt(struct socket *sock,
int level, int optname,
         if (level != SOL_ALG || !type)
                 goto unlock;

+        if (ask->refcnt) {
+                err = -EBUSY;
+                goto unlock;
+        }
+
         switch (optname) {
         case ALG_SET_KEY:
                 if (sock->state == SS_CONNECTED)
@@ -224,7 +263,7 @@ static int alg_setsockopt(struct socket *sock, int
level, int optname,
                         goto unlock;
                 if (!type->setauthsize)
                         goto unlock;
-                err = type->setauthsize(ask->private, optlen);
+                err = alg_setauthsize(sk, optlen);
         }

 unlock:
@@ -264,7 +303,8 @@ int af_alg_accept(struct sock *sk, struct socket *newsock)

         sk2->sk_family = PF_ALG;

-        sock_hold(sk);
+        if (!ask->refcnt++)
+                sock_hold(sk);
         alg_sk(sk2)->parent = sk;
         alg_sk(sk2)->type = type;

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 634b4d1..df483f9 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -31,6 +31,11 @@ struct skcipher_sg_list {
         struct scatterlist sg[0];
 };

+struct skcipher_tfm {
+        struct crypto_skcipher *skcipher;
+        bool has_key;
+};
+
 struct skcipher_ctx {
         struct list_head tsgl;
         struct af_alg_sgl rsgl;
@@ -750,17 +755,41 @@ static struct proto_ops algif_skcipher_ops = {

 static void *skcipher_bind(const char *name, u32 type, u32 mask)
 {
-        return crypto_alloc_skcipher(name, type, mask);
+        struct skcipher_tfm *tfm;
+        struct crypto_skcipher *skcipher;
+
+        tfm = kzalloc(sizeof(*tfm), GFP_KERNEL);
+        if (!tfm)
+                return ERR_PTR(-ENOMEM);
+
+        skcipher = crypto_alloc_skcipher(name, type, mask);
+        if (IS_ERR(skcipher)) {
+                kfree(tfm);
+                return ERR_CAST(skcipher);
+        }
+
+        tfm->skcipher = skcipher;
+
+        return tfm;
 }

 static void skcipher_release(void *private)
 {
-        crypto_free_skcipher(private);
+        struct skcipher_tfm *tfm = private;
+
+        crypto_free_skcipher(tfm->skcipher);
+        kfree(tfm);
 }

 static int skcipher_setkey(void *private, const u8 *key, unsigned int keylen)
 {
-        return crypto_skcipher_setkey(private, key, keylen);
+        struct skcipher_tfm *tfm = private;
+        int err;
+
+        err = crypto_skcipher_setkey(tfm->skcipher, key, keylen);
+        tfm->has_key = !err;
+
+        return err;
 }

 static void skcipher_wait(struct sock *sk)
@@ -792,20 +821,25 @@ static int skcipher_accept_parent(void *private,
struct sock *sk)
 {
         struct skcipher_ctx *ctx;
         struct alg_sock *ask = alg_sk(sk);
-        unsigned int len = sizeof(*ctx) + crypto_skcipher_reqsize(private);
+        struct skcipher_tfm *tfm = private;
+        struct crypto_skcipher *skcipher = tfm->skcipher;
+        unsigned int len = sizeof(*ctx) + crypto_skcipher_reqsize(skcipher);
+
+        if (!tfm->has_key)
+                return -ENOKEY;

         ctx = sock_kmalloc(sk, len, GFP_KERNEL);
         if (!ctx)
                 return -ENOMEM;

-        ctx->iv = sock_kmalloc(sk, crypto_skcipher_ivsize(private),
+        ctx->iv = sock_kmalloc(sk, crypto_skcipher_ivsize(skcipher),
                                GFP_KERNEL);
         if (!ctx->iv) {
                 sock_kfree_s(sk, ctx, len);
                 return -ENOMEM;
         }

-        memset(ctx->iv, 0, crypto_skcipher_ivsize(private));
+        memset(ctx->iv, 0, crypto_skcipher_ivsize(skcipher));

         INIT_LIST_HEAD(&ctx->tsgl);
         ctx->len = len;
@@ -818,7 +852,7 @@ static int skcipher_accept_parent(void *private,
struct sock *sk)

         ask->private = ctx;

-        skcipher_request_set_tfm(&ctx->req, private);
+        skcipher_request_set_tfm(&ctx->req, skcipher);
         skcipher_request_set_callback(&ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
                                       af_alg_complete, &ctx->completion);
