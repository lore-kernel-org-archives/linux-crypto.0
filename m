From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 5/6] crypto: sparc64/md5 - fix module description
Date: Sun, 11 Jan 2015 18:17:46 +0100
Message-ID: <1420996667-31693-6-git-send-email-minipli@googlemail.com>
References: <1420996667-31693-1-git-send-email-minipli@googlemail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:48473 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbbAKRSQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 11 Jan 2015 12:18:16 -0500
Received: by mail-wi0-f171.google.com with SMTP id bs8so10472875wib.4
        for <linux-crypto@vger.kernel.org>; Sun, 11 Jan 2015 09:18:14 -0800 (PST)
In-Reply-To: <1420996667-31693-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

MD5 is not SHA1.

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/sparc/crypto/md5_glue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/crypto/md5_glue.c b/arch/sparc/crypto/md5_glue.c
index 64c7ff5f72a9..b688731d7ede 100644
--- a/arch/sparc/crypto/md5_glue.c
+++ b/arch/sparc/crypto/md5_glue.c
@@ -183,7 +183,7 @@ module_init(md5_sparc64_mod_init);
 module_exit(md5_sparc64_mod_fini);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("MD5 Secure Hash Algorithm, sparc64 md5 opcode accelerated");
+MODULE_DESCRIPTION("MD5 Message Digest Algorithm, sparc64 md5 opcode accelerated");
 
 MODULE_ALIAS_CRYPTO("md5");
 
-- 
1.7.10.4
