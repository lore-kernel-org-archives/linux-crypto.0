From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 2/6] crypto: sparc64/aes - fix module description
Date: Sun, 11 Jan 2015 18:17:43 +0100
Message-ID: <1420996667-31693-3-git-send-email-minipli@googlemail.com>
References: <1420996667-31693-1-git-send-email-minipli@googlemail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:39408 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbbAKRSO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 11 Jan 2015 12:18:14 -0500
Received: by mail-wg0-f48.google.com with SMTP id l2so15746629wgh.7
        for <linux-crypto@vger.kernel.org>; Sun, 11 Jan 2015 09:18:12 -0800 (PST)
In-Reply-To: <1420996667-31693-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

AES is a block cipher, not a hash.

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/sparc/crypto/aes_glue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/crypto/aes_glue.c b/arch/sparc/crypto/aes_glue.c
index 705408766ab0..2e48eb8813ff 100644
--- a/arch/sparc/crypto/aes_glue.c
+++ b/arch/sparc/crypto/aes_glue.c
@@ -497,7 +497,7 @@ module_init(aes_sparc64_mod_init);
 module_exit(aes_sparc64_mod_fini);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("AES Secure Hash Algorithm, sparc64 aes opcode accelerated");
+MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm, sparc64 aes opcode accelerated");
 
 MODULE_ALIAS_CRYPTO("aes");
 
-- 
1.7.10.4
