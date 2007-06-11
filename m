From: Benjamin Gilbert <bgilbert@cs.cmu.edu>
Subject: [PATCH] [CRYPTO] Add optimized SHA-1 implementation for x86_64
Date: Mon, 11 Jun 2007 15:52:35 -0400
Message-ID: <20070611195235.25087.90810.stgit@dev>
References: <466DA6DF.1080403@cs.cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: akpm@linux-foundation.org, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: jengelh@computergmbh.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from CHOKECHERRY.SRV.CS.CMU.EDU ([128.2.185.41]:53992 "EHLO
	chokecherry.srv.cs.cmu.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752133AbXFKTwn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Jun 2007 15:52:43 -0400
In-Reply-To: <466DA6DF.1080403@cs.cmu.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add optimized implementation of the SHA-1 hash function for x86_64, por=
ted
from the x86 implementation in Nettle (which is LGPLed).

The code has been tested with tcrypt and the NIST test vectors.

Signed-off-by: Benjamin Gilbert <bgilbert@cs.cmu.edu>
---

 arch/x86_64/kernel/x8664_ksyms.c |    3=20
 arch/x86_64/lib/Makefile         |    2=20
 arch/x86_64/lib/sha1.S           |  281 ++++++++++++++++++++++++++++++=
++++++++
 include/linux/cryptohash.h       |    2=20
 lib/Kconfig                      |    7 +
 5 files changed, 293 insertions(+), 2 deletions(-)

diff --git a/arch/x86_64/kernel/x8664_ksyms.c b/arch/x86_64/kernel/x866=
4_ksyms.c
index 77c25b3..bc641ab 100644
--- a/arch/x86_64/kernel/x8664_ksyms.c
+++ b/arch/x86_64/kernel/x8664_ksyms.c
@@ -3,6 +3,7 @@
=20
 #include <linux/module.h>
 #include <linux/smp.h>
+#include <linux/cryptohash.h>
=20
 #include <asm/semaphore.h>
 #include <asm/processor.h>
@@ -60,3 +61,5 @@ EXPORT_SYMBOL(init_level4_pgt);
 EXPORT_SYMBOL(load_gs_index);
=20
 EXPORT_SYMBOL(_proxy_pda);
+
+EXPORT_SYMBOL(sha_transform);
diff --git a/arch/x86_64/lib/Makefile b/arch/x86_64/lib/Makefile
index c943271..6c8110b 100644
--- a/arch/x86_64/lib/Makefile
+++ b/arch/x86_64/lib/Makefile
@@ -9,5 +9,5 @@ obj-$(CONFIG_SMP)	+=3D msr-on-cpu.o
=20
 lib-y :=3D csum-partial.o csum-copy.o csum-wrappers.o delay.o \
 	usercopy.o getuser.o putuser.o  \
-	thunk.o clear_page.o copy_page.o bitstr.o bitops.o
+	thunk.o clear_page.o copy_page.o bitstr.o bitops.o sha1.o
 lib-y +=3D memcpy.o memmove.o memset.o copy_user.o rwlock.o copy_user_=
nocache.o
diff --git a/arch/x86_64/lib/sha1.S b/arch/x86_64/lib/sha1.S
new file mode 100644
index 0000000..f928ac3
--- /dev/null
+++ b/arch/x86_64/lib/sha1.S
@@ -0,0 +1,281 @@
+/*
+ * sha1-x86_64 - x86_64-optimized SHA1 hash algorithm
+ *
+ * Originally from Nettle
+ * Ported from M4 to cpp by Benjamin Gilbert <bgilbert@cs.cmu.edu>
+ * Ported from x86 to x86_64 by Benjamin Gilbert
+ *
+ * Copyright (C) 2004, Niels M=C3=B6ller
+ * Copyright (C) 2006-2007 Carnegie Mellon University
+ *
+ * This library is free software; you can redistribute it and/or modif=
y it
+ * under the terms of version 2.1 of the GNU Lesser General Public Lic=
ense as
+ * published by the Free Software Foundation.  A copy of the GNU Lesse=
r General
+ * Public License should have been distributed along with this library=
 in the
+ * file LICENSE.LGPL.
+ *
+ * This library is distributed in the hope that it will be useful, but=
 WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY =
or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Publi=
c License
+ * for more details.
+ */
+
+#include <linux/linkage.h>
+#include <asm/dwarf2.h>
+
+/* Register usage.  r12-15 must be saved if they will be used.  Access=
ing
+   r8-r15 takes an extra instruction byte. */
+#define P_STATE	%rdi			/* Pointer parameter */
+#define P_DATA	%rsi			/* Pointer parameter */
+#define DATA	%rdx			/* Pointer parameter */
+#define SA	%edi			/* Reuses P_STATE */
+#define SB	%esi			/* Reuses P_DATA */
+#define SC	%eax
+#define SD	%ebx			/* Callee-saved */
+#define SE	%ebp			/* Callee-saved */
+#define TMP	%ecx
+#define TMP2	%r8d			/* Used by F3 */
+#define CONST	%r9d
+#define STATE	%r10
+
+/* Constants */
+#define K1VALUE	$0x5A827999		/* Rounds  0-19 */
+#define K2VALUE	$0x6ED9EBA1		/* Rounds 20-39 */
+#define K3VALUE	$0x8F1BBCDC		/* Rounds 40-59 */
+#define K4VALUE	$0xCA62C1D6		/* Rounds 60-79 */
+
+/* Convert stack offsets in 32-bit words to offsets in bytes */
+#define OFFSET(i) 4*(i)
+
+/* Reads the input via P_DATA into register, byteswaps it, and stores =
it in
+   the DATA array. */
+#define SWAP(index, register)					\
+	movl	OFFSET(index)(P_DATA), register;		\
+	bswap	register;					\
+	movl	register, OFFSET(index)(DATA)
+
+/* push/pop wrappers that update the DWARF unwind table */
+#define PUSH(regname)						\
+	push			%regname;			\
+	CFI_ADJUST_CFA_OFFSET	8;				\
+	CFI_REL_OFFSET		regname, 0
+
+#define POP(regname)						\
+	pop			%regname;			\
+	CFI_ADJUST_CFA_OFFSET	-8;				\
+	CFI_RESTORE		regname
+
+/*
+ * expand(i) is the expansion function
+ *
+ *   W[i] =3D (W[i - 16] ^ W[i - 14] ^ W[i - 8] ^ W[i - 3]) <<< 1
+ *
+ * where W[i] is stored in DATA[i mod 16].
+ *
+ * Result is stored back in W[i], and also left in TMP, the only
+ * register that is used.
+ */
+#define EXPAND(i)						\
+	movl	OFFSET(i % 16)(DATA), TMP;			\
+	xorl	OFFSET((i + 2) % 16)(DATA), TMP;		\
+	xorl	OFFSET((i + 8) % 16)(DATA), TMP;		\
+	xorl	OFFSET((i + 13) % 16)(DATA), TMP;		\
+	roll	$1, TMP;					\
+	movl	TMP, OFFSET(i % 16)(DATA)
+
+/*
+ * The f functions,
+ *
+ *  f1(x,y,z) =3D z ^ (x & (y ^ z))
+ *  f2(x,y,z) =3D x ^ y ^ z
+ *  f3(x,y,z) =3D (x & y) | (z & (x | y))
+ *  f4 =3D f2
+ *
+ * The macro Fk(x,y,z) computes =3D fk(x,y,z).
+ * Result is left in TMP.
+ */
+#define F1(x,y,z)						\
+	movl	z, TMP;						\
+	xorl	y, TMP;						\
+	andl	x, TMP;						\
+	xorl	z, TMP
+
+#define F2(x,y,z)						\
+	movl	x, TMP;						\
+	xorl	y, TMP;						\
+	xorl	z, TMP
+
+#define F3(x,y,z)						\
+	movl	x, TMP2;					\
+	andl	y, TMP2;					\
+	movl	x, TMP;						\
+	orl	y, TMP;						\
+	andl	z, TMP;						\
+	orl	TMP2, TMP
+
+/*
+ * The form of one sha1 round is
+ *
+ *   a' =3D e + a <<< 5 + f( b, c, d ) + k + w;
+ *   b' =3D a;
+ *   c' =3D b <<< 30;
+ *   d' =3D c;
+ *   e' =3D d;
+ *
+ * where <<< denotes rotation. We permute our variables, so that we
+ * instead get
+ *
+ *   e +=3D a <<< 5 + f( b, c, d ) + k + w;
+ *   b <<<=3D 30
+ *
+ * k is not an explicit parameter; it's always stored in CONST.
+ *
+ * Using the TMP register for the rotate could be avoided, by rotating
+ * %a in place, adding, and then rotating back.
+ */
+#define ROUND(a,b,c,d,e,f,w)					\
+	addl	CONST, e;					\
+	addl	w, e;						\
+	f(b,c,d);						\
+	addl	TMP, e;						\
+	movl	a, TMP;						\
+	roll	$5, TMP;					\
+	addl	TMP, e;						\
+	roll	$30, b;
+
+/* sha_transform(__u32 *digest, const char *in, __u32 *W) */
+/* We expect a 64-byte workspace. */
+.text
+ENTRY(sha_transform)
+	CFI_STARTPROC
+	PUSH(rbx)
+	PUSH(rbp)
+
+	/* Load and byteswap data */
+	SWAP( 0,  %eax); SWAP( 1,  %ebx); SWAP( 2,  %ecx); SWAP( 3,  %ebp)
+	SWAP( 4,  %r8d); SWAP( 5,  %r9d); SWAP( 6, %r10d); SWAP( 7, %r11d)
+	SWAP( 8,  %eax); SWAP( 9,  %ebx); SWAP(10,  %ecx); SWAP(11,  %ebp)
+	SWAP(12,  %r8d); SWAP(13,  %r9d); SWAP(14, %r10d); SWAP(15, %r11d)
+
+	/* P_DATA now dead; free up P_STATE for other uses */
+	movq	P_STATE, STATE
+
+	/* load the state vector */
+	movl	(STATE),   SA
+	movl	4(STATE),  SB
+	movl	8(STATE),  SC
+	movl	12(STATE), SD
+	movl	16(STATE), SE
+
+	movl	K1VALUE, CONST
+	ROUND(SA, SB, SC, SD, SE, F1, OFFSET( 0)(DATA))
+	ROUND(SE, SA, SB, SC, SD, F1, OFFSET( 1)(DATA))
+	ROUND(SD, SE, SA, SB, SC, F1, OFFSET( 2)(DATA))
+	ROUND(SC, SD, SE, SA, SB, F1, OFFSET( 3)(DATA))
+	ROUND(SB, SC, SD, SE, SA, F1, OFFSET( 4)(DATA))
+
+	ROUND(SA, SB, SC, SD, SE, F1, OFFSET( 5)(DATA))
+	ROUND(SE, SA, SB, SC, SD, F1, OFFSET( 6)(DATA))
+	ROUND(SD, SE, SA, SB, SC, F1, OFFSET( 7)(DATA))
+	ROUND(SC, SD, SE, SA, SB, F1, OFFSET( 8)(DATA))
+	ROUND(SB, SC, SD, SE, SA, F1, OFFSET( 9)(DATA))
+
+	ROUND(SA, SB, SC, SD, SE, F1, OFFSET(10)(DATA))
+	ROUND(SE, SA, SB, SC, SD, F1, OFFSET(11)(DATA))
+	ROUND(SD, SE, SA, SB, SC, F1, OFFSET(12)(DATA))
+	ROUND(SC, SD, SE, SA, SB, F1, OFFSET(13)(DATA))
+	ROUND(SB, SC, SD, SE, SA, F1, OFFSET(14)(DATA))
+
+	ROUND(SA, SB, SC, SD, SE, F1, OFFSET(15)(DATA))
+	EXPAND(16); ROUND(SE, SA, SB, SC, SD, F1, TMP)
+	EXPAND(17); ROUND(SD, SE, SA, SB, SC, F1, TMP)
+	EXPAND(18); ROUND(SC, SD, SE, SA, SB, F1, TMP)
+	EXPAND(19); ROUND(SB, SC, SD, SE, SA, F1, TMP)
+
+	movl	K2VALUE, CONST
+	EXPAND(20); ROUND(SA, SB, SC, SD, SE, F2, TMP)
+	EXPAND(21); ROUND(SE, SA, SB, SC, SD, F2, TMP)
+	EXPAND(22); ROUND(SD, SE, SA, SB, SC, F2, TMP)
+	EXPAND(23); ROUND(SC, SD, SE, SA, SB, F2, TMP)
+	EXPAND(24); ROUND(SB, SC, SD, SE, SA, F2, TMP)
+
+	EXPAND(25); ROUND(SA, SB, SC, SD, SE, F2, TMP)
+	EXPAND(26); ROUND(SE, SA, SB, SC, SD, F2, TMP)
+	EXPAND(27); ROUND(SD, SE, SA, SB, SC, F2, TMP)
+	EXPAND(28); ROUND(SC, SD, SE, SA, SB, F2, TMP)
+	EXPAND(29); ROUND(SB, SC, SD, SE, SA, F2, TMP)
+
+	EXPAND(30); ROUND(SA, SB, SC, SD, SE, F2, TMP)
+	EXPAND(31); ROUND(SE, SA, SB, SC, SD, F2, TMP)
+	EXPAND(32); ROUND(SD, SE, SA, SB, SC, F2, TMP)
+	EXPAND(33); ROUND(SC, SD, SE, SA, SB, F2, TMP)
+	EXPAND(34); ROUND(SB, SC, SD, SE, SA, F2, TMP)
+
+	EXPAND(35); ROUND(SA, SB, SC, SD, SE, F2, TMP)
+	EXPAND(36); ROUND(SE, SA, SB, SC, SD, F2, TMP)
+	EXPAND(37); ROUND(SD, SE, SA, SB, SC, F2, TMP)
+	EXPAND(38); ROUND(SC, SD, SE, SA, SB, F2, TMP)
+	EXPAND(39); ROUND(SB, SC, SD, SE, SA, F2, TMP)
+
+	movl	K3VALUE, CONST
+	EXPAND(40); ROUND(SA, SB, SC, SD, SE, F3, TMP)
+	EXPAND(41); ROUND(SE, SA, SB, SC, SD, F3, TMP)
+	EXPAND(42); ROUND(SD, SE, SA, SB, SC, F3, TMP)
+	EXPAND(43); ROUND(SC, SD, SE, SA, SB, F3, TMP)
+	EXPAND(44); ROUND(SB, SC, SD, SE, SA, F3, TMP)
+
+	EXPAND(45); ROUND(SA, SB, SC, SD, SE, F3, TMP)
+	EXPAND(46); ROUND(SE, SA, SB, SC, SD, F3, TMP)
+	EXPAND(47); ROUND(SD, SE, SA, SB, SC, F3, TMP)
+	EXPAND(48); ROUND(SC, SD, SE, SA, SB, F3, TMP)
+	EXPAND(49); ROUND(SB, SC, SD, SE, SA, F3, TMP)
+
+	EXPAND(50); ROUND(SA, SB, SC, SD, SE, F3, TMP)
+	EXPAND(51); ROUND(SE, SA, SB, SC, SD, F3, TMP)
+	EXPAND(52); ROUND(SD, SE, SA, SB, SC, F3, TMP)
+	EXPAND(53); ROUND(SC, SD, SE, SA, SB, F3, TMP)
+	EXPAND(54); ROUND(SB, SC, SD, SE, SA, F3, TMP)
+
+	EXPAND(55); ROUND(SA, SB, SC, SD, SE, F3, TMP)
+	EXPAND(56); ROUND(SE, SA, SB, SC, SD, F3, TMP)
+	EXPAND(57); ROUND(SD, SE, SA, SB, SC, F3, TMP)
+	EXPAND(58); ROUND(SC, SD, SE, SA, SB, F3, TMP)
+	EXPAND(59); ROUND(SB, SC, SD, SE, SA, F3, TMP)
+
+	movl	K4VALUE, CONST
+	EXPAND(60); ROUND(SA, SB, SC, SD, SE, F2, TMP)
+	EXPAND(61); ROUND(SE, SA, SB, SC, SD, F2, TMP)
+	EXPAND(62); ROUND(SD, SE, SA, SB, SC, F2, TMP)
+	EXPAND(63); ROUND(SC, SD, SE, SA, SB, F2, TMP)
+	EXPAND(64); ROUND(SB, SC, SD, SE, SA, F2, TMP)
+
+	EXPAND(65); ROUND(SA, SB, SC, SD, SE, F2, TMP)
+	EXPAND(66); ROUND(SE, SA, SB, SC, SD, F2, TMP)
+	EXPAND(67); ROUND(SD, SE, SA, SB, SC, F2, TMP)
+	EXPAND(68); ROUND(SC, SD, SE, SA, SB, F2, TMP)
+	EXPAND(69); ROUND(SB, SC, SD, SE, SA, F2, TMP)
+
+	EXPAND(70); ROUND(SA, SB, SC, SD, SE, F2, TMP)
+	EXPAND(71); ROUND(SE, SA, SB, SC, SD, F2, TMP)
+	EXPAND(72); ROUND(SD, SE, SA, SB, SC, F2, TMP)
+	EXPAND(73); ROUND(SC, SD, SE, SA, SB, F2, TMP)
+	EXPAND(74); ROUND(SB, SC, SD, SE, SA, F2, TMP)
+
+	EXPAND(75); ROUND(SA, SB, SC, SD, SE, F2, TMP)
+	EXPAND(76); ROUND(SE, SA, SB, SC, SD, F2, TMP)
+	EXPAND(77); ROUND(SD, SE, SA, SB, SC, F2, TMP)
+	EXPAND(78); ROUND(SC, SD, SE, SA, SB, F2, TMP)
+	EXPAND(79); ROUND(SB, SC, SD, SE, SA, F2, TMP)
+
+	/* Update the state vector */
+	addl	SA, (STATE)
+	addl	SB, 4(STATE)
+	addl	SC, 8(STATE)
+	addl	SD, 12(STATE)
+	addl	SE, 16(STATE)
+
+	POP(rbp)
+	POP(rbx)
+	ret
+	CFI_ENDPROC
+ENDPROC(sha_transform)
diff --git a/include/linux/cryptohash.h b/include/linux/cryptohash.h
index 0da331c..b3b14a3 100644
--- a/include/linux/cryptohash.h
+++ b/include/linux/cryptohash.h
@@ -7,6 +7,8 @@
=20
 #if defined(CONFIG_SHA1_X86)
 #define SHA_WORKSPACE_WORDS 0
+#elif defined(CONFIG_SHA1_X86_64)
+#define SHA_WORKSPACE_WORDS 16
 #else
 #define SHA_WORKSPACE_WORDS 80
 #endif
diff --git a/lib/Kconfig b/lib/Kconfig
index 69fdb64..23a84ed 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -132,9 +132,14 @@ config SHA1_X86
 	depends on (X86 || UML_X86) && !64BIT && X86_BSWAP
 	default y
=20
+config SHA1_X86_64
+	bool
+	depends on (X86 || UML_X86) && 64BIT
+	default y
+
 config SHA1_GENERIC
 	bool
-	depends on !SHA1_X86
+	depends on !SHA1_X86 && !SHA1_X86_64
 	default y
=20
 endmenu
