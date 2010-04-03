From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH 1/7] crypto: rename arc4
Date: Sat,  3 Apr 2010 09:49:23 +0200
Message-ID: <1270280969-11357-2-git-send-email-sebastian@breakpoint.cc>
References: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc>
Cc: linux-crypto@vger.kernel.org, linux-wireless@vger.kernel.org,
	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
	<linux-ppp@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53094 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752040Ab0DCHtk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 3 Apr 2010 03:49:40 -0400
In-Reply-To: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The blk version of arc4 is comming. The rename ensures that the request
for arc4 loads both modules: this one and the new blk edition.

Cc: <linux-ppp@vger.kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 crypto/Makefile              |    2 +-
 crypto/{arc4.c => arc4cip.c} |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)
 rename crypto/{arc4.c => arc4cip.c} (98%)

diff --git a/crypto/Makefile b/crypto/Makefile
index 9e8f619..1f15112 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -67,7 +67,7 @@ obj-$(CONFIG_CRYPTO_AES) += aes_generic.o
 obj-$(CONFIG_CRYPTO_CAMELLIA) += camellia.o
 obj-$(CONFIG_CRYPTO_CAST5) += cast5.o
 obj-$(CONFIG_CRYPTO_CAST6) += cast6.o
-obj-$(CONFIG_CRYPTO_ARC4) += arc4.o
+obj-$(CONFIG_CRYPTO_ARC4) += arc4cip.o
 obj-$(CONFIG_CRYPTO_TEA) += tea.o
 obj-$(CONFIG_CRYPTO_KHAZAD) += khazad.o
 obj-$(CONFIG_CRYPTO_ANUBIS) += anubis.o
diff --git a/crypto/arc4.c b/crypto/arc4cip.c
similarity index 98%
rename from crypto/arc4.c
rename to crypto/arc4cip.c
index 8be47e1..bf04659 100644
--- a/crypto/arc4.c
+++ b/crypto/arc4cip.c
@@ -102,3 +102,4 @@ module_exit(arc4_exit);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("ARC4 Cipher Algorithm");
 MODULE_AUTHOR("Jon Oberheide <jon@oberheide.org>");
+MODULE_ALIAS("arc4");
-- 
1.6.6

