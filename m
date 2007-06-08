From: Benjamin Gilbert <bgilbert@cs.cmu.edu>
Subject: [PATCH 2/3] [CRYPTO] Add optimized SHA-1 implementation for i486+
Date: Fri, 08 Jun 2007 17:42:53 -0400
Message-ID: <20070608214253.23949.40465.stgit@dev>
References: <20070608214242.23949.30350.stgit@dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: akpm@linux-foundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from CHOKECHERRY.SRV.CS.CMU.EDU ([128.2.185.41]:48429 "EHLO
	chokecherry.srv.cs.cmu.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970679AbXFHW2g (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Jun 2007 18:28:36 -0400
In-Reply-To: <20070608214242.23949.30350.stgit@dev>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add x86-optimized implementation of the SHA-1 hash function, taken from
Nettle under the LGPL.  This code will be enabled on kernels compiled f=
or
486es or better; kernels which support 386es will use the generic
implementation (since we need BSWAP).

We disable building lib/sha1.o when an optimized implementation is
available, as the library link order for x86 (and x86_64) would otherwi=
se
ignore the optimized version.  The existing optimized implementation fo=
r ARM
does not do this; the library link order for that architecture appears =
to
favor the arch/arm/ version automatically.  I've left this situation al=
one
since I'm not familiar with the ARM code, but a !ARM condition could be
added to CONFIG_SHA1_GENERIC if it makes sense.

The code has been tested with tcrypt and the NIST test vectors.

Signed-off-by: Benjamin Gilbert <bgilbert@cs.cmu.edu>
---

 arch/i386/kernel/i386_ksyms.c |    5 +
 arch/i386/lib/Makefile        |    1=20
 arch/i386/lib/sha1.S          |  299 +++++++++++++++++++++++++++++++++=
++++++++
 include/linux/cryptohash.h    |    9 +
 lib/Kconfig                   |   13 ++
 lib/Makefile                  |    3=20
 6 files changed, 328 insertions(+), 2 deletions(-)

diff --git a/arch/i386/kernel/i386_ksyms.c b/arch/i386/kernel/i386_ksym=
s.c
index e3d4b73..812bc4e 100644
--- a/arch/i386/kernel/i386_ksyms.c
+++ b/arch/i386/kernel/i386_ksyms.c
@@ -1,4 +1,5 @@
 #include <linux/module.h>
+#include <linux/cryptohash.h>
 #include <asm/checksum.h>
 #include <asm/desc.h>
=20
@@ -28,3 +29,7 @@ EXPORT_SYMBOL(__read_lock_failed);
 #endif
=20
 EXPORT_SYMBOL(csum_partial);
+
+#ifdef CONFIG_SHA1_X86
+EXPORT_SYMBOL(sha_transform);
+#endif
diff --git a/arch/i386/lib/Makefile b/arch/i386/lib/Makefile
index 22d8ac5..69f4845 100644
--- a/arch/i386/lib/Makefile
+++ b/arch/i386/lib/Makefile
@@ -6,6 +6,7 @@
 lib-y =3D checksum.o delay.o usercopy.o getuser.o putuser.o memcpy.o s=
trstr.o \
 	bitops.o semaphore.o
=20
+lib-$(CONFIG_SHA1_X86) +=3D sha1.o
 lib-$(CONFIG_X86_USE_3DNOW) +=3D mmx.o
=20
 obj-$(CONFIG_SMP)	+=3D msr-on-cpu.o
diff --git a/arch/i386/lib/sha1.S b/arch/i386/lib/sha1.S
new file mode 100644
index 0000000..28aa4b7
--- /dev/null
+++ b/arch/i386/lib/sha1.S
@@ -0,0 +1,299 @@
+/*
+ * x86-optimized SHA1 hash algorithm (i486 and above)
+ *
+ * Originally from Nettle
+ * Ported from M4 to cpp by Benjamin Gilbert <bgilbert@cs.cmu.edu>
+ *
+ * Copyright (C) 2004, Niels M=F6ller
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
+/* Register usage */
+#define SA	%eax
+#define SB	%ebx
+#define SC	%ecx
+#define SD	%edx
+#define SE	%ebp
+#define DATA	%esp
+#define TMP	%edi
+#define TMP2	%esi			/* Used by SWAP and F3 */
+#define TMP3	64(%esp)
+
+/* Constants */
+#define K1VALUE	$0x5A827999		/* Rounds  0-19 */
+#define K2VALUE	$0x6ED9EBA1		/* Rounds 20-39 */
+#define K3VALUE	$0x8F1BBCDC		/* Rounds 40-59 */
+#define K4VALUE	$0xCA62C1D6		/* Rounds 60-79 */
+
+/* Convert stack offsets in words to offsets in bytes */
+#define OFFSET(i) 4*(i)
+
+/* Reads the input via TMP2 into register, byteswaps it, and stores it=
 in
+   the DATA array. */
+#define SWAP(index, register)					\
+	movl	OFFSET(index)(TMP2), register;			\
+	bswap	register;					\
+	movl	register, OFFSET(index)(DATA)
+
+/* Sets the workspace word at the given index to TMP. */
+#define CLEAR(index)						\
+	movl	TMP, OFFSET(index)(DATA)
+
+/* pushl/popl wrappers that update the DWARF unwind table */
+#define PUSH(regname)						\
+	pushl			%regname;			\
+	CFI_ADJUST_CFA_OFFSET	4;				\
+	CFI_REL_OFFSET		regname, 0
+
+#define POP(regname)						\
+	popl			%regname;			\
+	CFI_ADJUST_CFA_OFFSET	-4;				\
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
+ * Using the TMP register for the rotate could be avoided, by rotating
+ * %a in place, adding, and then rotating back.
+ */
+#define ROUND(a,b,c,d,e,f,k,w)					\
+	addl	k, e;						\
+	addl	w, e;						\
+	f(b,c,d);						\
+	addl	TMP, e;						\
+	movl	a, TMP;						\
+	roll	$5, TMP;					\
+	addl	TMP, e;						\
+	roll	$30, b;
+
+/* sha_transform(__u32 *digest, const char *in, __u32 *W) */
+/* The workspace argument is ignored; we don't have enough registers t=
o handle
+   a workspace that isn't on our own stack. */
+.text
+ENTRY(sha_transform)
+	CFI_STARTPROC
+	/* save all registers that need to be saved */
+	PUSH(ebx)		/* 80(%esp) */
+	PUSH(ebp)		/* 76(%esp) */
+	PUSH(esi)		/* 72(%esp) */
+	PUSH(edi)		/* 68(%esp) */
+
+	subl	$68, %esp	/* %esp =3D W */
+	CFI_ADJUST_CFA_OFFSET	68
+
+	/* Load and byteswap data */
+	movl	92(%esp), TMP2
+
+	SWAP( 0, %eax); SWAP( 1, %ebx); SWAP( 2, %ecx); SWAP( 3, %edx)
+	SWAP( 4, %eax); SWAP( 5, %ebx); SWAP( 6, %ecx); SWAP( 7, %edx)
+	SWAP( 8, %eax); SWAP( 9, %ebx); SWAP(10, %ecx); SWAP(11, %edx)
+	SWAP(12, %eax); SWAP(13, %ebx); SWAP(14, %ecx); SWAP(15, %edx)
+
+	/* load the state vector */
+	movl	88(%esp),TMP
+	movl	(TMP),   SA
+	movl	4(TMP),  SB
+	movl	8(TMP),  SC
+	movl	12(TMP), SD
+	movl	16(TMP), SE
+
+	movl	K1VALUE, TMP2
+	ROUND(SA, SB, SC, SD, SE, F1, TMP2, OFFSET( 0)(DATA))
+	ROUND(SE, SA, SB, SC, SD, F1, TMP2, OFFSET( 1)(DATA))
+	ROUND(SD, SE, SA, SB, SC, F1, TMP2, OFFSET( 2)(DATA))
+	ROUND(SC, SD, SE, SA, SB, F1, TMP2, OFFSET( 3)(DATA))
+	ROUND(SB, SC, SD, SE, SA, F1, TMP2, OFFSET( 4)(DATA))
+
+	ROUND(SA, SB, SC, SD, SE, F1, TMP2, OFFSET( 5)(DATA))
+	ROUND(SE, SA, SB, SC, SD, F1, TMP2, OFFSET( 6)(DATA))
+	ROUND(SD, SE, SA, SB, SC, F1, TMP2, OFFSET( 7)(DATA))
+	ROUND(SC, SD, SE, SA, SB, F1, TMP2, OFFSET( 8)(DATA))
+	ROUND(SB, SC, SD, SE, SA, F1, TMP2, OFFSET( 9)(DATA))
+
+	ROUND(SA, SB, SC, SD, SE, F1, TMP2, OFFSET(10)(DATA))
+	ROUND(SE, SA, SB, SC, SD, F1, TMP2, OFFSET(11)(DATA))
+	ROUND(SD, SE, SA, SB, SC, F1, TMP2, OFFSET(12)(DATA))
+	ROUND(SC, SD, SE, SA, SB, F1, TMP2, OFFSET(13)(DATA))
+	ROUND(SB, SC, SD, SE, SA, F1, TMP2, OFFSET(14)(DATA))
+
+	ROUND(SA, SB, SC, SD, SE, F1, TMP2, OFFSET(15)(DATA))
+	EXPAND(16); ROUND(SE, SA, SB, SC, SD, F1, TMP2, TMP)
+	EXPAND(17); ROUND(SD, SE, SA, SB, SC, F1, TMP2, TMP)
+	EXPAND(18); ROUND(SC, SD, SE, SA, SB, F1, TMP2, TMP)
+	EXPAND(19); ROUND(SB, SC, SD, SE, SA, F1, TMP2, TMP)
+
+	/* TMP2 is free to use in these rounds */
+	movl	K2VALUE, TMP2
+	EXPAND(20); ROUND(SA, SB, SC, SD, SE, F2, TMP2, TMP)
+	EXPAND(21); ROUND(SE, SA, SB, SC, SD, F2, TMP2, TMP)
+	EXPAND(22); ROUND(SD, SE, SA, SB, SC, F2, TMP2, TMP)
+	EXPAND(23); ROUND(SC, SD, SE, SA, SB, F2, TMP2, TMP)
+	EXPAND(24); ROUND(SB, SC, SD, SE, SA, F2, TMP2, TMP)
+
+	EXPAND(25); ROUND(SA, SB, SC, SD, SE, F2, TMP2, TMP)
+	EXPAND(26); ROUND(SE, SA, SB, SC, SD, F2, TMP2, TMP)
+	EXPAND(27); ROUND(SD, SE, SA, SB, SC, F2, TMP2, TMP)
+	EXPAND(28); ROUND(SC, SD, SE, SA, SB, F2, TMP2, TMP)
+	EXPAND(29); ROUND(SB, SC, SD, SE, SA, F2, TMP2, TMP)
+
+	EXPAND(30); ROUND(SA, SB, SC, SD, SE, F2, TMP2, TMP)
+	EXPAND(31); ROUND(SE, SA, SB, SC, SD, F2, TMP2, TMP)
+	EXPAND(32); ROUND(SD, SE, SA, SB, SC, F2, TMP2, TMP)
+	EXPAND(33); ROUND(SC, SD, SE, SA, SB, F2, TMP2, TMP)
+	EXPAND(34); ROUND(SB, SC, SD, SE, SA, F2, TMP2, TMP)
+
+	EXPAND(35); ROUND(SA, SB, SC, SD, SE, F2, TMP2, TMP)
+	EXPAND(36); ROUND(SE, SA, SB, SC, SD, F2, TMP2, TMP)
+	EXPAND(37); ROUND(SD, SE, SA, SB, SC, F2, TMP2, TMP)
+	EXPAND(38); ROUND(SC, SD, SE, SA, SB, F2, TMP2, TMP)
+	EXPAND(39); ROUND(SB, SC, SD, SE, SA, F2, TMP2, TMP)
+
+	/* We have to put this constant on the stack */
+	movl	K3VALUE, TMP3
+	EXPAND(40); ROUND(SA, SB, SC, SD, SE, F3, TMP3, TMP)
+	EXPAND(41); ROUND(SE, SA, SB, SC, SD, F3, TMP3, TMP)
+	EXPAND(42); ROUND(SD, SE, SA, SB, SC, F3, TMP3, TMP)
+	EXPAND(43); ROUND(SC, SD, SE, SA, SB, F3, TMP3, TMP)
+	EXPAND(44); ROUND(SB, SC, SD, SE, SA, F3, TMP3, TMP)
+
+	EXPAND(45); ROUND(SA, SB, SC, SD, SE, F3, TMP3, TMP)
+	EXPAND(46); ROUND(SE, SA, SB, SC, SD, F3, TMP3, TMP)
+	EXPAND(47); ROUND(SD, SE, SA, SB, SC, F3, TMP3, TMP)
+	EXPAND(48); ROUND(SC, SD, SE, SA, SB, F3, TMP3, TMP)
+	EXPAND(49); ROUND(SB, SC, SD, SE, SA, F3, TMP3, TMP)
+
+	EXPAND(50); ROUND(SA, SB, SC, SD, SE, F3, TMP3, TMP)
+	EXPAND(51); ROUND(SE, SA, SB, SC, SD, F3, TMP3, TMP)
+	EXPAND(52); ROUND(SD, SE, SA, SB, SC, F3, TMP3, TMP)
+	EXPAND(53); ROUND(SC, SD, SE, SA, SB, F3, TMP3, TMP)
+	EXPAND(54); ROUND(SB, SC, SD, SE, SA, F3, TMP3, TMP)
+
+	EXPAND(55); ROUND(SA, SB, SC, SD, SE, F3, TMP3, TMP)
+	EXPAND(56); ROUND(SE, SA, SB, SC, SD, F3, TMP3, TMP)
+	EXPAND(57); ROUND(SD, SE, SA, SB, SC, F3, TMP3, TMP)
+	EXPAND(58); ROUND(SC, SD, SE, SA, SB, F3, TMP3, TMP)
+	EXPAND(59); ROUND(SB, SC, SD, SE, SA, F3, TMP3, TMP)
+
+	movl	K4VALUE, TMP2
+	EXPAND(60); ROUND(SA, SB, SC, SD, SE, F2, TMP2, TMP)
+	EXPAND(61); ROUND(SE, SA, SB, SC, SD, F2, TMP2, TMP)
+	EXPAND(62); ROUND(SD, SE, SA, SB, SC, F2, TMP2, TMP)
+	EXPAND(63); ROUND(SC, SD, SE, SA, SB, F2, TMP2, TMP)
+	EXPAND(64); ROUND(SB, SC, SD, SE, SA, F2, TMP2, TMP)
+
+	EXPAND(65); ROUND(SA, SB, SC, SD, SE, F2, TMP2, TMP)
+	EXPAND(66); ROUND(SE, SA, SB, SC, SD, F2, TMP2, TMP)
+	EXPAND(67); ROUND(SD, SE, SA, SB, SC, F2, TMP2, TMP)
+	EXPAND(68); ROUND(SC, SD, SE, SA, SB, F2, TMP2, TMP)
+	EXPAND(69); ROUND(SB, SC, SD, SE, SA, F2, TMP2, TMP)
+
+	EXPAND(70); ROUND(SA, SB, SC, SD, SE, F2, TMP2, TMP)
+	EXPAND(71); ROUND(SE, SA, SB, SC, SD, F2, TMP2, TMP)
+	EXPAND(72); ROUND(SD, SE, SA, SB, SC, F2, TMP2, TMP)
+	EXPAND(73); ROUND(SC, SD, SE, SA, SB, F2, TMP2, TMP)
+	EXPAND(74); ROUND(SB, SC, SD, SE, SA, F2, TMP2, TMP)
+
+	EXPAND(75); ROUND(SA, SB, SC, SD, SE, F2, TMP2, TMP)
+	EXPAND(76); ROUND(SE, SA, SB, SC, SD, F2, TMP2, TMP)
+	EXPAND(77); ROUND(SD, SE, SA, SB, SC, F2, TMP2, TMP)
+	EXPAND(78); ROUND(SC, SD, SE, SA, SB, F2, TMP2, TMP)
+	EXPAND(79); ROUND(SB, SC, SD, SE, SA, F2, TMP2, TMP)
+
+	/* Update the state vector */
+	movl	88(%esp),TMP
+	addl	SA, (TMP)
+	addl	SB, 4(TMP)
+	addl	SC, 8(TMP)
+	addl	SD, 12(TMP)
+	addl	SE, 16(TMP)
+
+	/* Clear the workspace for security */
+	xorl	TMP, TMP
+	CLEAR( 0); CLEAR( 1); CLEAR( 2); CLEAR( 3);
+	CLEAR( 4); CLEAR( 5); CLEAR( 6); CLEAR( 7);
+	CLEAR( 8); CLEAR( 9); CLEAR(10); CLEAR(11);
+	CLEAR(12); CLEAR(13); CLEAR(14); CLEAR(15);
+
+	addl	$68, %esp
+	CFI_ADJUST_CFA_OFFSET	-68
+	POP(edi)
+	POP(esi)
+	POP(ebp)
+	POP(ebx)
+	ret
+	CFI_ENDPROC
+ENDPROC(sha_transform)
diff --git a/include/linux/cryptohash.h b/include/linux/cryptohash.h
index a172401..0da331c 100644
--- a/include/linux/cryptohash.h
+++ b/include/linux/cryptohash.h
@@ -1,8 +1,15 @@
 #ifndef __CRYPTOHASH_H
 #define __CRYPTOHASH_H
=20
+#include <linux/linkage.h>
+
 #define SHA_DIGEST_WORDS 5
+
+#if defined(CONFIG_SHA1_X86)
+#define SHA_WORKSPACE_WORDS 0
+#else
 #define SHA_WORKSPACE_WORDS 80
+#endif
=20
 /**
  * sha_init - initialize the vectors for a SHA1 digest
@@ -17,7 +24,7 @@ static inline void sha_init(__u32 *buf)
 	buf[4] =3D 0xc3d2e1f0;
 }
=20
-void sha_transform(__u32 *digest, const char *data, __u32 *W);
+asmlinkage void sha_transform(__u32 *digest, const char *data, __u32 *=
W);
=20
 __u32 half_md4_transform(__u32 buf[4], __u32 const in[8]);
=20
diff --git a/lib/Kconfig b/lib/Kconfig
index 2e7ae6b..69fdb64 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -124,4 +124,17 @@ config HAS_DMA
 	depends on !NO_DMA
 	default y
=20
+#
+# Optimized SHA-1 support is autoconfigured
+#
+config SHA1_X86
+	bool
+	depends on (X86 || UML_X86) && !64BIT && X86_BSWAP
+	default y
+
+config SHA1_GENERIC
+	bool
+	depends on !SHA1_X86
+	default y
+
 endmenu
diff --git a/lib/Makefile b/lib/Makefile
index c8c8e20..f67be29 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -5,10 +5,11 @@
 lib-y :=3D ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o bitmap.o extable.o prio_tree.o \
-	 sha1.o irq_regs.o reciprocal_div.o
+	 irq_regs.o reciprocal_div.o
=20
 lib-$(CONFIG_MMU) +=3D ioremap.o
 lib-$(CONFIG_SMP) +=3D cpumask.o
+lib-$(CONFIG_SHA1_GENERIC) +=3D sha1.o
=20
 lib-y	+=3D kobject.o kref.o kobject_uevent.o klist.o
=20
