From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2] crypto: drbg - initialize in subsys_initcall
Date: Mon, 08 Jun 2015 14:42:50 +0200
Message-ID: <3033189.WTiU3v3QJk@tachyon.chronox.de>
References: <7507652.XDRqQzIvs8@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46124 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739AbbFHMsE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Jun 2015 08:48:04 -0400
In-Reply-To: <7507652.XDRqQzIvs8@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When compiling the DRBG statically into the kernel, the testmgr
allocation of the DRBG may be done at a time the Jitter RNG is
not available as it is registered later. The patch changes the
initialization to be invoked in subsys_initcall.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/jitterentropy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index a60147e..20dc178 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -897,7 +897,7 @@ static void __exit jent_mod_exit(void)
 	crypto_unregister_rng(&jent_alg);
 }
 
-module_init(jent_mod_init);
+subsys_initcall(jent_mod_init);
 module_exit(jent_mod_exit);
 
 MODULE_LICENSE("Dual BSD/GPL");
-- 
2.4.2
