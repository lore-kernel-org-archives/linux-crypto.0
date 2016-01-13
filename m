From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/4] crypto: af_alg - Forbid bind(2) when nokey child sockets
 are present
Date: Wed, 13 Jan 2016 15:03:32 +0800
Message-ID: <20160113070332.GD8169@gondor.apana.org.au>
References: <CACT4Y+YP0Ppj41P9mX1SPSEXkV=ffe0vuK1Ap7r0Ub8GROD5nQ@mail.gmail.com>
 <20160113065729.GA8123@gondor.apana.org.au>
 <20160113065903.GA8169@gondor.apana.org.au>
 <20160113070036.GB8169@gondor.apana.org.au>
 <20160113070106.GC8169@gondor.apana.org.au>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:33748 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbcAMHDj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Jan 2016 02:03:39 -0500
Content-Disposition: inline
In-Reply-To: <20160113070106.GC8169@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch forbids the calling of bind(2) when there are child
sockets created by accept(2) in existence, even if they are created
on the nokey path.

This is needed as those child sockets have references to the tfm
object which bind(2) will destroy.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index e7cb836..f5e18c2 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -130,19 +130,16 @@ EXPORT_SYMBOL_GPL(af_alg_release);
 void af_alg_release_parent(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
-	bool last;
+	unsigned int nokey = ask->nokey_refcnt;
+	bool last = nokey && !ask->refcnt;
 
 	sk = ask->parent;
-
-	if (ask->nokey_refcnt && !ask->refcnt) {
-		sock_put(sk);
-		return;
-	}
-
 	ask = alg_sk(sk);
 
 	lock_sock(sk);
-	last = !--ask->refcnt;
+	ask->nokey_refcnt -= nokey;
+	if (!last)
+		last = !--ask->refcnt;
 	release_sock(sk);
 
 	if (last)
@@ -188,7 +185,7 @@ static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 
 	err = -EBUSY;
 	lock_sock(sk);
-	if (ask->refcnt)
+	if (ask->refcnt | ask->nokey_refcnt)
 		goto unlock;
 
 	swap(ask->type, type);
@@ -306,6 +303,7 @@ int af_alg_accept(struct sock *sk, struct socket *newsock)
 
 	if (nokey || !ask->refcnt++)
 		sock_hold(sk);
+	ask->nokey_refcnt += nokey;
 	alg_sk(sk2)->parent = sk;
 	alg_sk(sk2)->type = type;
 	alg_sk(sk2)->nokey_refcnt = nokey;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
