From: David Miller <davem@davemloft.net>
Subject: [PATCH] sparc64: Add CAMELLIA driver making use of the new
 camellia opcodes.
Date: Tue, 28 Aug 2012 18:07:21 -0400 (EDT)
Message-ID: <20120828.180721.2155848889340737169.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: sparclinux@vger.kernel.org
Return-path: <sparclinux-owner@vger.kernel.org>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Signed-off-by: David S. Miller <davem@davemloft.net>
---

Only a few more things I intend to work on, such as adding CTR mode to
the three encryption drivers written thus far (AES, DES, CAMELLIA).
And also experimenting with unrolling the ECB/CBC/CTR loops in these
three algorithms to work on 2 blocks at a time.

As I mentioned last week, SPARC-T4 can do Kasumi too, but since we
lack a generic C version and tests I'm very unlikely to work on
support for the sparc64 Kasumi opcodes.

 arch/sparc/crypto/Makefile        |    2 +
 arch/sparc/crypto/camellia_asm.S  |  583 +++++++++++++++++++++++++++++++++++++
 arch/sparc/crypto/camellia_glue.c |  318 ++++++++++++++++++++
 crypto/Kconfig                    |   16 +
 4 files changed, 919 insertions(+)
 create mode 100644 arch/sparc/crypto/camellia_asm.S
 create mode 100644 arch/sparc/crypto/camellia_glue.c

diff --git a/arch/sparc/crypto/Makefile b/arch/sparc/crypto/Makefile
index dd999c6..5d469d8 100644
--- a/arch/sparc/crypto/Makefile
+++ b/arch/sparc/crypto/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_CRYPTO_MD5_SPARC64) += md5-sparc64.o
 
 obj-$(CONFIG_CRYPTO_AES_SPARC64) += aes-sparc64.o
 obj-$(CONFIG_CRYPTO_DES_SPARC64) += des-sparc64.o
+obj-$(CONFIG_CRYPTO_DES_SPARC64) += camellia-sparc64.o
 
 obj-$(CONFIG_CRYPTO_CRC32C_SPARC64) += crc32c-sparc64.o
 
@@ -19,5 +20,6 @@ md5-sparc64-y := md5_asm.o md5_glue.o
 
 aes-sparc64-y := aes_asm.o aes_glue.o
 des-sparc64-y := des_asm.o des_glue.o
+camellia-sparc64-y := camellia_asm.o camellia_glue.o
 
 crc32c-sparc64-y := crc32c_asm.o crc32c_glue.o
