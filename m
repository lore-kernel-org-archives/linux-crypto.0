From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [PATCH] [crypto] twofish-asm: fix module description
Date: Sun, 13 Jan 2008 15:01:53 +0100
Message-ID: <20080113140153.GA6469@Chamillionaire.breakpoint.cc>
References: <20080112003420.GB23721@Chamillionaire.breakpoint.cc> <20080113003513.GA8764@gondor.apana.org.au>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:32986 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751448AbYAMOB5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 13 Jan 2008 09:01:57 -0500
Content-Disposition: inline
In-Reply-To: <20080113003513.GA8764@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
* Herbert Xu | 2008-01-13 11:35:14 [+1100]:

>Applied to cryptodev-2.6.  Thanks Sebastian.
could you please squash this one into :)

 arch/x86/crypto/twofish_glue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/crypto/twofish_glue.c b/arch/x86/crypto/twofish_glue.c
index 0c74675..cefaf8b 100644
--- a/arch/x86/crypto/twofish_glue.c
+++ b/arch/x86/crypto/twofish_glue.c
@@ -92,6 +92,6 @@ module_init(init);
 module_exit(fini);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION ("Twofish Cipher Algorithm, i586 asm optimized");
+MODULE_DESCRIPTION ("Twofish Cipher Algorithm, asm optimized");
 MODULE_ALIAS("twofish");
 MODULE_ALIAS("twofish-asm");
-- 
1.5.3.7
