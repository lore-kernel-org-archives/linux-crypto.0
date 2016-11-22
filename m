From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 5/16] crypto: api - Do not clear type bits in crypto_larval_lookup
Date: Tue, 22 Nov 2016 20:08:21 +0800
Message-ID: <E1c99s5-00037q-8C@gondobar>
References: <20161122120703.GA11911@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33662 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932698AbcKVMIc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2016 07:08:32 -0500
Received: from [192.168.128.4] (helo=gondobar)
        by fornost.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
        id 1c99sC-00060k-3I
        for <linux-crypto@vger.kernel.org>; Tue, 22 Nov 2016 23:08:29 +1100
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
