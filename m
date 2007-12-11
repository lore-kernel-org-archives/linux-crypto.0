From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/8] [CRYPTO] authenc: Use RTA_OK to check length
Date: Tue, 11 Dec 2007 11:50:20 +0800
Message-ID: <E1J1w8S-0002eC-00@gondolin.me.apana.org.au>
References: <20071211034945.GA10099@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1769 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751775AbXLKDuY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Dec 2007 22:50:24 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J1w8T-0005pF-IZ
	for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2007 14:50:21 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] authenc: Use RTA_OK to check length

This patch changes setkey to use RTA_OK to check the validity of the
setkey request.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/authenc.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 80d9d0b..aa442de 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -44,7 +44,7 @@ static int crypto_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
 	struct crypto_authenc_key_param *param;
 	int err = -EINVAL;
 
-	if (keylen < sizeof(*rta))
+	if (!RTA_OK(rta, keylen))
 		goto badkey;
 	if (rta->rta_type != CRYPTO_AUTHENC_KEYA_PARAM)
 		goto badkey;
