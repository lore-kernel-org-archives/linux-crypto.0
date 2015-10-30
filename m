From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: algif_hash - Only export and import on sockets with data
Date: Fri, 30 Oct 2015 20:16:51 +0800
Message-ID: <20151030121651.GA23757@gondor.apana.org.au>
References: <CAFXBA=mVmRsAk3fuyjf3WA-P+0dHKu0upUdb5Qxr0kwn1rKiDw@mail.gmail.com>
 <28376488.AMz6xlEXXD@tauon.atsec.com>
 <CAFXBA==pRTY57SkfPRnW_6MVRUJ0J8Uwi+Bigxtk21WNhvY3jA@mail.gmail.com>
 <3576256.SqRabKS4lK@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harsh Jain <harshjain.prof@gmail.com>, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60474 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031011AbbJ3MQ5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Oct 2015 08:16:57 -0400
Content-Disposition: inline
In-Reply-To: <3576256.SqRabKS4lK@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 30, 2015 at 12:10:51PM +0100, Stephan Mueller wrote:
> Am Freitag, 30. Oktober 2015, 14:02:27 schrieb Harsh Jain:
> 
> Hi Harsh,
> 
> >Hi Stephan,
> >
> >If we add sendmsg() in between 2 accept calls then the setkey problem
> >will happen?
> >
> >handle->opfd = accept(handle->tfmfd, NULL, 0);
> >sendmsg()
> >handle->opfd = accept(handle->opfd, NULL, 0);
> >sendmsg()
> >handle->opfd = accept(handle->opfd, NULL, 0);
> 
> Without testing, I would very much expect that, because the setkey does not 
> apply to the subordinate tfm.

setkey should be needed as the subsequent accept will all be based
on the same parent fd, meaning that they will all use a single tfm.

Please try the following patch.

---8<---
The hash_accept call fails to work on sockets that have not received
any data.  For some algorithm implementations it may cause crashes.

This patch fixes this by ensuring that we only export and import on
sockets that have received data.

Cc: stable@vger.kernel.org
Reported-by: Harsh Jain <harshjain.prof@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 1396ad0..bbda6b4 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -181,11 +181,14 @@ static int hash_accept(struct socket *sock, struct socket *newsock, int flags)
 	struct sock *sk2;
 	struct alg_sock *ask2;
 	struct hash_ctx *ctx2;
+	bool more = ctx->more;
 	int err;
 
-	err = crypto_ahash_export(req, state);
-	if (err)
-		return err;
+	if (more) {
+		err = crypto_ahash_export(req, state);
+		if (err)
+			return err;
+	}
 
 	err = af_alg_accept(ask->parent, newsock);
 	if (err)
@@ -194,12 +197,14 @@ static int hash_accept(struct socket *sock, struct socket *newsock, int flags)
 	sk2 = newsock->sk;
 	ask2 = alg_sk(sk2);
 	ctx2 = ask2->private;
-	ctx2->more = 1;
+	ctx2->more = more;
 
-	err = crypto_ahash_import(&ctx2->req, state);
-	if (err) {
-		sock_orphan(sk2);
-		sock_put(sk2);
+	if (more) {
+		err = crypto_ahash_import(&ctx2->req, state);
+		if (err) {
+			sock_orphan(sk2);
+			sock_put(sk2);
+		}
 	}
 
 	return err;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
