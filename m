From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/2] crypto: af_alg - Add nokey compatibility path
Date: Mon, 4 Jan 2016 13:35:18 +0900
Message-ID: <20160104043518.GA4411@gondor.apana.org.au>
References: <CACT4Y+YOwOfRHOwJ=FA9aaL2cZ-PRhTvd_mCzxx2nnN_L3tygw@mail.gmail.com>
 <5687BA0F.3020104@gmail.com>
 <5687E19E.2070801@gmail.com>
 <1647086.cdlVYfuqk1@myon.chronox.de>
 <56883096.1020009@gmail.com>
 <20160103013126.GA30385@gondor.apana.org.au>
 <5688ED04.4090802@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>,
	Dmitry Vyukov <dvyukov@google.com>, syzkaller@googlegroups.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kcc@google.com, glider@google.com,
	edumazet@google.com, sasha.levin@oracle.com, keescook@google.com
To: Milan Broz <gmazyland@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55465 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbcADEgF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 3 Jan 2016 23:36:05 -0500
Content-Disposition: inline
In-Reply-To: <5688ED04.4090802@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jan 03, 2016 at 10:42:28AM +0100, Milan Broz wrote:
> 
> yes, basically it prepares socket()/bind()/accept() and then it calls setkey once.
> (I'll try to fix in next releases to call setkey first though.)

OK please try these two patches (warning, totally untested).

---8<---
This patch adds a compatibility path to support old applications
that do acept(2) before setkey.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index eaf98e2..6566d2e 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -76,6 +76,8 @@ int af_alg_register_type(const struct af_alg_type *type)
 		goto unlock;
 
 	type->ops->owner = THIS_MODULE;
+	if (type->ops_nokey)
+		type->ops_nokey->owner = THIS_MODULE;
 	node->type = type;
 	list_add(&node->list, &alg_types);
 	err = 0;
@@ -267,6 +269,7 @@ int af_alg_accept(struct sock *sk, struct socket *newsock)
 	const struct af_alg_type *type;
 	struct sock *sk2;
 	int err;
+	bool nokey;
 
 	lock_sock(sk);
 	type = ask->type;
@@ -285,12 +288,17 @@ int af_alg_accept(struct sock *sk, struct socket *newsock)
 	security_sk_clone(sk, sk2);
 
 	err = type->accept(ask->private, sk2);
+
+	nokey = err == -ENOKEY;
+	if (nokey && type->accept_nokey)
+		err = type->accept_nokey(ask->private, sk2);
+
 	if (err)
 		goto unlock;
 
 	sk2->sk_family = PF_ALG;
 
-	if (!ask->refcnt++)
+	if (nokey || !ask->refcnt++)
 		sock_hold(sk);
 	alg_sk(sk2)->parent = sk;
 	alg_sk(sk2)->type = type;
@@ -298,6 +306,9 @@ int af_alg_accept(struct sock *sk, struct socket *newsock)
 	newsock->ops = type->ops;
 	newsock->state = SS_CONNECTED;
 
+	if (nokey)
+		newsock->ops = type->ops_nokey;
+
 	err = 0;
 
 unlock:
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 589716f..df82844 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -52,9 +52,11 @@ struct af_alg_type {
 	void (*release)(void *private);
 	int (*setkey)(void *private, const u8 *key, unsigned int keylen);
 	int (*accept)(void *private, struct sock *sk);
+	int (*accept_nokey)(void *private, struct sock *sk);
 	int (*setauthsize)(void *private, unsigned int authsize);
 
 	struct proto_ops *ops;
+	struct proto_ops *ops_nokey;
 	struct module *owner;
 	char name[14];
 };
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
