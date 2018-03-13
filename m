From: Leonard Crestez <leonard.crestez@nxp.com>
Subject: [PATCH] crypto: arm,arm64 - Fix random regeneration of S_shipped
Date: Tue, 13 Mar 2018 22:17:23 +0200
Message-ID: <db77e20709db11b951a28c3303feb63990ef82d7.1520972030.git.leonard.crestez@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Russell King <linux@armlinux.org.uk>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The decision to rebuild .S_shipped is made based on the relative
timestamps of .S_shipped and .pl files but git makes this essentially
random. This means that the perl script might run anyway (usually at
most once per checkout), defeating the whole purpose of _shipped.

Fix by skipping the rule unless explicit make variables are provided:
REGENERATE_ARM_CRYPTO or REGENERATE_ARM64_CRYPTO.

This can produce nasty occasional build failures downstream, for example
for toolchains with broken perl. The solution is minimally intrusive to
make it easier to push into stable.

Another report on a similar issue here: https://lkml.org/lkml/2018/3/8/1379

Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Cc: <stable@vger.kernel.org>
---
 arch/arm/crypto/Makefile   | 2 ++
 arch/arm64/crypto/Makefile | 2 ++
 2 files changed, 4 insertions(+)

Not clear if this needs to go through crypto or arm but all commits in these
directories start with "crypto:".

My problems were only on arm64 because of a yocto toolchain which ships a version
of perl which fails on "use integer;".

CC stable because this can cause trouble for downstream packagers.

diff --git a/arch/arm/crypto/Makefile b/arch/arm/crypto/Makefile
index 30ef8e2..c9919c2 100644
--- a/arch/arm/crypto/Makefile
+++ b/arch/arm/crypto/Makefile
@@ -47,20 +47,22 @@ sha256-arm-y	:= sha256-core.o sha256_glue.o $(sha256-arm-neon-y)
 sha512-arm-neon-$(CONFIG_KERNEL_MODE_NEON) := sha512-neon-glue.o
 sha512-arm-y	:= sha512-core.o sha512-glue.o $(sha512-arm-neon-y)
 sha1-arm-ce-y	:= sha1-ce-core.o sha1-ce-glue.o
 sha2-arm-ce-y	:= sha2-ce-core.o sha2-ce-glue.o
 aes-arm-ce-y	:= aes-ce-core.o aes-ce-glue.o
 ghash-arm-ce-y	:= ghash-ce-core.o ghash-ce-glue.o
 crct10dif-arm-ce-y	:= crct10dif-ce-core.o crct10dif-ce-glue.o
 crc32-arm-ce-y:= crc32-ce-core.o crc32-ce-glue.o
 chacha20-neon-y := chacha20-neon-core.o chacha20-neon-glue.o
 
+ifdef REGENERATE_ARM_CRYPTO
 quiet_cmd_perl = PERL    $@
       cmd_perl = $(PERL) $(<) > $(@)
 
 $(src)/sha256-core.S_shipped: $(src)/sha256-armv4.pl
 	$(call cmd,perl)
 
 $(src)/sha512-core.S_shipped: $(src)/sha512-armv4.pl
 	$(call cmd,perl)
+endif
 
 .PRECIOUS: $(obj)/sha256-core.S $(obj)/sha512-core.S
diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
index cee9b8d9..dfe651b 100644
--- a/arch/arm64/crypto/Makefile
+++ b/arch/arm64/crypto/Makefile
@@ -60,20 +60,22 @@ obj-$(CONFIG_CRYPTO_AES_ARM64_BS) += aes-neon-bs.o
 aes-neon-bs-y := aes-neonbs-core.o aes-neonbs-glue.o
 
 AFLAGS_aes-ce.o		:= -DINTERLEAVE=4
 AFLAGS_aes-neon.o	:= -DINTERLEAVE=4
 
 CFLAGS_aes-glue-ce.o	:= -DUSE_V8_CRYPTO_EXTENSIONS
 
 $(obj)/aes-glue-%.o: $(src)/aes-glue.c FORCE
 	$(call if_changed_rule,cc_o_c)
 
+ifdef REGENERATE_ARM64_CRYPTO
 quiet_cmd_perlasm = PERLASM $@
       cmd_perlasm = $(PERL) $(<) void $(@)
 
 $(src)/sha256-core.S_shipped: $(src)/sha512-armv8.pl
 	$(call cmd,perlasm)
 
 $(src)/sha512-core.S_shipped: $(src)/sha512-armv8.pl
 	$(call cmd,perlasm)
+endif
 
 .PRECIOUS: $(obj)/sha256-core.S $(obj)/sha512-core.S
-- 
2.7.4
