From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: af_alg - Forbid the use internal algorithms
Date: Mon, 22 Jun 2015 10:14:19 +0800
Message-ID: <20150622021419.GA5782@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52893 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbbFVCO0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 21 Jun 2015 22:14:26 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The bit CRYPTO_ALG_INTERNAL was added to stop af_alg from accessing
internal algorithms.  However, af_alg itself was never modified to
actually stop that bit from being used by the user.  Therefore the
user could always override it by specifying the relevant bit in the
type and/or mask.

This patch silently discards the bit in both type and mask.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/af_alg.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index f22cc56..2bc180e 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -127,6 +127,7 @@ EXPORT_SYMBOL_GPL(af_alg_release);
 
 static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 {
+	const u32 forbidden = CRYPTO_ALG_INTERNAL;
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
 	struct sockaddr_alg *sa = (void *)uaddr;
@@ -151,7 +152,9 @@ static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	if (IS_ERR(type))
 		return PTR_ERR(type);
 
-	private = type->bind(sa->salg_name, sa->salg_feat, sa->salg_mask);
+	private = type->bind(sa->salg_name,
+			     sa->salg_feat & ~forbidden,
+			     sa->salg_mask & ~forbidden);
 	if (IS_ERR(private)) {
 		module_put(type->owner);
 		return PTR_ERR(private);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
