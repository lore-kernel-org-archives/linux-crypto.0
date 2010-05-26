From: Joachim Fritschi <jfritschi@freenet.de>
Subject: [RESEND][PATCH] crypto: twofish: Rename twofish to twofish_generic
 and add an alias
Date: Wed, 26 May 2010 22:41:01 +0200
Message-ID: <4BFD875D.2090709@freenet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lnx503.hrz.tu-darmstadt.de ([130.83.156.232]:51120 "EHLO
	lnx503.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757672Ab0EZUlO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 26 May 2010 16:41:14 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This fixes the broken autoloading of the corresponding twofish assembler
ciphers on x86 and x86_64 if they are available. The module name of the
generic implementation was in conflict with the alias in the assembler
modules. The generic twofish c implementation is renamed to
twofish_generic according to the other algorithms with assembler
implementations and an module alias is added for 'twofish'. You can now
load 'twofish' giving you the best implementation by priority,
'twofish-generic' to get the c implementation or 'twofish-asm' to get
the assembler version of cipher.

Signed-off-by: Joachim Fritschi jfritschi@freenet.de
---
  crypto/Makefile                         |    2 +-
  crypto/{twofish.c => twofish_generic.c} |    1 +
  2 files changed, 2 insertions(+), 1 deletions(-)
  rename crypto/{twofish.c => twofish_generic.c} (99%)

diff --git a/crypto/Makefile b/crypto/Makefile
index d7e6441..d719716 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -61,7 +61,7 @@ obj-$(CONFIG_CRYPTO_CRYPTD) += cryptd.o
  obj-$(CONFIG_CRYPTO_DES) += des_generic.o
  obj-$(CONFIG_CRYPTO_FCRYPT) += fcrypt.o
  obj-$(CONFIG_CRYPTO_BLOWFISH) += blowfish.o
-obj-$(CONFIG_CRYPTO_TWOFISH) += twofish.o
+obj-$(CONFIG_CRYPTO_TWOFISH) += twofish_generic.o
  obj-$(CONFIG_CRYPTO_TWOFISH_COMMON) += twofish_common.o
  obj-$(CONFIG_CRYPTO_SERPENT) += serpent.o
  obj-$(CONFIG_CRYPTO_AES) += aes_generic.o
diff --git a/crypto/twofish.c b/crypto/twofish_generic.c
similarity index 99%
rename from crypto/twofish.c
rename to crypto/twofish_generic.c
index dfcda23..1f07b84 100644
--- a/crypto/twofish.c
+++ b/crypto/twofish_generic.c
@@ -212,3 +212,4 @@ module_exit(twofish_mod_fini);
   MODULE_LICENSE("GPL");
  MODULE_DESCRIPTION ("Twofish Cipher Algorithm");
+MODULE_ALIAS("twofish");
-- 
1.6.4.4
