From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: algif_skcipher - Pass on error from af_alg_make_sg
Date: Sun, 28 Nov 2010 16:29:36 +0800
Message-ID: <20101128082936.GA9427@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:53622 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab0K1I3i (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 28 Nov 2010 03:29:38 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by fornost.hengli.com.au with esmtp (Exim 4.69 #1 (Debian))
	id 1PMcdc-0001yD-Sv
	for <linux-crypto@vger.kernel.org>; Sun, 28 Nov 2010 19:29:36 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 4.69)
	(envelope-from <herbert@gondor.apana.org.au>)
	id 1PMcdc-0002SL-Pc
	for linux-crypto@vger.kernel.org; Sun, 28 Nov 2010 16:29:36 +0800
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

The error from af_alg_make_sg was lost unintentionally.

commit c762be637503b833012457087133c1292fd6056d
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Sun Nov 28 16:28:01 2010 +0800

    crypto: algif_skcipher - Pass on error from af_alg_make_sg
    
    The error returned from af_alg_make_sg is currently lost and we
    always pass on -EINVAL.  This patch pases on the underlying error.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 211c956..9b2f440 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -472,7 +472,8 @@ static int skcipher_recvmsg(struct kiocb *unused, struct socket *sock,
 				goto unlock;
 
 			used = af_alg_make_sg(&ctx->rsgl, from, used, 1);
-			if (used < 0)
+			err = used;
+			if (err < 0)
 				goto unlock;
 
 			ablkcipher_request_set_crypt(&ctx->req, sg,

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
