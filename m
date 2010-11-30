From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: algif_skcipher - Handle unaligned receive buffer
Date: Tue, 30 Nov 2010 17:06:03 +0800
Message-ID: <20101130090603.GA28925@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Miloslav Trmac <mitr@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:43662 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab0K3JGF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 30 Nov 2010 04:06:05 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

This patch fixes unexpected EINVAL failures on recvmsg when
encrypting/decrypting due to unaligned receive buffers.

commit bc97e57eb21f8db55bf0e1f182d384e75b2e3c99
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Tue Nov 30 17:04:31 2010 +0800

    crypto: algif_skcipher - Handle unaligned receive buffer
    
    As it is if user-space passes through a receive buffer that's not
    aligned to to the cipher block size, we'll end up encrypting or
    decrypting a partial block which causes a spurious EINVAL to be
    returned.
    
    This patch fixes this by moving the partial block test after the
    af_alg_make_sg call.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 1f33480..6a6dfc0 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -454,17 +454,17 @@ static int skcipher_recvmsg(struct kiocb *unused, struct socket *sock,
 
 			used = min_t(unsigned long, used, seglen);
 
+			used = af_alg_make_sg(&ctx->rsgl, from, used, 1);
+			err = used;
+			if (err < 0)
+				goto unlock;
+
 			if (ctx->more || used < ctx->used)
 				used -= used % bs;
 
 			err = -EINVAL;
 			if (!used)
-				goto unlock;
-
-			used = af_alg_make_sg(&ctx->rsgl, from, used, 1);
-			err = used;
-			if (err < 0)
-				goto unlock;
+				goto free;
 
 			ablkcipher_request_set_crypt(&ctx->req, sg,
 						     ctx->rsgl.sg, used,
@@ -476,6 +476,7 @@ static int skcipher_recvmsg(struct kiocb *unused, struct socket *sock,
 					crypto_ablkcipher_decrypt(&ctx->req),
 				&ctx->completion);
 
+free:
 			af_alg_free_sg(&ctx->rsgl);
 
 			if (err)

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
