From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH stable 3.10.y 03/18] crypto: af_alg - Add nokey compatibility path
Date: Thu, 27 Oct 2016 17:29:36 +0300
Message-ID: <1477578591-28924-4-git-send-email-aryabinin@virtuozzo.com>
References: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>
To: Willy Tarreau <w@1wt.eu>, <stable@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ve1eur01on0122.outbound.protection.outlook.com ([104.47.1.122]:62542
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S942238AbcJ0QBU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Oct 2016 12:01:20 -0400
In-Reply-To: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 37766586c965d63758ad542325a96d5384f4a8c9 upstream.

This patch adds a compatibility path to support old applications
that do acept(2) before setkey.

Cc: stable@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
---
 crypto/af_alg.c         | 13 ++++++++++++-
 include/crypto/if_alg.h |  2 ++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 0ca108f..de130c2 100644
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
@@ -257,6 +259,7 @@ int af_alg_accept(struct sock *sk, struct socket *newsock)
 	const struct af_alg_type *type;
 	struct sock *sk2;
 	int err;
+	bool nokey;
 
 	lock_sock(sk);
 	type = ask->type;
@@ -275,12 +278,17 @@ int af_alg_accept(struct sock *sk, struct socket *newsock)
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
@@ -288,6 +296,9 @@ int af_alg_accept(struct sock *sk, struct socket *newsock)
 	newsock->ops = type->ops;
 	newsock->state = SS_CONNECTED;
 
+	if (nokey)
+		newsock->ops = type->ops_nokey;
+
 	err = 0;
 
 unlock:
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 2f38daa..9e6a2f3 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -51,8 +51,10 @@ struct af_alg_type {
 	void (*release)(void *private);
 	int (*setkey)(void *private, const u8 *key, unsigned int keylen);
 	int (*accept)(void *private, struct sock *sk);
+	int (*accept_nokey)(void *private, struct sock *sk);
 
 	struct proto_ops *ops;
+	struct proto_ops *ops_nokey;
 	struct module *owner;
 	char name[14];
 };
-- 
2.7.3
