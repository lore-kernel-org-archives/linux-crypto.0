From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH stable 3.10.y 09/18] crypto: af_alg - Allow af_af_alg_release_parent to be called on nokey path
Date: Thu, 27 Oct 2016 17:29:42 +0300
Message-ID: <1477578591-28924-10-git-send-email-aryabinin@virtuozzo.com>
References: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>
To: Willy Tarreau <w@1wt.eu>, <stable@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ve1eur01on0102.outbound.protection.outlook.com ([104.47.1.102]:36000
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S936570AbcJ0QEO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Oct 2016 12:04:14 -0400
In-Reply-To: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 6a935170a980024dd29199e9dbb5c4da4767a1b9 upstream.

This patch allows af_alg_release_parent to be called even for
nokey sockets.

Cc: stable@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
---
 crypto/af_alg.c         | 9 ++++++++-
 include/crypto/if_alg.h | 1 +
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index de130c2..2f8fd84 100644
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
@@ -258,8 +264,8 @@ int af_alg_accept(struct sock *sk, struct socket *newsock)
 	struct alg_sock *ask = alg_sk(sk);
 	const struct af_alg_type *type;
 	struct sock *sk2;
+	unsigned int nokey;
 	int err;
-	bool nokey;
 
 	lock_sock(sk);
 	type = ask->type;
@@ -292,6 +298,7 @@ int af_alg_accept(struct sock *sk, struct socket *newsock)
 		sock_hold(sk);
 	alg_sk(sk2)->parent = sk;
 	alg_sk(sk2)->type = type;
+	alg_sk(sk2)->nokey_refcnt = nokey;
 
 	newsock->ops = type->ops;
 	newsock->state = SS_CONNECTED;
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 9e6a2f3..bfefd81 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -31,6 +31,7 @@ struct alg_sock {
 	struct sock *parent;
 
 	unsigned int refcnt;
+	unsigned int nokey_refcnt;
 
 	const struct af_alg_type *type;
 	void *private;
-- 
2.7.3
