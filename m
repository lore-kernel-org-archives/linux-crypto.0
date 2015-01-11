From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 3/6] crypto: sparc64/camellia - fix module alias
Date: Sun, 11 Jan 2015 18:17:44 +0100
Message-ID: <1420996667-31693-4-git-send-email-minipli@googlemail.com>
References: <1420996667-31693-1-git-send-email-minipli@googlemail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:44627 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbbAKRSO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 11 Jan 2015 12:18:14 -0500
Received: by mail-wg0-f45.google.com with SMTP id b13so15719692wgh.4
        for <linux-crypto@vger.kernel.org>; Sun, 11 Jan 2015 09:18:13 -0800 (PST)
In-Reply-To: <1420996667-31693-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The module alias should be "camellia", not "aes".

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/sparc/crypto/camellia_glue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/crypto/camellia_glue.c b/arch/sparc/crypto/camellia_glue.c
index 641f55cb61c3..6bf2479a12fb 100644
--- a/arch/sparc/crypto/camellia_glue.c
+++ b/arch/sparc/crypto/camellia_glue.c
@@ -322,6 +322,6 @@ module_exit(camellia_sparc64_mod_fini);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Camellia Cipher Algorithm, sparc64 camellia opcode accelerated");
 
-MODULE_ALIAS_CRYPTO("aes");
+MODULE_ALIAS_CRYPTO("camellia");
 
 #include "crop_devid.c"
-- 
1.7.10.4
