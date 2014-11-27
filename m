From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: algif_skcipher - Fixed blocking recvmsg
Date: Thu, 27 Nov 2014 22:38:12 +0800
Message-ID: <20141127143811.GA25283@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:52394 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaK0OiR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Nov 2014 09:38:17 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As most (all?) users of algif_skcipher are single-threaded and
therefore always write before reading from an algif_skcipher
socket, they never block and exercise that code-path.

It turns out that code path doesn't even work because we never
reload ctx->used after waking up so we never even see the new
data and immediately return an error (and a loud WARN_ON).
    
This patch fixes this by always reloading ctx->used.

Reported-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 3438996..f80e652 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -448,14 +448,13 @@ static int skcipher_recvmsg(struct kiocb *unused, struct socket *sock,
 			while (!sg->length)
 				sg++;
 
-			used = ctx->used;
-			if (!used) {
+			if (!ctx->used) {
 				err = skcipher_wait_for_data(sk, flags);
 				if (err)
 					goto unlock;
 			}
 
-			used = min_t(unsigned long, used, seglen);
+			used = min_t(unsigned long, ctx->used, seglen);
 
 			used = af_alg_make_sg(&ctx->rsgl, from, used, 1);
 			err = used;

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
