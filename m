From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: arm: workaround for building with old binutils
Date: Sat, 11 Apr 2015 15:32:34 +0200
Message-ID: <1428759154-16251-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	linux@arm.linux.org.uk, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, davem@davemloft.net,
	arnd@arndb.de
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

How about something like this:

A warning will be emitted by make when descending into the arch/arm/crypto
directory, but only if any ARMv8 Crypto modules were in fact selected.

/home/ard/linux-2.6/arch/arm/crypto/Makefile:22: These ARMv8 Crypto Extensions modules need binutils 2.23 or higher
/home/ard/linux-2.6/arch/arm/crypto/Makefile:23: aes-arm-ce.o sha1-arm-ce.o sha2-arm-ce.o ghash-arm-ce.o


----------------->8------------------
Old versions of binutils (before 2.23) do not yet understand the
crypto-neon-fp-armv8 fpu instructions, and an attempt to build these
files results in a build failure:

arch/arm/crypto/aes-ce-core.S:133: Error: selected processor does not support ARM mode `vld1.8 {q10-q11},[ip]!'
arch/arm/crypto/aes-ce-core.S:133: Error: bad instruction `aese.8 q0,q8'
arch/arm/crypto/aes-ce-core.S:133: Error: bad instruction `aesmc.8 q0,q0'
arch/arm/crypto/aes-ce-core.S:133: Error: bad instruction `aese.8 q0,q9'
arch/arm/crypto/aes-ce-core.S:133: Error: bad instruction `aesmc.8 q0,q0'

Since the affected versions are still in widespread use, and this breaks
'allmodconfig' builds, we should try to at least get a successful kernel
build. Unfortunately, I could not come up with a way to make the Kconfig
symbol depend on the binutils version, which would be the nicest solution.

Instead, this patch uses the 'as-instr' Kbuild macro to find out whether
the support is present in the assembler, and otherwise emits a non-fatal
warning indicating which selected modules could not be built.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: http://storage.kernelci.org/next/next-20150410/arm-allmodconfig/build.log
Fixes: 864cbeed4ab22d ("crypto: arm - add support for SHA1 using ARMv8 Crypto Instructions")
[ard.biesheuvel:
 - omit modules entirely instead of building empty ones if binutils is too old
 - update commit log accordingly]
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/Makefile | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/arm/crypto/Makefile b/arch/arm/crypto/Makefile
index b37597ad979c..fc5150702b64 100644
--- a/arch/arm/crypto/Makefile
+++ b/arch/arm/crypto/Makefile
@@ -4,14 +4,25 @@
 
 obj-$(CONFIG_CRYPTO_AES_ARM) += aes-arm.o
 obj-$(CONFIG_CRYPTO_AES_ARM_BS) += aes-arm-bs.o
-obj-$(CONFIG_CRYPTO_AES_ARM_CE) += aes-arm-ce.o
 obj-$(CONFIG_CRYPTO_SHA1_ARM) += sha1-arm.o
 obj-$(CONFIG_CRYPTO_SHA1_ARM_NEON) += sha1-arm-neon.o
 obj-$(CONFIG_CRYPTO_SHA256_ARM) += sha256-arm.o
 obj-$(CONFIG_CRYPTO_SHA512_ARM) += sha512-arm.o
-obj-$(CONFIG_CRYPTO_SHA1_ARM_CE) += sha1-arm-ce.o
-obj-$(CONFIG_CRYPTO_SHA2_ARM_CE) += sha2-arm-ce.o
-obj-$(CONFIG_CRYPTO_GHASH_ARM_CE) += ghash-arm-ce.o
+
+ce-obj-$(CONFIG_CRYPTO_AES_ARM_CE) += aes-arm-ce.o
+ce-obj-$(CONFIG_CRYPTO_SHA1_ARM_CE) += sha1-arm-ce.o
+ce-obj-$(CONFIG_CRYPTO_SHA2_ARM_CE) += sha2-arm-ce.o
+ce-obj-$(CONFIG_CRYPTO_GHASH_ARM_CE) += ghash-arm-ce.o
+
+ifneq ($(ce-obj-y)$(ce-obj-m),)
+ifeq ($(call as-instr,.fpu crypto-neon-fp-armv8,y,n),y)
+obj-y += $(ce-obj-y)
+obj-m += $(ce-obj-m)
+else
+$(warning These ARMv8 Crypto Extensions modules need binutils 2.23 or higher)
+$(warning $(ce-obj-y) $(ce-obj-m))
+endif
+endif
 
 aes-arm-y	:= aes-armv4.o aes_glue.o
 aes-arm-bs-y	:= aesbs-core.o aesbs-glue.o
-- 
1.8.3.2
