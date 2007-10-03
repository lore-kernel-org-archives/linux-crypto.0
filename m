From: Sebastian Siewior <sebastian@breakpoint.cc>
Subject: [PATCH] [crypto] load the DES module by an alias
Date: Wed, 3 Oct 2007 21:23:37 +0200
Message-ID: <E1IdMSS-0004KR-RF@Chamillionaire.breakpoint.cc>
References: <200708200234.25620.ak@suse.de> <E1IMveX-0002Kv-00@gondolin.me.apana.org.au>
 <20070820101618.GE16680@bingen.suse.de> <20070820120605.GA13163@gondor.apana.org.au>
 <20070930124239.GB24811@Chamillionaire.breakpoint.cc> <20071003073522.GA7285@gondor.apana.org.au>
 <20071004083512.GA11305@Chamillionaire.breakpoint.cc>
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60905 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759041AbXJDIx0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Oct 2007 04:53:26 -0400
In-Reply-To: <20071004083512.GA11305@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Loading the crypto algorithm by the alias instead of by module directly
has the advantage that all possible implementations of this algorithm
are loaded automatically and the crypto API can choose the best one
depending on its priority.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 crypto/Makefile                 |    2 +-
 crypto/{des.c => des_generic.c} |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)
 rename crypto/{des.c => des_generic.c} (99%)

diff --git a/crypto/Makefile b/crypto/Makefile
index 7025bd5..b6ef5e4 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -33,7 +33,7 @@ obj-$(CONFIG_CRYPTO_PCBC) += pcbc.o
 obj-$(CONFIG_CRYPTO_LRW) += lrw.o
 obj-$(CONFIG_CRYPTO_XTS) += xts.o
 obj-$(CONFIG_CRYPTO_CRYPTD) += cryptd.o
-obj-$(CONFIG_CRYPTO_DES) += des.o
+obj-$(CONFIG_CRYPTO_DES) += des_generic.o
 obj-$(CONFIG_CRYPTO_FCRYPT) += fcrypt.o
 obj-$(CONFIG_CRYPTO_BLOWFISH) += blowfish.o
 obj-$(CONFIG_CRYPTO_TWOFISH) += twofish.o
diff --git a/crypto/des.c b/crypto/des_generic.c
similarity index 99%
rename from crypto/des.c
rename to crypto/des_generic.c
index 1df3a71..59966d1 100644
--- a/crypto/des.c
+++ b/crypto/des_generic.c
@@ -1009,3 +1009,4 @@ module_exit(fini);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("DES & Triple DES EDE Cipher Algorithms");
 MODULE_AUTHOR("Dag Arne Osvik <da@osvik.no>");
+MODULE_ALIAS("des");
-- 
1.5.3.2
