From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: af_alg - Allow af_af_alg_release_parent to be called on
 nokey path
Date: Wed, 13 Jan 2016 14:59:03 +0800
Message-ID: <20160113065903.GA8169@gondor.apana.org.au>
References: <CACT4Y+YP0Ppj41P9mX1SPSEXkV=ffe0vuK1Ap7r0Ub8GROD5nQ@mail.gmail.com>
 <20160113065729.GA8123@gondor.apana.org.au>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:53519 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbcAMG7I (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Jan 2016 01:59:08 -0500
Content-Disposition: inline
In-Reply-To: <20160113065729.GA8123@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch allows af_alg_release_parent to be called even for
nokey sockets.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 6566d2e..e7cb836 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -133,6 +133,12 @@ void af_alg_release_parent(struct sock *sk)
 	bool last;
 
 	sk = ask->parent;
+
+	if (ask->nokey_refcnt && !ask->refcnt) {
+		sock_put(sk);
+		return;
+	}
+
 	ask = alg_sk(sk);
 
 	lock_sock(sk);
@@ -268,8 +274,8 @@ int af_alg_accept(struct sock *sk, struct socket *newsock)
 	struct alg_sock *ask = alg_sk(sk);
 	const struct af_alg_type *type;
 	struct sock *sk2;
+	unsigned int nokey;
 	int err;
-	bool nokey;
 
 	lock_sock(sk);
 	type = ask->type;
@@ -302,6 +308,7 @@ int af_alg_accept(struct sock *sk, struct socket *newsock)
 		sock_hold(sk);
 	alg_sk(sk2)->parent = sk;
 	alg_sk(sk2)->type = type;
+	alg_sk(sk2)->nokey_refcnt = nokey;
 
 	newsock->ops = type->ops;
 	newsock->state = SS_CONNECTED;
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index df82844..a2bfd78 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -31,6 +31,7 @@ struct alg_sock {
 	struct sock *parent;
 
 	unsigned int refcnt;
+	unsigned int nokey_refcnt;
 
 	const struct af_alg_type *type;
 	void *private;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
