From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/8] [CRYPTO] ccm: Fix crash in rfc4309_setkey
Date: Mon, 17 Dec 2007 18:31:16 +0800
Message-ID: <E1J4DFk-000393-00@gondolin.me.apana.org.au>
References: <20071217103037.GA11988@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4836 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760167AbXLQKbT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Dec 2007 05:31:19 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J4DFl-0008VK-F6
	for <linux-crypto@vger.kernel.org>; Mon, 17 Dec 2007 21:31:17 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] ccm: Fix crash in rfc4309_setkey

The nonce is being extracted from the wrong place due to the incorrect
placement of the keylen adjustment.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ccm.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index 8c7d3b7..82bcc14 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -630,7 +630,7 @@ static int crypto_rfc4309_setkey(struct crypto_aead *parent, const u8 *key,
 		return -EINVAL;
 
 	keylen -= 3;
-	memcpy(ctx->nonce, key + keylen - 3, 3);
+	memcpy(ctx->nonce, key + keylen, 3);
 
 	crypto_aead_clear_flags(child, CRYPTO_TFM_REQ_MASK);
 	crypto_aead_set_flags(child, crypto_aead_get_flags(parent) &
