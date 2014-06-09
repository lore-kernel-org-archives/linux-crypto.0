From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH 2/2] crypto: des_3des - add x86-64 assembly implementation
Date: Mon, 09 Jun 2014 20:59:54 +0300
Message-ID: <20140609175954.15947.72318.stgit@localhost6.localdomain6>
References: <20140609175949.15947.64452.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tulikuusama.dnainternet.net ([83.102.40.132]:33192 "EHLO
	tulikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753766AbaFISHS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Jun 2014 14:07:18 -0400
In-Reply-To: <20140609175949.15947.64452.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Patch adds x86_64 assembly implementation of Triple DES EDE cipher algo=
rithm.
Two assembly implementations are provided. First is regular 'one-block =
at
time' encrypt/decrypt function. Second is 'three-blocks at time' functi=
on that
gains performance increase on out-of-order CPUs.

tcrypt test results:

Intel Core i5-4570:

des3_ede-asm vs des3_ede-generic:
size    ecb-enc ecb-dec cbc-enc cbc-dec ctr-enc ctr-dec
16B     1.21x   1.22x   1.27x   1.36x   1.25x   1.25x
64B     1.98x   1.96x   1.23x   2.04x   2.01x   2.00x
256B    2.34x   2.37x   1.21x   2.40x   2.38x   2.39x
1024B   2.50x   2.47x   1.22x   2.51x   2.52x   2.51x
8192B   2.51x   2.53x   1.21x   2.56x   2.54x   2.55x

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 arch/x86/crypto/Makefile          |    2=20
 arch/x86/crypto/des3_ede-asm_64.S |  805 +++++++++++++++++++++++++++++=
++++++++
 arch/x86/crypto/des3_ede_glue.c   |  509 +++++++++++++++++++++++
 crypto/Kconfig                    |   13 +
 crypto/des_generic.c              |   22 +
 include/crypto/des.h              |    3=20
 6 files changed, 1349 insertions(+), 5 deletions(-)
 create mode 100644 arch/x86/crypto/des3_ede-asm_64.S
 create mode 100644 arch/x86/crypto/des3_ede_glue.c

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 61d6e28..a470de2 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_CRYPTO_SALSA20_586) +=3D salsa20-i586.o
 obj-$(CONFIG_CRYPTO_SERPENT_SSE2_586) +=3D serpent-sse2-i586.o
=20
 obj-$(CONFIG_CRYPTO_AES_X86_64) +=3D aes-x86_64.o
+obj-$(CONFIG_CRYPTO_DES3_EDE_X86_64) +=3D des3_ede-x86_64.o
 obj-$(CONFIG_CRYPTO_CAMELLIA_X86_64) +=3D camellia-x86_64.o
 obj-$(CONFIG_CRYPTO_BLOWFISH_X86_64) +=3D blowfish-x86_64.o
 obj-$(CONFIG_CRYPTO_TWOFISH_X86_64) +=3D twofish-x86_64.o
@@ -52,6 +53,7 @@ salsa20-i586-y :=3D salsa20-i586-asm_32.o salsa20_glu=
e.o
 serpent-sse2-i586-y :=3D serpent-sse2-i586-asm_32.o serpent_sse2_glue.=
o
=20
 aes-x86_64-y :=3D aes-x86_64-asm_64.o aes_glue.o
+des3_ede-x86_64-y :=3D des3_ede-asm_64.o des3_ede_glue.o
 camellia-x86_64-y :=3D camellia-x86_64-asm_64.o camellia_glue.o
 blowfish-x86_64-y :=3D blowfish-x86_64-asm_64.o blowfish_glue.o
 twofish-x86_64-y :=3D twofish-x86_64-asm_64.o twofish_glue.o
