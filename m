From: David Miller <davem@davemloft.net>
Subject: [PATCH] sparc64: Add DES driver making use of the new des opcodes.
Date: Sun, 26 Aug 2012 01:40:23 -0400 (EDT)
Message-ID: <20120826.014023.533405514217044893.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: sparclinux@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:60035 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab2HZFk2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 26 Aug 2012 01:40:28 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/crypto/Makefile   |    2 +
 arch/sparc/crypto/des_asm.S  |  439 +++++++++++++++++++++++++++++++++++
 arch/sparc/crypto/des_glue.c |  525 ++++++++++++++++++++++++++++++++++++++++++
 crypto/Kconfig               |    8 +
 4 files changed, 974 insertions(+)
 create mode 100644 arch/sparc/crypto/des_asm.S
 create mode 100644 arch/sparc/crypto/des_glue.c

diff --git a/arch/sparc/crypto/Makefile b/arch/sparc/crypto/Makefile
index c6ca941..dd999c6 100644
--- a/arch/sparc/crypto/Makefile
+++ b/arch/sparc/crypto/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_CRYPTO_SHA512_SPARC64) += sha512-sparc64.o
 obj-$(CONFIG_CRYPTO_MD5_SPARC64) += md5-sparc64.o
 
 obj-$(CONFIG_CRYPTO_AES_SPARC64) += aes-sparc64.o
+obj-$(CONFIG_CRYPTO_DES_SPARC64) += des-sparc64.o
 
 obj-$(CONFIG_CRYPTO_CRC32C_SPARC64) += crc32c-sparc64.o
 
@@ -17,5 +18,6 @@ sha512-sparc64-y := sha512_asm.o sha512_glue.o
 md5-sparc64-y := md5_asm.o md5_glue.o
 
 aes-sparc64-y := aes_asm.o aes_glue.o
+des-sparc64-y := des_asm.o des_glue.o
 
 crc32c-sparc64-y := crc32c_asm.o crc32c_glue.o
