Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C6BC76196
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Mar 2023 03:55:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbjC1Dz0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Mar 2023 23:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232487AbjC1Dy5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Mar 2023 23:54:57 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB55C7
        for <linux-crypto@vger.kernel.org>; Mon, 27 Mar 2023 20:54:30 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1ph0Pg-009OVH-QA; Tue, 28 Mar 2023 11:54:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Mar 2023 11:54:24 +0800
Date:   Tue, 28 Mar 2023 11:54:24 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas BOURGOIN <thomas.bourgoin@foss.st.com>
Subject: [PATCH] crypto: algif_hash - Allocate hash state with kmalloc
Message-ID: <ZCJk8JQV+0N3VwPS@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Allocating the hash state on the stack limits its size.  Change
this to use kmalloc so the limit can be removed for new drivers.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 1d017ec5c63c..63af72e19fa8 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -235,24 +235,31 @@ static int hash_accept(struct socket *sock, struct socket *newsock, int flags,
 	struct alg_sock *ask = alg_sk(sk);
 	struct hash_ctx *ctx = ask->private;
 	struct ahash_request *req = &ctx->req;
-	char state[HASH_MAX_STATESIZE];
+	struct crypto_ahash *tfm;
 	struct sock *sk2;
 	struct alg_sock *ask2;
 	struct hash_ctx *ctx2;
+	char *state;
 	bool more;
 	int err;
 
+	tfm = crypto_ahash_reqtfm(req);
+	state = kmalloc(crypto_ahash_statesize(tfm), GFP_KERNEL);
+	err = -ENOMEM;
+	if (!state)
+		goto out;
+
 	lock_sock(sk);
 	more = ctx->more;
 	err = more ? crypto_ahash_export(req, state) : 0;
 	release_sock(sk);
 
 	if (err)
-		return err;
+		goto out_free_state;
 
 	err = af_alg_accept(ask->parent, newsock, kern);
 	if (err)
-		return err;
+		goto out_free_state;
 
 	sk2 = newsock->sk;
 	ask2 = alg_sk(sk2);
@@ -260,7 +267,7 @@ static int hash_accept(struct socket *sock, struct socket *newsock, int flags,
 	ctx2->more = more;
 
 	if (!more)
-		return err;
+		goto out_free_state;
 
 	err = crypto_ahash_import(&ctx2->req, state);
 	if (err) {
@@ -268,6 +275,10 @@ static int hash_accept(struct socket *sock, struct socket *newsock, int flags,
 		sock_put(sk2);
 	}
 
+out_free_state:
+	kfree_sensitive(state);
+
+out:
 	return err;
 }
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
