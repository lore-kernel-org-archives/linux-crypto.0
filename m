From: Jean Delvare <jdelvare@suse.de>
Subject: [PATCH] crypto: powerpc - Rename CRYPT_CRC32C_VPMSUM option
Date: Tue, 22 Nov 2016 10:32:44 +0100
Message-ID: <20161122103244.38d435cd@endymion>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33314 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755344AbcKVJcx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2016 04:32:53 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

For consistency with the other 246 kernel configuration options,
rename CRYPT_CRC32C_VPMSUM to CRYPTO_CRC32C_VPMSUM.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Anton Blanchard <anton@samba.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/powerpc/crypto/Makefile |    2 +-
 crypto/Kconfig               |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-4.9-rc5.orig/arch/powerpc/crypto/Makefile	2016-10-03 01:24:33.000000000 +0200
+++ linux-4.9-rc5/arch/powerpc/crypto/Makefile	2016-11-22 10:24:49.902659542 +0100
@@ -9,7 +9,7 @@ obj-$(CONFIG_CRYPTO_MD5_PPC) += md5-ppc.
 obj-$(CONFIG_CRYPTO_SHA1_PPC) += sha1-powerpc.o
 obj-$(CONFIG_CRYPTO_SHA1_PPC_SPE) += sha1-ppc-spe.o
 obj-$(CONFIG_CRYPTO_SHA256_PPC_SPE) += sha256-ppc-spe.o
-obj-$(CONFIG_CRYPT_CRC32C_VPMSUM) += crc32c-vpmsum.o
+obj-$(CONFIG_CRYPTO_CRC32C_VPMSUM) += crc32c-vpmsum.o
 
 aes-ppc-spe-y := aes-spe-core.o aes-spe-keys.o aes-tab-4k.o aes-spe-modes.o aes-spe-glue.o
 md5-ppc-y := md5-asm.o md5-glue.o
--- linux-4.9-rc5.orig/crypto/Kconfig	2016-10-03 01:24:33.000000000 +0200
+++ linux-4.9-rc5/crypto/Kconfig	2016-11-22 10:25:03.270801004 +0100
@@ -437,7 +437,7 @@ config CRYPTO_CRC32C_INTEL
 	  gain performance compared with software implementation.
 	  Module will be crc32c-intel.
 
-config CRYPT_CRC32C_VPMSUM
+config CRYPTO_CRC32C_VPMSUM
 	tristate "CRC32c CRC algorithm (powerpc64)"
 	depends on PPC64 && ALTIVEC
 	select CRYPTO_HASH


-- 
Jean Delvare
SUSE L3 Support
