Return-Path: <SRS0=nn+h=7V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23FA7C433DF
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Jun 2020 06:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0818C2076A
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Jun 2020 06:48:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbgFHGs6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Jun 2020 02:48:58 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53962 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728053AbgFHGs6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Jun 2020 02:48:58 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jiBaN-0001q9-Am; Mon, 08 Jun 2020 16:48:44 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 08 Jun 2020 16:48:43 +1000
Date:   Mon, 8 Jun 2020 16:48:43 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Mauricio Faria de Oliveira <mfo@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: [v2 PATCH] crypto: af_alg - fix use-after-free in af_alg_accept()
 due to bh_lock_sock()
Message-ID: <20200608064843.GA22167@gondor.apana.org.au>
References: <20200605161657.535043-1-mfo@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605161657.535043-1-mfo@canonical.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 05, 2020 at 01:16:57PM -0300, Mauricio Faria de Oliveira wrote:
> This patch fixes a regression from commit 37f96694cf73 ("crypto: af_alg
>  - Use bh_lock_sock in sk_destruct"), which allows the critical regions
> of af_alg_accept() and af_alg_release_parent() to run concurrently.

Thanks a lot for tracking this down.  I think we don't need something
as complicated as backlog processing used by TCP.  We could simply
change the ref counts to atomic_t and get rid of the locking.

---8<---
The locking in af_alg_release_parent is broken as the BH socket
lock can only be taken if there is a code-path to handle the case
where the lock is owned by process-context.  Instead of adding
such handling, we can fix this by changing the ref counts to
atomic_t.

This patch also modifies the main refcnt to include both normal
and nokey sockets.  This way we don't have to fudge the nokey
ref count when a socket changes from nokey to normal.

Credits go to Mauricio Faria de Oliveira who diagnosed this bug
and sent a patch for it:

https://lore.kernel.org/linux-crypto/20200605161657.535043-1-mfo@canonical.com/

Reported-by: Brian Moyles <bmoyles@netflix.com>
Reported-by: Mauricio Faria de Oliveira <mfo@canonical.com>
Fixes: 37f96694cf73 ("crypto: af_alg - Use bh_lock_sock in...")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index b1cd3535c525..28fc323e3fe3 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -128,21 +128,15 @@ EXPORT_SYMBOL_GPL(af_alg_release);
 void af_alg_release_parent(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
-	unsigned int nokey = ask->nokey_refcnt;
-	bool last = nokey && !ask->refcnt;
+	unsigned int nokey = atomic_read(&ask->nokey_refcnt);
 
 	sk = ask->parent;
 	ask = alg_sk(sk);
 
-	local_bh_disable();
-	bh_lock_sock(sk);
-	ask->nokey_refcnt -= nokey;
-	if (!last)
-		last = !--ask->refcnt;
-	bh_unlock_sock(sk);
-	local_bh_enable();
+	if (nokey)
+		atomic_dec(&ask->nokey_refcnt);
 
-	if (last)
+	if (atomic_dec_and_test(&ask->refcnt))
 		sock_put(sk);
 }
 EXPORT_SYMBOL_GPL(af_alg_release_parent);
@@ -187,7 +181,7 @@ static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 
 	err = -EBUSY;
 	lock_sock(sk);
-	if (ask->refcnt | ask->nokey_refcnt)
+	if (atomic_read(&ask->refcnt))
 		goto unlock;
 
 	swap(ask->type, type);
@@ -236,7 +230,7 @@ static int alg_setsockopt(struct socket *sock, int level, int optname,
 	int err = -EBUSY;
 
 	lock_sock(sk);
-	if (ask->refcnt)
+	if (atomic_read(&ask->refcnt) != atomic_read(&ask->nokey_refcnt))
 		goto unlock;
 
 	type = ask->type;
@@ -301,12 +295,14 @@ int af_alg_accept(struct sock *sk, struct socket *newsock, bool kern)
 	if (err)
 		goto unlock;
 
-	if (nokey || !ask->refcnt++)
+	if (atomic_inc_return_relaxed(&ask->refcnt) == 1)
 		sock_hold(sk);
-	ask->nokey_refcnt += nokey;
+	if (nokey) {
+		atomic_inc(&ask->nokey_refcnt);
+		atomic_set(&alg_sk(sk2)->nokey_refcnt, 1);
+	}
 	alg_sk(sk2)->parent = sk;
 	alg_sk(sk2)->type = type;
-	alg_sk(sk2)->nokey_refcnt = nokey;
 
 	newsock->ops = type->ops;
 	newsock->state = SS_CONNECTED;
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index eb1910b6d434..0ae000a61c7f 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -384,7 +384,7 @@ static int aead_check_key(struct socket *sock)
 	struct alg_sock *ask = alg_sk(sk);
 
 	lock_sock(sk);
-	if (ask->refcnt)
+	if (!atomic_read(&ask->nokey_refcnt))
 		goto unlock_child;
 
 	psk = ask->parent;
@@ -396,11 +396,8 @@ static int aead_check_key(struct socket *sock)
 	if (crypto_aead_get_flags(tfm->aead) & CRYPTO_TFM_NEED_KEY)
 		goto unlock;
 
-	if (!pask->refcnt++)
-		sock_hold(psk);
-
-	ask->refcnt = 1;
-	sock_put(psk);
+	atomic_dec(&pask->nokey_refcnt);
+	atomic_set(&ask->nokey_refcnt, 0);
 
 	err = 0;
 
diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index da1ffa4f7f8d..e71727c25a7d 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -301,7 +301,7 @@ static int hash_check_key(struct socket *sock)
 	struct alg_sock *ask = alg_sk(sk);
 
 	lock_sock(sk);
-	if (ask->refcnt)
+	if (!atomic_read(&ask->nokey_refcnt))
 		goto unlock_child;
 
 	psk = ask->parent;
@@ -313,11 +313,8 @@ static int hash_check_key(struct socket *sock)
 	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		goto unlock;
 
-	if (!pask->refcnt++)
-		sock_hold(psk);
-
-	ask->refcnt = 1;
-	sock_put(psk);
+	atomic_dec(&pask->nokey_refcnt);
+	atomic_set(&ask->nokey_refcnt, 0);
 
 	err = 0;
 
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index e2c8ab408bed..ab97b6c7b81d 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -215,7 +215,7 @@ static int skcipher_check_key(struct socket *sock)
 	struct alg_sock *ask = alg_sk(sk);
 
 	lock_sock(sk);
-	if (ask->refcnt)
+	if (!atomic_read(&ask->nokey_refcnt))
 		goto unlock_child;
 
 	psk = ask->parent;
@@ -227,11 +227,8 @@ static int skcipher_check_key(struct socket *sock)
 	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		goto unlock;
 
-	if (!pask->refcnt++)
-		sock_hold(psk);
-
-	ask->refcnt = 1;
-	sock_put(psk);
+	atomic_dec(&pask->nokey_refcnt);
+	atomic_set(&ask->nokey_refcnt, 0);
 
 	err = 0;
 
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 56527c85d122..088c1ded2714 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -29,8 +29,8 @@ struct alg_sock {
 
 	struct sock *parent;
 
-	unsigned int refcnt;
-	unsigned int nokey_refcnt;
+	atomic_t refcnt;
+	atomic_t nokey_refcnt;
 
 	const struct af_alg_type *type;
 	void *private;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
