From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 4/6] crypto: sparc64/des - add "des3_ede" module alias
Date: Sun, 11 Jan 2015 18:17:45 +0100
Message-ID: <1420996667-31693-5-git-send-email-minipli@googlemail.com>
References: <1420996667-31693-1-git-send-email-minipli@googlemail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:63918 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbbAKRSP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 11 Jan 2015 12:18:15 -0500
Received: by mail-wi0-f179.google.com with SMTP id ex7so10642296wid.0
        for <linux-crypto@vger.kernel.org>; Sun, 11 Jan 2015 09:18:14 -0800 (PST)
In-Reply-To: <1420996667-31693-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This module provides implementations for "des3_ede", too. Announce those
via an appropriate crypto module alias so it can be used in favour to
the generic C implementation.

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/sparc/crypto/des_glue.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sparc/crypto/des_glue.c b/arch/sparc/crypto/des_glue.c
index d11500972994..dd6a34fa6e19 100644
--- a/arch/sparc/crypto/des_glue.c
+++ b/arch/sparc/crypto/des_glue.c
@@ -533,5 +533,6 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("DES & Triple DES EDE Cipher Algorithms, sparc64 des opcode accelerated");
 
 MODULE_ALIAS_CRYPTO("des");
+MODULE_ALIAS_CRYPTO("des3_ede");
 
 #include "crop_devid.c"
-- 
1.7.10.4
