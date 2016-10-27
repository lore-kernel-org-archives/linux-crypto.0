From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH stable 3.10.y 14/18] crypto: algif_skcipher - Fix race condition in skcipher_check_key
Date: Thu, 27 Oct 2016 17:29:47 +0300
Message-ID: <1477578591-28924-15-git-send-email-aryabinin@virtuozzo.com>
References: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>
To: Willy Tarreau <w@1wt.eu>, <stable@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ve1eur01on0103.outbound.protection.outlook.com ([104.47.1.103]:14496
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934208AbcJ0RCY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Oct 2016 13:02:24 -0400
In-Reply-To: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 1822793a523e5d5730b19cc21160ff1717421bc8 upstream.

We need to lock the child socket in skcipher_check_key as otherwise
two simultaneous calls can cause the parent socket to be freed.

Cc: stable@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
---
 crypto/algif_skcipher.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index a7800b7..13fd26e 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -551,22 +551,23 @@ static struct proto_ops algif_skcipher_ops = {
 
 static int skcipher_check_key(struct socket *sock)
 {
-	int err;
+	int err = 0;
 	struct sock *psk;
 	struct alg_sock *pask;
 	struct skcipher_tfm *tfm;
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
 
+	lock_sock(sk);
 	if (ask->refcnt)
-		return 0;
+		goto unlock_child;
 
 	psk = ask->parent;
 	pask = alg_sk(ask->parent);
 	tfm = pask->private;
 
 	err = -ENOKEY;
-	lock_sock(psk);
+	lock_sock_nested(psk, SINGLE_DEPTH_NESTING);
 	if (!tfm->has_key)
 		goto unlock;
 
@@ -580,6 +581,8 @@ static int skcipher_check_key(struct socket *sock)
 
 unlock:
 	release_sock(psk);
+unlock_child:
+	release_sock(sk);
 
 	return err;
 }
-- 
2.7.3