diff --git a/arch/sparc/crypto/des_asm.S b/arch/sparc/crypto/des_asm.S
new file mode 100644
index 0000000..589481e
--- /dev/null
+++ b/arch/sparc/crypto/des_asm.S
@@ -0,0 +1,439 @@
+#include <linux/linkage.h>
+#include <asm/visasm.h>
+
+#define F3F(x,y,z)	(((x)<<30)|((y)<<19)|((z)<<5))
+
+#define FPD_ENCODE(x)	(((x) >> 5) | ((x) & ~(0x20)))
+
+#define RS1(x)		(FPD_ENCODE(x) << 14)
+#define RS2(x)		(FPD_ENCODE(x) <<  0)
+#define RS3(x)		(FPD_ENCODE(x) <<  9)
+#define RD(x)		(FPD_ENCODE(x) << 25)
+#define IMM5(x)		((x)           <<  0)
+
+#define DES_IP(a,b)		\
+	.word		(F3F(2, 0x36, 0x134)|RS1(a)|RD(b));
+#define DES_IIP(a,b)		\
+	.word		(F3F(2, 0x36, 0x135)|RS1(a)|RD(b));
+#define DES_KEXPAND(a,b,c)	\
+	.word		(F3F(2, 0x36, 0x136)|RS1(a)|IMM5(b)|RD(c));
+#define DES_ROUND(a,b,c,d)	\
+	.word		(F3F(2, 0x19, 0x009)|RS1(a)|RS2(b)|RS3(c)|RD(d));
+
+#define MOVXTOD_G1_F60 \
+	.word		0xbbb02301
+#define MOVXTOD_G1_F62 \
+	.word		0xbfb02301
+
+	.align	32
+ENTRY(des_sparc64_key_expand)
+	/* %o0=input_key, %o1=output_key */
+	VISEntryHalf
+	ld	[%o0 + 0x00], %f0
+	ld	[%o0 + 0x04], %f1
+	DES_KEXPAND(0, 0, 0)
+	DES_KEXPAND(0, 1, 2)
+	DES_KEXPAND(2, 3, 6)
+	DES_KEXPAND(2, 2, 4)
+	DES_KEXPAND(6, 3, 10)
+	DES_KEXPAND(6, 2, 8)
+	DES_KEXPAND(10, 3, 14)
+	DES_KEXPAND(10, 2, 12)
+	DES_KEXPAND(14, 1, 16)
+	DES_KEXPAND(16, 3, 20)
+	DES_KEXPAND(16, 2, 18)
+	DES_KEXPAND(20, 3, 24)
+	DES_KEXPAND(20, 2, 22)
+	DES_KEXPAND(24, 3, 28)
+	DES_KEXPAND(24, 2, 26)
+	DES_KEXPAND(28, 1, 30)
+	std	%f0, [%o1 + 0x00]
+	std	%f2, [%o1 + 0x08]
+	std	%f4, [%o1 + 0x10]
+	std	%f6, [%o1 + 0x18]
+	std	%f8, [%o1 + 0x20]
+	std	%f10, [%o1 + 0x28]
+	std	%f12, [%o1 + 0x30]
+	std	%f14, [%o1 + 0x38]
+	std	%f16, [%o1 + 0x40]
+	std	%f18, [%o1 + 0x48]
+	std	%f20, [%o1 + 0x50]
+	std	%f22, [%o1 + 0x58]
+	std	%f24, [%o1 + 0x60]
+	std	%f26, [%o1 + 0x68]
+	std	%f28, [%o1 + 0x70]
+	std	%f30, [%o1 + 0x78]
+	retl
+	 VISExitHalf
+ENDPROC(des_sparc64_key_expand)
+
+	.align	32
+ENTRY(des_sparc64_crypt)
+	/* %o0=key, %o1=input, %o2=output */
+	VISEntry
+	ldd	[%o1 + 0x00], %f32
+	ldd	[%o0 + 0x00], %f0
+	ldd	[%o0 + 0x08], %f2
+	ldd	[%o0 + 0x10], %f4
+	ldd	[%o0 + 0x18], %f6
+	ldd	[%o0 + 0x20], %f8
+	ldd	[%o0 + 0x28], %f10
+	ldd	[%o0 + 0x30], %f12
+	ldd	[%o0 + 0x38], %f14
+	ldd	[%o0 + 0x40], %f16
+	ldd	[%o0 + 0x48], %f18
+	ldd	[%o0 + 0x50], %f20
+	ldd	[%o0 + 0x58], %f22
+	ldd	[%o0 + 0x60], %f24
+	ldd	[%o0 + 0x68], %f26
+	ldd	[%o0 + 0x70], %f28
+	ldd	[%o0 + 0x78], %f30
+	DES_IP(32, 32)
+	DES_ROUND(0, 2, 32, 32)
+	DES_ROUND(4, 6, 32, 32)
+	DES_ROUND(8, 10, 32, 32)
+	DES_ROUND(12, 14, 32, 32)
+	DES_ROUND(16, 18, 32, 32)
+	DES_ROUND(20, 22, 32, 32)
+	DES_ROUND(24, 26, 32, 32)
+	DES_ROUND(28, 30, 32, 32)
+	DES_IIP(32, 32)
+	std	%f32, [%o2 + 0x00]
+	retl
+	 VISExit
+ENDPROC(des_sparc64_crypt)
+
+	.align	32
+ENTRY(des_sparc64_load_keys)
+	/* %o0=key */
+	VISEntry
+	ldd	[%o0 + 0x00], %f0
+	ldd	[%o0 + 0x08], %f2
+	ldd	[%o0 + 0x10], %f4
+	ldd	[%o0 + 0x18], %f6
+	ldd	[%o0 + 0x20], %f8
+	ldd	[%o0 + 0x28], %f10
+	ldd	[%o0 + 0x30], %f12
+	ldd	[%o0 + 0x38], %f14
+	ldd	[%o0 + 0x40], %f16
+	ldd	[%o0 + 0x48], %f18
+	ldd	[%o0 + 0x50], %f20
+	ldd	[%o0 + 0x58], %f22
+	ldd	[%o0 + 0x60], %f24
+	ldd	[%o0 + 0x68], %f26
+	ldd	[%o0 + 0x70], %f28
+	retl
+	 ldd	[%o0 + 0x78], %f30
+ENDPROC(des_sparc64_load_keys)
+
+	.align	32
+ENTRY(des_sparc64_ecb_crypt)
+	/* %o0=input, %o1=output, %o2=len */
+1:	ldd	[%o0 + 0x00], %f32
+	add	%o0, 0x08, %o0
+	DES_IP(32, 32)
+	DES_ROUND(0, 2, 32, 32)
+	DES_ROUND(4, 6, 32, 32)
+	DES_ROUND(8, 10, 32, 32)
+	DES_ROUND(12, 14, 32, 32)
+	DES_ROUND(16, 18, 32, 32)
+	DES_ROUND(20, 22, 32, 32)
+	DES_ROUND(24, 26, 32, 32)
+	DES_ROUND(28, 30, 32, 32)
+	DES_IIP(32, 32)
+	std	%f32, [%o1 + 0x00]
+	subcc	%o2, 0x08, %o2
+	bne,pt	%icc, 1b
+	 add	%o1, 0x08, %o1
+	retl
+	 nop
+ENDPROC(des_sparc64_ecb_crypt)
+
+	.align	32
+ENTRY(des_sparc64_cbc_encrypt)
+	/* %o0=input, %o1=output, %o2=len, %o3=IV */
+	ldd	[%o3 + 0x00], %f32
+1:	ldd	[%o0 + 0x00], %f34
+	fxor	%f32, %f34, %f32
+	DES_IP(32, 32)
+	DES_ROUND(0, 2, 32, 32)
+	DES_ROUND(4, 6, 32, 32)
+	DES_ROUND(8, 10, 32, 32)
+	DES_ROUND(12, 14, 32, 32)
+	DES_ROUND(16, 18, 32, 32)
+	DES_ROUND(20, 22, 32, 32)
+	DES_ROUND(24, 26, 32, 32)
+	DES_ROUND(28, 30, 32, 32)
+	DES_IIP(32, 32)
+	std	%f32, [%o1 + 0x00]
+	add	%o0, 0x08, %o0
+	subcc	%o2, 0x08, %o2
+	bne,pt	%icc, 1b
+	 add	%o1, 0x08, %o1
+	retl
+	 std	%f32, [%o3 + 0x00]
+ENDPROC(des_sparc64_cbc_encrypt)
+
+	.align	32
+ENTRY(des_sparc64_cbc_decrypt)
+	/* %o0=input, %o1=output, %o2=len, %o3=IV */
+	ldd	[%o3 + 0x00], %f34
+1:	ldd	[%o0 + 0x00], %f36
+	DES_IP(36, 32)
+	DES_ROUND(0, 2, 32, 32)
+	DES_ROUND(4, 6, 32, 32)
+	DES_ROUND(8, 10, 32, 32)
+	DES_ROUND(12, 14, 32, 32)
+	DES_ROUND(16, 18, 32, 32)
+	DES_ROUND(20, 22, 32, 32)
+	DES_ROUND(24, 26, 32, 32)
+	DES_ROUND(28, 30, 32, 32)
+	DES_IIP(32, 32)
+	fxor	%f32, %f34, %f32
+	std	%f32, [%o1 + 0x00]
+	add	%o0, 0x08, %o0
+	subcc	%o2, 0x08, %o2
+	bne,pt	%icc, 1b
+	 add	%o1, 0x08, %o1
+	retl
+	 std	%f36, [%o3 + 0x00]
+ENDPROC(des_sparc64_cbc_decrypt)
+
+	.align	32
+ENTRY(des3_ede_sparc64_crypt)
+	/* %o0=key, %o1=input, %o2=output */
+	VISEntry
+	ldd	[%o1 + 0x00], %f32
+	ldd	[%o0 + 0x00], %f0
+	ldd	[%o0 + 0x08], %f2
+	ldd	[%o0 + 0x10], %f4
+	ldd	[%o0 + 0x18], %f6
+	ldd	[%o0 + 0x20], %f8
+	ldd	[%o0 + 0x28], %f10
+	ldd	[%o0 + 0x30], %f12
+	ldd	[%o0 + 0x38], %f14
+	ldd	[%o0 + 0x40], %f16
+	ldd	[%o0 + 0x48], %f18
+	ldd	[%o0 + 0x50], %f20
+	ldd	[%o0 + 0x58], %f22
+	ldd	[%o0 + 0x60], %f24
+	ldd	[%o0 + 0x68], %f26
+	ldd	[%o0 + 0x70], %f28
+	ldd	[%o0 + 0x78], %f30
+	DES_IP(32, 32)
+	DES_ROUND(0, 2, 32, 32)
+	ldd	[%o0 + 0x80], %f0
+	ldd	[%o0 + 0x88], %f2
+	DES_ROUND(4, 6, 32, 32)
+	ldd	[%o0 + 0x90], %f4
+	ldd	[%o0 + 0x98], %f6
+	DES_ROUND(8, 10, 32, 32)
+	ldd	[%o0 + 0xa0], %f8
+	ldd	[%o0 + 0xa8], %f10
+	DES_ROUND(12, 14, 32, 32)
+	ldd	[%o0 + 0xb0], %f12
+	ldd	[%o0 + 0xb8], %f14
+	DES_ROUND(16, 18, 32, 32)
+	ldd	[%o0 + 0xc0], %f16
+	ldd	[%o0 + 0xc8], %f18
+	DES_ROUND(20, 22, 32, 32)
+	ldd	[%o0 + 0xd0], %f20
+	ldd	[%o0 + 0xd8], %f22
+	DES_ROUND(24, 26, 32, 32)
+	ldd	[%o0 + 0xe0], %f24
+	ldd	[%o0 + 0xe8], %f26
+	DES_ROUND(28, 30, 32, 32)
+	ldd	[%o0 + 0xf0], %f28
+	ldd	[%o0 + 0xf8], %f30
+	DES_IIP(32, 32)
+	DES_IP(32, 32)
+	DES_ROUND(0, 2, 32, 32)
+	ldd	[%o0 + 0x100], %f0
+	ldd	[%o0 + 0x108], %f2
+	DES_ROUND(4, 6, 32, 32)
+	ldd	[%o0 + 0x110], %f4
+	ldd	[%o0 + 0x118], %f6
+	DES_ROUND(8, 10, 32, 32)
+	ldd	[%o0 + 0x120], %f8
+	ldd	[%o0 + 0x128], %f10
+	DES_ROUND(12, 14, 32, 32)
+	ldd	[%o0 + 0x130], %f12
+	ldd	[%o0 + 0x138], %f14
+	DES_ROUND(16, 18, 32, 32)
+	ldd	[%o0 + 0x140], %f16
+	ldd	[%o0 + 0x148], %f18
+	DES_ROUND(20, 22, 32, 32)
+	ldd	[%o0 + 0x150], %f20
+	ldd	[%o0 + 0x158], %f22
+	DES_ROUND(24, 26, 32, 32)
+	ldd	[%o0 + 0x160], %f24
+	ldd	[%o0 + 0x168], %f26
+	DES_ROUND(28, 30, 32, 32)
+	ldd	[%o0 + 0x170], %f28
+	ldd	[%o0 + 0x178], %f30
+	DES_IIP(32, 32)
+	DES_IP(32, 32)
+	DES_ROUND(0, 2, 32, 32)
+	DES_ROUND(4, 6, 32, 32)
+	DES_ROUND(8, 10, 32, 32)
+	DES_ROUND(12, 14, 32, 32)
+	DES_ROUND(16, 18, 32, 32)
+	DES_ROUND(20, 22, 32, 32)
+	DES_ROUND(24, 26, 32, 32)
+	DES_ROUND(28, 30, 32, 32)
+	DES_IIP(32, 32)
+
+	std	%f32, [%o2 + 0x00]
+	retl
+	 VISExit
+ENDPROC(des3_ede_sparc64_crypt)
+
+	.align	32
+ENTRY(des3_ede_sparc64_load_keys)
+	/* %o0=key */
+	VISEntry
+	ldd	[%o0 + 0x00], %f0
+	ldd	[%o0 + 0x08], %f2
+	ldd	[%o0 + 0x10], %f4
+	ldd	[%o0 + 0x18], %f6
+	ldd	[%o0 + 0x20], %f8
+	ldd	[%o0 + 0x28], %f10
+	ldd	[%o0 + 0x30], %f12
+	ldd	[%o0 + 0x38], %f14
+	ldd	[%o0 + 0x40], %f16
+	ldd	[%o0 + 0x48], %f18
+	ldd	[%o0 + 0x50], %f20
+	ldd	[%o0 + 0x58], %f22
+	ldd	[%o0 + 0x60], %f24
+	ldd	[%o0 + 0x68], %f26
+	ldd	[%o0 + 0x70], %f28
+	ldd	[%o0 + 0x78], %f30
+	ldd	[%o0 + 0x80], %f32
+	ldd	[%o0 + 0x88], %f34
+	ldd	[%o0 + 0x90], %f36
+	ldd	[%o0 + 0x98], %f38
+	ldd	[%o0 + 0xa0], %f40
+	ldd	[%o0 + 0xa8], %f42
+	ldd	[%o0 + 0xb0], %f44
+	ldd	[%o0 + 0xb8], %f46
+	ldd	[%o0 + 0xc0], %f48
+	ldd	[%o0 + 0xc8], %f50
+	ldd	[%o0 + 0xd0], %f52
+	ldd	[%o0 + 0xd8], %f54
+	ldd	[%o0 + 0xe0], %f56
+	retl
+	 ldd	[%o0 + 0xe8], %f58
+ENDPROC(des3_ede_sparc64_load_keys)
+
+#define DES3_LOOP_BODY(X) \
+	DES_IP(X, X) \
+	DES_ROUND(0, 2, X, X) \
+	DES_ROUND(4, 6, X, X) \
+	DES_ROUND(8, 10, X, X) \
+	DES_ROUND(12, 14, X, X) \
+	DES_ROUND(16, 18, X, X) \
+	ldd	[%o0 + 0xf0], %f16; \
+	ldd	[%o0 + 0xf8], %f18; \
+	DES_ROUND(20, 22, X, X) \
+	ldd	[%o0 + 0x100], %f20; \
+	ldd	[%o0 + 0x108], %f22; \
+	DES_ROUND(24, 26, X, X) \
+	ldd	[%o0 + 0x110], %f24; \
+	ldd	[%o0 + 0x118], %f26; \
+	DES_ROUND(28, 30, X, X) \
+	ldd	[%o0 + 0x120], %f28; \
+	ldd	[%o0 + 0x128], %f30; \
+	DES_IIP(X, X) \
+	DES_IP(X, X) \
+	DES_ROUND(32, 34, X, X) \
+	ldd	[%o0 + 0x130], %f0; \
+	ldd	[%o0 + 0x138], %f2; \
+	DES_ROUND(36, 38, X, X) \
+	ldd	[%o0 + 0x140], %f4; \
+	ldd	[%o0 + 0x148], %f6; \
+	DES_ROUND(40, 42, X, X) \
+	ldd	[%o0 + 0x150], %f8; \
+	ldd	[%o0 + 0x158], %f10; \
+	DES_ROUND(44, 46, X, X) \
+	ldd	[%o0 + 0x160], %f12; \
+	ldd	[%o0 + 0x168], %f14; \
+	DES_ROUND(48, 50, X, X) \
+	DES_ROUND(52, 54, X, X) \
+	DES_ROUND(56, 58, X, X) \
+	DES_ROUND(16, 18, X, X) \
+	ldd	[%o0 + 0x170], %f16; \
+	ldd	[%o0 + 0x178], %f18; \
+	DES_IIP(X, X) \
+	DES_IP(X, X) \
+	DES_ROUND(20, 22, X, X) \
+	ldd	[%o0 + 0x50], %f20; \
+	ldd	[%o0 + 0x58], %f22; \
+	DES_ROUND(24, 26, X, X) \
+	ldd	[%o0 + 0x60], %f24; \
+	ldd	[%o0 + 0x68], %f26; \
+	DES_ROUND(28, 30, X, X) \
+	ldd	[%o0 + 0x70], %f28; \
+	ldd	[%o0 + 0x78], %f30; \
+	DES_ROUND(0, 2, X, X) \
+	ldd	[%o0 + 0x00], %f0; \
+	ldd	[%o0 + 0x08], %f2; \
+	DES_ROUND(4, 6, X, X) \
+	ldd	[%o0 + 0x10], %f4; \
+	ldd	[%o0 + 0x18], %f6; \
+	DES_ROUND(8, 10, X, X) \
+	ldd	[%o0 + 0x20], %f8; \
+	ldd	[%o0 + 0x28], %f10; \
+	DES_ROUND(12, 14, X, X) \
+	ldd	[%o0 + 0x30], %f12; \
+	ldd	[%o0 + 0x38], %f14; \
+	DES_ROUND(16, 18, X, X) \
+	ldd	[%o0 + 0x40], %f16; \
+	ldd	[%o0 + 0x48], %f18; \
+	DES_IIP(X, X)
+
+	.align	32
+ENTRY(des3_ede_sparc64_ecb_crypt)
+	/* %o0=key, %o1=input, %o2=output, %o3=len */
+1:	ldd	[%o1 + 0x00], %f60
+	DES3_LOOP_BODY(60)
+	std	%f60, [%o2 + 0x00]
+	subcc	%o3, 0x08, %o3
+	bne,pt	%icc, 1b
+	 add	%o2, 0x08, %o2
+	retl
+	 nop
+ENDPROC(des3_ede_sparc64_ecb_crypt)
+
+	.align	32
+ENTRY(des3_ede_sparc64_cbc_encrypt)
+	/* %o0=key, %o1=input, %o2=output, %o3=len, %o4=IV */
+	ldd	[%o4 + 0x00], %f60
+1:	ldd	[%o1 + 0x00], %f62
+	fxor	%f60, %f62, %f60
+	DES3_LOOP_BODY(60)
+	std	%f60, [%o2 + 0x00]
+	add	%o1, 0x08, %o1
+	subcc	%o3, 0x08, %o3
+	bne,pt	%icc, 1b
+	 add	%o2, 0x08, %o2
+	retl
+	 std	%f60, [%o4 + 0x00]
+ENDPROC(des3_ede_sparc64_cbc_encrypt)
+
+	.align	32
+ENTRY(des3_ede_sparc64_cbc_decrypt)
+	/* %o0=key, %o1=input, %o2=output, %o3=len, %o4=IV */
+	ldd	[%o4 + 0x00], %f62
+1:	ldx	[%o1 + 0x00], %g1
+	MOVXTOD_G1_F60
+	DES3_LOOP_BODY(60)
+	fxor	%f62, %f60, %f60
+	MOVXTOD_G1_F62
+	std	%f60, [%o2 + 0x00]
+	add	%o1, 0x08, %o1
+	subcc	%o3, 0x08, %o3
+	bne,pt	%icc, 1b
+	 add	%o2, 0x08, %o2
+	retl
+	 stx	%g1, [%o4 + 0x00]
+ENDPROC(des3_ede_sparc64_cbc_decrypt)
diff --git a/arch/sparc/crypto/des_glue.c b/arch/sparc/crypto/des_glue.c
new file mode 100644
index 0000000..5ec0309
--- /dev/null
+++ b/arch/sparc/crypto/des_glue.c
@@ -0,0 +1,525 @@
+/* Glue code for DES encryption optimized for sparc64 crypto opcodes.
+ *
+ * Copyright (C) 2012 David S. Miller <davem@davemloft.net>
+ */
+
+#include <linux/crypto.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/types.h>
+#include <crypto/algapi.h>
+#include <crypto/des.h>
+
+#include <asm/fpumacro.h>
+#include <asm/pstate.h>
+#include <asm/elf.h>
+
+struct des_sparc64_ctx {
+	u64 encrypt_expkey[DES_EXPKEY_WORDS / 2];
+	u64 decrypt_expkey[DES_EXPKEY_WORDS / 2];
+};
+
+struct des3_ede_sparc64_ctx {
+	u64 encrypt_expkey[DES3_EDE_EXPKEY_WORDS / 2];
+	u64 decrypt_expkey[DES3_EDE_EXPKEY_WORDS / 2];
+};
+
+static void encrypt_to_decrypt(u64 *d, const u64 *e)
+{
+	const u64 *s = e + (DES_EXPKEY_WORDS / 2) - 1;
+	int i;
+
+	for (i = 0; i < DES_EXPKEY_WORDS / 2; i++)
+		*d++ = *s--;
+}
+
+extern void des_sparc64_key_expand(const u32 *input_key, u64 *key);
+
+static int des_set_key(struct crypto_tfm *tfm, const u8 *key,
+		       unsigned int keylen)
+{
+	struct des_sparc64_ctx *dctx = crypto_tfm_ctx(tfm);
+	u32 *flags = &tfm->crt_flags;
+	u32 tmp[DES_EXPKEY_WORDS];
+	int ret;
+
+	/* Even though we have special instructions for key expansion,
+	 * we call des_ekey() so that we don't have to write our own
+	 * weak key detection code.
+	 */
+	ret = des_ekey(tmp, key);
+	if (unlikely(ret == 0) && (*flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
+		return -EINVAL;
+	}
+
+	des_sparc64_key_expand((const u32 *) key, &dctx->encrypt_expkey[0]);
+	encrypt_to_decrypt(&dctx->decrypt_expkey[0], &dctx->encrypt_expkey[0]);
+
+	return 0;
+}
+
+extern void des_sparc64_crypt(const u64 *key, const u64 *input,
+			      u64 *output);
+
+static void des_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+{
+	struct des_sparc64_ctx *ctx = crypto_tfm_ctx(tfm);
+	const u64 *K = ctx->encrypt_expkey;
+
+	des_sparc64_crypt(K, (const u64 *) src, (u64 *) dst);
+}
+
+static void des_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+{
+	struct des_sparc64_ctx *ctx = crypto_tfm_ctx(tfm);
+	const u64 *K = ctx->decrypt_expkey;
+
+	des_sparc64_crypt(K, (const u64 *) src, (u64 *) dst);
+}
+
+extern void des_sparc64_load_keys(const u64 *key);
+
+extern void des_sparc64_ecb_crypt(const u64 *input, u64 *output,
+				  unsigned int len);
+
+#define DES_BLOCK_MASK	(~(DES_BLOCK_SIZE - 1))
+
+static int __ecb_crypt(struct blkcipher_desc *desc,
+		       struct scatterlist *dst, struct scatterlist *src,
+		       unsigned int nbytes, bool encrypt)
+{
+	struct des_sparc64_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	if (encrypt)
+		des_sparc64_load_keys(&ctx->encrypt_expkey[0]);
+	else
+		des_sparc64_load_keys(&ctx->decrypt_expkey[0]);
+	while ((nbytes = walk.nbytes)) {
+		unsigned int block_len = nbytes & DES_BLOCK_MASK;
+
+		if (likely(block_len)) {
+			des_sparc64_ecb_crypt((const u64 *)walk.src.virt.addr,
+					      (u64 *) walk.dst.virt.addr,
+					      block_len);
+		}
+		nbytes &= DES_BLOCK_SIZE - 1;
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+	fprs_write(0);
+	return err;
+}
+
+static int ecb_encrypt(struct blkcipher_desc *desc,
+		       struct scatterlist *dst, struct scatterlist *src,
+		       unsigned int nbytes)
+{
+	return __ecb_crypt(desc, dst, src, nbytes, true);
+}
+
+static int ecb_decrypt(struct blkcipher_desc *desc,
+		       struct scatterlist *dst, struct scatterlist *src,
+		       unsigned int nbytes)
+{
+	return __ecb_crypt(desc, dst, src, nbytes, false);
+}
+
+extern void des_sparc64_cbc_encrypt(const u64 *input, u64 *output,
+				    unsigned int len, u64 *iv);
+
+static int cbc_encrypt(struct blkcipher_desc *desc,
+		       struct scatterlist *dst, struct scatterlist *src,
+		       unsigned int nbytes)
+{
+	struct des_sparc64_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	des_sparc64_load_keys(&ctx->encrypt_expkey[0]);
+	while ((nbytes = walk.nbytes)) {
+		unsigned int block_len = nbytes & DES_BLOCK_MASK;
+
+		if (likely(block_len)) {
+			des_sparc64_cbc_encrypt((const u64 *)walk.src.virt.addr,
+						(u64 *) walk.dst.virt.addr,
+						block_len, (u64 *) walk.iv);
+		}
+		nbytes &= DES_BLOCK_SIZE - 1;
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+	fprs_write(0);
+	return err;
+}
+
+extern void des_sparc64_cbc_decrypt(const u64 *input, u64 *output,
+				    unsigned int len, u64 *iv);
+
+static int cbc_decrypt(struct blkcipher_desc *desc,
+		       struct scatterlist *dst, struct scatterlist *src,
+		       unsigned int nbytes)
+{
+	struct des_sparc64_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	des_sparc64_load_keys(&ctx->decrypt_expkey[0]);
+	while ((nbytes = walk.nbytes)) {
+		unsigned int block_len = nbytes & DES_BLOCK_MASK;
+
+		if (likely(block_len)) {
+			des_sparc64_cbc_decrypt((const u64 *)walk.src.virt.addr,
+						(u64 *) walk.dst.virt.addr,
+						block_len, (u64 *) walk.iv);
+		}
+		nbytes &= DES_BLOCK_SIZE - 1;
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+	fprs_write(0);
+	return err;
+}
+
+static int des3_ede_set_key(struct crypto_tfm *tfm, const u8 *key,
+			    unsigned int keylen)
+{
+	struct des3_ede_sparc64_ctx *dctx = crypto_tfm_ctx(tfm);
+	const u32 *K = (const u32 *)key;
+	u32 *flags = &tfm->crt_flags;
+	u64 k1[DES_EXPKEY_WORDS / 2];
+	u64 k2[DES_EXPKEY_WORDS / 2];
+	u64 k3[DES_EXPKEY_WORDS / 2];
+
+	if (unlikely(!((K[0] ^ K[2]) | (K[1] ^ K[3])) ||
+		     !((K[2] ^ K[4]) | (K[3] ^ K[5]))) &&
+		     (*flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
+		return -EINVAL;
+	}
+
+	des_sparc64_key_expand((const u32 *)key, k1);
+	key += DES_KEY_SIZE;
+	des_sparc64_key_expand((const u32 *)key, k2);
+	key += DES_KEY_SIZE;
+	des_sparc64_key_expand((const u32 *)key, k3);
+
+	memcpy(&dctx->encrypt_expkey[0], &k1[0], sizeof(k1));
+	encrypt_to_decrypt(&dctx->encrypt_expkey[DES_EXPKEY_WORDS / 2], &k2[0]);
+	memcpy(&dctx->encrypt_expkey[(DES_EXPKEY_WORDS / 2) * 2],
+	       &k3[0], sizeof(k3));
+
+	encrypt_to_decrypt(&dctx->decrypt_expkey[0], &k3[0]);
+	memcpy(&dctx->decrypt_expkey[DES_EXPKEY_WORDS / 2],
+	       &k2[0], sizeof(k2));
+	encrypt_to_decrypt(&dctx->decrypt_expkey[(DES_EXPKEY_WORDS / 2) * 2],
+			   &k1[0]);
+
+	return 0;
+}
+
+extern void des3_ede_sparc64_crypt(const u64 *key, const u64 *input,
+				   u64 *output);
+
+static void des3_ede_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+{
+	struct des3_ede_sparc64_ctx *ctx = crypto_tfm_ctx(tfm);
+	const u64 *K = ctx->encrypt_expkey;
+
+	des3_ede_sparc64_crypt(K, (const u64 *) src, (u64 *) dst);
+}
+
+static void des3_ede_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+{
+	struct des3_ede_sparc64_ctx *ctx = crypto_tfm_ctx(tfm);
+	const u64 *K = ctx->decrypt_expkey;
+
+	des3_ede_sparc64_crypt(K, (const u64 *) src, (u64 *) dst);
+}
+
+extern void des3_ede_sparc64_load_keys(const u64 *key);
+
+extern void des3_ede_sparc64_ecb_crypt(const u64 *expkey, const u64 *input,
+				       u64 *output, unsigned int len);
+
+static int __ecb3_crypt(struct blkcipher_desc *desc,
+			struct scatterlist *dst, struct scatterlist *src,
+			unsigned int nbytes, bool encrypt)
+{
+	struct des3_ede_sparc64_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+	const u64 *K;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	if (encrypt)
+		K = &ctx->encrypt_expkey[0];
+	else
+		K = &ctx->decrypt_expkey[0];
+	des3_ede_sparc64_load_keys(K);
+	while ((nbytes = walk.nbytes)) {
+		unsigned int block_len = nbytes & DES_BLOCK_MASK;
+
+		if (likely(block_len)) {
+			const u64 *src64 = (const u64 *)walk.src.virt.addr;
+			des3_ede_sparc64_ecb_crypt(K, src64,
+						   (u64 *) walk.dst.virt.addr,
+						   block_len);
+		}
+		nbytes &= DES_BLOCK_SIZE - 1;
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+	fprs_write(0);
+	return err;
+}
+
+static int ecb3_encrypt(struct blkcipher_desc *desc,
+		       struct scatterlist *dst, struct scatterlist *src,
+		       unsigned int nbytes)
+{
+	return __ecb3_crypt(desc, dst, src, nbytes, true);
+}
+
+static int ecb3_decrypt(struct blkcipher_desc *desc,
+		       struct scatterlist *dst, struct scatterlist *src,
+		       unsigned int nbytes)
+{
+	return __ecb3_crypt(desc, dst, src, nbytes, false);
+}
+
+extern void des3_ede_sparc64_cbc_encrypt(const u64 *expkey, const u64 *input,
+					 u64 *output, unsigned int len,
+					 u64 *iv);
+
+static int cbc3_encrypt(struct blkcipher_desc *desc,
+			struct scatterlist *dst, struct scatterlist *src,
+			unsigned int nbytes)
+{
+	struct des3_ede_sparc64_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+	const u64 *K;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	K = &ctx->encrypt_expkey[0];
+	des3_ede_sparc64_load_keys(K);
+	while ((nbytes = walk.nbytes)) {
+		unsigned int block_len = nbytes & DES_BLOCK_MASK;
+
+		if (likely(block_len)) {
+			const u64 *src64 = (const u64 *)walk.src.virt.addr;
+			des3_ede_sparc64_cbc_encrypt(K, src64,
+						     (u64 *) walk.dst.virt.addr,
+						     block_len,
+						     (u64 *) walk.iv);
+		}
+		nbytes &= DES_BLOCK_SIZE - 1;
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+	fprs_write(0);
+	return err;
+}
+
+extern void des3_ede_sparc64_cbc_decrypt(const u64 *expkey, const u64 *input,
+					 u64 *output, unsigned int len,
+					 u64 *iv);
+
+static int cbc3_decrypt(struct blkcipher_desc *desc,
+			struct scatterlist *dst, struct scatterlist *src,
+			unsigned int nbytes)
+{
+	struct des3_ede_sparc64_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+	const u64 *K;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	K = &ctx->decrypt_expkey[0];
+	des3_ede_sparc64_load_keys(K);
+	while ((nbytes = walk.nbytes)) {
+		unsigned int block_len = nbytes & DES_BLOCK_MASK;
+
+		if (likely(block_len)) {
+			const u64 *src64 = (const u64 *)walk.src.virt.addr;
+			des3_ede_sparc64_cbc_decrypt(K, src64,
+						     (u64 *) walk.dst.virt.addr,
+						     block_len,
+						     (u64 *) walk.iv);
+		}
+		nbytes &= DES_BLOCK_SIZE - 1;
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+	fprs_write(0);
+	return err;
+}
+
+static struct crypto_alg algs[] = { {
+	.cra_name		= "des",
+	.cra_driver_name	= "des-sparc64",
+	.cra_priority		= 150,
+	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
+	.cra_blocksize		= DES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct des_sparc64_ctx),
+	.cra_alignmask		= 7,
+	.cra_module		= THIS_MODULE,
+	.cra_u	= {
+		.cipher	= {
+			.cia_min_keysize	= DES_KEY_SIZE,
+			.cia_max_keysize	= DES_KEY_SIZE,
+			.cia_setkey		= des_set_key,
+			.cia_encrypt		= des_encrypt,
+			.cia_decrypt		= des_decrypt
+		}
+	}
+}, {
+	.cra_name		= "ecb(des)",
+	.cra_driver_name	= "ecb-des-sparc64",
+	.cra_priority		= 150,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= DES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct des_sparc64_ctx),
+	.cra_alignmask		= 7,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= DES_KEY_SIZE,
+			.max_keysize	= DES_KEY_SIZE,
+			.setkey		= des_set_key,
+			.encrypt	= ecb_encrypt,
+			.decrypt	= ecb_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "cbc(des)",
+	.cra_driver_name	= "cbc-des-sparc64",
+	.cra_priority		= 150,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= DES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct des_sparc64_ctx),
+	.cra_alignmask		= 7,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= DES_KEY_SIZE,
+			.max_keysize	= DES_KEY_SIZE,
+			.setkey		= des_set_key,
+			.encrypt	= cbc_encrypt,
+			.decrypt	= cbc_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "des3_ede",
+	.cra_driver_name	= "des3_ede-sparc64",
+	.cra_priority		= 150,
+	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
+	.cra_blocksize		= DES3_EDE_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct des3_ede_sparc64_ctx),
+	.cra_alignmask		= 7,
+	.cra_module		= THIS_MODULE,
+	.cra_u	= {
+		.cipher	= {
+			.cia_min_keysize	= DES3_EDE_KEY_SIZE,
+			.cia_max_keysize	= DES3_EDE_KEY_SIZE,
+			.cia_setkey		= des3_ede_set_key,
+			.cia_encrypt		= des3_ede_encrypt,
+			.cia_decrypt		= des3_ede_decrypt
+		}
+	}
+}, {
+	.cra_name		= "ecb(des3_ede)",
+	.cra_driver_name	= "ecb-des3_ede-sparc64",
+	.cra_priority		= 150,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= DES3_EDE_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct des3_ede_sparc64_ctx),
+	.cra_alignmask		= 7,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= DES3_EDE_KEY_SIZE,
+			.max_keysize	= DES3_EDE_KEY_SIZE,
+			.setkey		= des3_ede_set_key,
+			.encrypt	= ecb3_encrypt,
+			.decrypt	= ecb3_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "cbc(des3_ede)",
+	.cra_driver_name	= "cbc-des3_ede-sparc64",
+	.cra_priority		= 150,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= DES3_EDE_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct des3_ede_sparc64_ctx),
+	.cra_alignmask		= 7,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= DES3_EDE_KEY_SIZE,
+			.max_keysize	= DES3_EDE_KEY_SIZE,
+			.setkey		= des3_ede_set_key,
+			.encrypt	= cbc3_encrypt,
+			.decrypt	= cbc3_decrypt,
+		},
+	},
+} };
+
+static bool __init sparc64_has_des_opcode(void)
+{
+	unsigned long cfr;
+
+	if (!(sparc64_elf_hwcap & HWCAP_SPARC_CRYPTO))
+		return false;
+
+	__asm__ __volatile__("rd %%asr26, %0" : "=r" (cfr));
+	if (!(cfr & CFR_DES))
+		return false;
+
+	return true;
+}
+
+static int __init des_sparc64_mod_init(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(algs); i++)
+		INIT_LIST_HEAD(&algs[i].cra_list);
+
+	if (sparc64_has_des_opcode()) {
+		pr_info("Using sparc64 des opcodes optimized DES implementation\n");
+		return crypto_register_algs(algs, ARRAY_SIZE(algs));
+	}
+	pr_info("sparc64 des opcodes not available.\n");
+	return -ENODEV;
+}
+
+static void __exit des_sparc64_mod_fini(void)
+{
+	crypto_unregister_algs(algs, ARRAY_SIZE(algs));
+}
+
+module_init(des_sparc64_mod_init);
+module_exit(des_sparc64_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("DES & Triple DES EDE Cipher Algorithms, sparc64 des opcode accelerated");
+
+MODULE_ALIAS("des");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 83993ea..469fc18 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -778,6 +778,14 @@ config CRYPTO_DES
 	help
 	  DES cipher algorithm (FIPS 46-2), and Triple DES EDE (FIPS 46-3).
 
+config CRYPTO_DES_SPARC64
+	tristate "DES and Triple DES EDE cipher algorithms (SPARC64)"
+	select CRYPTO_ALGAPI
+	select CRYPTO_DES
+	help
+	  DES cipher algorithm (FIPS 46-2), and Triple DES EDE (FIPS 46-3),
+	  optimized using SPARC64 crypto opcodes.
+
 config CRYPTO_FCRYPT
 	tristate "FCrypt cipher algorithm"
 	select CRYPTO_ALGAPI
-- 
1.7.10.4
