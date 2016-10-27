From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH stable 3.10.y 02/18] crypto: af_alg - Disallow bind/setkey/... after accept(2)
Date: Thu, 27 Oct 2016 17:29:35 +0300
Message-ID: <1477578591-28924-3-git-send-email-aryabinin@virtuozzo.com>
References: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>
To: Willy Tarreau <w@1wt.eu>, <stable@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-he1eur01on0091.outbound.protection.outlook.com ([104.47.0.91]:39679
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S942640AbcJ0TCA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Oct 2016 15:02:00 -0400
In-Reply-To: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>

commit c840ac6af3f8713a71b4d2363419145760bd6044 upstream.

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
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
---
 crypto/af_alg.c         | 35 ++++++++++++++++++++++++++++++++---
 include/crypto/if_alg.h |  8 +++-----
 2 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 1aaa555..0ca108f 100644
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
 	struct sock *sk = sock->sk;
@@ -132,6 +149,7 @@ static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	struct sockaddr_alg *sa = (void *)uaddr;
 	const struct af_alg_type *type;
 	void *private;
+	int err;
 
 	if (sock->state == SS_CONNECTED)
 		return -EINVAL;
@@ -157,16 +175,22 @@ static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
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
@@ -199,11 +223,15 @@ static int alg_setsockopt(struct socket *sock, int level, int optname,
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
 
@@ -252,7 +280,8 @@ int af_alg_accept(struct sock *sk, struct socket *newsock)
 
 	sk2->sk_family = PF_ALG;
 
-	sock_hold(sk);
+	if (!ask->refcnt++)
+		sock_hold(sk);
 	alg_sk(sk2)->parent = sk;
 	alg_sk(sk2)->type = type;
 
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index d61c111..2f38daa 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -30,6 +30,8 @@ struct alg_sock {
 
 	struct sock *parent;
 
+	unsigned int refcnt;
+
 	const struct af_alg_type *type;
 	void *private;
 };
@@ -64,6 +66,7 @@ int af_alg_register_type(const struct af_alg_type *type);
 int af_alg_unregister_type(const struct af_alg_type *type);
 
 int af_alg_release(struct socket *sock);
+void af_alg_release_parent(struct sock *sk);
 int af_alg_accept(struct sock *sk, struct socket *newsock);
 
 int af_alg_make_sg(struct af_alg_sgl *sgl, void __user *addr, int len,
@@ -80,11 +83,6 @@ static inline struct alg_sock *alg_sk(struct sock *sk)
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
2.7.3
