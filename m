From: David Miller <davem@davemloft.net>
Subject: [PATCH] sparc64: Add AES driver making use of the new aes opcodes.
Date: Wed, 22 Aug 2012 02:21:18 -0700 (PDT)
Message-ID: <20120822.022118.64713091452626424.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: sparclinux@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:51181 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758810Ab2HVJVV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Aug 2012 05:21:21 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: David S. Miller <davem@davemloft.net>
---

Currently supports ECB and CBC block modes.  I'll add CTR and maybe
some others when I get a chance.

If you're familiar with Intel AESNI stuff, these instructions provide
nearly identical functionality.  The difference is that we only have
64-bit float registers, so it takes two instructions to do a round.
The other difference is that the instructions are setup such that we
work from a single expanded key to do both encryption and decryption,
rather than a seperate one for each.

As for other encryption algorithms, these chips can do DES (which I
plan to work on next), Camellia, and Kasumi.  We have a generic
Camellia implementation and thus test vectors, so I'm likely to work
on support for that.  For Kasumi, we lack a generic implementation and
test vectors, and thus I'm very much not motivated to do anything with
it :-)

Finally I'll probably add support at some point for the crc32c
instruction as well.

 arch/sparc/crypto/Makefile   |    4 +
 arch/sparc/crypto/aes_asm.S  |  836 ++++++++++++++++++++++++++++++++++++++++++
 arch/sparc/crypto/aes_glue.c |  323 ++++++++++++++++
 crypto/Kconfig               |   28 ++
 4 files changed, 1191 insertions(+)
 create mode 100644 arch/sparc/crypto/aes_asm.S
 create mode 100644 arch/sparc/crypto/aes_glue.c

diff --git a/arch/sparc/crypto/Makefile b/arch/sparc/crypto/Makefile
index 5356698..5034324 100644
--- a/arch/sparc/crypto/Makefile
+++ b/arch/sparc/crypto/Makefile
@@ -7,7 +7,11 @@ obj-$(CONFIG_CRYPTO_SHA256_SPARC64) += sha256-sparc64.o
 obj-$(CONFIG_CRYPTO_SHA512_SPARC64) += sha512-sparc64.o
 obj-$(CONFIG_CRYPTO_MD5_SPARC64) += md5-sparc64.o
 
+obj-$(CONFIG_CRYPTO_AES_SPARC64) += aes-sparc64.o
+
 sha1-sparc64-y := sha1_asm.o sha1_glue.o
 sha256-sparc64-y := sha256_asm.o sha256_glue.o
 sha512-sparc64-y := sha512_asm.o sha512_glue.o
 md5-sparc64-y := md5_asm.o md5_glue.o