diff --git a/arch/sparc/crypto/camellia_asm.S b/arch/sparc/crypto/camellia_asm.S
new file mode 100644
index 0000000..21c5e6f
--- /dev/null
+++ b/arch/sparc/crypto/camellia_asm.S
@@ -0,0 +1,583 @@
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
+#define CAMELLIA_F(a,b,c,d)		\
+	.word		(F3F(2, 0x19, 0x00c)|RS1(a)|RS2(b)|RS3(c)|RD(d));
+#define CAMELLIA_FL(a,b,c)		\
+	.word		(F3F(2, 0x36, 0x13c)|RS1(a)|RS2(b)|RD(c));
+#define CAMELLIA_FLI(a,b,c)		\
+	.word		(F3F(2, 0x36, 0x13d)|RS1(a)|RS2(b)|RD(c));
+
+#define MOVDTOX_F0_O4	\
+	.word	0x99b02200
+#define MOVDTOX_F2_O5	\
+	.word	0x9bb02202
+
+#define CAMELLIA_6ROUNDS(KEY_BASE, I0, I1) \
+	CAMELLIA_F(KEY_BASE +  0, I1, I0, I1) \
+	CAMELLIA_F(KEY_BASE +  2, I0, I1, I0) \
+	CAMELLIA_F(KEY_BASE +  4, I1, I0, I1) \
+	CAMELLIA_F(KEY_BASE +  6, I0, I1, I0) \
+	CAMELLIA_F(KEY_BASE +  8, I1, I0, I1) \
+	CAMELLIA_F(KEY_BASE + 10, I0, I1, I0)
+
+#define CAMELLIA_6ROUNDS_FL_FLI(KEY_BASE, I0, I1) \
+	CAMELLIA_6ROUNDS(KEY_BASE, I0, I1) \
+	CAMELLIA_FL(KEY_BASE + 12, I0, I0) \
+	CAMELLIA_FLI(KEY_BASE + 14, I1, I1)
+
+	.data
+
+	.align	8
+SIGMA:	.xword	0xA09E667F3BCC908B
+	.xword	0xB67AE8584CAA73B2
+	.xword	0xC6EF372FE94F82BE
+	.xword	0x54FF53A5F1D36F1C
+	.xword	0x10E527FADE682D1D
+	.xword	0xB05688C2B3E6C1FD
+
+	.text
+
+	.align	32
+ENTRY(camellia_sparc64_key_expand)
+	/* %o0=in_key, %o1=out_key, %o2=key_len */
+	VISEntry
+	ld	[%o0 + 0x00], %f0	! i0, k[0]
+	ld	[%o0 + 0x04], %f1	! i1, k[1]
+	ld	[%o0 + 0x08], %f2	! i2, k[2]
+	ld	[%o0 + 0x0c], %f3	! i3, k[3]
+	std	%f0, [%o1 + 0x00]	! k[0, 1]
+	fsrc1	%f0, %f28
+	std	%f2, [%o1 + 0x08]	! k[2, 3]
+	cmp	%o2, 16
+	be	10f
+	 fsrc1	%f2, %f30
+
+	ld	[%o0 + 0x10], %f0
+	ld	[%o0 + 0x14], %f1
+	std	%f0, [%o1 + 0x20]	! k[8, 9]
+	cmp	%o2, 24
+	fone	%f10
+	be,a	1f
+	 fxor	%f10, %f0, %f2
+	ld	[%o0 + 0x18], %f2
+	ld	[%o0 + 0x1c], %f3
+1:
+	std	%f2, [%o1 + 0x28]	! k[10, 11]
+	fxor	%f28, %f0, %f0
+	fxor	%f30, %f2, %f2
+
+10:
+	sethi	%hi(SIGMA), %g3
+	or	%g3, %lo(SIGMA), %g3
+	ldd	[%g3 + 0x00], %f16
+	ldd	[%g3 + 0x08], %f18
+	ldd	[%g3 + 0x10], %f20
+	ldd	[%g3 + 0x18], %f22
+	ldd	[%g3 + 0x20], %f24
+	ldd	[%g3 + 0x28], %f26
+	CAMELLIA_F(16, 2, 0, 2)
+	CAMELLIA_F(18, 0, 2, 0)
+	fxor	%f28, %f0, %f0
+	fxor	%f30, %f2, %f2
+	CAMELLIA_F(20, 2, 0, 2)
+	CAMELLIA_F(22, 0, 2, 0)
+
+#define ROTL128(S01, S23, TMP1, TMP2, N)	\
+	srlx	S01, (64 - N), TMP1;		\
+	sllx	S01, N, S01;			\
+	srlx	S23, (64 - N), TMP2;		\
+	sllx	S23, N, S23;			\
+	or	S01, TMP2, S01;			\
+	or	S23, TMP1, S23
+
+	cmp	%o2, 16
+	bne	1f
+	 nop
+	/* 128-bit key */
+	std	%f0, [%o1 + 0x10]	! k[ 4,  5]
+	std	%f2, [%o1 + 0x18]	! k[ 6,  7]
+	MOVDTOX_F0_O4
+	MOVDTOX_F2_O5
+	ROTL128(%o4, %o5, %g2, %g3, 15)
+	stx	%o4, [%o1 + 0x30]	! k[12, 13]
+	stx	%o5, [%o1 + 0x38]	! k[14, 15]
+	ROTL128(%o4, %o5, %g2, %g3, 15)
+	stx	%o4, [%o1 + 0x40]	! k[16, 17]
+	stx	%o5, [%o1 + 0x48]	! k[18, 19]
+	ROTL128(%o4, %o5, %g2, %g3, 15)
+	stx	%o4, [%o1 + 0x60]	! k[24, 25]
+	ROTL128(%o4, %o5, %g2, %g3, 15)
+	stx	%o4, [%o1 + 0x70]	! k[28, 29]
+	stx	%o5, [%o1 + 0x78]	! k[30, 31]
+	ROTL128(%o4, %o5, %g2, %g3, 34)
+	stx	%o4, [%o1 + 0xa0]	! k[40, 41]
+	stx	%o5, [%o1 + 0xa8]	! k[42, 43]
+	ROTL128(%o4, %o5, %g2, %g3, 17)
+	stx	%o4, [%o1 + 0xc0]	! k[48, 49]
+	stx	%o5, [%o1 + 0xc8]	! k[50, 51]
+
+	ldx	[%o1 + 0x00], %o4	! k[ 0,  1]
+	ldx	[%o1 + 0x08], %o5	! k[ 2,  3]
+	ROTL128(%o4, %o5, %g2, %g3, 15)
+	stx	%o4, [%o1 + 0x20]	! k[ 8,  9]
+	stx	%o5, [%o1 + 0x28]	! k[10, 11]
+	ROTL128(%o4, %o5, %g2, %g3, 30)
+	stx	%o4, [%o1 + 0x50]	! k[20, 21]
+	stx	%o5, [%o1 + 0x58]	! k[22, 23]
+	ROTL128(%o4, %o5, %g2, %g3, 15)
+	stx	%o5, [%o1 + 0x68]	! k[26, 27]
+	ROTL128(%o4, %o5, %g2, %g3, 17)
+	stx	%o4, [%o1 + 0x80]	! k[32, 33]
+	stx	%o5, [%o1 + 0x88]	! k[34, 35]
+	ROTL128(%o4, %o5, %g2, %g3, 17)
+	stx	%o4, [%o1 + 0x90]	! k[36, 37]
+	stx	%o5, [%o1 + 0x98]	! k[38, 39]
+	ROTL128(%o4, %o5, %g2, %g3, 17)
+	stx	%o4, [%o1 + 0xb0]	! k[44, 45]
+	stx	%o5, [%o1 + 0xb8]	! k[46, 47]
+
+	ba,pt	%xcc, 2f
+	 mov	(3 * 16 * 4), %o0
+
+1:
+	/* 192-bit or 256-bit key */
+	std	%f0, [%o1 + 0x30]	! k[12, 13]
+	std	%f2, [%o1 + 0x38]	! k[14, 15]
+	ldd	[%o1 + 0x20], %f4	! k[ 8,  9]
+	ldd	[%o1 + 0x28], %f6	! k[10, 11]
+	fxor	%f0, %f4, %f0
+	fxor	%f2, %f6, %f2
+	CAMELLIA_F(24, 2, 0, 2)
+	CAMELLIA_F(26, 0, 2, 0)
+	std	%f0, [%o1 + 0x10]	! k[ 4,  5]
+	std	%f2, [%o1 + 0x18]	! k[ 6,  7]
+	MOVDTOX_F0_O4
+	MOVDTOX_F2_O5
+	ROTL128(%o4, %o5, %g2, %g3, 30)
+	stx	%o4, [%o1 + 0x50]	! k[20, 21]
+	stx	%o5, [%o1 + 0x58]	! k[22, 23]
+	ROTL128(%o4, %o5, %g2, %g3, 30)
+	stx	%o4, [%o1 + 0xa0]	! k[40, 41]
+	stx	%o5, [%o1 + 0xa8]	! k[42, 43]
+	ROTL128(%o4, %o5, %g2, %g3, 51)
+	stx	%o4, [%o1 + 0x100]	! k[64, 65]
+	stx	%o5, [%o1 + 0x108]	! k[66, 67]
+	ldx	[%o1 + 0x20], %o4	! k[ 8,  9]
+	ldx	[%o1 + 0x28], %o5	! k[10, 11]
+	ROTL128(%o4, %o5, %g2, %g3, 15)
+	stx	%o4, [%o1 + 0x20]	! k[ 8,  9]
+	stx	%o5, [%o1 + 0x28]	! k[10, 11]
+	ROTL128(%o4, %o5, %g2, %g3, 15)
+	stx	%o4, [%o1 + 0x40]	! k[16, 17]
+	stx	%o5, [%o1 + 0x48]	! k[18, 19]
+	ROTL128(%o4, %o5, %g2, %g3, 30)
+	stx	%o4, [%o1 + 0x90]	! k[36, 37]
+	stx	%o5, [%o1 + 0x98]	! k[38, 39]
+	ROTL128(%o4, %o5, %g2, %g3, 34)
+	stx	%o4, [%o1 + 0xd0]	! k[52, 53]
+	stx	%o5, [%o1 + 0xd8]	! k[54, 55]
+	ldx	[%o1 + 0x30], %o4	! k[12, 13]
+	ldx	[%o1 + 0x38], %o5	! k[14, 15]
+	ROTL128(%o4, %o5, %g2, %g3, 15)
+	stx	%o4, [%o1 + 0x30]	! k[12, 13]
+	stx	%o5, [%o1 + 0x38]	! k[14, 15]
+	ROTL128(%o4, %o5, %g2, %g3, 30)
+	stx	%o4, [%o1 + 0x70]	! k[28, 29]
+	stx	%o5, [%o1 + 0x78]	! k[30, 31]
+	srlx	%o4, 32, %g2
+	srlx	%o5, 32, %g3
+	stw	%o4, [%o1 + 0xc0]	! k[48]
+	stw	%g3, [%o1 + 0xc4]	! k[49]
+	stw	%o5, [%o1 + 0xc8]	! k[50]
+	stw	%g2, [%o1 + 0xcc]	! k[51]
+	ROTL128(%o4, %o5, %g2, %g3, 49)
+	stx	%o4, [%o1 + 0xe0]	! k[56, 57]
+	stx	%o5, [%o1 + 0xe8]	! k[58, 59]
+	ldx	[%o1 + 0x00], %o4	! k[ 0,  1]
+	ldx	[%o1 + 0x08], %o5	! k[ 2,  3]
+	ROTL128(%o4, %o5, %g2, %g3, 45)
+	stx	%o4, [%o1 + 0x60]	! k[24, 25]
+	stx	%o5, [%o1 + 0x68]	! k[26, 27]
+	ROTL128(%o4, %o5, %g2, %g3, 15)
+	stx	%o4, [%o1 + 0x80]	! k[32, 33]
+	stx	%o5, [%o1 + 0x88]	! k[34, 35]
+	ROTL128(%o4, %o5, %g2, %g3, 17)
+	stx	%o4, [%o1 + 0xb0]	! k[44, 45]
+	stx	%o5, [%o1 + 0xb8]	! k[46, 47]
+	ROTL128(%o4, %o5, %g2, %g3, 34)
+	stx	%o4, [%o1 + 0xf0]	! k[60, 61]
+	stx	%o5, [%o1 + 0xf8]	! k[62, 63]
+	mov	(4 * 16 * 4), %o0
+2:
+	add	%o1, %o0, %o1
+	ldd	[%o1 + 0x00], %f0
+	ldd	[%o1 + 0x08], %f2
+	std	%f0, [%o3 + 0x00]
+	std	%f2, [%o3 + 0x08]
+	add	%o3, 0x10, %o3
+1:
+	sub	%o1, (16 * 4), %o1
+	ldd	[%o1 + 0x38], %f0
+	ldd	[%o1 + 0x30], %f2
+	ldd	[%o1 + 0x28], %f4
+	ldd	[%o1 + 0x20], %f6
+	ldd	[%o1 + 0x18], %f8
+	ldd	[%o1 + 0x10], %f10
+	std	%f0, [%o3 + 0x00]
+	std	%f2, [%o3 + 0x08]
+	std	%f4, [%o3 + 0x10]
+	std	%f6, [%o3 + 0x18]
+	std	%f8, [%o3 + 0x20]
+	std	%f10, [%o3 + 0x28]
+
+	ldd	[%o1 + 0x08], %f0
+	ldd	[%o1 + 0x00], %f2
+	std	%f0, [%o3 + 0x30]
+	std	%f2, [%o3 + 0x38]
+	subcc	%o0, (16 * 4), %o0
+	bne,pt	%icc, 1b
+	 add	%o3, (16 * 4), %o3
+
+	std	%f2, [%o3 - 0x10]
+	std	%f0, [%o3 - 0x08]
+
+	retl
+	 VISExit
+ENDPROC(camellia_sparc64_key_expand)
+
+	.align	32
+ENTRY(camellia_sparc64_crypt)
+	/* %o0=key, %o1=input, %o2=output, %o3=key_len */
+	VISEntry
+
+	ld	[%o1 + 0x00], %f0
+	ld	[%o1 + 0x04], %f1
+	ld	[%o1 + 0x08], %f2
+	ld	[%o1 + 0x0c], %f3
+
+	ldd	[%o0 + 0x00], %f4
+	ldd	[%o0 + 0x08], %f6
+
+	cmp	%o3, 16
+	fxor	%f4, %f0, %f0
+	be	1f
+	 fxor	%f6, %f2, %f2
+
+	ldd	[%o0 + 0x10], %f8
+	ldd	[%o0 + 0x18], %f10
+	ldd	[%o0 + 0x20], %f12
+	ldd	[%o0 + 0x28], %f14
+	ldd	[%o0 + 0x30], %f16
+	ldd	[%o0 + 0x38], %f18
+	ldd	[%o0 + 0x40], %f20
+	ldd	[%o0 + 0x48], %f22
+	add	%o0, 0x40, %o0
+
+	CAMELLIA_6ROUNDS_FL_FLI( 8, 0, 2)
+
+1:
+	ldd	[%o0 + 0x10], %f8
+	ldd	[%o0 + 0x18], %f10
+	ldd	[%o0 + 0x20], %f12
+	ldd	[%o0 + 0x28], %f14
+	ldd	[%o0 + 0x30], %f16
+	ldd	[%o0 + 0x38], %f18
+	ldd	[%o0 + 0x40], %f20
+	ldd	[%o0 + 0x48], %f22
+	ldd	[%o0 + 0x50], %f24
+	ldd	[%o0 + 0x58], %f26
+	ldd	[%o0 + 0x60], %f28
+	ldd	[%o0 + 0x68], %f30
+	ldd	[%o0 + 0x70], %f32
+	ldd	[%o0 + 0x78], %f34
+	ldd	[%o0 + 0x80], %f36
+	ldd	[%o0 + 0x88], %f38
+	ldd	[%o0 + 0x90], %f40
+	ldd	[%o0 + 0x98], %f42
+	ldd	[%o0 + 0xa0], %f44
+	ldd	[%o0 + 0xa8], %f46
+	ldd	[%o0 + 0xb0], %f48
+	ldd	[%o0 + 0xb8], %f50
+	ldd	[%o0 + 0xc0], %f52
+	ldd	[%o0 + 0xc8], %f54
+
+	CAMELLIA_6ROUNDS_FL_FLI( 8, 0, 2)
+	CAMELLIA_6ROUNDS_FL_FLI(24, 0, 2)
+	CAMELLIA_6ROUNDS(40, 0, 2)
+	fxor	%f52, %f2, %f2
+	fxor	%f54, %f0, %f0
+
+	st	%f2, [%o2 + 0x00]
+	st	%f3, [%o2 + 0x04]
+	st	%f0, [%o2 + 0x08]
+	st	%f1, [%o2 + 0x0c]
+
+	retl
+	 VISExit
+ENDPROC(camellia_sparc64_crypt)
+
+	.align	32
+ENTRY(camellia_sparc64_load_keys)
+	/* %o0=key, %o1=key_len */
+	VISEntry
+	ldd	[%o0 + 0x00], %f4
+	ldd	[%o0 + 0x08], %f6
+	ldd	[%o0 + 0x10], %f8
+	ldd	[%o0 + 0x18], %f10
+	ldd	[%o0 + 0x20], %f12
+	ldd	[%o0 + 0x28], %f14
+	ldd	[%o0 + 0x30], %f16
+	ldd	[%o0 + 0x38], %f18
+	ldd	[%o0 + 0x40], %f20
+	ldd	[%o0 + 0x48], %f22
+	ldd	[%o0 + 0x50], %f24
+	ldd	[%o0 + 0x58], %f26
+	ldd	[%o0 + 0x60], %f28
+	ldd	[%o0 + 0x68], %f30
+	ldd	[%o0 + 0x70], %f32
+	ldd	[%o0 + 0x78], %f34
+	ldd	[%o0 + 0x80], %f36
+	ldd	[%o0 + 0x88], %f38
+	ldd	[%o0 + 0x90], %f40
+	ldd	[%o0 + 0x98], %f42
+	ldd	[%o0 + 0xa0], %f44
+	ldd	[%o0 + 0xa8], %f46
+	ldd	[%o0 + 0xb0], %f48
+	ldd	[%o0 + 0xb8], %f50
+	ldd	[%o0 + 0xc0], %f52
+	retl
+	 ldd	[%o0 + 0xc8], %f54
+ENDPROC(camellia_sparc64_load_keys)
+
+	.align	32
+ENTRY(camellia_sparc64_ecb_crypt_3_grand_rounds)
+	/* %o0=input, %o1=output, %o2=len, %o3=key */
+1:	ldd	[%o0 + 0x00], %f0
+	ldd	[%o0 + 0x08], %f2
+	add	%o0, 0x10, %o0
+	fxor	%f4, %f0, %f0
+	fxor	%f6, %f2, %f2
+	CAMELLIA_6ROUNDS_FL_FLI( 8, 0, 2)
+	CAMELLIA_6ROUNDS_FL_FLI(24, 0, 2)
+	CAMELLIA_6ROUNDS(40, 0, 2)
+	fxor	%f52, %f2, %f2
+	fxor	%f54, %f0, %f0
+	std	%f2, [%o1 + 0x00]
+	std	%f0, [%o1 + 0x08]
+	subcc	%o2, 0x10, %o2
+	bne,pt	%icc, 1b
+	 add	%o1, 0x10, %o1
+	retl
+	 nop
+ENDPROC(camellia_sparc64_ecb_crypt_3_grand_rounds)
+
+	.align	32
+ENTRY(camellia_sparc64_ecb_crypt_4_grand_rounds)
+	/* %o0=input, %o1=output, %o2=len, %o3=key */
+1:	ldd	[%o0 + 0x00], %f0
+	ldd	[%o0 + 0x08], %f2
+	add	%o0, 0x10, %o0
+	fxor	%f4, %f0, %f0
+	fxor	%f6, %f2, %f2
+	CAMELLIA_6ROUNDS_FL_FLI( 8, 0, 2)
+	ldd	[%o3 + 0xd0], %f8
+	ldd	[%o3 + 0xd8], %f10
+	ldd	[%o3 + 0xe0], %f12
+	ldd	[%o3 + 0xe8], %f14
+	ldd	[%o3 + 0xf0], %f16
+	ldd	[%o3 + 0xf8], %f18
+	ldd	[%o3 + 0x100], %f20
+	ldd	[%o3 + 0x108], %f22
+	CAMELLIA_6ROUNDS_FL_FLI(24, 0, 2)
+	CAMELLIA_6ROUNDS_FL_FLI(40, 0, 2)
+	CAMELLIA_F(8, 2, 0, 2)
+	CAMELLIA_F(10, 0, 2, 0)
+	ldd	[%o3 + 0x10], %f8
+	ldd	[%o3 + 0x18], %f10
+	CAMELLIA_F(12, 2, 0, 2)
+	CAMELLIA_F(14, 0, 2, 0)
+	ldd	[%o3 + 0x20], %f12
+	ldd	[%o3 + 0x28], %f14
+	CAMELLIA_F(16, 2, 0, 2)
+	CAMELLIA_F(18, 0, 2, 0)
+	ldd	[%o3 + 0x30], %f16
+	ldd	[%o3 + 0x38], %f18
+	fxor	%f20, %f2, %f2
+	fxor	%f22, %f0, %f0
+	ldd	[%o3 + 0x40], %f20
+	ldd	[%o3 + 0x48], %f22
+	std	%f2, [%o1 + 0x00]
+	std	%f0, [%o1 + 0x08]
+	subcc	%o2, 0x10, %o2
+	bne,pt	%icc, 1b
+	 add	%o1, 0x10, %o1
+	retl
+	 nop
+ENDPROC(camellia_sparc64_ecb_crypt_4_grand_rounds)
+
+	.align	32
+ENTRY(camellia_sparc64_cbc_encrypt_3_grand_rounds)
+	/* %o0=input, %o1=output, %o2=len, %o3=key, %o4=IV */
+	ldd	[%o4 + 0x00], %f60
+	ldd	[%o4 + 0x08], %f62
+1:	ldd	[%o0 + 0x00], %f0
+	ldd	[%o0 + 0x08], %f2
+	add	%o0, 0x10, %o0
+	fxor	%f60, %f0, %f0
+	fxor	%f62, %f2, %f2
+	fxor	%f4, %f0, %f0
+	fxor	%f6, %f2, %f2
+	CAMELLIA_6ROUNDS_FL_FLI( 8, 0, 2)
+	CAMELLIA_6ROUNDS_FL_FLI(24, 0, 2)
+	CAMELLIA_6ROUNDS(40, 0, 2)
+	fxor	%f52, %f2, %f60
+	fxor	%f54, %f0, %f62
+	std	%f60, [%o1 + 0x00]
+	std	%f62, [%o1 + 0x08]
+	subcc	%o2, 0x10, %o2
+	bne,pt	%icc, 1b
+	 add	%o1, 0x10, %o1
+	std	%f60, [%o4 + 0x00]
+	retl
+	 std	%f62, [%o4 + 0x08]
+ENDPROC(camellia_sparc64_cbc_encrypt_3_grand_rounds)
+
+	.align	32
+ENTRY(camellia_sparc64_cbc_encrypt_4_grand_rounds)
+	/* %o0=input, %o1=output, %o2=len, %o3=key, %o4=IV */
+	ldd	[%o4 + 0x00], %f60
+	ldd	[%o4 + 0x08], %f62
+1:	ldd	[%o0 + 0x00], %f0
+	ldd	[%o0 + 0x08], %f2
+	add	%o0, 0x10, %o0
+	fxor	%f60, %f0, %f0
+	fxor	%f62, %f2, %f2
+	fxor	%f4, %f0, %f0
+	fxor	%f6, %f2, %f2
+	CAMELLIA_6ROUNDS_FL_FLI( 8, 0, 2)
+	ldd	[%o3 + 0xd0], %f8
+	ldd	[%o3 + 0xd8], %f10
+	ldd	[%o3 + 0xe0], %f12
+	ldd	[%o3 + 0xe8], %f14
+	ldd	[%o3 + 0xf0], %f16
+	ldd	[%o3 + 0xf8], %f18
+	ldd	[%o3 + 0x100], %f20
+	ldd	[%o3 + 0x108], %f22
+	CAMELLIA_6ROUNDS_FL_FLI(24, 0, 2)
+	CAMELLIA_6ROUNDS_FL_FLI(40, 0, 2)
+	CAMELLIA_F(8, 2, 0, 2)
+	CAMELLIA_F(10, 0, 2, 0)
+	ldd	[%o3 + 0x10], %f8
+	ldd	[%o3 + 0x18], %f10
+	CAMELLIA_F(12, 2, 0, 2)
+	CAMELLIA_F(14, 0, 2, 0)
+	ldd	[%o3 + 0x20], %f12
+	ldd	[%o3 + 0x28], %f14
+	CAMELLIA_F(16, 2, 0, 2)
+	CAMELLIA_F(18, 0, 2, 0)
+	ldd	[%o3 + 0x30], %f16
+	ldd	[%o3 + 0x38], %f18
+	fxor	%f20, %f2, %f60
+	fxor	%f22, %f0, %f62
+	ldd	[%o3 + 0x40], %f20
+	ldd	[%o3 + 0x48], %f22
+	std	%f60, [%o1 + 0x00]
+	std	%f62, [%o1 + 0x08]
+	subcc	%o2, 0x10, %o2
+	bne,pt	%icc, 1b
+	 add	%o1, 0x10, %o1
+	std	%f60, [%o4 + 0x00]
+	retl
+	 std	%f62, [%o4 + 0x08]
+ENDPROC(camellia_sparc64_cbc_encrypt_4_grand_rounds)
+
+	.align	32
+ENTRY(camellia_sparc64_cbc_decrypt_3_grand_rounds)
+	/* %o0=input, %o1=output, %o2=len, %o3=key, %o4=IV */
+	ldd	[%o4 + 0x00], %f60
+	ldd	[%o4 + 0x08], %f62
+1:	ldd	[%o0 + 0x00], %f56
+	ldd	[%o0 + 0x08], %f58
+	add	%o0, 0x10, %o0
+	fxor	%f4, %f56, %f0
+	fxor	%f6, %f58, %f2
+	CAMELLIA_6ROUNDS_FL_FLI( 8, 0, 2)
+	CAMELLIA_6ROUNDS_FL_FLI(24, 0, 2)
+	CAMELLIA_6ROUNDS(40, 0, 2)
+	fxor	%f52, %f2, %f2
+	fxor	%f54, %f0, %f0
+	fxor	%f60, %f2, %f2
+	fxor	%f62, %f0, %f0
+	fsrc1	%f56, %f60
+	fsrc1	%f58, %f62
+	std	%f2, [%o1 + 0x00]
+	std	%f0, [%o1 + 0x08]
+	subcc	%o2, 0x10, %o2
+	bne,pt	%icc, 1b
+	 add	%o1, 0x10, %o1
+	std	%f60, [%o4 + 0x00]
+	retl
+	 std	%f62, [%o4 + 0x08]
+ENDPROC(camellia_sparc64_cbc_decrypt_3_grand_rounds)
+
+	.align	32
+ENTRY(camellia_sparc64_cbc_decrypt_4_grand_rounds)
+	/* %o0=input, %o1=output, %o2=len, %o3=key, %o4=IV */
+	ldd	[%o4 + 0x00], %f60
+	ldd	[%o4 + 0x08], %f62
+1:	ldd	[%o0 + 0x00], %f56
+	ldd	[%o0 + 0x08], %f58
+	add	%o0, 0x10, %o0
+	fxor	%f4, %f56, %f0
+	fxor	%f6, %f58, %f2
+	CAMELLIA_6ROUNDS_FL_FLI( 8, 0, 2)
+	ldd	[%o3 + 0xd0], %f8
+	ldd	[%o3 + 0xd8], %f10
+	ldd	[%o3 + 0xe0], %f12
+	ldd	[%o3 + 0xe8], %f14
+	ldd	[%o3 + 0xf0], %f16
+	ldd	[%o3 + 0xf8], %f18
+	ldd	[%o3 + 0x100], %f20
+	ldd	[%o3 + 0x108], %f22
+	CAMELLIA_6ROUNDS_FL_FLI(24, 0, 2)
+	CAMELLIA_6ROUNDS_FL_FLI(40, 0, 2)
+	CAMELLIA_F(8, 2, 0, 2)
+	CAMELLIA_F(10, 0, 2, 0)
+	ldd	[%o3 + 0x10], %f8
+	ldd	[%o3 + 0x18], %f10
+	CAMELLIA_F(12, 2, 0, 2)
+	CAMELLIA_F(14, 0, 2, 0)
+	ldd	[%o3 + 0x20], %f12
+	ldd	[%o3 + 0x28], %f14
+	CAMELLIA_F(16, 2, 0, 2)
+	CAMELLIA_F(18, 0, 2, 0)
+	ldd	[%o3 + 0x30], %f16
+	ldd	[%o3 + 0x38], %f18
+	fxor	%f20, %f2, %f2
+	fxor	%f22, %f0, %f0
+	ldd	[%o3 + 0x40], %f20
+	ldd	[%o3 + 0x48], %f22
+	fxor	%f60, %f2, %f2
+	fxor	%f62, %f0, %f0
+	fsrc1	%f56, %f60
+	fsrc1	%f58, %f62
+	std	%f2, [%o1 + 0x00]
+	std	%f0, [%o1 + 0x08]
+	subcc	%o2, 0x10, %o2
+	bne,pt	%icc, 1b
+	 add	%o1, 0x10, %o1
+	std	%f60, [%o4 + 0x00]
+	retl
+	 std	%f62, [%o4 + 0x08]
+ENDPROC(camellia_sparc64_cbc_decrypt_4_grand_rounds)
diff --git a/arch/sparc/crypto/camellia_glue.c b/arch/sparc/crypto/camellia_glue.c
new file mode 100644
index 0000000..c258cc5
--- /dev/null
+++ b/arch/sparc/crypto/camellia_glue.c
@@ -0,0 +1,318 @@
+/* Glue code for CAMELLIA encryption optimized for sparc64 crypto opcodes.
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
+
+#include <asm/fpumacro.h>
+#include <asm/pstate.h>
+#include <asm/elf.h>
+
+#define CAMELLIA_MIN_KEY_SIZE        16
+#define CAMELLIA_MAX_KEY_SIZE        32
+#define CAMELLIA_BLOCK_SIZE          16
+#define CAMELLIA_TABLE_BYTE_LEN     272
+
+struct camellia_sparc64_ctx {
+	u64 encrypt_key[CAMELLIA_TABLE_BYTE_LEN / sizeof(u64)];
+	u64 decrypt_key[CAMELLIA_TABLE_BYTE_LEN / sizeof(u64)];
+	int key_len;
+};
+
+extern void camellia_sparc64_key_expand(const u32 *in_key, u64 *encrypt_key,
+					unsigned int key_len, u64 *decrypt_key);
+
+static int camellia_set_key(struct crypto_tfm *tfm, const u8 *_in_key,
+			    unsigned int key_len)
+{
+	struct camellia_sparc64_ctx *ctx = crypto_tfm_ctx(tfm);
+	const u32 *in_key = (const u32 *) _in_key;
+	u32 *flags = &tfm->crt_flags;
+
+	if (key_len != 16 && key_len != 24 && key_len != 32) {
+		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+		return -EINVAL;
+	}
+
+	ctx->key_len = key_len;
+
+	camellia_sparc64_key_expand(in_key, &ctx->encrypt_key[0],
+				    key_len, &ctx->decrypt_key[0]);
+	return 0;
+}
+
+extern void camellia_sparc64_crypt(const u64 *key, const u32 *input,
+				   u32 *output, unsigned int key_len);
+
+static void camellia_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+{
+	struct camellia_sparc64_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	camellia_sparc64_crypt(&ctx->encrypt_key[0],
+			       (const u32 *) src,
+			       (u32 *) dst, ctx->key_len);
+}
+
+static void camellia_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+{
+	struct camellia_sparc64_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	camellia_sparc64_crypt(&ctx->decrypt_key[0],
+			       (const u32 *) src,
+			       (u32 *) dst, ctx->key_len);
+}
+
+extern void camellia_sparc64_load_keys(const u64 *key, unsigned int key_len);
+
+typedef void ecb_crypt_op(const u64 *input, u64 *output, unsigned int len,
+			  const u64 *key);
+
+extern ecb_crypt_op camellia_sparc64_ecb_crypt_3_grand_rounds;
+extern ecb_crypt_op camellia_sparc64_ecb_crypt_4_grand_rounds;
+
+#define CAMELLIA_BLOCK_MASK	(~(CAMELLIA_BLOCK_SIZE - 1))
+
+static int __ecb_crypt(struct blkcipher_desc *desc,
+		       struct scatterlist *dst, struct scatterlist *src,
+		       unsigned int nbytes, bool encrypt)
+{
+	struct camellia_sparc64_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+	ecb_crypt_op *op;
+	const u64 *key;
+	int err;
+
+	op = camellia_sparc64_ecb_crypt_3_grand_rounds;
+	if (ctx->key_len != 16)
+		op = camellia_sparc64_ecb_crypt_4_grand_rounds;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	if (encrypt)
+		key = &ctx->encrypt_key[0];
+	else
+		key = &ctx->decrypt_key[0];
+	camellia_sparc64_load_keys(key, ctx->key_len);
+	while ((nbytes = walk.nbytes)) {
+		unsigned int block_len = nbytes & CAMELLIA_BLOCK_MASK;
+
+		if (likely(block_len)) {
+			const u64 *src64;
+			u64 *dst64;
+
+			src64 = (const u64 *)walk.src.virt.addr;
+			dst64 = (u64 *) walk.dst.virt.addr;
+			op(src64, dst64, block_len, key);
+		}
+		nbytes &= CAMELLIA_BLOCK_SIZE - 1;
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
+typedef void cbc_crypt_op(const u64 *input, u64 *output, unsigned int len,
+			  const u64 *key, u64 *iv);
+
+extern cbc_crypt_op camellia_sparc64_cbc_encrypt_3_grand_rounds;
+extern cbc_crypt_op camellia_sparc64_cbc_encrypt_4_grand_rounds;
+extern cbc_crypt_op camellia_sparc64_cbc_decrypt_3_grand_rounds;
+extern cbc_crypt_op camellia_sparc64_cbc_decrypt_4_grand_rounds;
+
+static int cbc_encrypt(struct blkcipher_desc *desc,
+		       struct scatterlist *dst, struct scatterlist *src,
+		       unsigned int nbytes)
+{
+	struct camellia_sparc64_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+	cbc_crypt_op *op;
+	const u64 *key;
+	int err;
+
+	op = camellia_sparc64_cbc_encrypt_3_grand_rounds;
+	if (ctx->key_len != 16)
+		op = camellia_sparc64_cbc_encrypt_4_grand_rounds;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	key = &ctx->encrypt_key[0];
+	camellia_sparc64_load_keys(key, ctx->key_len);
+	while ((nbytes = walk.nbytes)) {
+		unsigned int block_len = nbytes & CAMELLIA_BLOCK_MASK;
+
+		if (likely(block_len)) {
+			const u64 *src64;
+			u64 *dst64;
+
+			src64 = (const u64 *)walk.src.virt.addr;
+			dst64 = (u64 *) walk.dst.virt.addr;
+			op(src64, dst64, block_len, key,
+			   (u64 *) walk.iv);
+		}
+		nbytes &= CAMELLIA_BLOCK_SIZE - 1;
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+	fprs_write(0);
+	return err;
+}
+
+static int cbc_decrypt(struct blkcipher_desc *desc,
+		       struct scatterlist *dst, struct scatterlist *src,
+		       unsigned int nbytes)
+{
+	struct camellia_sparc64_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+	cbc_crypt_op *op;
+	const u64 *key;
+	int err;
+
+	op = camellia_sparc64_cbc_decrypt_3_grand_rounds;
+	if (ctx->key_len != 16)
+		op = camellia_sparc64_cbc_decrypt_4_grand_rounds;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	key = &ctx->decrypt_key[0];
+	camellia_sparc64_load_keys(key, ctx->key_len);
+	while ((nbytes = walk.nbytes)) {
+		unsigned int block_len = nbytes & CAMELLIA_BLOCK_MASK;
+
+		if (likely(block_len)) {
+			const u64 *src64;
+			u64 *dst64;
+
+			src64 = (const u64 *)walk.src.virt.addr;
+			dst64 = (u64 *) walk.dst.virt.addr;
+			op(src64, dst64, block_len, key,
+			   (u64 *) walk.iv);
+		}
+		nbytes &= CAMELLIA_BLOCK_SIZE - 1;
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+	fprs_write(0);
+	return err;
+}
+
+static struct crypto_alg algs[] = { {
+	.cra_name		= "camellia",
+	.cra_driver_name	= "camellia-sparc64",
+	.cra_priority		= 150,
+	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
+	.cra_blocksize		= CAMELLIA_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct camellia_sparc64_ctx),
+	.cra_alignmask		= 3,
+	.cra_module		= THIS_MODULE,
+	.cra_u	= {
+		.cipher	= {
+			.cia_min_keysize	= CAMELLIA_MIN_KEY_SIZE,
+			.cia_max_keysize	= CAMELLIA_MAX_KEY_SIZE,
+			.cia_setkey		= camellia_set_key,
+			.cia_encrypt		= camellia_encrypt,
+			.cia_decrypt		= camellia_decrypt
+		}
+	}
+}, {
+	.cra_name		= "ecb(camellia)",
+	.cra_driver_name	= "ecb-camellia-sparc64",
+	.cra_priority		= 150,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= CAMELLIA_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct camellia_sparc64_ctx),
+	.cra_alignmask		= 7,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= CAMELLIA_MIN_KEY_SIZE,
+			.max_keysize	= CAMELLIA_MAX_KEY_SIZE,
+			.setkey		= camellia_set_key,
+			.encrypt	= ecb_encrypt,
+			.decrypt	= ecb_decrypt,
+		},
+	},
+}, {
+	.cra_name		= "cbc(camellia)",
+	.cra_driver_name	= "cbc-camellia-sparc64",
+	.cra_priority		= 150,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= CAMELLIA_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct camellia_sparc64_ctx),
+	.cra_alignmask		= 7,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= CAMELLIA_MIN_KEY_SIZE,
+			.max_keysize	= CAMELLIA_MAX_KEY_SIZE,
+			.setkey		= camellia_set_key,
+			.encrypt	= cbc_encrypt,
+			.decrypt	= cbc_decrypt,
+		},
+	},
+}
+};
+
+static bool __init sparc64_has_camellia_opcode(void)
+{
+	unsigned long cfr;
+
+	if (!(sparc64_elf_hwcap & HWCAP_SPARC_CRYPTO))
+		return false;
+
+	__asm__ __volatile__("rd %%asr26, %0" : "=r" (cfr));
+	if (!(cfr & CFR_CAMELLIA))
+		return false;
+
+	return true;
+}
+
+static int __init camellia_sparc64_mod_init(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(algs); i++)
+		INIT_LIST_HEAD(&algs[i].cra_list);
+
+	if (sparc64_has_camellia_opcode()) {
+		pr_info("Using sparc64 camellia opcodes optimized CAMELLIA implementation\n");
+		return crypto_register_algs(algs, ARRAY_SIZE(algs));
+	}
+	pr_info("sparc64 camellia opcodes not available.\n");
+	return -ENODEV;
+}
+
+static void __exit camellia_sparc64_mod_fini(void)
+{
+	crypto_unregister_algs(algs, ARRAY_SIZE(algs));
+}
+
+module_init(camellia_sparc64_mod_init);
+module_exit(camellia_sparc64_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Camellia Cipher Algorithm, sparc64 camellia opcode accelerated");
+
+MODULE_ALIAS("aes");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 469fc18..94f232f 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -758,6 +758,22 @@ config CRYPTO_CAMELLIA_X86_64
 	  See also:
 	  <https://info.isl.ntt.co.jp/crypt/eng/camellia/index_s.html>
 
+config CRYPTO_CAMELLIA_SPARC64
+	tristate "Camellia cipher algorithm (SPARC64)"
+	depends on SPARC64
+	depends on CRYPTO
+	select CRYPTO_ALGAPI
+	help
+	  Camellia cipher algorithm module (SPARC64).
+
+	  Camellia is a symmetric key block cipher developed jointly
+	  at NTT and Mitsubishi Electric Corporation.
+
+	  The Camellia specifies three key sizes: 128, 192 and 256 bits.
+
+	  See also:
+	  <https://info.isl.ntt.co.jp/crypt/eng/camellia/index_s.html>
+
 config CRYPTO_CAST5
 	tristate "CAST5 (CAST-128) cipher algorithm"
 	select CRYPTO_ALGAPI
-- 
1.7.10.4

