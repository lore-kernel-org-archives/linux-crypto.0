From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 1/2] crypto: algif_hash - Fix race condition in
 hash_check_key
Date: Fri, 15 Jan 2016 22:01:08 +0800
Message-ID: <20160115140108.GA31859@gondor.apana.org.au>
References: <CACT4Y+ap-GiGRjwWr9kDwMNwQOg5TbJfi8kGD2H2Qv5SBrQK4Q@mail.gmail.com>
 <20160114141341.GA21300@gondor.apana.org.au>
 <CACT4Y+bEJ4iVqUB8yFT=7bHgyaQmFQUq08kEa8Wp_poj5Mthog@mail.gmail.com>
 <20160115135900.GA31813@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	syzkaller <syzkaller@googlegroups.com>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Sasha Levin <sasha.levin@oracle.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56818 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbcAOOBM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Jan 2016 09:01:12 -0500
Content-Disposition: inline
In-Reply-To: <20160115135900.GA31813@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We need to lock the child socket in hash_check_key as otherwise
two simultaneous calls can cause the parent socket to be freed.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 46637be..0557e62 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -242,22 +242,23 @@ static struct proto_ops algif_hash_ops = {
 
 static int hash_check_key(struct socket *sock)
 {
-	int err;
+	int err = 0;
 	struct sock *psk;
 	struct alg_sock *pask;
 	struct algif_hash_tfm *tfm;
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
 
@@ -271,6 +272,8 @@ static int hash_check_key(struct socket *sock)
 
 unlock:
 	release_sock(psk);
+unlock_child:
+	release_sock(sk);
 
 	return err;
 }
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
