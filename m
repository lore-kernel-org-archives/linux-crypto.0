From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/2] crypto: algif_skcipher - Fix race condition in
 skcipher_check_key
Date: Thu, 14 Jan 2016 22:16:18 +0800
Message-ID: <20160114141618.GB21348@gondor.apana.org.au>
References: <CACT4Y+ap-GiGRjwWr9kDwMNwQOg5TbJfi8kGD2H2Qv5SBrQK4Q@mail.gmail.com>
 <20160114141341.GA21300@gondor.apana.org.au>
 <20160114141528.GA21348@gondor.apana.org.au>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:36570 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbcANOQV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Jan 2016 09:16:21 -0500
Content-Disposition: inline
In-Reply-To: <20160114141528.GA21348@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We need to lock the child socket in skcipher_check_key as otherwise
two simultaneous calls can cause the parent socket to be freed.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 39df2a9..5772c0b 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -755,15 +755,16 @@ static struct proto_ops algif_skcipher_ops = {
 
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
@@ -784,6 +785,8 @@ static int skcipher_check_key(struct socket *sock)
 
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