+
+aes-sparc64-y := aes_asm.o aes_glue.o
diff --git a/arch/sparc/crypto/aes_asm.S b/arch/sparc/crypto/aes_asm.S
new file mode 100644
index 0000000..f656dc7
--- /dev/null
+++ b/arch/sparc/crypto/aes_asm.S
@@ -0,0 +1,836 @@
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
+#define IMM5(x)		((x)           <<  9)
+
+#define AES_EROUND01(a,b,c,d)	\
+	.word	(F3F(2, 0x19, 0)|RS1(a)|RS2(b)|RS3(c)|RD(d));
+#define AES_EROUND23(a,b,c,d)	\
+	.word	(F3F(2, 0x19, 1)|RS1(a)|RS2(b)|RS3(c)|RD(d));
+#define AES_DROUND01(a,b,c,d)	\
+	.word	(F3F(2, 0x19, 2)|RS1(a)|RS2(b)|RS3(c)|RD(d));
+#define AES_DROUND23(a,b,c,d)	\
+	.word	(F3F(2, 0x19, 3)|RS1(a)|RS2(b)|RS3(c)|RD(d));
+#define AES_EROUND01_L(a,b,c,d)	\
+	.word	(F3F(2, 0x19, 4)|RS1(a)|RS2(b)|RS3(c)|RD(d));
+#define AES_EROUND23_L(a,b,c,d)	\
+	.word	(F3F(2, 0x19, 5)|RS1(a)|RS2(b)|RS3(c)|RD(d));
+#define AES_DROUND01_L(a,b,c,d)	\
+	.word	(F3F(2, 0x19, 6)|RS1(a)|RS2(b)|RS3(c)|RD(d));
+#define AES_DROUND23_L(a,b,c,d)	\
+	.word	(F3F(2, 0x19, 7)|RS1(a)|RS2(b)|RS3(c)|RD(d));
+#define AES_KEXPAND1(a,b,c,d)	\
+	.word	(F3F(2, 0x19, 8)|RS1(a)|RS2(b)|IMM5(c)|RD(d));
+#define AES_KEXPAND0(a,b,c)	\
+	.word	(F3F(2, 0x36, 0x130)|RS1(a)|RS2(b)|RD(c));
+#define AES_KEXPAND2(a,b,c)	\
+	.word	(F3F(2, 0x36, 0x131)|RS1(a)|RS2(b)|RD(c));
+
+#define MOVXTOD_G3_F4		\
+	.word	0x89b02303;
+#define MOVXTOD_G7_F6		\
+	.word	0x8db02307;
+#define MOVXTOD_G3_F0		\
+	.word	0x81b02303;
+#define MOVXTOD_G7_F2		\
+	.word	0x85b02307;
+#define MOVXTOD_O0_F0		\
+	.word	0x81b02308;
+#define MOVXTOD_O1_F2		\
+	.word	0x85b02309;
+
+#define ENCRYPT_TWO_ROUNDS(KEY_BASE, I0, I1, T0, T1) \
+	AES_EROUND01(KEY_BASE +  0, I0, I1, T0) \
+	AES_EROUND23(KEY_BASE +  2, I0, I1, T1) \
+	AES_EROUND01(KEY_BASE +  4, T0, T1, I0) \
+	AES_EROUND23(KEY_BASE +  6, T0, T1, I1)
+
+#define ENCRYPT_TWO_ROUNDS_LAST(KEY_BASE, I0, I1, T0, T1) \
+	AES_EROUND01(KEY_BASE +  0, I0, I1, T0) \
+	AES_EROUND23(KEY_BASE +  2, I0, I1, T1) \
+	AES_EROUND01_L(KEY_BASE +  4, T0, T1, I0) \
+	AES_EROUND23_L(KEY_BASE +  6, T0, T1, I1)
+
+	/* 10 rounds */
+#define ENCRYPT_128(KEY_BASE, I0, I1, T0, T1) \
+	ENCRYPT_TWO_ROUNDS(KEY_BASE +  0, I0, I1, T0, T1) \
+	ENCRYPT_TWO_ROUNDS(KEY_BASE +  8, I0, I1, T0, T1) \
+	ENCRYPT_TWO_ROUNDS(KEY_BASE + 16, I0, I1, T0, T1) \
+	ENCRYPT_TWO_ROUNDS(KEY_BASE + 24, I0, I1, T0, T1) \
+	ENCRYPT_TWO_ROUNDS_LAST(KEY_BASE + 32, I0, I1, T0, T1)
+
+	/* 12 rounds */
+#define ENCRYPT_192(KEY_BASE, I0, I1, T0, T1) \
+	ENCRYPT_TWO_ROUNDS(KEY_BASE +  0, I0, I1, T0, T1) \
+	ENCRYPT_TWO_ROUNDS(KEY_BASE +  8, I0, I1, T0, T1) \
+	ENCRYPT_TWO_ROUNDS(KEY_BASE + 16, I0, I1, T0, T1) \
+	ENCRYPT_TWO_ROUNDS(KEY_BASE + 24, I0, I1, T0, T1) \
+	ENCRYPT_TWO_ROUNDS(KEY_BASE + 32, I0, I1, T0, T1) \
+	ENCRYPT_TWO_ROUNDS_LAST(KEY_BASE + 40, I0, I1, T0, T1)
+
+	/* 14 rounds */
+#define ENCRYPT_256(KEY_BASE, I0, I1, T0, T1) \
+	ENCRYPT_TWO_ROUNDS(KEY_BASE +  0, I0, I1, T0, T1) \
+	ENCRYPT_TWO_ROUNDS(KEY_BASE +  8, I0, I1, T0, T1) \
+	ENCRYPT_TWO_ROUNDS(KEY_BASE + 16, I0, I1, T0, T1) \
+	ENCRYPT_TWO_ROUNDS(KEY_BASE + 24, I0, I1, T0, T1) \
+	ENCRYPT_TWO_ROUNDS(KEY_BASE + 32, I0, I1, T0, T1) \
+	ENCRYPT_TWO_ROUNDS(KEY_BASE + 40, I0, I1, T0, T1) \
+	ENCRYPT_TWO_ROUNDS_LAST(KEY_BASE + 48, I0, I1, T0, T1)
+
+#define DECRYPT_TWO_ROUNDS(KEY_TOP, I0, I1, T0, T1) \
+	AES_DROUND23(KEY_TOP -  2, I0, I1, T1) \
+	AES_DROUND01(KEY_TOP -  4, I0, I1, T0) \
+	AES_DROUND23(KEY_TOP -  6, T0, T1, I1) \
+	AES_DROUND01(KEY_TOP -  8, T0, T1, I0)
+
+#define DECRYPT_TWO_ROUNDS_LAST(KEY_TOP, I0, I1, T0, T1) \
+	AES_DROUND23(KEY_TOP -  2, I0, I1, T1) \
+	AES_DROUND01(KEY_TOP -  4, I0, I1, T0) \
+	AES_DROUND23_L(KEY_TOP -  6, T0, T1, I1) \
+	AES_DROUND01_L(KEY_TOP -  8, T0, T1, I0)
+
+	/* 10 rounds */
+#define DECRYPT_128(KEY_TOP, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS(KEY_TOP -  0, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS(KEY_TOP -  8, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS(KEY_TOP - 16, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS(KEY_TOP - 24, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS_LAST(KEY_TOP - 32, I0, I1, T0, T1)
+
+	/* 12 rounds */
+#define DECRYPT_192(KEY_TOP, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS(KEY_TOP -  0, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS(KEY_TOP -  8, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS(KEY_TOP - 16, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS(KEY_TOP - 24, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS(KEY_TOP - 32, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS_LAST(KEY_TOP - 40, I0, I1, T0, T1)
+
+	/* 14 rounds */
+#define DECRYPT_256(KEY_TOP, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS(KEY_TOP -  0, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS(KEY_TOP -  8, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS(KEY_TOP - 16, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS(KEY_TOP - 24, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS(KEY_TOP - 32, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS(KEY_TOP - 40, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS_LAST(KEY_TOP - 48, I0, I1, T0, T1)
+
+ENTRY(aes_sparc64_key_expand)
+	/* %o0=input_key, %o1=output_key, %o2=key_len */
+	VISEntry
+	ld	[%o0 + 0x00], %f0
+	ld	[%o0 + 0x04], %f1
+	ld	[%o0 + 0x08], %f2
+	ld	[%o0 + 0x0c], %f3
+
+	std	%f0, [%o1 + 0x00]
+	std	%f2, [%o1 + 0x08]
+	add	%o1, 0x10, %o1
+
+	cmp	%o2, 24
+	bl	2f
+	 nop
+
+	be	1f
+	 nop
+
+	/* 256-bit key expansion */
+	ld	[%o0 + 0x10], %f4
+	ld	[%o0 + 0x14], %f5
+	ld	[%o0 + 0x18], %f6
+	ld	[%o0 + 0x1c], %f7
+
+	std	%f4, [%o1 + 0x00]
+	std	%f6, [%o1 + 0x08]
+	add	%o1, 0x10, %o1
+
+	AES_KEXPAND1(0, 6, 0x0, 8)
+	AES_KEXPAND2(2, 8, 10)
+	AES_KEXPAND0(4, 10, 12)
+	AES_KEXPAND2(6, 12, 14)
+	AES_KEXPAND1(8, 14, 0x1, 16)
+	AES_KEXPAND2(10, 16, 18)
+	AES_KEXPAND0(12, 18, 20)
+	AES_KEXPAND2(14, 20, 22)
+	AES_KEXPAND1(16, 22, 0x2, 24)
+	AES_KEXPAND2(18, 24, 26)
+	AES_KEXPAND0(20, 26, 28)
+	AES_KEXPAND2(22, 28, 30)
+	AES_KEXPAND1(24, 30, 0x3, 32)
+	AES_KEXPAND2(26, 32, 34)
+	AES_KEXPAND0(28, 34, 36)
+	AES_KEXPAND2(30, 36, 38)
+	AES_KEXPAND1(32, 38, 0x4, 40)
+	AES_KEXPAND2(34, 40, 42)
+	AES_KEXPAND0(36, 42, 44)
+	AES_KEXPAND2(38, 44, 46)
+	AES_KEXPAND1(40, 46, 0x5, 48)
+	AES_KEXPAND2(42, 48, 50)
+	AES_KEXPAND0(44, 50, 52)
+	AES_KEXPAND2(46, 52, 54)
+	AES_KEXPAND1(48, 54, 0x6, 56)
+	AES_KEXPAND2(50, 56, 58)
+
+	std	%f8, [%o1 + 0x00]
+	std	%f10, [%o1 + 0x08]
+	std	%f12, [%o1 + 0x10]
+	std	%f14, [%o1 + 0x18]
+	std	%f16, [%o1 + 0x20]
+	std	%f18, [%o1 + 0x28]
+	std	%f20, [%o1 + 0x30]
+	std	%f22, [%o1 + 0x38]
+	std	%f24, [%o1 + 0x40]
+	std	%f26, [%o1 + 0x48]
+	std	%f28, [%o1 + 0x50]
+	std	%f30, [%o1 + 0x58]
+	std	%f32, [%o1 + 0x60]
+	std	%f34, [%o1 + 0x68]
+	std	%f36, [%o1 + 0x70]
+	std	%f38, [%o1 + 0x78]
+	std	%f40, [%o1 + 0x80]
+	std	%f42, [%o1 + 0x88]
+	std	%f44, [%o1 + 0x90]
+	std	%f46, [%o1 + 0x98]
+	std	%f48, [%o1 + 0xa0]
+	std	%f50, [%o1 + 0xa8]
+	std	%f52, [%o1 + 0xb0]
+	std	%f54, [%o1 + 0xb8]
+	std	%f56, [%o1 + 0xc0]
+	ba,pt	%xcc, 80f
+	 std	%f58, [%o1 + 0xc8]
+
+1:	
+	/* 192-bit key expansion */
+	ld	[%o0 + 0x10], %f4
+	ld	[%o0 + 0x14], %f5
+
+	std	%f4, [%o1 + 0x00]
+	add	%o1, 0x08, %o1
+
+	AES_KEXPAND1(0, 4, 0x0, 6)
+	AES_KEXPAND2(2, 6, 8)
+	AES_KEXPAND2(4, 8, 10)
+	AES_KEXPAND1(6, 10, 0x1, 12)
+	AES_KEXPAND2(8, 12, 14)
+	AES_KEXPAND2(10, 14, 16)
+	AES_KEXPAND1(12, 16, 0x2, 18)
+	AES_KEXPAND2(14, 18, 20)
+	AES_KEXPAND2(16, 20, 22)
+	AES_KEXPAND1(18, 22, 0x3, 24)
+	AES_KEXPAND2(20, 24, 26)
+	AES_KEXPAND2(22, 26, 28)
+	AES_KEXPAND1(24, 28, 0x4, 30)
+	AES_KEXPAND2(26, 30, 32)
+	AES_KEXPAND2(28, 32, 34)
+	AES_KEXPAND1(30, 34, 0x5, 36)
+	AES_KEXPAND2(32, 36, 38)
+	AES_KEXPAND2(34, 38, 40)
+	AES_KEXPAND1(36, 40, 0x6, 42)
+	AES_KEXPAND2(38, 42, 44)
+	AES_KEXPAND2(40, 44, 46)
+	AES_KEXPAND1(42, 46, 0x7, 48)
+	AES_KEXPAND2(44, 48, 50)
+
+	std	%f6, [%o1 + 0x00]
+	std	%f8, [%o1 + 0x08]
+	std	%f10, [%o1 + 0x10]
+	std	%f12, [%o1 + 0x18]
+	std	%f14, [%o1 + 0x20]
+	std	%f16, [%o1 + 0x28]
+	std	%f18, [%o1 + 0x30]
+	std	%f20, [%o1 + 0x38]
+	std	%f22, [%o1 + 0x40]
+	std	%f24, [%o1 + 0x48]
+	std	%f26, [%o1 + 0x50]
+	std	%f28, [%o1 + 0x58]
+	std	%f30, [%o1 + 0x60]
+	std	%f32, [%o1 + 0x68]
+	std	%f34, [%o1 + 0x70]
+	std	%f36, [%o1 + 0x78]
+	std	%f38, [%o1 + 0x80]
+	std	%f40, [%o1 + 0x88]
+	std	%f42, [%o1 + 0x90]
+	std	%f44, [%o1 + 0x98]
+	std	%f46, [%o1 + 0xa0]
+	std	%f48, [%o1 + 0xa8]
+	ba,pt	%xcc, 80f
+	 std	%f50, [%o1 + 0xb0]
+
+2:
+	/* 128-bit key expansion */
+	AES_KEXPAND1(0, 2, 0x0, 4)
+	AES_KEXPAND2(2, 4, 6)
+	AES_KEXPAND1(4, 6, 0x1, 8)
+	AES_KEXPAND2(6, 8, 10)
+	AES_KEXPAND1(8, 10, 0x2, 12)
+	AES_KEXPAND2(10, 12, 14)
+	AES_KEXPAND1(12, 14, 0x3, 16)
+	AES_KEXPAND2(14, 16, 18)
+	AES_KEXPAND1(16, 18, 0x4, 20)
+	AES_KEXPAND2(18, 20, 22)
+	AES_KEXPAND1(20, 22, 0x5, 24)
+	AES_KEXPAND2(22, 24, 26)
+	AES_KEXPAND1(24, 26, 0x6, 28)
+	AES_KEXPAND2(26, 28, 30)
+	AES_KEXPAND1(28, 30, 0x7, 32)
+	AES_KEXPAND2(30, 32, 34)
+	AES_KEXPAND1(32, 34, 0x8, 36)
+	AES_KEXPAND2(34, 36, 38)
+	AES_KEXPAND1(36, 38, 0x9, 40)
+	AES_KEXPAND2(38, 40, 42)
+
+	std	%f4, [%o1 + 0x00]
+	std	%f6, [%o1 + 0x08]
+	std	%f8, [%o1 + 0x10]
+	std	%f10, [%o1 + 0x18]
+	std	%f12, [%o1 + 0x20]
+	std	%f14, [%o1 + 0x28]
+	std	%f16, [%o1 + 0x30]
+	std	%f18, [%o1 + 0x38]
+	std	%f20, [%o1 + 0x40]
+	std	%f22, [%o1 + 0x48]
+	std	%f24, [%o1 + 0x50]
+	std	%f26, [%o1 + 0x58]
+	std	%f28, [%o1 + 0x60]
+	std	%f30, [%o1 + 0x68]
+	std	%f32, [%o1 + 0x70]
+	std	%f34, [%o1 + 0x78]
+	std	%f36, [%o1 + 0x80]
+	std	%f38, [%o1 + 0x88]
+	std	%f40, [%o1 + 0x90]
+	std	%f42, [%o1 + 0x98]
+80:
+	retl
+	 VISExit
+ENDPROC(aes_sparc64_key_expand)
+
+ENTRY(aes_sparc64_encrypt)
+	/* %o0=key, %o1=input, %o2=output, %o3=key_len */
+	VISEntry
+	ld		[%o1 + 0x00], %f4
+	ld		[%o1 + 0x04], %f5
+	ld		[%o1 + 0x08], %f6
+	ld		[%o1 + 0x0c], %f7
+
+	ldd		[%o0 + 0x00], %f8
+	ldd		[%o0 + 0x08], %f10
+	cmp		%o3, 24
+	fxor		%f8, %f4, %f4
+	bl		2f
+	 fxor		%f10, %f6, %f6
+
+	be		1f
+	 ldd		[%o0 + 0x10], %f8
+
+	ldd		[%o0 + 0x18], %f10
+	ldd		[%o0 + 0x20], %f12
+	ldd		[%o0 + 0x28], %f14
+	add		%o0, 0x20, %o0
+
+	ENCRYPT_TWO_ROUNDS(8, 4, 6, 0, 2)
+
+	ldd		[%o0 + 0x10], %f8
+
+1:
+	ldd		[%o0 + 0x18], %f10
+	ldd		[%o0 + 0x20], %f12
+	ldd		[%o0 + 0x28], %f14
+	add		%o0, 0x20, %o0
+
+	ENCRYPT_TWO_ROUNDS(8, 4, 6, 0, 2)
+
+2:
+	ldd		[%o0 + 0x10], %f12
+	ldd		[%o0 + 0x18], %f14
+	ldd		[%o0 + 0x20], %f16
+	ldd		[%o0 + 0x28], %f18
+	ldd		[%o0 + 0x30], %f20
+	ldd		[%o0 + 0x38], %f22
+	ldd		[%o0 + 0x40], %f24
+	ldd		[%o0 + 0x48], %f26
+	ldd		[%o0 + 0x50], %f28
+	ldd		[%o0 + 0x58], %f30
+	ldd		[%o0 + 0x60], %f32
+	ldd		[%o0 + 0x68], %f34
+	ldd		[%o0 + 0x70], %f36
+	ldd		[%o0 + 0x78], %f38
+	ldd		[%o0 + 0x80], %f40
+	ldd		[%o0 + 0x88], %f42
+	ldd		[%o0 + 0x90], %f44
+	ldd		[%o0 + 0x98], %f46
+	ldd		[%o0 + 0xa0], %f48
+	ldd		[%o0 + 0xa8], %f50
+
+
+	ENCRYPT_128(12, 4, 6, 0, 2)
+
+	st		%f4, [%o2 + 0x00]
+	st		%f5, [%o2 + 0x04]
+	st		%f6, [%o2 + 0x08]
+	st		%f7, [%o2 + 0x0c]
+
+	retl
+	 VISExit
+ENDPROC(aes_sparc64_encrypt)
+
+ENTRY(aes_sparc64_decrypt)
+	/* %o0=key, %o1=input, %o2=output, %o3=key_len, %o4=exp_key_len */
+	VISEntry
+	ld		[%o1 + 0x00], %f4
+	add		%o0, %o4, %o0
+	ld		[%o1 + 0x04], %f5
+	ld		[%o1 + 0x08], %f6
+	ld		[%o1 + 0x0c], %f7
+	
+	ldd		[%o0 - 0x08], %f8
+	ldd		[%o0 - 0x10], %f10
+
+	cmp		%o3, 24
+	fxor		%f10, %f4, %f4
+	bl		2f
+	 fxor		%f8, %f6, %f6
+
+	be		1f
+	 ldd		[%o0 - 0x30], %f8
+
+	ldd		[%o0 - 0x28], %f10
+	ldd		[%o0 - 0x20], %f12
+	ldd		[%o0 - 0x18], %f14
+	sub		%o0, 0x20, %o0
+
+	DECRYPT_TWO_ROUNDS(16, 4, 6, 0, 2)
+
+	ldd		[%o0 - 0x30], %f8
+1:
+	ldd		[%o0 - 0x28], %f10
+	ldd		[%o0 - 0x20], %f12
+	ldd		[%o0 - 0x18], %f14
+	sub		%o0, 0x20, %o0
+
+	DECRYPT_TWO_ROUNDS(16, 4, 6, 0, 2)
+2:
+	ldd		[%o0 - 0xb0], %f12
+	ldd		[%o0 - 0xa8], %f14
+	ldd		[%o0 - 0xa0], %f16
+	ldd		[%o0 - 0x98], %f18
+	ldd		[%o0 - 0x90], %f20
+	ldd		[%o0 - 0x88], %f22
+	ldd		[%o0 - 0x80], %f24
+	ldd		[%o0 - 0x78], %f26
+	ldd		[%o0 - 0x70], %f28
+	ldd		[%o0 - 0x68], %f30
+	ldd		[%o0 - 0x60], %f32
+	ldd		[%o0 - 0x58], %f34
+	ldd		[%o0 - 0x50], %f36
+	ldd		[%o0 - 0x48], %f38
+	ldd		[%o0 - 0x40], %f40
+	ldd		[%o0 - 0x38], %f42
+	ldd		[%o0 - 0x30], %f44
+	ldd		[%o0 - 0x28], %f46
+	ldd		[%o0 - 0x20], %f48
+	ldd		[%o0 - 0x18], %f50
+
+	DECRYPT_128(52, 4, 6, 0, 2)
+
+	st		%f4, [%o2 + 0x00]
+	st		%f5, [%o2 + 0x04]
+	st		%f6, [%o2 + 0x08]
+	st		%f7, [%o2 + 0x0c]
+
+	retl
+	 VISExit
+ENDPROC(aes_sparc64_decrypt)
+
+ENTRY(aes_sparc64_load_decrypt_keys)
+	/* %o0=key */
+	ba,pt		%xcc, aes_sparc64_load_encrypt_keys
+	 sub		%o0, 0x10, %o0
+ENDPROC(aes_sparc64_load_decrypt_keys)
+
+ENTRY(aes_sparc64_load_encrypt_keys)
+	/* %o0=key */
+	VISEntry
+	ldd		[%o0 + 0x10], %f8
+	ldd		[%o0 + 0x18], %f10
+	ldd		[%o0 + 0x20], %f12
+	ldd		[%o0 + 0x28], %f14
+	ldd		[%o0 + 0x30], %f16
+	ldd		[%o0 + 0x38], %f18
+	ldd		[%o0 + 0x40], %f20
+	ldd		[%o0 + 0x48], %f22
+	ldd		[%o0 + 0x50], %f24
+	ldd		[%o0 + 0x58], %f26
+	ldd		[%o0 + 0x60], %f28
+	ldd		[%o0 + 0x68], %f30
+	ldd		[%o0 + 0x70], %f32
+	ldd		[%o0 + 0x78], %f34
+	ldd		[%o0 + 0x80], %f36
+	ldd		[%o0 + 0x88], %f38
+	ldd		[%o0 + 0x90], %f40
+	ldd		[%o0 + 0x98], %f42
+	ldd		[%o0 + 0xa0], %f44
+	ldd		[%o0 + 0xa8], %f46
+	ldd		[%o0 + 0xb0], %f48
+	ldd		[%o0 + 0xb8], %f50
+	ldd		[%o0 + 0xc0], %f52
+	ldd		[%o0 + 0xc8], %f54
+	ldd		[%o0 + 0xd0], %f56
+	ldd		[%o0 + 0xd8], %f58
+	ldd		[%o0 + 0xe0], %f60
+	retl
+	 ldd		[%o0 + 0xe8], %f62
+ENDPROC(aes_sparc64_load_encrypt_keys)
+
+ENTRY(aes_sparc64_ecb_encrypt)
+	/* %o0=key, %o1=input, %o2=output, %o3=key_len, %o4=len */
+	ldx		[%o0 + 0x00], %g1
+	ldx		[%o0 + 0x08], %g2
+	cmp		%o3, 24
+	bl		2f
+	 nop
+	be		1f
+	 nop
+
+0:
+	/* 256-bit key */
+	ldx		[%o1 + 0x00], %g3
+	ldx		[%o1 + 0x08], %g7
+	add		%o1, 0x10, %o1
+	xor		%g1, %g3, %g3
+	xor		%g2, %g7, %g7
+	MOVXTOD_G3_F4
+	MOVXTOD_G7_F6
+
+	ENCRYPT_256(8, 4, 6, 0, 2)
+
+	std		%f4, [%o2 + 0x00]
+	std		%f6, [%o2 + 0x08]
+	subcc		%o4, 0x10, %o4
+	bne,pt		%xcc, 0b
+	 add		%o2, 0x10, %o2
+
+	retl
+	 nop
+
+1:
+	/* 192-bit key */
+	ldx		[%o1 + 0x00], %g3
+	ldx		[%o1 + 0x08], %g7
+	add		%o1, 0x10, %o1
+	xor		%g1, %g3, %g3
+	xor		%g2, %g7, %g7
+	MOVXTOD_G3_F4
+	MOVXTOD_G7_F6
+
+	ENCRYPT_192(8, 4, 6, 0, 2)
+
+	std		%f4, [%o2 + 0x00]
+	std		%f6, [%o2 + 0x08]
+	subcc		%o4, 0x10, %o4
+	bne,pt		%xcc, 1b
+	 add		%o2, 0x10, %o2
+
+	retl
+	 nop
+
+2:
+	/* 128-bit key */
+	ldx		[%o1 + 0x00], %g3
+	ldx		[%o1 + 0x08], %g7
+	add		%o1, 0x10, %o1
+	xor		%g1, %g3, %g3
+	xor		%g2, %g7, %g7
+	MOVXTOD_G3_F4
+	MOVXTOD_G7_F6
+
+	ENCRYPT_128(8, 4, 6, 0, 2)
+
+	std		%f4, [%o2 + 0x00]
+	std		%f6, [%o2 + 0x08]
+	subcc		%o4, 0x10, %o4
+	bne,pt		%xcc, 2b
+	 add		%o2, 0x10, %o2
+
+	retl
+	 nop
+ENDPROC(aes_sparc64_ecb_encrypt)
+
+ENTRY(aes_sparc64_ecb_decrypt)
+	/* %o0=&key[key_len], %o1=input, %o2=output, %o3=key_len, %o4=len, %o5=iv */
+	ldx		[%o0 - 0x10], %g1
+	ldx		[%o0 - 0x08], %g2
+	cmp		%o3, 24
+	bl		2f
+	 nop
+	be		1f
+	 nop
+
+0:
+	/* 256-bit key */
+	ldx		[%o1 + 0x00], %g3
+	ldx		[%o1 + 0x08], %g7
+	add		%o1, 0x10, %o1
+	xor		%g1, %g3, %g3
+	xor		%g2, %g7, %g7
+	MOVXTOD_G3_F4
+	MOVXTOD_G7_F6
+
+	DECRYPT_256(64, 4, 6, 0, 2)
+
+	std		%f4, [%o2 + 0x00]
+	std		%f6, [%o2 + 0x08]
+	subcc		%o4, 0x10, %o4
+	bne,pt		%xcc, 0b
+	 add		%o2, 0x10, %o2
+
+	retl
+	 nop
+
+1:
+	/* 192-bit key */
+	ldx		[%o1 + 0x00], %g3
+	ldx		[%o1 + 0x08], %g7
+	add		%o1, 0x10, %o1
+	xor		%g1, %g3, %g3
+	xor		%g2, %g7, %g7
+	MOVXTOD_G3_F4
+	MOVXTOD_G7_F6
+
+	DECRYPT_192(56, 4, 6, 0, 2)
+
+	std		%f4, [%o2 + 0x00]
+	std		%f6, [%o2 + 0x08]
+	subcc		%o4, 0x10, %o4
+	bne,pt		%xcc, 1b
+	 add		%o2, 0x10, %o2
+
+	retl
+	 nop
+
+2:
+	/* 128-bit key */
+	ldx		[%o1 + 0x00], %g3
+	ldx		[%o1 + 0x08], %g7
+	add		%o1, 0x10, %o1
+	xor		%g1, %g3, %g3
+	xor		%g2, %g7, %g7
+	MOVXTOD_G3_F4
+	MOVXTOD_G7_F6
+
+	DECRYPT_128(48, 4, 6, 0, 2)
+
+	std		%f4, [%o2 + 0x00]
+	std		%f6, [%o2 + 0x08]
+	subcc		%o4, 0x10, %o4
+	bne,pt		%xcc, 2b
+	 add		%o2, 0x10, %o2
+
+	retl
+	 nop
+ENDPROC(aes_sparc64_ecb_decrypt)
+
+ENTRY(aes_sparc64_cbc_encrypt)
+	/* %o0=key, %o1=input, %o2=output, %o3=key_len, %o4=len */
+	ldd		[%o5 + 0x00], %f4
+	ldd		[%o5 + 0x08], %f6
+	ldx		[%o0 + 0x00], %g1
+	ldx		[%o0 + 0x08], %g2
+	cmp		%o3, 24
+	bl		2f
+	 nop
+	be		1f
+	 nop
+
+0:
+	/* 256-bit key */
+	ldx		[%o1 + 0x00], %g3
+	ldx		[%o1 + 0x08], %g7
+	add		%o1, 0x10, %o1
+	xor		%g1, %g3, %g3
+	xor		%g2, %g7, %g7
+	MOVXTOD_G3_F0
+	MOVXTOD_G7_F2
+	fxor		%f4, %f0, %f4
+	fxor		%f6, %f2, %f6
+
+	ENCRYPT_256(8, 4, 6, 0, 2)
+
+	std		%f4, [%o2 + 0x00]
+	std		%f6, [%o2 + 0x08]
+	subcc		%o4, 0x10, %o4
+	bne,pt		%xcc, 0b
+	 add		%o2, 0x10, %o2
+
+	std		%f4, [%o5 + 0x00]
+	std		%f6, [%o5 + 0x08]
+
+	retl
+	 nop
+
+1:
+	/* 192-bit key */
+	ldx		[%o1 + 0x00], %g3
+	ldx		[%o1 + 0x08], %g7
+	add		%o1, 0x10, %o1
+	xor		%g1, %g3, %g3
+	xor		%g2, %g7, %g7
+	MOVXTOD_G3_F0
+	MOVXTOD_G7_F2
+	fxor		%f4, %f0, %f4
+	fxor		%f6, %f2, %f6
+
+	ENCRYPT_192(8, 4, 6, 0, 2)
+
+	std		%f4, [%o2 + 0x00]
+	std		%f6, [%o2 + 0x08]
+	subcc		%o4, 0x10, %o4
+	bne,pt		%xcc, 1b
+	 add		%o2, 0x10, %o2
+
+	std		%f4, [%o5 + 0x00]
+	std		%f6, [%o5 + 0x08]
+
+	retl
+	 nop
+
+2:
+	/* 128-bit key */
+	ldx		[%o1 + 0x00], %g3
+	ldx		[%o1 + 0x08], %g7
+	add		%o1, 0x10, %o1
+	xor		%g1, %g3, %g3
+	xor		%g2, %g7, %g7
+	MOVXTOD_G3_F0
+	MOVXTOD_G7_F2
+	fxor		%f4, %f0, %f4
+	fxor		%f6, %f2, %f6
+
+	ENCRYPT_128(8, 4, 6, 0, 2)
+
+	std		%f4, [%o2 + 0x00]
+	std		%f6, [%o2 + 0x08]
+	subcc		%o4, 0x10, %o4
+	bne,pt		%xcc, 2b
+	 add		%o2, 0x10, %o2
+
+	std		%f4, [%o5 + 0x00]
+	std		%f6, [%o5 + 0x08]
+
+	retl
+	 nop
+ENDPROC(aes_sparc64_cbc_encrypt)
+
+ENTRY(aes_sparc64_cbc_decrypt)
+	/* %o0=&key[key_len], %o1=key_len, %o2=input, %o3=output, %o4=len, %o5=iv */
+	ldx		[%o0 - 0x10], %g1
+	ldx		[%o0 - 0x08], %g2
+	cmp		%o1, 24
+	ldx		[%o5 + 0x00], %o0
+	bl		2f
+	 ldx		[%o5 + 0x08], %o1
+	be		1f
+	 nop
+
+0:
+	/* 256-bit key */
+	ldx		[%o2 + 0x00], %g3
+	ldx		[%o2 + 0x08], %g7
+	add		%o2, 0x10, %o2
+	xor		%g1, %g3, %g3
+	xor		%g2, %g7, %g7
+	MOVXTOD_G3_F4
+	MOVXTOD_G7_F6
+
+	DECRYPT_256(64, 4, 6, 0, 2)
+
+	MOVXTOD_O0_F0
+	MOVXTOD_O1_F2
+	xor		%g1, %g3, %o0
+	xor		%g2, %g7, %o1
+	fxor		%f4, %f0, %f4
+	fxor		%f6, %f2, %f6
+
+	std		%f4, [%o3 + 0x00]
+	std		%f6, [%o3 + 0x08]
+	subcc		%o4, 0x10, %o4
+	bne,pt		%xcc, 0b
+	 add		%o3, 0x10, %o3
+
+	stx		%o0, [%o5 + 0x00]
+	stx		%o1, [%o5 + 0x08]
+
+	retl
+	 nop
+
+1:
+	/* 192-bit key */
+	ldx		[%o2 + 0x00], %g3
+	ldx		[%o2 + 0x08], %g7
+	add		%o2, 0x10, %o2
+	xor		%g1, %g3, %g3
+	xor		%g2, %g7, %g7
+	MOVXTOD_G3_F4
+	MOVXTOD_G7_F6
+
+	DECRYPT_192(56, 4, 6, 0, 2)
+
+	MOVXTOD_O0_F0
+	MOVXTOD_O1_F2
+	xor		%g1, %g3, %o0
+	xor		%g2, %g7, %o1
+	fxor		%f4, %f0, %f4
+	fxor		%f6, %f2, %f6
+
+	std		%f4, [%o3 + 0x00]
+	std		%f6, [%o3 + 0x08]
+	subcc		%o4, 0x10, %o4
+	bne,pt		%xcc, 1b
+	 add		%o3, 0x10, %o3
+
+	stx		%o0, [%o5 + 0x00]
+	stx		%o1, [%o5 + 0x08]
+
+	retl
+	 nop
+
+2:
+	/* 128-bit key */
+	ldx		[%o2 + 0x00], %g3
+	ldx		[%o2 + 0x08], %g7
+	add		%o2, 0x10, %o2
+	xor		%g1, %g3, %g3
+	xor		%g2, %g7, %g7
+	MOVXTOD_G3_F4
+	MOVXTOD_G7_F6
+
+	DECRYPT_128(48, 4, 6, 0, 2)
+
+	MOVXTOD_O0_F0
+	MOVXTOD_O1_F2
+	xor		%g1, %g3, %o0
+	xor		%g2, %g7, %o1
+	fxor		%f4, %f0, %f4
+	fxor		%f6, %f2, %f6
+
+	std		%f4, [%o3 + 0x00]
+	std		%f6, [%o3 + 0x08]
+	subcc		%o4, 0x10, %o4
+	bne,pt		%xcc, 2b
+	 add		%o3, 0x10, %o3
+
+	stx		%o0, [%o5 + 0x00]
+	stx		%o1, [%o5 + 0x08]
+
+	retl
+	 nop
+ENDPROC(aes_sparc64_cbc_decrypt)
diff --git a/arch/sparc/crypto/aes_glue.c b/arch/sparc/crypto/aes_glue.c
new file mode 100644
index 0000000..a87c5fa
--- /dev/null
+++ b/arch/sparc/crypto/aes_glue.c
@@ -0,0 +1,323 @@
+/* Glue code for AES encryption optimized for sparc64 crypto opcodes.
+ *
+ * This is based largely upon arch/x86/crypto/aesni-intel_glue.c
+ *
+ * Copyright (C) 2008, Intel Corp.
+ *    Author: Huang Ying <ying.huang@intel.com>
+ *
+ * Added RFC4106 AES-GCM support for 128-bit keys under the AEAD
+ * interface for 64-bit kernels.
+ *    Authors: Adrian Hoban <adrian.hoban@intel.com>
+ *             Gabriele Paoloni <gabriele.paoloni@intel.com>
+ *             Tadeusz Struk (tadeusz.struk@intel.com)
+ *             Aidan O'Mahony (aidan.o.mahony@intel.com)
+ *    Copyright (c) 2010, Intel Corporation.
+ */
+
+#include <linux/crypto.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/types.h>
+#include <crypto/algapi.h>
+#include <crypto/aes.h>
+
+#include <asm/fpumacro.h>
+#include <asm/pstate.h>
+#include <asm/elf.h>
+
+struct crypto_sparc64_aes_ctx {
+	u64 key[AES_MAX_KEYLENGTH / sizeof(u64)];
+	u32 key_length;
+	u32 expanded_key_length;
+};
+
+extern void aes_sparc64_key_expand(const u32 *in_key, u64 *output_key,
+				   unsigned int key_len);
+
+static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
+		       unsigned int key_len)
+{
+	struct crypto_sparc64_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+	u32 *flags = &tfm->crt_flags;
+
+	switch (key_len) {
+	case AES_KEYSIZE_128:
+		ctx->expanded_key_length = 0xb0;
+		break;
+
+	case AES_KEYSIZE_192:
+		ctx->expanded_key_length = 0xd0;
+		break;
+
+	case AES_KEYSIZE_256:
+		ctx->expanded_key_length = 0xf0;
+		break;
+
+	default:
+		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+		return -EINVAL;
+	}
+
+	aes_sparc64_key_expand((const u32 *)in_key, &ctx->key[0], key_len);
+	ctx->key_length = key_len;
+
+	return 0;
+}
+
+extern void aes_sparc64_encrypt(const u64 *key, const u32 *input,
+				u32 *output, unsigned int key_len);
+
+static void aes_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+{
+	struct crypto_sparc64_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	aes_sparc64_encrypt(&ctx->key[0], (const u32 *) src,
+			    (u32 *) dst, ctx->key_length);
+}
+
+extern void aes_sparc64_decrypt(const u64 *key, const u32 *input,
+				u32 *output, unsigned int key_len,
+				unsigned int expanded_key_len);
+
+static void aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+{
+	struct crypto_sparc64_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	aes_sparc64_decrypt(&ctx->key[0], (const u32 *) src,
+			    (u32 *) dst, ctx->key_length,
+			    ctx->expanded_key_length);
+}
+
+extern void aes_sparc64_load_encrypt_keys(u64 *key);
+extern void aes_sparc64_load_decrypt_keys(u64 *key);
+
+#define AES_BLOCK_MASK	(~(AES_BLOCK_SIZE-1))
+
+extern void aes_sparc64_ecb_encrypt(u64 *key, const u32 *input, u32 *output,
+				    unsigned int key_len, unsigned int len);
+
+static int ecb_encrypt(struct blkcipher_desc *desc,
+		       struct scatterlist *dst, struct scatterlist *src,
+		       unsigned int nbytes)
+{
+	struct crypto_sparc64_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	aes_sparc64_load_encrypt_keys(&ctx->key[0]);
+	while ((nbytes = walk.nbytes)) {
+		unsigned int block_len = nbytes & AES_BLOCK_MASK;
+
+		if (likely(block_len)) {
+			aes_sparc64_ecb_encrypt(&ctx->key[0],
+						(const u32 *)walk.src.virt.addr,
+						(u32 *) walk.dst.virt.addr,
+						ctx->key_length, block_len);
+		}
+		nbytes &= AES_BLOCK_SIZE - 1;
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+	fprs_write(0);
+	return err;
+}
+
+extern void aes_sparc64_ecb_decrypt(u64 *ekey, const u32 *input, u32 *output,
+				    unsigned int key_len, unsigned int len);
+
+static int ecb_decrypt(struct blkcipher_desc *desc,
+		       struct scatterlist *dst, struct scatterlist *src,
+		       unsigned int nbytes)
+{
+	struct crypto_sparc64_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+	u64 *key_end;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	aes_sparc64_load_decrypt_keys(&ctx->key[0]);
+	key_end = &ctx->key[ctx->expanded_key_length / sizeof(u64)];
+	while ((nbytes = walk.nbytes)) {
+		unsigned int block_len = nbytes & AES_BLOCK_MASK;
+
+		aes_sparc64_ecb_decrypt(key_end, (const u32 *) walk.src.virt.addr,
+					(u32 *) walk.dst.virt.addr, ctx->key_length,
+					block_len);
+		nbytes &= AES_BLOCK_SIZE - 1;
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+	fprs_write(0);
+
+	return err;
+}
+
+extern void aes_sparc64_cbc_encrypt(u64 *key, const u32 *input, u32 *output,
+				    unsigned int key_len, unsigned int len,
+				    u64 *iv);
+
+static int cbc_encrypt(struct blkcipher_desc *desc,
+		       struct scatterlist *dst, struct scatterlist *src,
+		       unsigned int nbytes)
+{
+	struct crypto_sparc64_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	aes_sparc64_load_encrypt_keys(&ctx->key[0]);
+	while ((nbytes = walk.nbytes)) {
+		unsigned int block_len = nbytes & AES_BLOCK_MASK;
+
+		if (likely(block_len)) {
+			aes_sparc64_cbc_encrypt(&ctx->key[0],
+						(const u32 *)walk.src.virt.addr,
+						(u32 *) walk.dst.virt.addr,
+						ctx->key_length, block_len,
+						(u64 *) walk.iv);
+		}
+		nbytes &= AES_BLOCK_SIZE - 1;
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+	fprs_write(0);
+	return err;
+}
+
+extern void aes_sparc64_cbc_decrypt(u64 *ekey, unsigned int key_len,
+				    const u32 *input, u32 *output,
+				    unsigned int len, u64 *iv);
+
+static int cbc_decrypt(struct blkcipher_desc *desc,
+		       struct scatterlist *dst, struct scatterlist *src,
+		       unsigned int nbytes)
+{
+	struct crypto_sparc64_aes_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+	u64 *key_end;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	aes_sparc64_load_decrypt_keys(&ctx->key[0]);
+	key_end = &ctx->key[ctx->expanded_key_length / sizeof(u64)];
+	while ((nbytes = walk.nbytes)) {
+		unsigned int block_len = nbytes & AES_BLOCK_MASK;
+
+		aes_sparc64_cbc_decrypt(key_end, ctx->key_length,
+					(const u32 *) walk.src.virt.addr,
+					(u32 *) walk.dst.virt.addr,
+					block_len, (u64 *) walk.iv);
+		nbytes &= AES_BLOCK_SIZE - 1;
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+	fprs_write(0);
+
+	return err;
+}
+
+static struct crypto_alg algs[] = { {
+	.cra_name		= "aes",
+	.cra_driver_name	= "aes-sparc64",
+	.cra_priority		= 150,
+	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct crypto_sparc64_aes_ctx),
+	.cra_alignmask		= 3,
+	.cra_module		= THIS_MODULE,
+	.cra_u	= {
+		.cipher	= {
+			.cia_min_keysize	= AES_MIN_KEY_SIZE,
+			.cia_max_keysize	= AES_MAX_KEY_SIZE,
+			.cia_setkey		= aes_set_key,
+			.cia_encrypt		= aes_encrypt,
+			.cia_decrypt		= aes_decrypt
+		}
+	}
+}, {
+	.cra_name		= "ecb(aes)",
+	.cra_driver_name	= "ecb-aes-sparc64",
+	.cra_priority		= 150,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct crypto_sparc64_aes_ctx),
+	.cra_alignmask		= 7,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= AES_MIN_KEY_SIZE,
+			.max_keysize	= AES_MAX_KEY_SIZE,
+			.setkey		= aes_set_key,
+			.encrypt	= ecb_encrypt,
+			.decrypt	= ecb_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "cbc(aes)",
+	.cra_driver_name	= "cbc-aes-sparc64",
+	.cra_priority		= 150,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct crypto_sparc64_aes_ctx),
+	.cra_alignmask		= 7,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= AES_MIN_KEY_SIZE,
+			.max_keysize	= AES_MAX_KEY_SIZE,
+			.setkey		= aes_set_key,
+			.encrypt	= cbc_encrypt,
+			.decrypt	= cbc_decrypt,
+		},
+	},
+} };
+
+static bool __init sparc64_has_aes_opcode(void)
+{
+	unsigned long cfr;
+
+	if (!(sparc64_elf_hwcap & HWCAP_SPARC_CRYPTO))
+		return false;
+
+	__asm__ __volatile__("rd %%asr26, %0" : "=r" (cfr));
+	if (!(cfr & CFR_AES))
+		return false;
+
+	return true;
+}
+
+static int __init aes_sparc64_mod_init(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(algs); i++)
+		INIT_LIST_HEAD(&algs[i].cra_list);
+
+	if (sparc64_has_aes_opcode()) {
+		pr_info("Using sparc64 aes opcodes optimized AES implementation\n");
+		return crypto_register_algs(algs, ARRAY_SIZE(algs));
+	}
+	pr_info("sparc64 aes opcodes not available.\n");
+	return -ENODEV;
+}
+
+static void __exit aes_sparc64_mod_fini(void)
+{
+	crypto_unregister_algs(algs, ARRAY_SIZE(algs));
+}
+
+module_init(aes_sparc64_mod_init);
+module_exit(aes_sparc64_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("AES Secure Hash Algorithm, sparc64 aes opcode accelerated");
+
+MODULE_ALIAS("aes");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 4cb1ab0..49f867b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -624,6 +624,34 @@ config CRYPTO_AES_NI_INTEL
 	  ECB, CBC, LRW, PCBC, XTS. The 64 bit version has additional
 	  acceleration for CTR.
 
+config CRYPTO_AES_SPARC64
+	tristate "AES cipher algorithms (SPARC64)"
+	depends on SPARC64
+	select CRYPTO_CRYPTD
+	select CRYPTO_ALGAPI
+	help
+	  Use SPARC64 crypto opcodes for AES algorithm.
+
+	  AES cipher algorithms (FIPS-197). AES uses the Rijndael
+	  algorithm.
+
+	  Rijndael appears to be consistently a very good performer in
+	  both hardware and software across a wide range of computing
+	  environments regardless of its use in feedback or non-feedback
+	  modes. Its key setup time is excellent, and its key agility is
+	  good. Rijndael's very low memory requirements make it very well
+	  suited for restricted-space environments, in which it also
+	  demonstrates excellent performance. Rijndael's operations are
+	  among the easiest to defend against power and timing attacks.
+
+	  The AES specifies three key sizes: 128, 192 and 256 bits
+
+	  See <http://csrc.nist.gov/encryption/aes/> for more information.
+
+	  In addition to AES cipher algorithm support, the acceleration
+	  for some popular block cipher mode is supported too, including
+	  ECB and CBC.
+
 config CRYPTO_ANUBIS
 	tristate "Anubis cipher algorithm"
 	select CRYPTO_ALGAPI
-- 
1.7.10.4