diff --git a/arch/x86/crypto/des3_ede-asm_64.S b/arch/x86/crypto/des3_e=
de-asm_64.S
new file mode 100644
index 0000000..038f6ae
--- /dev/null
+++ b/arch/x86/crypto/des3_ede-asm_64.S
@@ -0,0 +1,805 @@
+/*
+ * des3_ede-asm_64.S  -  x86-64 assembly implementation of 3DES cipher
+ *
+ * Copyright =C2=A9 2014 Jussi Kivilinna <jussi.kivilinna@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/linkage.h>
+
+.file "des3_ede-asm_64.S"
+.text
+
+#define s1 .L_s1
+#define s2 ((s1) + (64*8))
+#define s3 ((s2) + (64*8))
+#define s4 ((s3) + (64*8))
+#define s5 ((s4) + (64*8))
+#define s6 ((s5) + (64*8))
+#define s7 ((s6) + (64*8))
+#define s8 ((s7) + (64*8))
+
+/* register macros */
+#define CTX %rdi
+
+#define RL0 %r8
+#define RL1 %r9
+#define RL2 %r10
+
+#define RL0d %r8d
+#define RL1d %r9d
+#define RL2d %r10d
+
+#define RR0 %r11
+#define RR1 %r12
+#define RR2 %r13
+
+#define RR0d %r11d
+#define RR1d %r12d
+#define RR2d %r13d
+
+#define RW0 %rax
+#define RW1 %rbx
+#define RW2 %rcx
+
+#define RW0d %eax
+#define RW1d %ebx
+#define RW2d %ecx
+
+#define RW0bl %al
+#define RW1bl %bl
+#define RW2bl %cl
+
+#define RW0bh %ah
+#define RW1bh %bh
+#define RW2bh %ch
+
+#define RT0 %r15
+#define RT1 %rbp
+#define RT2 %r14
+#define RT3 %rdx
+
+#define RT0d %r15d
+#define RT1d %ebp
+#define RT2d %r14d
+#define RT3d %edx
+
+/*********************************************************************=
**
+ * 1-way 3DES
+ *********************************************************************=
**/
+#define do_permutation(a, b, offset, mask) \
+	movl a, RT0d; \
+	shrl $(offset), RT0d; \
+	xorl b, RT0d; \
+	andl $(mask), RT0d; \
+	xorl RT0d, b; \
+	shll $(offset), RT0d; \
+	xorl RT0d, a;
+
+#define expand_to_64bits(val, mask) \
+	movl val##d, RT0d; \
+	rorl $4, RT0d; \
+	shlq $32, RT0; \
+	orq RT0, val; \
+	andq mask, val;
+
+#define compress_to_64bits(val) \
+	movq val, RT0; \
+	shrq $32, RT0; \
+	roll $4, RT0d; \
+	orl RT0d, val##d;
+
+#define initial_permutation(left, right) \
+	do_permutation(left##d, right##d,  4, 0x0f0f0f0f); \
+	do_permutation(left##d, right##d, 16, 0x0000ffff); \
+	do_permutation(right##d, left##d,  2, 0x33333333); \
+	do_permutation(right##d, left##d,  8, 0x00ff00ff); \
+	movabs $0x3f3f3f3f3f3f3f3f, RT3; \
+	movl left##d, RW0d; \
+	roll $1, right##d; \
+	xorl right##d, RW0d; \
+	andl $0xaaaaaaaa, RW0d; \
+	xorl RW0d, left##d; \
+	xorl RW0d, right##d; \
+	roll $1, left##d; \
+	expand_to_64bits(right, RT3); \
+	expand_to_64bits(left, RT3);
+
+#define final_permutation(left, right) \
+	compress_to_64bits(right); \
+	compress_to_64bits(left); \
+	movl right##d, RW0d; \
+	rorl $1, left##d; \
+	xorl left##d, RW0d; \
+	andl $0xaaaaaaaa, RW0d; \
+	xorl RW0d, right##d; \
+	xorl RW0d, left##d; \
+	rorl $1, right##d; \
+	do_permutation(right##d, left##d,  8, 0x00ff00ff); \
+	do_permutation(right##d, left##d,  2, 0x33333333); \
+	do_permutation(left##d, right##d, 16, 0x0000ffff); \
+	do_permutation(left##d, right##d,  4, 0x0f0f0f0f);
+
+#define round1(n, from, to, load_next_key) \
+	xorq from, RW0; \
+	\
+	movzbl RW0bl, RT0d; \
+	movzbl RW0bh, RT1d; \
+	shrq $16, RW0; \
+	movzbl RW0bl, RT2d; \
+	movzbl RW0bh, RT3d; \
+	shrq $16, RW0; \
+	movq s8(, RT0, 8), RT0; \
+	xorq s6(, RT1, 8), to; \
+	movzbl RW0bl, RL1d; \
+	movzbl RW0bh, RT1d; \
+	shrl $16, RW0d; \
+	xorq s4(, RT2, 8), RT0; \
+	xorq s2(, RT3, 8), to; \
+	movzbl RW0bl, RT2d; \
+	movzbl RW0bh, RT3d; \
+	xorq s7(, RL1, 8), RT0; \
+	xorq s5(, RT1, 8), to; \
+	xorq s3(, RT2, 8), RT0; \
+	load_next_key(n, RW0); \
+	xorq RT0, to; \
+	xorq s1(, RT3, 8), to; \
+
+#define load_next_key(n, RWx) \
+	movq (((n) + 1) * 8)(CTX), RWx;
+
+#define dummy2(a, b) /*_*/
+
+#define read_block(io, left, right) \
+	movl    (io), left##d; \
+	movl   4(io), right##d; \
+	bswapl left##d; \
+	bswapl right##d;
+
+#define write_block(io, left, right) \
+	bswapl left##d; \
+	bswapl right##d; \
+	movl   left##d,   (io); \
+	movl   right##d, 4(io);
+
+ENTRY(des3_ede_x86_64_crypt_blk)
+	/* input:
+	 *	%rdi: round keys, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 */
+	pushq %rbp;
+	pushq %rbx;
+	pushq %r12;
+	pushq %r13;
+	pushq %r14;
+	pushq %r15;
+
+	read_block(%rdx, RL0, RR0);
+	initial_permutation(RL0, RR0);
+
+	movq (CTX), RW0;
+
+	round1(0, RR0, RL0, load_next_key);
+	round1(1, RL0, RR0, load_next_key);
+	round1(2, RR0, RL0, load_next_key);
+	round1(3, RL0, RR0, load_next_key);
+	round1(4, RR0, RL0, load_next_key);
+	round1(5, RL0, RR0, load_next_key);
+	round1(6, RR0, RL0, load_next_key);
+	round1(7, RL0, RR0, load_next_key);
+	round1(8, RR0, RL0, load_next_key);
+	round1(9, RL0, RR0, load_next_key);
+	round1(10, RR0, RL0, load_next_key);
+	round1(11, RL0, RR0, load_next_key);
+	round1(12, RR0, RL0, load_next_key);
+	round1(13, RL0, RR0, load_next_key);
+	round1(14, RR0, RL0, load_next_key);
+	round1(15, RL0, RR0, load_next_key);
+
+	round1(16+0, RL0, RR0, load_next_key);
+	round1(16+1, RR0, RL0, load_next_key);
+	round1(16+2, RL0, RR0, load_next_key);
+	round1(16+3, RR0, RL0, load_next_key);
+	round1(16+4, RL0, RR0, load_next_key);
+	round1(16+5, RR0, RL0, load_next_key);
+	round1(16+6, RL0, RR0, load_next_key);
+	round1(16+7, RR0, RL0, load_next_key);
+	round1(16+8, RL0, RR0, load_next_key);
+	round1(16+9, RR0, RL0, load_next_key);
+	round1(16+10, RL0, RR0, load_next_key);
+	round1(16+11, RR0, RL0, load_next_key);
+	round1(16+12, RL0, RR0, load_next_key);
+	round1(16+13, RR0, RL0, load_next_key);
+	round1(16+14, RL0, RR0, load_next_key);
+	round1(16+15, RR0, RL0, load_next_key);
+
+	round1(32+0, RR0, RL0, load_next_key);
+	round1(32+1, RL0, RR0, load_next_key);
+	round1(32+2, RR0, RL0, load_next_key);
+	round1(32+3, RL0, RR0, load_next_key);
+	round1(32+4, RR0, RL0, load_next_key);
+	round1(32+5, RL0, RR0, load_next_key);
+	round1(32+6, RR0, RL0, load_next_key);
+	round1(32+7, RL0, RR0, load_next_key);
+	round1(32+8, RR0, RL0, load_next_key);
+	round1(32+9, RL0, RR0, load_next_key);
+	round1(32+10, RR0, RL0, load_next_key);
+	round1(32+11, RL0, RR0, load_next_key);
+	round1(32+12, RR0, RL0, load_next_key);
+	round1(32+13, RL0, RR0, load_next_key);
+	round1(32+14, RR0, RL0, load_next_key);
+	round1(32+15, RL0, RR0, dummy2);
+
+	final_permutation(RR0, RL0);
+	write_block(%rsi, RR0, RL0);
+
+	popq %r15;
+	popq %r14;
+	popq %r13;
+	popq %r12;
+	popq %rbx;
+	popq %rbp;
+
+	ret;
+ENDPROC(des3_ede_x86_64_crypt_blk)
+
+/*********************************************************************=
**
+ * 3-way 3DES
+ *********************************************************************=
**/
+#define expand_to_64bits(val, mask) \
+	movl val##d, RT0d; \
+	rorl $4, RT0d; \
+	shlq $32, RT0; \
+	orq RT0, val; \
+	andq mask, val;
+
+#define compress_to_64bits(val) \
+	movq val, RT0; \
+	shrq $32, RT0; \
+	roll $4, RT0d; \
+	orl RT0d, val##d;
+
+#define initial_permutation3(left, right) \
+	do_permutation(left##0d, right##0d,  4, 0x0f0f0f0f); \
+	do_permutation(left##0d, right##0d, 16, 0x0000ffff); \
+	  do_permutation(left##1d, right##1d,  4, 0x0f0f0f0f); \
+	  do_permutation(left##1d, right##1d, 16, 0x0000ffff); \
+	    do_permutation(left##2d, right##2d,  4, 0x0f0f0f0f); \
+	    do_permutation(left##2d, right##2d, 16, 0x0000ffff); \
+	    \
+	do_permutation(right##0d, left##0d,  2, 0x33333333); \
+	do_permutation(right##0d, left##0d,  8, 0x00ff00ff); \
+	  do_permutation(right##1d, left##1d,  2, 0x33333333); \
+	  do_permutation(right##1d, left##1d,  8, 0x00ff00ff); \
+	    do_permutation(right##2d, left##2d,  2, 0x33333333); \
+	    do_permutation(right##2d, left##2d,  8, 0x00ff00ff); \
+	    \
+	movabs $0x3f3f3f3f3f3f3f3f, RT3; \
+	    \
+	movl left##0d, RW0d; \
+	roll $1, right##0d; \
+	xorl right##0d, RW0d; \
+	andl $0xaaaaaaaa, RW0d; \
+	xorl RW0d, left##0d; \
+	xorl RW0d, right##0d; \
+	roll $1, left##0d; \
+	expand_to_64bits(right##0, RT3); \
+	expand_to_64bits(left##0, RT3); \
+	  movl left##1d, RW1d; \
+	  roll $1, right##1d; \
+	  xorl right##1d, RW1d; \
+	  andl $0xaaaaaaaa, RW1d; \
+	  xorl RW1d, left##1d; \
+	  xorl RW1d, right##1d; \
+	  roll $1, left##1d; \
+	  expand_to_64bits(right##1, RT3); \
+	  expand_to_64bits(left##1, RT3); \
+	    movl left##2d, RW2d; \
+	    roll $1, right##2d; \
+	    xorl right##2d, RW2d; \
+	    andl $0xaaaaaaaa, RW2d; \
+	    xorl RW2d, left##2d; \
+	    xorl RW2d, right##2d; \
+	    roll $1, left##2d; \
+	    expand_to_64bits(right##2, RT3); \
+	    expand_to_64bits(left##2, RT3);
+
+#define final_permutation3(left, right) \
+	compress_to_64bits(right##0); \
+	compress_to_64bits(left##0); \
+	movl right##0d, RW0d; \
+	rorl $1, left##0d; \
+	xorl left##0d, RW0d; \
+	andl $0xaaaaaaaa, RW0d; \
+	xorl RW0d, right##0d; \
+	xorl RW0d, left##0d; \
+	rorl $1, right##0d; \
+	  compress_to_64bits(right##1); \
+	  compress_to_64bits(left##1); \
+	  movl right##1d, RW1d; \
+	  rorl $1, left##1d; \
+	  xorl left##1d, RW1d; \
+	  andl $0xaaaaaaaa, RW1d; \
+	  xorl RW1d, right##1d; \
+	  xorl RW1d, left##1d; \
+	  rorl $1, right##1d; \
+	    compress_to_64bits(right##2); \
+	    compress_to_64bits(left##2); \
+	    movl right##2d, RW2d; \
+	    rorl $1, left##2d; \
+	    xorl left##2d, RW2d; \
+	    andl $0xaaaaaaaa, RW2d; \
+	    xorl RW2d, right##2d; \
+	    xorl RW2d, left##2d; \
+	    rorl $1, right##2d; \
+	    \
+	do_permutation(right##0d, left##0d,  8, 0x00ff00ff); \
+	do_permutation(right##0d, left##0d,  2, 0x33333333); \
+	  do_permutation(right##1d, left##1d,  8, 0x00ff00ff); \
+	  do_permutation(right##1d, left##1d,  2, 0x33333333); \
+	    do_permutation(right##2d, left##2d,  8, 0x00ff00ff); \
+	    do_permutation(right##2d, left##2d,  2, 0x33333333); \
+	    \
+	do_permutation(left##0d, right##0d, 16, 0x0000ffff); \
+	do_permutation(left##0d, right##0d,  4, 0x0f0f0f0f); \
+	  do_permutation(left##1d, right##1d, 16, 0x0000ffff); \
+	  do_permutation(left##1d, right##1d,  4, 0x0f0f0f0f); \
+	    do_permutation(left##2d, right##2d, 16, 0x0000ffff); \
+	    do_permutation(left##2d, right##2d,  4, 0x0f0f0f0f);
+
+#define round3(n, from, to, load_next_key, do_movq) \
+	xorq from##0, RW0; \
+	movzbl RW0bl, RT3d; \
+	movzbl RW0bh, RT1d; \
+	shrq $16, RW0; \
+	xorq s8(, RT3, 8), to##0; \
+	xorq s6(, RT1, 8), to##0; \
+	movzbl RW0bl, RT3d; \
+	movzbl RW0bh, RT1d; \
+	shrq $16, RW0; \
+	xorq s4(, RT3, 8), to##0; \
+	xorq s2(, RT1, 8), to##0; \
+	movzbl RW0bl, RT3d; \
+	movzbl RW0bh, RT1d; \
+	shrl $16, RW0d; \
+	xorq s7(, RT3, 8), to##0; \
+	xorq s5(, RT1, 8), to##0; \
+	movzbl RW0bl, RT3d; \
+	movzbl RW0bh, RT1d; \
+	load_next_key(n, RW0); \
+	xorq s3(, RT3, 8), to##0; \
+	xorq s1(, RT1, 8), to##0; \
+		xorq from##1, RW1; \
+		movzbl RW1bl, RT3d; \
+		movzbl RW1bh, RT1d; \
+		shrq $16, RW1; \
+		xorq s8(, RT3, 8), to##1; \
+		xorq s6(, RT1, 8), to##1; \
+		movzbl RW1bl, RT3d; \
+		movzbl RW1bh, RT1d; \
+		shrq $16, RW1; \
+		xorq s4(, RT3, 8), to##1; \
+		xorq s2(, RT1, 8), to##1; \
+		movzbl RW1bl, RT3d; \
+		movzbl RW1bh, RT1d; \
+		shrl $16, RW1d; \
+		xorq s7(, RT3, 8), to##1; \
+		xorq s5(, RT1, 8), to##1; \
+		movzbl RW1bl, RT3d; \
+		movzbl RW1bh, RT1d; \
+		do_movq(RW0, RW1); \
+		xorq s3(, RT3, 8), to##1; \
+		xorq s1(, RT1, 8), to##1; \
+			xorq from##2, RW2; \
+			movzbl RW2bl, RT3d; \
+			movzbl RW2bh, RT1d; \
+			shrq $16, RW2; \
+			xorq s8(, RT3, 8), to##2; \
+			xorq s6(, RT1, 8), to##2; \
+			movzbl RW2bl, RT3d; \
+			movzbl RW2bh, RT1d; \
+			shrq $16, RW2; \
+			xorq s4(, RT3, 8), to##2; \
+			xorq s2(, RT1, 8), to##2; \
+			movzbl RW2bl, RT3d; \
+			movzbl RW2bh, RT1d; \
+			shrl $16, RW2d; \
+			xorq s7(, RT3, 8), to##2; \
+			xorq s5(, RT1, 8), to##2; \
+			movzbl RW2bl, RT3d; \
+			movzbl RW2bh, RT1d; \
+			do_movq(RW0, RW2); \
+			xorq s3(, RT3, 8), to##2; \
+			xorq s1(, RT1, 8), to##2;
+
+#define __movq(src, dst) \
+	movq src, dst;
+
+ENTRY(des3_ede_x86_64_crypt_blk_3way)
+	/* input:
+	 *	%rdi: ctx, round keys
+	 *	%rsi: dst (3 blocks)
+	 *	%rdx: src (3 blocks)
+	 */
+
+	pushq %rbp;
+	pushq %rbx;
+	pushq %r12;
+	pushq %r13;
+	pushq %r14;
+	pushq %r15;
+
+	/* load input */
+	movl 0 * 4(%rdx), RL0d;
+	movl 1 * 4(%rdx), RR0d;
+	movl 2 * 4(%rdx), RL1d;
+	movl 3 * 4(%rdx), RR1d;
+	movl 4 * 4(%rdx), RL2d;
+	movl 5 * 4(%rdx), RR2d;
+
+	bswapl RL0d;
+	bswapl RR0d;
+	bswapl RL1d;
+	bswapl RR1d;
+	bswapl RL2d;
+	bswapl RR2d;
+
+	initial_permutation3(RL, RR);
+
+	movq 0(CTX), RW0;
+	movq RW0, RW1;
+	movq RW0, RW2;
+
+	round3(0, RR, RL, load_next_key, __movq);
+	round3(1, RL, RR, load_next_key, __movq);
+	round3(2, RR, RL, load_next_key, __movq);
+	round3(3, RL, RR, load_next_key, __movq);
+	round3(4, RR, RL, load_next_key, __movq);
+	round3(5, RL, RR, load_next_key, __movq);
+	round3(6, RR, RL, load_next_key, __movq);
+	round3(7, RL, RR, load_next_key, __movq);
+	round3(8, RR, RL, load_next_key, __movq);
+	round3(9, RL, RR, load_next_key, __movq);
+	round3(10, RR, RL, load_next_key, __movq);
+	round3(11, RL, RR, load_next_key, __movq);
+	round3(12, RR, RL, load_next_key, __movq);
+	round3(13, RL, RR, load_next_key, __movq);
+	round3(14, RR, RL, load_next_key, __movq);
+	round3(15, RL, RR, load_next_key, __movq);
+
+	round3(16+0, RL, RR, load_next_key, __movq);
+	round3(16+1, RR, RL, load_next_key, __movq);
+	round3(16+2, RL, RR, load_next_key, __movq);
+	round3(16+3, RR, RL, load_next_key, __movq);
+	round3(16+4, RL, RR, load_next_key, __movq);
+	round3(16+5, RR, RL, load_next_key, __movq);
+	round3(16+6, RL, RR, load_next_key, __movq);
+	round3(16+7, RR, RL, load_next_key, __movq);
+	round3(16+8, RL, RR, load_next_key, __movq);
+	round3(16+9, RR, RL, load_next_key, __movq);
+	round3(16+10, RL, RR, load_next_key, __movq);
+	round3(16+11, RR, RL, load_next_key, __movq);
+	round3(16+12, RL, RR, load_next_key, __movq);
+	round3(16+13, RR, RL, load_next_key, __movq);
+	round3(16+14, RL, RR, load_next_key, __movq);
+	round3(16+15, RR, RL, load_next_key, __movq);
+
+	round3(32+0, RR, RL, load_next_key, __movq);
+	round3(32+1, RL, RR, load_next_key, __movq);
+	round3(32+2, RR, RL, load_next_key, __movq);
+	round3(32+3, RL, RR, load_next_key, __movq);
+	round3(32+4, RR, RL, load_next_key, __movq);
+	round3(32+5, RL, RR, load_next_key, __movq);
+	round3(32+6, RR, RL, load_next_key, __movq);
+	round3(32+7, RL, RR, load_next_key, __movq);
+	round3(32+8, RR, RL, load_next_key, __movq);
+	round3(32+9, RL, RR, load_next_key, __movq);
+	round3(32+10, RR, RL, load_next_key, __movq);
+	round3(32+11, RL, RR, load_next_key, __movq);
+	round3(32+12, RR, RL, load_next_key, __movq);
+	round3(32+13, RL, RR, load_next_key, __movq);
+	round3(32+14, RR, RL, load_next_key, __movq);
+	round3(32+15, RL, RR, dummy2, dummy2);
+
+	final_permutation3(RR, RL);
+
+	bswapl RR0d;
+	bswapl RL0d;
+	bswapl RR1d;
+	bswapl RL1d;
+	bswapl RR2d;
+	bswapl RL2d;
+
+	movl RR0d, 0 * 4(%rsi);
+	movl RL0d, 1 * 4(%rsi);
+	movl RR1d, 2 * 4(%rsi);
+	movl RL1d, 3 * 4(%rsi);
+	movl RR2d, 4 * 4(%rsi);
+	movl RL2d, 5 * 4(%rsi);
+
+	popq %r15;
+	popq %r14;
+	popq %r13;
+	popq %r12;
+	popq %rbx;
+	popq %rbp;
+
+	ret;
+ENDPROC(des3_ede_x86_64_crypt_blk_3way)
+
+.data
+.align 16
+.L_s1:
+	.quad 0x0010100001010400, 0x0000000000000000
+	.quad 0x0000100000010000, 0x0010100001010404
+	.quad 0x0010100001010004, 0x0000100000010404
+	.quad 0x0000000000000004, 0x0000100000010000
+	.quad 0x0000000000000400, 0x0010100001010400
+	.quad 0x0010100001010404, 0x0000000000000400
+	.quad 0x0010000001000404, 0x0010100001010004
+	.quad 0x0010000001000000, 0x0000000000000004
+	.quad 0x0000000000000404, 0x0010000001000400
+	.quad 0x0010000001000400, 0x0000100000010400
+	.quad 0x0000100000010400, 0x0010100001010000
+	.quad 0x0010100001010000, 0x0010000001000404
+	.quad 0x0000100000010004, 0x0010000001000004
+	.quad 0x0010000001000004, 0x0000100000010004
+	.quad 0x0000000000000000, 0x0000000000000404
+	.quad 0x0000100000010404, 0x0010000001000000
+	.quad 0x0000100000010000, 0x0010100001010404
+	.quad 0x0000000000000004, 0x0010100001010000
+	.quad 0x0010100001010400, 0x0010000001000000
+	.quad 0x0010000001000000, 0x0000000000000400
+	.quad 0x0010100001010004, 0x0000100000010000
+	.quad 0x0000100000010400, 0x0010000001000004
+	.quad 0x0000000000000400, 0x0000000000000004
+	.quad 0x0010000001000404, 0x0000100000010404
+	.quad 0x0010100001010404, 0x0000100000010004
+	.quad 0x0010100001010000, 0x0010000001000404
+	.quad 0x0010000001000004, 0x0000000000000404
+	.quad 0x0000100000010404, 0x0010100001010400
+	.quad 0x0000000000000404, 0x0010000001000400
+	.quad 0x0010000001000400, 0x0000000000000000
+	.quad 0x0000100000010004, 0x0000100000010400
+	.quad 0x0000000000000000, 0x0010100001010004
+.L_s2:
+	.quad 0x0801080200100020, 0x0800080000000000
+	.quad 0x0000080000000000, 0x0001080200100020
+	.quad 0x0001000000100000, 0x0000000200000020
+	.quad 0x0801000200100020, 0x0800080200000020
+	.quad 0x0800000200000020, 0x0801080200100020
+	.quad 0x0801080000100000, 0x0800000000000000
+	.quad 0x0800080000000000, 0x0001000000100000
+	.quad 0x0000000200000020, 0x0801000200100020
+	.quad 0x0001080000100000, 0x0001000200100020
+	.quad 0x0800080200000020, 0x0000000000000000
+	.quad 0x0800000000000000, 0x0000080000000000
+	.quad 0x0001080200100020, 0x0801000000100000
+	.quad 0x0001000200100020, 0x0800000200000020
+	.quad 0x0000000000000000, 0x0001080000100000
+	.quad 0x0000080200000020, 0x0801080000100000
+	.quad 0x0801000000100000, 0x0000080200000020
+	.quad 0x0000000000000000, 0x0001080200100020
+	.quad 0x0801000200100020, 0x0001000000100000
+	.quad 0x0800080200000020, 0x0801000000100000
+	.quad 0x0801080000100000, 0x0000080000000000
+	.quad 0x0801000000100000, 0x0800080000000000
+	.quad 0x0000000200000020, 0x0801080200100020
+	.quad 0x0001080200100020, 0x0000000200000020
+	.quad 0x0000080000000000, 0x0800000000000000
+	.quad 0x0000080200000020, 0x0801080000100000
+	.quad 0x0001000000100000, 0x0800000200000020
+	.quad 0x0001000200100020, 0x0800080200000020
+	.quad 0x0800000200000020, 0x0001000200100020
+	.quad 0x0001080000100000, 0x0000000000000000
+	.quad 0x0800080000000000, 0x0000080200000020
+	.quad 0x0800000000000000, 0x0801000200100020
+	.quad 0x0801080200100020, 0x0001080000100000
+.L_s3:
+	.quad 0x0000002000000208, 0x0000202008020200
+	.quad 0x0000000000000000, 0x0000200008020008
+	.quad 0x0000002008000200, 0x0000000000000000
+	.quad 0x0000202000020208, 0x0000002008000200
+	.quad 0x0000200000020008, 0x0000000008000008
+	.quad 0x0000000008000008, 0x0000200000020000
+	.quad 0x0000202008020208, 0x0000200000020008
+	.quad 0x0000200008020000, 0x0000002000000208
+	.quad 0x0000000008000000, 0x0000000000000008
+	.quad 0x0000202008020200, 0x0000002000000200
+	.quad 0x0000202000020200, 0x0000200008020000
+	.quad 0x0000200008020008, 0x0000202000020208
+	.quad 0x0000002008000208, 0x0000202000020200
+	.quad 0x0000200000020000, 0x0000002008000208
+	.quad 0x0000000000000008, 0x0000202008020208
+	.quad 0x0000002000000200, 0x0000000008000000
+	.quad 0x0000202008020200, 0x0000000008000000
+	.quad 0x0000200000020008, 0x0000002000000208
+	.quad 0x0000200000020000, 0x0000202008020200
+	.quad 0x0000002008000200, 0x0000000000000000
+	.quad 0x0000002000000200, 0x0000200000020008
+	.quad 0x0000202008020208, 0x0000002008000200
+	.quad 0x0000000008000008, 0x0000002000000200
+	.quad 0x0000000000000000, 0x0000200008020008
+	.quad 0x0000002008000208, 0x0000200000020000
+	.quad 0x0000000008000000, 0x0000202008020208
+	.quad 0x0000000000000008, 0x0000202000020208
+	.quad 0x0000202000020200, 0x0000000008000008
+	.quad 0x0000200008020000, 0x0000002008000208
+	.quad 0x0000002000000208, 0x0000200008020000
+	.quad 0x0000202000020208, 0x0000000000000008
+	.quad 0x0000200008020008, 0x0000202000020200
+.L_s4:
+	.quad 0x1008020000002001, 0x1000020800002001
+	.quad 0x1000020800002001, 0x0000000800000000
+	.quad 0x0008020800002000, 0x1008000800000001
+	.quad 0x1008000000000001, 0x1000020000002001
+	.quad 0x0000000000000000, 0x0008020000002000
+	.quad 0x0008020000002000, 0x1008020800002001
+	.quad 0x1000000800000001, 0x0000000000000000
+	.quad 0x0008000800000000, 0x1008000000000001
+	.quad 0x1000000000000001, 0x0000020000002000
+	.quad 0x0008000000000000, 0x1008020000002001
+	.quad 0x0000000800000000, 0x0008000000000000
+	.quad 0x1000020000002001, 0x0000020800002000
+	.quad 0x1008000800000001, 0x1000000000000001
+	.quad 0x0000020800002000, 0x0008000800000000
+	.quad 0x0000020000002000, 0x0008020800002000
+	.quad 0x1008020800002001, 0x1000000800000001
+	.quad 0x0008000800000000, 0x1008000000000001
+	.quad 0x0008020000002000, 0x1008020800002001
+	.quad 0x1000000800000001, 0x0000000000000000
+	.quad 0x0000000000000000, 0x0008020000002000
+	.quad 0x0000020800002000, 0x0008000800000000
+	.quad 0x1008000800000001, 0x1000000000000001
+	.quad 0x1008020000002001, 0x1000020800002001
+	.quad 0x1000020800002001, 0x0000000800000000
+	.quad 0x1008020800002001, 0x1000000800000001
+	.quad 0x1000000000000001, 0x0000020000002000
+	.quad 0x1008000000000001, 0x1000020000002001
+	.quad 0x0008020800002000, 0x1008000800000001
+	.quad 0x1000020000002001, 0x0000020800002000
+	.quad 0x0008000000000000, 0x1008020000002001
+	.quad 0x0000000800000000, 0x0008000000000000
+	.quad 0x0000020000002000, 0x0008020800002000
+.L_s5:
+	.quad 0x0000001000000100, 0x0020001002080100
+	.quad 0x0020000002080000, 0x0420001002000100
+	.quad 0x0000000000080000, 0x0000001000000100
+	.quad 0x0400000000000000, 0x0020000002080000
+	.quad 0x0400001000080100, 0x0000000000080000
+	.quad 0x0020001002000100, 0x0400001000080100
+	.quad 0x0420001002000100, 0x0420000002080000
+	.quad 0x0000001000080100, 0x0400000000000000
+	.quad 0x0020000002000000, 0x0400000000080000
+	.quad 0x0400000000080000, 0x0000000000000000
+	.quad 0x0400001000000100, 0x0420001002080100
+	.quad 0x0420001002080100, 0x0020001002000100
+	.quad 0x0420000002080000, 0x0400001000000100
+	.quad 0x0000000000000000, 0x0420000002000000
+	.quad 0x0020001002080100, 0x0020000002000000
+	.quad 0x0420000002000000, 0x0000001000080100
+	.quad 0x0000000000080000, 0x0420001002000100
+	.quad 0x0000001000000100, 0x0020000002000000
+	.quad 0x0400000000000000, 0x0020000002080000
+	.quad 0x0420001002000100, 0x0400001000080100
+	.quad 0x0020001002000100, 0x0400000000000000
+	.quad 0x0420000002080000, 0x0020001002080100
+	.quad 0x0400001000080100, 0x0000001000000100
+	.quad 0x0020000002000000, 0x0420000002080000
+	.quad 0x0420001002080100, 0x0000001000080100
+	.quad 0x0420000002000000, 0x0420001002080100
+	.quad 0x0020000002080000, 0x0000000000000000
+	.quad 0x0400000000080000, 0x0420000002000000
+	.quad 0x0000001000080100, 0x0020001002000100
+	.quad 0x0400001000000100, 0x0000000000080000
+	.quad 0x0000000000000000, 0x0400000000080000
+	.quad 0x0020001002080100, 0x0400001000000100
+.L_s6:
+	.quad 0x0200000120000010, 0x0204000020000000
+	.quad 0x0000040000000000, 0x0204040120000010
+	.quad 0x0204000020000000, 0x0000000100000010
+	.quad 0x0204040120000010, 0x0004000000000000
+	.quad 0x0200040020000000, 0x0004040100000010
+	.quad 0x0004000000000000, 0x0200000120000010
+	.quad 0x0004000100000010, 0x0200040020000000
+	.quad 0x0200000020000000, 0x0000040100000010
+	.quad 0x0000000000000000, 0x0004000100000010
+	.quad 0x0200040120000010, 0x0000040000000000
+	.quad 0x0004040000000000, 0x0200040120000010
+	.quad 0x0000000100000010, 0x0204000120000010
+	.quad 0x0204000120000010, 0x0000000000000000
+	.quad 0x0004040100000010, 0x0204040020000000
+	.quad 0x0000040100000010, 0x0004040000000000
+	.quad 0x0204040020000000, 0x0200000020000000
+	.quad 0x0200040020000000, 0x0000000100000010
+	.quad 0x0204000120000010, 0x0004040000000000
+	.quad 0x0204040120000010, 0x0004000000000000
+	.quad 0x0000040100000010, 0x0200000120000010
+	.quad 0x0004000000000000, 0x0200040020000000
+	.quad 0x0200000020000000, 0x0000040100000010
+	.quad 0x0200000120000010, 0x0204040120000010
+	.quad 0x0004040000000000, 0x0204000020000000
+	.quad 0x0004040100000010, 0x0204040020000000
+	.quad 0x0000000000000000, 0x0204000120000010
+	.quad 0x0000000100000010, 0x0000040000000000
+	.quad 0x0204000020000000, 0x0004040100000010
+	.quad 0x0000040000000000, 0x0004000100000010
+	.quad 0x0200040120000010, 0x0000000000000000
+	.quad 0x0204040020000000, 0x0200000020000000
+	.quad 0x0004000100000010, 0x0200040120000010
+.L_s7:
+	.quad 0x0002000000200000, 0x2002000004200002
+	.quad 0x2000000004000802, 0x0000000000000000
+	.quad 0x0000000000000800, 0x2000000004000802
+	.quad 0x2002000000200802, 0x0002000004200800
+	.quad 0x2002000004200802, 0x0002000000200000
+	.quad 0x0000000000000000, 0x2000000004000002
+	.quad 0x2000000000000002, 0x0000000004000000
+	.quad 0x2002000004200002, 0x2000000000000802
+	.quad 0x0000000004000800, 0x2002000000200802
+	.quad 0x2002000000200002, 0x0000000004000800
+	.quad 0x2000000004000002, 0x0002000004200000
+	.quad 0x0002000004200800, 0x2002000000200002
+	.quad 0x0002000004200000, 0x0000000000000800
+	.quad 0x2000000000000802, 0x2002000004200802
+	.quad 0x0002000000200800, 0x2000000000000002
+	.quad 0x0000000004000000, 0x0002000000200800
+	.quad 0x0000000004000000, 0x0002000000200800
+	.quad 0x0002000000200000, 0x2000000004000802
+	.quad 0x2000000004000802, 0x2002000004200002
+	.quad 0x2002000004200002, 0x2000000000000002
+	.quad 0x2002000000200002, 0x0000000004000000
+	.quad 0x0000000004000800, 0x0002000000200000
+	.quad 0x0002000004200800, 0x2000000000000802
+	.quad 0x2002000000200802, 0x0002000004200800
+	.quad 0x2000000000000802, 0x2000000004000002
+	.quad 0x2002000004200802, 0x0002000004200000
+	.quad 0x0002000000200800, 0x0000000000000000
+	.quad 0x2000000000000002, 0x2002000004200802
+	.quad 0x0000000000000000, 0x2002000000200802
+	.quad 0x0002000004200000, 0x0000000000000800
+	.quad 0x2000000004000002, 0x0000000004000800
+	.quad 0x0000000000000800, 0x2002000000200002
+.L_s8:
+	.quad 0x0100010410001000, 0x0000010000001000
+	.quad 0x0000000000040000, 0x0100010410041000
+	.quad 0x0100000010000000, 0x0100010410001000
+	.quad 0x0000000400000000, 0x0100000010000000
+	.quad 0x0000000400040000, 0x0100000010040000
+	.quad 0x0100010410041000, 0x0000010000041000
+	.quad 0x0100010010041000, 0x0000010400041000
+	.quad 0x0000010000001000, 0x0000000400000000
+	.quad 0x0100000010040000, 0x0100000410000000
+	.quad 0x0100010010001000, 0x0000010400001000
+	.quad 0x0000010000041000, 0x0000000400040000
+	.quad 0x0100000410040000, 0x0100010010041000
+	.quad 0x0000010400001000, 0x0000000000000000
+	.quad 0x0000000000000000, 0x0100000410040000
+	.quad 0x0100000410000000, 0x0100010010001000
+	.quad 0x0000010400041000, 0x0000000000040000
+	.quad 0x0000010400041000, 0x0000000000040000
+	.quad 0x0100010010041000, 0x0000010000001000
+	.quad 0x0000000400000000, 0x0100000410040000
+	.quad 0x0000010000001000, 0x0000010400041000
+	.quad 0x0100010010001000, 0x0000000400000000
+	.quad 0x0100000410000000, 0x0100000010040000
+	.quad 0x0100000410040000, 0x0100000010000000
+	.quad 0x0000000000040000, 0x0100010410001000
+	.quad 0x0000000000000000, 0x0100010410041000
+	.quad 0x0000000400040000, 0x0100000410000000
+	.quad 0x0100000010040000, 0x0100010010001000
+	.quad 0x0100010410001000, 0x0000000000000000
+	.quad 0x0100010410041000, 0x0000010000041000
+	.quad 0x0000010000041000, 0x0000010400001000
+	.quad 0x0000010400001000, 0x0000000400040000
+	.quad 0x0100000010000000, 0x0100010010041000
diff --git a/arch/x86/crypto/des3_ede_glue.c b/arch/x86/crypto/des3_ede=
_glue.c
new file mode 100644
index 0000000..ebc4215
--- /dev/null
+++ b/arch/x86/crypto/des3_ede_glue.c
@@ -0,0 +1,509 @@
+/*
+ * Glue Code for assembler optimized version of 3DES
+ *
+ * Copyright =C2=A9 2014 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ *
+ * CBC & ECB parts based on code (crypto/cbc.c,ecb.c) by:
+ *   Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
+ * CTR part based on code (crypto/ctr.c) by:
+ *   (C) Copyright IBM Corp. 2007 - Joy Latten <latten@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <asm/processor.h>
+#include <crypto/des.h>
+#include <linux/crypto.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <crypto/algapi.h>
+
+struct des3_ede_x86_ctx {
+	u32 enc_expkey[DES3_EDE_EXPKEY_WORDS];
+	u32 dec_expkey[DES3_EDE_EXPKEY_WORDS];
+};
+
+/* regular block cipher functions */
+asmlinkage void des3_ede_x86_64_crypt_blk(const u32 *expkey, u8 *dst,
+					  const u8 *src);
+
+/* 3-way parallel cipher functions */
+asmlinkage void des3_ede_x86_64_crypt_blk_3way(const u32 *expkey, u8 *=
dst,
+					       const u8 *src);
+
+static inline void des3_ede_enc_blk(struct des3_ede_x86_ctx *ctx, u8 *=
dst,
+				    const u8 *src)
+{
+	u32 *enc_ctx =3D ctx->enc_expkey;
+
+	des3_ede_x86_64_crypt_blk(enc_ctx, dst, src);
+}
+
+static inline void des3_ede_dec_blk(struct des3_ede_x86_ctx *ctx, u8 *=
dst,
+				    const u8 *src)
+{
+	u32 *dec_ctx =3D ctx->dec_expkey;
+
+	des3_ede_x86_64_crypt_blk(dec_ctx, dst, src);
+}
+
+static inline void des3_ede_enc_blk_3way(struct des3_ede_x86_ctx *ctx,=
 u8 *dst,
+					 const u8 *src)
+{
+	u32 *enc_ctx =3D ctx->enc_expkey;
+
+	des3_ede_x86_64_crypt_blk_3way(enc_ctx, dst, src);
+}
+
+static inline void des3_ede_dec_blk_3way(struct des3_ede_x86_ctx *ctx,=
 u8 *dst,
+					 const u8 *src)
+{
+	u32 *dec_ctx =3D ctx->dec_expkey;
+
+	des3_ede_x86_64_crypt_blk_3way(dec_ctx, dst, src);
+}
+
+static void des3_ede_x86_encrypt(struct crypto_tfm *tfm, u8 *dst, cons=
t u8 *src)
+{
+	des3_ede_enc_blk(crypto_tfm_ctx(tfm), dst, src);
+}
+
+static void des3_ede_x86_decrypt(struct crypto_tfm *tfm, u8 *dst, cons=
t u8 *src)
+{
+	des3_ede_dec_blk(crypto_tfm_ctx(tfm), dst, src);
+}
+
+static int ecb_crypt(struct blkcipher_desc *desc, struct blkcipher_wal=
k *walk,
+		     const u32 *expkey)
+{
+	unsigned int bsize =3D DES3_EDE_BLOCK_SIZE;
+	unsigned int nbytes;
+	int err;
+
+	err =3D blkcipher_walk_virt(desc, walk);
+
+	while ((nbytes =3D walk->nbytes)) {
+		u8 *wsrc =3D walk->src.virt.addr;
+		u8 *wdst =3D walk->dst.virt.addr;
+
+		/* Process four block batch */
+		if (nbytes >=3D bsize * 3) {
+			do {
+				des3_ede_x86_64_crypt_blk_3way(expkey, wdst,
+							       wsrc);
+
+				wsrc +=3D bsize * 3;
+				wdst +=3D bsize * 3;
+				nbytes -=3D bsize * 3;
+			} while (nbytes >=3D bsize * 3);
+
+			if (nbytes < bsize)
+				goto done;
+		}
+
+		/* Handle leftovers */
+		do {
+			des3_ede_x86_64_crypt_blk(expkey, wdst, wsrc);
+
+			wsrc +=3D bsize;
+			wdst +=3D bsize;
+			nbytes -=3D bsize;
+		} while (nbytes >=3D bsize);
+
+done:
+		err =3D blkcipher_walk_done(desc, walk, nbytes);
+	}
+
+	return err;
+}
+
+static int ecb_encrypt(struct blkcipher_desc *desc, struct scatterlist=
 *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct des3_ede_x86_ctx *ctx =3D crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	return ecb_crypt(desc, &walk, ctx->enc_expkey);
+}
+
+static int ecb_decrypt(struct blkcipher_desc *desc, struct scatterlist=
 *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct des3_ede_x86_ctx *ctx =3D crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	return ecb_crypt(desc, &walk, ctx->dec_expkey);
+}
+
+static unsigned int __cbc_encrypt(struct blkcipher_desc *desc,
+				  struct blkcipher_walk *walk)
+{
+	struct des3_ede_x86_ctx *ctx =3D crypto_blkcipher_ctx(desc->tfm);
+	unsigned int bsize =3D DES3_EDE_BLOCK_SIZE;
+	unsigned int nbytes =3D walk->nbytes;
+	u64 *src =3D (u64 *)walk->src.virt.addr;
+	u64 *dst =3D (u64 *)walk->dst.virt.addr;
+	u64 *iv =3D (u64 *)walk->iv;
+
+	do {
+		*dst =3D *src ^ *iv;
+		des3_ede_enc_blk(ctx, (u8 *)dst, (u8 *)dst);
+		iv =3D dst;
+
+		src +=3D 1;
+		dst +=3D 1;
+		nbytes -=3D bsize;
+	} while (nbytes >=3D bsize);
+
+	*(u64 *)walk->iv =3D *iv;
+	return nbytes;
+}
+
+static int cbc_encrypt(struct blkcipher_desc *desc, struct scatterlist=
 *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err =3D blkcipher_walk_virt(desc, &walk);
+
+	while ((nbytes =3D walk.nbytes)) {
+		nbytes =3D __cbc_encrypt(desc, &walk);
+		err =3D blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	return err;
+}
+
+static unsigned int __cbc_decrypt(struct blkcipher_desc *desc,
+				  struct blkcipher_walk *walk)
+{
+	struct des3_ede_x86_ctx *ctx =3D crypto_blkcipher_ctx(desc->tfm);
+	unsigned int bsize =3D DES3_EDE_BLOCK_SIZE;
+	unsigned int nbytes =3D walk->nbytes;
+	u64 *src =3D (u64 *)walk->src.virt.addr;
+	u64 *dst =3D (u64 *)walk->dst.virt.addr;
+	u64 ivs[3 - 1];
+	u64 last_iv;
+
+	/* Start of the last block. */
+	src +=3D nbytes / bsize - 1;
+	dst +=3D nbytes / bsize - 1;
+
+	last_iv =3D *src;
+
+	/* Process four block batch */
+	if (nbytes >=3D bsize * 3) {
+		do {
+			nbytes -=3D bsize * 3 - bsize;
+			src -=3D 3 - 1;
+			dst -=3D 3 - 1;
+
+			ivs[0] =3D src[0];
+			ivs[1] =3D src[1];
+
+			des3_ede_dec_blk_3way(ctx, (u8 *)dst, (u8 *)src);
+
+			dst[1] ^=3D ivs[0];
+			dst[2] ^=3D ivs[1];
+
+			nbytes -=3D bsize;
+			if (nbytes < bsize)
+				goto done;
+
+			*dst ^=3D *(src - 1);
+			src -=3D 1;
+			dst -=3D 1;
+		} while (nbytes >=3D bsize * 3);
+	}
+
+	/* Handle leftovers */
+	for (;;) {
+		des3_ede_dec_blk(ctx, (u8 *)dst, (u8 *)src);
+
+		nbytes -=3D bsize;
+		if (nbytes < bsize)
+			break;
+
+		*dst ^=3D *(src - 1);
+		src -=3D 1;
+		dst -=3D 1;
+	}
+
+done:
+	*dst ^=3D *(u64 *)walk->iv;
+	*(u64 *)walk->iv =3D last_iv;
+
+	return nbytes;
+}
+
+static int cbc_decrypt(struct blkcipher_desc *desc, struct scatterlist=
 *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err =3D blkcipher_walk_virt(desc, &walk);
+
+	while ((nbytes =3D walk.nbytes)) {
+		nbytes =3D __cbc_decrypt(desc, &walk);
+		err =3D blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	return err;
+}
+
+static void ctr_crypt_final(struct des3_ede_x86_ctx *ctx,
+			    struct blkcipher_walk *walk)
+{
+	u8 *ctrblk =3D walk->iv;
+	u8 keystream[DES3_EDE_BLOCK_SIZE];
+	u8 *src =3D walk->src.virt.addr;
+	u8 *dst =3D walk->dst.virt.addr;
+	unsigned int nbytes =3D walk->nbytes;
+
+	des3_ede_enc_blk(ctx, keystream, ctrblk);
+	crypto_xor(keystream, src, nbytes);
+	memcpy(dst, keystream, nbytes);
+
+	crypto_inc(ctrblk, DES3_EDE_BLOCK_SIZE);
+}
+
+static unsigned int __ctr_crypt(struct blkcipher_desc *desc,
+				struct blkcipher_walk *walk)
+{
+	struct des3_ede_x86_ctx *ctx =3D crypto_blkcipher_ctx(desc->tfm);
+	unsigned int bsize =3D DES3_EDE_BLOCK_SIZE;
+	unsigned int nbytes =3D walk->nbytes;
+	u64 *src =3D (u64 *)walk->src.virt.addr;
+	u64 *dst =3D (u64 *)walk->dst.virt.addr;
+	u64 ctrblk =3D be64_to_cpu(*(__be64 *)walk->iv);
+	__be64 ctrblocks[3];
+
+	/* Process four block batch */
+	if (nbytes >=3D bsize * 3) {
+		do {
+			/* create ctrblks for parallel encrypt */
+			ctrblocks[0] =3D cpu_to_be64(ctrblk++);
+			ctrblocks[1] =3D cpu_to_be64(ctrblk++);
+			ctrblocks[2] =3D cpu_to_be64(ctrblk++);
+
+			des3_ede_enc_blk_3way(ctx, (u8 *)ctrblocks,
+					      (u8 *)ctrblocks);
+
+			dst[0] =3D src[0] ^ ctrblocks[0];
+			dst[1] =3D src[1] ^ ctrblocks[1];
+			dst[2] =3D src[2] ^ ctrblocks[2];
+
+			src +=3D 3;
+			dst +=3D 3;
+		} while ((nbytes -=3D bsize * 3) >=3D bsize * 3);
+
+		if (nbytes < bsize)
+			goto done;
+	}
+
+	/* Handle leftovers */
+	do {
+		ctrblocks[0] =3D cpu_to_be64(ctrblk++);
+
+		des3_ede_enc_blk(ctx, (u8 *)ctrblocks, (u8 *)ctrblocks);
+
+		dst[0] =3D src[0] ^ ctrblocks[0];
+
+		src +=3D 1;
+		dst +=3D 1;
+	} while ((nbytes -=3D bsize) >=3D bsize);
+
+done:
+	*(__be64 *)walk->iv =3D cpu_to_be64(ctrblk);
+	return nbytes;
+}
+
+static int ctr_crypt(struct blkcipher_desc *desc, struct scatterlist *=
dst,
+		     struct scatterlist *src, unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err =3D blkcipher_walk_virt_block(desc, &walk, DES3_EDE_BLOCK_SIZE);
+
+	while ((nbytes =3D walk.nbytes) >=3D DES3_EDE_BLOCK_SIZE) {
+		nbytes =3D __ctr_crypt(desc, &walk);
+		err =3D blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	if (walk.nbytes) {
+		ctr_crypt_final(crypto_blkcipher_ctx(desc->tfm), &walk);
+		err =3D blkcipher_walk_done(desc, &walk, 0);
+	}
+
+	return err;
+}
+
+static int des3_ede_x86_setkey(struct crypto_tfm *tfm, const u8 *key,
+			       unsigned int keylen)
+{
+	struct des3_ede_x86_ctx *ctx =3D crypto_tfm_ctx(tfm);
+	u32 i, j, tmp;
+	int err;
+
+	/* Generate encryption context using generic implementation. */
+	err =3D __des3_ede_setkey(ctx->enc_expkey, &tfm->crt_flags, key, keyl=
en);
+	if (err < 0)
+		return err;
+
+	/* Fix encryption context for this implementation and form decryption
+	 * context. */
+	j =3D DES3_EDE_EXPKEY_WORDS - 2;
+	for (i =3D 0; i < DES3_EDE_EXPKEY_WORDS; i +=3D 2, j -=3D 2) {
+		tmp =3D ror32(ctx->enc_expkey[i + 1], 4);
+		ctx->enc_expkey[i + 1] =3D tmp;
+
+		ctx->dec_expkey[j + 0] =3D ctx->enc_expkey[i + 0];
+		ctx->dec_expkey[j + 1] =3D tmp;
+	}
+
+	return 0;
+}
+
+static struct crypto_alg des3_ede_algs[4] =3D { {
+	.cra_name		=3D "des3_ede",
+	.cra_driver_name	=3D "des3_ede-asm",
+	.cra_priority		=3D 200,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_CIPHER,
+	.cra_blocksize		=3D DES3_EDE_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct des3_ede_x86_ctx),
+	.cra_alignmask		=3D 0,
+	.cra_module		=3D THIS_MODULE,
+	.cra_u =3D {
+		.cipher =3D {
+			.cia_min_keysize	=3D DES3_EDE_KEY_SIZE,
+			.cia_max_keysize	=3D DES3_EDE_KEY_SIZE,
+			.cia_setkey		=3D des3_ede_x86_setkey,
+			.cia_encrypt		=3D des3_ede_x86_encrypt,
+			.cia_decrypt		=3D des3_ede_x86_decrypt,
+		}
+	}
+}, {
+	.cra_name		=3D "ecb(des3_ede)",
+	.cra_driver_name	=3D "ecb-des3_ede-asm",
+	.cra_priority		=3D 300,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		=3D DES3_EDE_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct des3_ede_x86_ctx),
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_blkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_u =3D {
+		.blkcipher =3D {
+			.min_keysize	=3D DES3_EDE_KEY_SIZE,
+			.max_keysize	=3D DES3_EDE_KEY_SIZE,
+			.setkey		=3D des3_ede_x86_setkey,
+			.encrypt	=3D ecb_encrypt,
+			.decrypt	=3D ecb_decrypt,
+		},
+	},
+}, {
+	.cra_name		=3D "cbc(des3_ede)",
+	.cra_driver_name	=3D "cbc-des3_ede-asm",
+	.cra_priority		=3D 300,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		=3D DES3_EDE_BLOCK_SIZE,
+	.cra_ctxsize		=3D sizeof(struct des3_ede_x86_ctx),
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_blkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_u =3D {
+		.blkcipher =3D {
+			.min_keysize	=3D DES3_EDE_KEY_SIZE,
+			.max_keysize	=3D DES3_EDE_KEY_SIZE,
+			.ivsize		=3D DES3_EDE_BLOCK_SIZE,
+			.setkey		=3D des3_ede_x86_setkey,
+			.encrypt	=3D cbc_encrypt,
+			.decrypt	=3D cbc_decrypt,
+		},
+	},
+}, {
+	.cra_name		=3D "ctr(des3_ede)",
+	.cra_driver_name	=3D "ctr-des3_ede-asm",
+	.cra_priority		=3D 300,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		=3D 1,
+	.cra_ctxsize		=3D sizeof(struct des3_ede_x86_ctx),
+	.cra_alignmask		=3D 0,
+	.cra_type		=3D &crypto_blkcipher_type,
+	.cra_module		=3D THIS_MODULE,
+	.cra_u =3D {
+		.blkcipher =3D {
+			.min_keysize	=3D DES3_EDE_KEY_SIZE,
+			.max_keysize	=3D DES3_EDE_KEY_SIZE,
+			.ivsize		=3D DES3_EDE_BLOCK_SIZE,
+			.setkey		=3D des3_ede_x86_setkey,
+			.encrypt	=3D ctr_crypt,
+			.decrypt	=3D ctr_crypt,
+		},
+	},
+} };
+
+static bool is_blacklisted_cpu(void)
+{
+	if (boot_cpu_data.x86_vendor !=3D X86_VENDOR_INTEL)
+		return false;
+
+	if (boot_cpu_data.x86 =3D=3D 0x0f) {
+		/*
+		 * On Pentium 4, des3_ede-x86_64 is slower than generic C
+		 * implementation because use of 64bit rotates (which are really
+		 * slow on P4). Therefore blacklist P4s.
+		 */
+		return true;
+	}
+
+	return false;
+}
+
+static int force;
+module_param(force, int, 0);
+MODULE_PARM_DESC(force, "Force module load, ignore CPU blacklist");
+
+static int __init des3_ede_x86_init(void)
+{
+	if (!force && is_blacklisted_cpu()) {
+		pr_info("des3_ede-x86_64: performance on this CPU would be suboptima=
l: disabling des3_ede-x86_64.\n");
+		return -ENODEV;
+	}
+
+	return crypto_register_algs(des3_ede_algs, ARRAY_SIZE(des3_ede_algs))=
;
+}
+
+static void __exit des3_ede_x86_fini(void)
+{
+	crypto_unregister_algs(des3_ede_algs, ARRAY_SIZE(des3_ede_algs));
+}
+
+module_init(des3_ede_x86_init);
+module_exit(des3_ede_x86_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Triple DES EDE Cipher Algorithm, asm optimized");
+MODULE_ALIAS("des3_ede");
+MODULE_ALIAS("des3_ede-asm");
+MODULE_ALIAS("des");
+MODULE_ALIAS("des-asm");
+MODULE_AUTHOR("Jussi Kivilinna <jussi.kivilinna@iki.fi>");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index ce4012a..b6036bf 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1019,6 +1019,19 @@ config CRYPTO_DES_SPARC64
 	  DES cipher algorithm (FIPS 46-2), and Triple DES EDE (FIPS 46-3),
 	  optimized using SPARC64 crypto opcodes.
=20
+config CRYPTO_DES3_EDE_X86_64
+	tristate "Triple DES EDE cipher algorithm (x86-64)"
+	depends on X86 && 64BIT
+	select CRYPTO_ALGAPI
+	select CRYPTO_DES
+	help
+	  Triple DES EDE (FIPS 46-3) algorithm.
+
+	  This module provides implementation of the Triple DES EDE cipher
+	  algorithm that is optimized for x86-64 processors. Two versions of
+	  algorithm are provided; regular processing one input block and
+	  one that processes three blocks parallel.
+
 config CRYPTO_FCRYPT
 	tristate "FCrypt cipher algorithm"
 	select CRYPTO_ALGAPI
diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index f6cf63f..298d464 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -859,13 +859,10 @@ static void des_decrypt(struct crypto_tfm *tfm, u=
8 *dst, const u8 *src)
  *   property.
  *
  */
-static int des3_ede_setkey(struct crypto_tfm *tfm, const u8 *key,
-			   unsigned int keylen)
+int __des3_ede_setkey(u32 *expkey, u32 *flags, const u8 *key,
+		      unsigned int keylen)
 {
 	const u32 *K =3D (const u32 *)key;
-	struct des3_ede_ctx *dctx =3D crypto_tfm_ctx(tfm);
-	u32 *expkey =3D dctx->expkey;
-	u32 *flags =3D &tfm->crt_flags;
=20
 	if (unlikely(!((K[0] ^ K[2]) | (K[1] ^ K[3])) ||
 		     !((K[2] ^ K[4]) | (K[3] ^ K[5]))) &&
@@ -880,6 +877,17 @@ static int des3_ede_setkey(struct crypto_tfm *tfm,=
 const u8 *key,
=20
 	return 0;
 }
+EXPORT_SYMBOL_GPL(__des3_ede_setkey);
+
+static int des3_ede_setkey(struct crypto_tfm *tfm, const u8 *key,
+			   unsigned int keylen)
+{
+	struct des3_ede_ctx *dctx =3D crypto_tfm_ctx(tfm);
+	u32 *flags =3D &tfm->crt_flags;
+	u32 *expkey =3D dctx->expkey;
+
+	return __des3_ede_setkey(expkey, flags, key, keylen);
+}
=20
 static void des3_ede_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8=
 *src)
 {
@@ -945,6 +953,8 @@ static void des3_ede_decrypt(struct crypto_tfm *tfm=
, u8 *dst, const u8 *src)
=20
 static struct crypto_alg des_algs[2] =3D { {
 	.cra_name		=3D	"des",
+	.cra_driver_name	=3D	"des-generic",
+	.cra_priority		=3D	100,
 	.cra_flags		=3D	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=3D	DES_BLOCK_SIZE,
 	.cra_ctxsize		=3D	sizeof(struct des_ctx),
@@ -958,6 +968,8 @@ static struct crypto_alg des_algs[2] =3D { {
 	.cia_decrypt		=3D	des_decrypt } }
 }, {
 	.cra_name		=3D	"des3_ede",
+	.cra_driver_name	=3D	"des3_ede-generic",
+	.cra_priority		=3D	100,
 	.cra_flags		=3D	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=3D	DES3_EDE_BLOCK_SIZE,
 	.cra_ctxsize		=3D	sizeof(struct des3_ede_ctx),
diff --git a/include/crypto/des.h b/include/crypto/des.h
index 2971c63..fc6274c 100644
--- a/include/crypto/des.h
+++ b/include/crypto/des.h
@@ -16,4 +16,7 @@
=20
 extern unsigned long des_ekey(u32 *pe, const u8 *k);
=20
+extern int __des3_ede_setkey(u32 *expkey, u32 *flags, const u8 *key,
+			     unsigned int keylen);
+
 #endif /* __CRYPTO_DES_H */
