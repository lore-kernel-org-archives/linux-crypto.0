From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/4] [CRYPTO] authenc: Fix hash verification
Date: Sun, 02 Dec 2007 18:53:11 +1100
Message-ID: <E1IyjdX-0001XC-00@gondolin.me.apana.org.au>
References: <20071122083656.GB7368@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2738 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751840AbXLBHxN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 2 Dec 2007 02:53:13 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1IyjdX-00089X-Vk
	for <linux-crypto@vger.kernel.org>; Sun, 02 Dec 2007 18:53:12 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] authenc: Fix hash verification

The previous code incorrectly included the hash in the verification which
also meant that we'd crash and burn when it comes to actually verifying
the hash since we'd go past the end of the SG list.

This patch fixes that by subtracting authsize from cryptlen at the start.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/authenc.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -174,6 +174,11 @@ static int crypto_authenc_verify(struct 
 	unsigned int authsize;
 	int err;
 
+	authsize = crypto_aead_authsize(authenc);
+	if (cryptlen < authsize)
+		return -EINVAL;
+	cryptlen -= authsize;
+
 	ohash = (u8 *)ALIGN((unsigned long)ohash + crypto_hash_alignmask(auth), 
 			    crypto_hash_alignmask(auth) + 1);
 	ihash = ohash + crypto_hash_digestsize(auth);
@@ -198,7 +203,6 @@ auth_unlock:
 	if (err)
 		return err;
 
-	authsize = crypto_aead_authsize(authenc);
 	scatterwalk_map_and_copy(ihash, src, cryptlen, authsize, 0);
 	return memcmp(ihash, ohash, authsize) ? -EINVAL : 0;
 }
