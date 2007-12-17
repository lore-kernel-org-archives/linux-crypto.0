From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/8] [CRYPTO] ccm: Fix construction of rfc4309 algorithm
Date: Mon, 17 Dec 2007 18:31:13 +0800
Message-ID: <E1J4DFh-00038i-00@gondolin.me.apana.org.au>
References: <20071217103037.GA11988@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4829 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758917AbXLQKbP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Dec 2007 05:31:15 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J4DFi-0008V6-5m
	for <linux-crypto@vger.kernel.org>; Mon, 17 Dec 2007 21:31:14 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] ccm: Fix construction of rfc4309 algorithm

There is a silly typo in the rfc4309 construction that refers to a
blkcipher when it should be aead.  This broke the allocation of rfc4309
algorithms.

This patch fixes that and removes a duplicate type checking at the
start of that same function.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ccm.c |    6 +-----
 1 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index 7ca2519..8c7d3b7 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -728,10 +728,6 @@ static struct crypto_instance *crypto_rfc4309_alloc(struct rtattr **tb)
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return ERR_PTR(-EINVAL);
 
-	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_AEAD);
-	if (err)
-		return ERR_PTR(err);
-
 	ccm_name = crypto_attr_alg_name(tb[1]);
 	err = PTR_ERR(ccm_name);
 	if (IS_ERR(ccm_name))
@@ -753,7 +749,7 @@ static struct crypto_instance *crypto_rfc4309_alloc(struct rtattr **tb)
 	err = -EINVAL;
 
 	/* We only support 16-byte blocks. */
-	if (alg->cra_blkcipher.ivsize != 16)
+	if (alg->cra_aead.ivsize != 16)
 		goto out_drop_alg;
 
 	/* Not a stream cipher? */
