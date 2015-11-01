From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v2] crypto: algif_hash - Only export and import on sockets
 with data
Date: Sun, 1 Nov 2015 17:11:19 +0800
Message-ID: <20151101091119.GA3035@gondor.apana.org.au>
References: <CAFXBA=mVmRsAk3fuyjf3WA-P+0dHKu0upUdb5Qxr0kwn1rKiDw@mail.gmail.com>
 <3576256.SqRabKS4lK@tauon.atsec.com>
 <20151030121651.GA23757@gondor.apana.org.au>
 <2587504.xtsMOV5mei@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harsh Jain <harshjain.prof@gmail.com>, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41146 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbbKAJL1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 1 Nov 2015 04:11:27 -0500
Content-Disposition: inline
In-Reply-To: <2587504.xtsMOV5mei@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Oct 31, 2015 at 12:45:47AM +0100, Stephan Mueller wrote:
> 
> Testing complete: patch solves the oops and allows to successfully perform 
> HMAC even when having subsequent accepts and operating on those subsequent 
> accepts.

Thanks Stephan!

Unfortunately my patch is incomplete as some other thread could
change ctx->more while we're in the middle of the accept call.

So here is an updated version.

---8<---
The hash_accept call fails to work on sockets that have not received
any data.  For some algorithm implementations it may cause crashes.

This patch fixes this by ensuring that we only export and import on
sockets that have received data.

Cc: stable@vger.kernel.org
Reported-by: Harsh Jain <harshjain.prof@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 1396ad0..b4c24fe 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -181,9 +181,14 @@ static int hash_accept(struct socket *sock, struct socket *newsock, int flags)
 	struct sock *sk2;
 	struct alg_sock *ask2;
 	struct hash_ctx *ctx2;
+	bool more;
 	int err;
 
-	err = crypto_ahash_export(req, state);
+	lock_sock(sk);
+	more = ctx->more;
+	err = more ? crypto_ahash_export(req, state) : 0;
+	release_sock(sk);
+
 	if (err)
 		return err;
 
@@ -194,7 +199,10 @@ static int hash_accept(struct socket *sock, struct socket *newsock, int flags)
 	sk2 = newsock->sk;
 	ask2 = alg_sk(sk2);
 	ctx2 = ask2->private;
-	ctx2->more = 1;
+	ctx2->more = more;
+
+	if (!more)
+		return err;
 
 	err = crypto_ahash_import(&ctx2->req, state);
 	if (err) {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
