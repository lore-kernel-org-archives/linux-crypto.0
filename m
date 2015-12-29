From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: use-after-free in hash_sock_destruct
Date: Tue, 29 Dec 2015 22:40:37 +0800
Message-ID: <20151229144037.GA5576@gondor.apana.org.au>
References: <CACT4Y+a8Y5qz7rODCJ9QJbVhNv2WmS+COx7dSejGU=3kBWjLLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	syzkaller <syzkaller@googlegroups.com>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Kees Cook <keescook@google.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+a8Y5qz7rODCJ9QJbVhNv2WmS+COx7dSejGU=3kBWjLLQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Dec 17, 2015 at 01:59:50PM +0100, Dmitry Vyukov wrote:
> 
> The following program causes use-after-free in hash_sock_destruct:

This patch should fix the problem.  AFAIK everything that you have
reported should now be fixed.  If you still have issues please
resubmit them (and please cc me).  Thanks!

---8<---
Subject: crypto: af_alg - Disallow bind/setkey/... after accept(2)

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
index a8e7aa3..f5a2426 100644
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
@@ -188,14 +212,41 @@ static int alg_setkey(struct sock *sk, char __user *ukey,
 	if (copy_from_user(key, ukey, keylen))
 		goto out;
 
+	err = -EBUSY;
+	lock_sock(sk);
+	if (ask->refcnt)
+		goto unlock;
+
 	err = type->setkey(ask->private, key, keylen);
 
+unlock:
+	release_sock(sk);
+
 out:
 	sock_kzfree_s(sk, key, keylen);
 
 	return err;
 }
 
+static int alg_setauthsize(struct sock *sk, unsigned int size)
+{
+	int err;
+	struct alg_sock *ask = alg_sk(sk);
+	const struct af_alg_type *type = ask->type;
+
+	err = -EBUSY;
+	lock_sock(sk);
+	if (ask->refcnt)
+		goto unlock;
+
+	err = type->setauthsize(ask->private, size);
+
+unlock:
+	release_sock(sk);
+
+	return err;
+}
+
 static int alg_setsockopt(struct socket *sock, int level, int optname,
 			  char __user *optval, unsigned int optlen)
 {
@@ -224,7 +275,7 @@ static int alg_setsockopt(struct socket *sock, int level, int optname,
 			goto unlock;
 		if (!type->setauthsize)
 			goto unlock;
-		err = type->setauthsize(ask->private, optlen);
+		err = alg_setauthsize(sk, optlen);
 	}
 
 unlock:
@@ -264,7 +315,8 @@ int af_alg_accept(struct sock *sk, struct socket *newsock)
 
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
