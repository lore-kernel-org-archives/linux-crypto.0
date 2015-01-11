From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 6/6] crypto: x86/des3_ede - drop bogus module aliases
Date: Sun, 11 Jan 2015 18:17:47 +0100
Message-ID: <1420996667-31693-7-git-send-email-minipli@googlemail.com>
References: <1420996667-31693-1-git-send-email-minipli@googlemail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:64157 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbbAKRSQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 11 Jan 2015 12:18:16 -0500
Received: by mail-wg0-f51.google.com with SMTP id x12so15698529wgg.10
        for <linux-crypto@vger.kernel.org>; Sun, 11 Jan 2015 09:18:15 -0800 (PST)
In-Reply-To: <1420996667-31693-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This module implements variations of "des3_ede" only. Drop the bogus
module aliases for "des".

Cc: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/x86/crypto/des3_ede_glue.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/crypto/des3_ede_glue.c b/arch/x86/crypto/des3_ede_glue.c
index 38a14f818ef1..d6fc59aaaadf 100644
--- a/arch/x86/crypto/des3_ede_glue.c
+++ b/arch/x86/crypto/des3_ede_glue.c
@@ -504,6 +504,4 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Triple DES EDE Cipher Algorithm, asm optimized");
 MODULE_ALIAS_CRYPTO("des3_ede");
 MODULE_ALIAS_CRYPTO("des3_ede-asm");
-MODULE_ALIAS_CRYPTO("des");
-MODULE_ALIAS_CRYPTO("des-asm");
 MODULE_AUTHOR("Jussi Kivilinna <jussi.kivilinna@iki.fi>");
-- 
1.7.10.4
