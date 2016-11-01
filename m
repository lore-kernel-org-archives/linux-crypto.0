From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/16] crypto: api - Do not clear type bits in crypto_larval_lookup
Date: Wed, 02 Nov 2016 07:19:06 +0800
Message-ID: <E1c1iKg-0004C3-Rb@gondolin.me.apana.org.au>
References: <20161101231648.GA15967@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49118 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752119AbcKAXTJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Nov 2016 19:19:09 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
        by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
        id 1c1iKg-00073E-VD
        for <linux-crypto@vger.kernel.org>; Wed, 02 Nov 2016 10:19:07 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently all bits not set in mask are cleared in crypto_larval_lookup.
This is unnecessary as wherever the type bits are used it is always
masked anyway.

This patch removes the clearing so that we may use bits set in the
type but not in the mask for special purposes, e.g., picking up
internal algorithms.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/api.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/api.c b/crypto/api.c
index a88729f..b16ce16 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -211,8 +211,8 @@ struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask)
 	if (!name)
 		return ERR_PTR(-ENOENT);
 
+	type &= ~(CRYPTO_ALG_LARVAL | CRYPTO_ALG_DEAD);
 	mask &= ~(CRYPTO_ALG_LARVAL | CRYPTO_ALG_DEAD);
-	type &= mask;
 
 	alg = crypto_alg_lookup(name, type, mask);
 	if (!alg) {
