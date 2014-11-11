From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 2/2] crypto: AF_ALG - zeroize IV buffer
Date: Tue, 11 Nov 2014 05:37:57 +0100
Message-ID: <1988935.aEo2Rr1ofd@tachyon.chronox.de>
References: <1503070.D5VR9iy8Cm@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: 'Sandy Harris' <sandyinchina@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:54323 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbaKKEid (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Nov 2014 23:38:33 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S63BF> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Tue, 11 Nov 2014 05:38:29 +0100
In-Reply-To: <1503070.D5VR9iy8Cm@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Zeroize the buffer holding the IV used for the completed
cipher operation before the buffer is released by the
skcipher AF_ALG interface handler.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_skcipher.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 83187f4..85e3bdb 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -566,6 +566,7 @@ static void skcipher_sock_destruct(struct sock *sk)
 	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(&ctx->req);
 
 	skcipher_free_sgl(sk);
+	memzero_explicit(ctx->iv, crypto_ablkcipher_ivsize(tfm));
 	sock_kfree_s(sk, ctx->iv, crypto_ablkcipher_ivsize(tfm));
 	sock_kfree_s(sk, ctx, ctx->len);
 	af_alg_release_parent(sk);
-- 
2.1.0
