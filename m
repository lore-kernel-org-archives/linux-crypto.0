From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v2] crypto: af_alg - Disallow bind/setkey/... after accept(2)
Date: Wed, 30 Dec 2015 11:47:53 +0800
Message-ID: <20151230034753.GA8776@gondor.apana.org.au>
References: <CACT4Y+Y0k-SuTCVMJOdymwvgEHiM+dSJ3hLOmEb6ZdK=t39gXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	syzkaller <syzkaller@googlegroups.com>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Eric Dumazet <edumazet@google.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39526 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbbL3DsA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 Dec 2015 22:48:00 -0500
Content-Disposition: inline
In-Reply-To: <CACT4Y+Y0k-SuTCVMJOdymwvgEHiM+dSJ3hLOmEb6ZdK=t39gXA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 29, 2015 at 07:36:14PM +0100, Dmitry Vyukov wrote:
> Hello,
> 
> On commit 8513342170278468bac126640a5d2d12ffbff106
> + crypto: algif_skcipher - Use new skcipher interface
> + crypto: algif_skcipher - Require setkey before accept(2)
> + crypto: af_alg - Disallow bind/setkey/... after accept(2)

OK there is a silly bug in the last patch.  Here is an updated
version.

---8<---
Each af_alg parent socket obtained by socket(2) corresponds to a
tfm object once bind(2) has succeeded.  An accept(2) call on that
parent socket creates a context which then uses the tfm object.

Therefore as long as any child sockets created by accept(2) exist
the parent socket must not be modified or freed.

This patch guarantees this by using locks and a reference count
on the parent socket.  Any attempt to modify the parent socket will
fail with EBUSY.

Cc: stable@vger.kernel.org
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index a8e7aa3..7b5b592 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -125,6 +125,23 @@ int af_alg_release(struct socket *sock)
 }
 EXPORT_SYMBOL_GPL(af_alg_release);
 
+void af_alg_release_parent(struct sock *sk)
+{
+	struct alg_sock *ask = alg_sk(sk);
+	bool last;
+
+	sk = ask->parent;
+	ask = alg_sk(sk);
+
+	lock_sock(sk);
+	last = !--ask->refcnt;
+	release_sock(sk);
+
+	if (last)
+		sock_put(sk);
+}
+EXPORT_SYMBOL_GPL(af_alg_release_parent);
+
 static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 {
 	const u32 forbidden = CRYPTO_ALG_INTERNAL;
@@ -133,6 +150,7 @@ static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	struct sockaddr_alg *sa = (void *)uaddr;
 	const struct af_alg_type *type;
 	void *private;
+	int err;
 
 	if (sock->state == SS_CONNECTED)
 		return -EINVAL;
@@ -160,16 +178,22 @@ static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		return PTR_ERR(private);
 	}
 
+	err = -EBUSY;
 	lock_sock(sk);
+	if (ask->refcnt)
+		goto unlock;
 
 	swap(ask->type, type);
 	swap(ask->private, private);
 
+	err = 0;
+
+unlock:
 	release_sock(sk);
 
 	alg_do_release(type, private);
 
-	return 0;
+	return err;
 }
 
 static int alg_setkey(struct sock *sk, char __user *ukey,
@@ -202,11 +226,15 @@ static int alg_setsockopt(struct socket *sock, int level, int optname,
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
 	const struct af_alg_type *type;
-	int err = -ENOPROTOOPT;
+	int err = -EBUSY;
 
 	lock_sock(sk);
+	if (ask->refcnt)
+		goto unlock;
+
 	type = ask->type;
 
+	err = -ENOPROTOOPT;
 	if (level != SOL_ALG || !type)
 		goto unlock;
 
@@ -264,7 +292,8 @@ int af_alg_accept(struct sock *sk, struct socket *newsock)
 
 	sk2->sk_family = PF_ALG;
 
-	sock_hold(sk);
+	if (!ask->refcnt++)
+		sock_hold(sk);
 	alg_sk(sk2)->parent = sk;
 	alg_sk(sk2)->type = type;
 
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 018afb2..589716f 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -30,6 +30,8 @@ struct alg_sock {
 
 	struct sock *parent;
 
+	unsigned int refcnt;
+
 	const struct af_alg_type *type;
 	void *private;
 };
@@ -67,6 +69,7 @@ int af_alg_register_type(const struct af_alg_type *type);
 int af_alg_unregister_type(const struct af_alg_type *type);
 
 int af_alg_release(struct socket *sock);
+void af_alg_release_parent(struct sock *sk);
 int af_alg_accept(struct sock *sk, struct socket *newsock);
 
 int af_alg_make_sg(struct af_alg_sgl *sgl, struct iov_iter *iter, int len);
@@ -83,11 +86,6 @@ static inline struct alg_sock *alg_sk(struct sock *sk)
 	return (struct alg_sock *)sk;
 }
 
-static inline void af_alg_release_parent(struct sock *sk)
-{
-	sock_put(alg_sk(sk)->parent);
-}
-
 static inline void af_alg_init_completion(struct af_alg_completion *completion)
 {
 	init_completion(&completion->completion);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
