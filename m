From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 12/16] crypto: shash - Propagate reinit return value
Date: Thu, 09 Jul 2009 12:53:58 +0800
Message-ID: <E1MOldu-0005X9-H5@gondolin.me.apana.org.au>
References: <20090709045052.GA21092@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44870 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757463AbZGIEyA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jul 2009 00:54:00 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MOldu-0006Eo-PO
	for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2009 14:53:58 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: shash - Propagate reinit return value

This patch fixes crypto_shash_import to propagate the value returned
by reinit.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/shash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 7832310..23e05a1 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -180,7 +180,7 @@ int crypto_shash_import(struct shash_desc *desc, const u8 *in)
 	memcpy(shash_desc_ctx(desc), in, crypto_shash_descsize(tfm));
 
 	if (alg->reinit)
-		alg->reinit(desc);
+		return alg->reinit(desc);
 
 	return 0;
 }
