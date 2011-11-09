From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 1/4] [v2] crypto: serpent - add 8-way parallel x86_64/SSE2
 assembler implementation
Date: Wed, 09 Nov 2011 16:26:25 +0200
Message-ID: <20111109142625.23131.66808.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:46238 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab1KIO0d (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Nov 2011 09:26:33 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Patch adds x86_64/SSE2 assembler implementation of serpent cipher. Assembler
functions crypt data in eigth block chunks (two 4 block chunk SSE2 operations
in parallel to improve performance on out-of-order CPUs). Glue code is based
on one from AES-NI implementation, so requests from irq context are redirected
to cryptd.

v2:
 - add missing include of linux/module.h
   (appearently crypto.h used to include module.h, which changed for 3.2 by
    commit 7c926402a7e8c9b279968fd94efec8700ba3859e)

Patch has been tested with tcrypt and automated filesystem tests.

Tcrypt benchmarks results (serpent-sse2/serpent_generic speed ratios):

AMD Phenom II 1055T (fam:16, model:10):

size    ecb-enc ecb-dec cbc-enc cbc-dec ctr-enc ctr-dec
16B     1.03x   1.01x   1.03x   1.05x   1.00x   0.99x
64B     1.00x   1.01x   1.02x   1.04x   1.02x   1.01x
256B    2.34x   2.41x   0.99x   2.43x   2.39x   2.40x
1024B   2.51x   2.57x   1.00x   2.59x   2.56x   2.56x
8192B   2.50x   2.54x   1.00x   2.55x   2.57x   2.57x

Intel Celeron T1600 (fam:6, model:15, step:13):

size    ecb-enc ecb-dec cbc-enc cbc-dec ctr-enc ctr-dec
16B     0.97x   0.97x   1.01x   1.01x   1.01x   1.02x
64B     1.00x   1.00x   1.00x   1.02x   1.01x   1.01x
256B    3.41x   3.35x   1.00x   3.39x   3.42x   3.44x
1024B   3.75x   3.72x   0.99x   3.74x   3.75x   3.75x
8192B   3.70x   3.68x   0.99x   3.68x   3.69x   3.69x

Full output:
 http://koti.mbnet.fi/axh/kernel/crypto/phenom-ii-1055t/serpent-generic.txt
 http://koti.mbnet.fi/axh/kernel/crypto/phenom-ii-1055t/serpent-sse2.txt
 http://koti.mbnet.fi/axh/kernel/crypto/celeron-t1600/serpent-generic.txt
 http://koti.mbnet.fi/axh/kernel/crypto/celeron-t1600/serpent-sse2.txt

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/Makefile                     |    2 
 arch/x86/crypto/serpent-sse2-x86_64-asm_64.S |  761 ++++++++++++++++++++++++++
 arch/x86/crypto/serpent_sse2_glue.c          |  720 +++++++++++++++++++++++++
 arch/x86/include/asm/serpent.h               |   33 +
 crypto/Kconfig                               |   17 +
 crypto/testmgr.c                             |   60 ++
 6 files changed, 1593 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/crypto/serpent-sse2-x86_64-asm_64.S
 create mode 100644 arch/x86/crypto/serpent_sse2_glue.c
 create mode 100644 arch/x86/include/asm/serpent.h

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 3537d4b..12ebdbd 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_CRYPTO_BLOWFISH_X86_64) += blowfish-x86_64.o
 obj-$(CONFIG_CRYPTO_TWOFISH_X86_64) += twofish-x86_64.o
 obj-$(CONFIG_CRYPTO_TWOFISH_X86_64_3WAY) += twofish-x86_64-3way.o
 obj-$(CONFIG_CRYPTO_SALSA20_X86_64) += salsa20-x86_64.o
+obj-$(CONFIG_CRYPTO_SERPENT_SSE2_X86_64) += serpent-sse2-x86_64.o
 obj-$(CONFIG_CRYPTO_AES_NI_INTEL) += aesni-intel.o
 obj-$(CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL) += ghash-clmulni-intel.o
 
@@ -26,6 +27,7 @@ blowfish-x86_64-y := blowfish-x86_64-asm_64.o blowfish_glue.o
 twofish-x86_64-y := twofish-x86_64-asm_64.o twofish_glue.o
 twofish-x86_64-3way-y := twofish-x86_64-asm_64-3way.o twofish_glue_3way.o
 salsa20-x86_64-y := salsa20-x86_64-asm_64.o salsa20_glue.o
+serpent-sse2-x86_64-y := serpent-sse2-x86_64-asm_64.o serpent_sse2_glue.o
 
 aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o fpu.o
 
diff --git a/arch/x86/crypto/serpent-sse2-x86_64-asm_64.S b/arch/x86/crypto/serpent-sse2-x86_64-asm_64.S
new file mode 100644
index 0000000..7f24a15
--- /dev/null
+++ b/arch/x86/crypto/serpent-sse2-x86_64-asm_64.S
@@ -0,0 +1,761 @@
+/*
+ * Serpent Cipher 8-way parallel algorithm (x86_64/SSE2)
+ *
+ * Copyright (C) 2011 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ *
+ * Based on crypto/serpent.c by
+ *  Copyright (C) 2002 Dag Arne Osvik <osvik@ii.uib.no>
+ *                2003 Herbert Valerio Riedel <hvr@gnu.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
+ * USA
+ *
+ */
+
+.file "serpent-sse2-x86_64-asm_64.S"
+.text
+
+#define CTX %rdi
+
+/**********************************************************************
+  8-way SSE2 serpent
+ **********************************************************************/
+#define RA1 %xmm0
+#define RB1 %xmm1
+#define RC1 %xmm2
+#define RD1 %xmm3
+#define RE1 %xmm4
+
+#define RA2 %xmm5
+#define RB2 %xmm6
+#define RC2 %xmm7
+#define RD2 %xmm8
+#define RE2 %xmm9
+
+#define RNOT %xmm10
+
+#define RK0 %xmm11
+#define RK1 %xmm12
+#define RK2 %xmm13
+#define RK3 %xmm14
+
+#define S0_1(x0, x1, x2, x3, x4) \
+	movdqa x3,		x4; \
+	por x0,			x3; \
+	pxor x4,		x0; \
+	pxor x2,		x4; \
+	pxor RNOT,		x4; \
+	pxor x1,		x3; \
+	pand x0,		x1; \
+	pxor x4,		x1; \
+	pxor x0,		x2;
+#define S0_2(x0, x1, x2, x3, x4) \
+	pxor x3,		x0; \
+	por x0,			x4; \
+	pxor x2,		x0; \
+	pand x1,		x2; \
+	pxor x2,		x3; \
+	pxor RNOT,		x1; \
+	pxor x4,		x2; \
+	pxor x2,		x1;
+
+#define S1_1(x0, x1, x2, x3, x4) \
+	movdqa x1,		x4; \
+	pxor x0,		x1; \
+	pxor x3,		x0; \
+	pxor RNOT,		x3; \
+	pand x1,		x4; \
+	por x1,			x0; \
+	pxor x2,		x3; \
+	pxor x3,		x0; \
+	pxor x3,		x1;
+#define S1_2(x0, x1, x2, x3, x4) \
+	pxor x4,		x3; \
+	por x4,			x1; \
+	pxor x2,		x4; \
+	pand x0,		x2; \
+	pxor x1,		x2; \
+	por x0,			x1; \
+	pxor RNOT,		x0; \
+	pxor x2,		x0; \
+	pxor x1,		x4;
+
+#define S2_1(x0, x1, x2, x3, x4) \
+	pxor RNOT,		x3; \
+	pxor x0,		x1; \
+	movdqa x0,		x4; \
+	pand x2,		x0; \
+	pxor x3,		x0; \
+	por x4,			x3; \
+	pxor x1,		x2; \
+	pxor x1,		x3; \
+	pand x0,		x1;
+#define S2_2(x0, x1, x2, x3, x4) \
+	pxor x2,		x0; \
+	pand x3,		x2; \
+	por x1,			x3; \
+	pxor RNOT,		x0; \
+	pxor x0,		x3; \
+	pxor x0,		x4; \
+	pxor x2,		x0; \
+	por x2,			x1;
+
+#define S3_1(x0, x1, x2, x3, x4) \
+	movdqa x1,		x4; \
+	pxor x3,		x1; \
+	por x0,			x3; \
+	pand x0,		x4; \
+	pxor x2,		x0; \
+	pxor x1,		x2; \
+	pand x3,		x1; \
+	pxor x3,		x2; \
+	por x4,			x0; \
+	pxor x3,		x4;
+#define S3_2(x0, x1, x2, x3, x4) \
+	pxor x0,		x1; \
+	pand x3,		x0; \
+	pand x4,		x3; \
+	pxor x2,		x3; \
+	por x1,			x4; \
+	pand x1,		x2; \
+	pxor x3,		x4; \
+	pxor x3,		x0; \
+	pxor x2,		x3;
+
+#define S4_1(x0, x1, x2, x3, x4) \
+	movdqa x3,		x4; \
+	pand x0,		x3; \
+	pxor x4,		x0; \
+	pxor x2,		x3; \
+	por x4,			x2; \
+	pxor x1,		x0; \
+	pxor x3,		x4; \
+	por x0,			x2; \
+	pxor x1,		x2;
+#define S4_2(x0, x1, x2, x3, x4) \
+	pand x0,		x1; \
+	pxor x4,		x1; \
+	pand x2,		x4; \
+	pxor x3,		x2; \
+	pxor x0,		x4; \
+	por x1,			x3; \
+	pxor RNOT,		x1; \
+	pxor x0,		x3;
+
+#define S5_1(x0, x1, x2, x3, x4) \
+	movdqa x1,		x4; \
+	por x0,			x1; \
+	pxor x1,		x2; \
+	pxor RNOT,		x3; \
+	pxor x0,		x4; \
+	pxor x2,		x0; \
+	pand x4,		x1; \
+	por x3,			x4; \
+	pxor x0,		x4;
+#define S5_2(x0, x1, x2, x3, x4) \
+	pand x3,		x0; \
+	pxor x3,		x1; \
+	pxor x2,		x3; \
+	pxor x1,		x0; \
+	pand x4,		x2; \
+	pxor x2,		x1; \
+	pand x0,		x2; \
+	pxor x2,		x3;
+
+#define S6_1(x0, x1, x2, x3, x4) \
+	movdqa x1,		x4; \
+	pxor x0,		x3; \
+	pxor x2,		x1; \
+	pxor x0,		x2; \
+	pand x3,		x0; \
+	por x3,			x1; \
+	pxor RNOT,		x4; \
+	pxor x1,		x0; \
+	pxor x2,		x1;
+#define S6_2(x0, x1, x2, x3, x4) \
+	pxor x4,		x3; \
+	pxor x0,		x4; \
+	pand x0,		x2; \
+	pxor x1,		x4; \
+	pxor x3,		x2; \
+	pand x1,		x3; \
+	pxor x0,		x3; \
+	pxor x2,		x1;
+
+#define S7_1(x0, x1, x2, x3, x4) \
+	pxor RNOT,		x1; \
+	movdqa x1,		x4; \
+	pxor RNOT,		x0; \
+	pand x2,		x1; \
+	pxor x3,		x1; \
+	por x4,			x3; \
+	pxor x2,		x4; \
+	pxor x3,		x2; \
+	pxor x0,		x3; \
+	por x1,			x0;
+#define S7_2(x0, x1, x2, x3, x4) \
+	pand x0,		x2; \
+	pxor x4,		x0; \
+	pxor x3,		x4; \
+	pand x0,		x3; \
+	pxor x1,		x4; \
+	pxor x4,		x2; \
+	pxor x1,		x3; \
+	por x0,			x4; \
+	pxor x1,		x4;
+
+#define SI0_1(x0, x1, x2, x3, x4) \
+	movdqa x3,		x4; \
+	pxor x0,		x1; \
+	por x1,			x3; \
+	pxor x1,		x4; \
+	pxor RNOT,		x0; \
+	pxor x3,		x2; \
+	pxor x0,		x3; \
+	pand x1,		x0; \
+	pxor x2,		x0;
+#define SI0_2(x0, x1, x2, x3, x4) \
+	pand x3,		x2; \
+	pxor x4,		x3; \
+	pxor x3,		x2; \
+	pxor x3,		x1; \
+	pand x0,		x3; \
+	pxor x0,		x1; \
+	pxor x2,		x0; \
+	pxor x3,		x4;
+
+#define SI1_1(x0, x1, x2, x3, x4) \
+	pxor x3,		x1; \
+	movdqa x0,		x4; \
+	pxor x2,		x0; \
+	pxor RNOT,		x2; \
+	por x1,			x4; \
+	pxor x3,		x4; \
+	pand x1,		x3; \
+	pxor x2,		x1; \
+	pand x4,		x2;
+#define SI1_2(x0, x1, x2, x3, x4) \
+	pxor x1,		x4; \
+	por x3,			x1; \
+	pxor x0,		x3; \
+	pxor x0,		x2; \
+	por x4,			x0; \
+	pxor x4,		x2; \
+	pxor x0,		x1; \
+	pxor x1,		x4;
+
+#define SI2_1(x0, x1, x2, x3, x4) \
+	pxor x1,		x2; \
+	movdqa x3,		x4; \
+	pxor RNOT,		x3; \
+	por x2,			x3; \
+	pxor x4,		x2; \
+	pxor x0,		x4; \
+	pxor x1,		x3; \
+	por x2,			x1; \
+	pxor x0,		x2;
+#define SI2_2(x0, x1, x2, x3, x4) \
+	pxor x4,		x1; \
+	por x3,			x4; \
+	pxor x3,		x2; \
+	pxor x2,		x4; \
+	pand x1,		x2; \
+	pxor x3,		x2; \
+	pxor x4,		x3; \
+	pxor x0,		x4;
+
+#define SI3_1(x0, x1, x2, x3, x4) \
+	pxor x1,		x2; \
+	movdqa x1,		x4; \
+	pand x2,		x1; \
+	pxor x0,		x1; \
+	por x4,			x0; \
+	pxor x3,		x4; \
+	pxor x3,		x0; \
+	por x1,			x3; \
+	pxor x2,		x1;
+#define SI3_2(x0, x1, x2, x3, x4) \
+	pxor x3,		x1; \
+	pxor x2,		x0; \
+	pxor x3,		x2; \
+	pand x1,		x3; \
+	pxor x0,		x1; \
+	pand x2,		x0; \
+	pxor x3,		x4; \
+	pxor x0,		x3; \
+	pxor x1,		x0;
+
+#define SI4_1(x0, x1, x2, x3, x4) \
+	pxor x3,		x2; \
+	movdqa x0,		x4; \
+	pand x1,		x0; \
+	pxor x2,		x0; \
+	por x3,			x2; \
+	pxor RNOT,		x4; \
+	pxor x0,		x1; \
+	pxor x2,		x0; \
+	pand x4,		x2;
+#define SI4_2(x0, x1, x2, x3, x4) \
+	pxor x0,		x2; \
+	por x4,			x0; \
+	pxor x3,		x0; \
+	pand x2,		x3; \
+	pxor x3,		x4; \
+	pxor x1,		x3; \
+	pand x0,		x1; \
+	pxor x1,		x4; \
+	pxor x3,		x0;
+
+#define SI5_1(x0, x1, x2, x3, x4) \
+	movdqa x1,		x4; \
+	por x2,			x1; \
+	pxor x4,		x2; \
+	pxor x3,		x1; \
+	pand x4,		x3; \
+	pxor x3,		x2; \
+	por x0,			x3; \
+	pxor RNOT,		x0; \
+	pxor x2,		x3; \
+	por x0,			x2;
+#define SI5_2(x0, x1, x2, x3, x4) \
+	pxor x1,		x4; \
+	pxor x4,		x2; \
+	pand x0,		x4; \
+	pxor x1,		x0; \
+	pxor x3,		x1; \
+	pand x2,		x0; \
+	pxor x3,		x2; \
+	pxor x2,		x0; \
+	pxor x4,		x2; \
+	pxor x3,		x4;
+
+#define SI6_1(x0, x1, x2, x3, x4) \
+	pxor x2,		x0; \
+	movdqa x0,		x4; \
+	pand x3,		x0; \
+	pxor x3,		x2; \
+	pxor x2,		x0; \
+	pxor x1,		x3; \
+	por x4,			x2; \
+	pxor x3,		x2; \
+	pand x0,		x3;
+#define SI6_2(x0, x1, x2, x3, x4) \
+	pxor RNOT,		x0; \
+	pxor x1,		x3; \
+	pand x2,		x1; \
+	pxor x0,		x4; \
+	pxor x4,		x3; \
+	pxor x2,		x4; \
+	pxor x1,		x0; \
+	pxor x0,		x2;
+
+#define SI7_1(x0, x1, x2, x3, x4) \
+	movdqa x3,		x4; \
+	pand x0,		x3; \
+	pxor x2,		x0; \
+	por x4,			x2; \
+	pxor x1,		x4; \
+	pxor RNOT,		x0; \
+	por x3,			x1; \
+	pxor x0,		x4; \
+	pand x2,		x0; \
+	pxor x1,		x0;
+#define SI7_2(x0, x1, x2, x3, x4) \
+	pand x2,		x1; \
+	pxor x2,		x3; \
+	pxor x3,		x4; \
+	pand x3,		x2; \
+	por x0,			x3; \
+	pxor x4,		x1; \
+	pxor x4,		x3; \
+	pand x0,		x4; \
+	pxor x2,		x4;
+
+#define get_key(i, j, t) \
+	movd (4*(i)+(j))*4(CTX), t; \
+	pshufd $0, t, t;
+
+#define K2(x0, x1, x2, x3, x4, i) \
+	get_key(i, 0, RK0); \
+	get_key(i, 1, RK1); \
+	get_key(i, 2, RK2); \
+	get_key(i, 3, RK3); \
+	pxor RK0,		x0 ## 1; \
+	pxor RK1,		x1 ## 1; \
+	pxor RK2,		x2 ## 1; \
+	pxor RK3,		x3 ## 1; \
+		pxor RK0,		x0 ## 2; \
+		pxor RK1,		x1 ## 2; \
+		pxor RK2,		x2 ## 2; \
+		pxor RK3,		x3 ## 2;
+
+#define LK2(x0, x1, x2, x3, x4, i) \
+	movdqa x0 ## 1,		x4 ## 1; \
+	pslld $13,		x0 ## 1; \
+	psrld $(32 - 13),	x4 ## 1; \
+	por x4 ## 1,		x0 ## 1; \
+	pxor x0 ## 1,		x1 ## 1; \
+	movdqa x2 ## 1,		x4 ## 1; \
+	pslld $3,		x2 ## 1; \
+	psrld $(32 - 3),	x4 ## 1; \
+	por x4 ## 1,		x2 ## 1; \
+	pxor x2 ## 1,		x1 ## 1; \
+		movdqa x0 ## 2,		x4 ## 2; \
+		pslld $13,		x0 ## 2; \
+		psrld $(32 - 13),	x4 ## 2; \
+		por x4 ## 2,		x0 ## 2; \
+		pxor x0 ## 2,		x1 ## 2; \
+		movdqa x2 ## 2,		x4 ## 2; \
+		pslld $3,		x2 ## 2; \
+		psrld $(32 - 3),	x4 ## 2; \
+		por x4 ## 2,		x2 ## 2; \
+		pxor x2 ## 2,		x1 ## 2; \
+	movdqa x1 ## 1,		x4 ## 1; \
+	pslld $1,		x1 ## 1; \
+	psrld $(32 - 1),	x4 ## 1; \
+	por x4 ## 1,		x1 ## 1; \
+	movdqa x0 ## 1,		x4 ## 1; \
+	pslld $3,		x4 ## 1; \
+	pxor x2 ## 1,		x3 ## 1; \
+	pxor x4 ## 1,		x3 ## 1; \
+	movdqa x3 ## 1,		x4 ## 1; \
+	get_key(i, 1, RK1); \
+		movdqa x1 ## 2,		x4 ## 2; \
+		pslld $1,		x1 ## 2; \
+		psrld $(32 - 1),	x4 ## 2; \
+		por x4 ## 2,		x1 ## 2; \
+		movdqa x0 ## 2,		x4 ## 2; \
+		pslld $3,		x4 ## 2; \
+		pxor x2 ## 2,		x3 ## 2; \
+		pxor x4 ## 2,		x3 ## 2; \
+		movdqa x3 ## 2,		x4 ## 2; \
+		get_key(i, 3, RK3); \
+	pslld $7,		x3 ## 1; \
+	psrld $(32 - 7),	x4 ## 1; \
+	por x4 ## 1,		x3 ## 1; \
+	movdqa x1 ## 1,		x4 ## 1; \
+	pslld $7,		x4 ## 1; \
+	pxor x1 ## 1,		x0 ## 1; \
+	pxor x3 ## 1,		x0 ## 1; \
+	pxor x3 ## 1,		x2 ## 1; \
+	pxor x4 ## 1,		x2 ## 1; \
+	get_key(i, 0, RK0); \
+		pslld $7,		x3 ## 2; \
+		psrld $(32 - 7),	x4 ## 2; \
+		por x4 ## 2,		x3 ## 2; \
+		movdqa x1 ## 2,		x4 ## 2; \
+		pslld $7,		x4 ## 2; \
+		pxor x1 ## 2,		x0 ## 2; \
+		pxor x3 ## 2,		x0 ## 2; \
+		pxor x3 ## 2,		x2 ## 2; \
+		pxor x4 ## 2,		x2 ## 2; \
+		get_key(i, 2, RK2); \
+	pxor RK1,		x1 ## 1; \
+	pxor RK3,		x3 ## 1; \
+	movdqa x0 ## 1,		x4 ## 1; \
+	pslld $5,		x0 ## 1; \
+	psrld $(32 - 5),	x4 ## 1; \
+	por x4 ## 1,		x0 ## 1; \
+	movdqa x2 ## 1,		x4 ## 1; \
+	pslld $22,		x2 ## 1; \
+	psrld $(32 - 22),	x4 ## 1; \
+	por x4 ## 1,		x2 ## 1; \
+	pxor RK0,		x0 ## 1; \
+	pxor RK2,		x2 ## 1; \
+		pxor RK1,		x1 ## 2; \
+		pxor RK3,		x3 ## 2; \
+		movdqa x0 ## 2,		x4 ## 2; \
+		pslld $5,		x0 ## 2; \
+		psrld $(32 - 5),	x4 ## 2; \
+		por x4 ## 2,		x0 ## 2; \
+		movdqa x2 ## 2,		x4 ## 2; \
+		pslld $22,		x2 ## 2; \
+		psrld $(32 - 22),	x4 ## 2; \
+		por x4 ## 2,		x2 ## 2; \
+		pxor RK0,		x0 ## 2; \
+		pxor RK2,		x2 ## 2;
+
+#define KL2(x0, x1, x2, x3, x4, i) \
+	pxor RK0,		x0 ## 1; \
+	pxor RK2,		x2 ## 1; \
+	movdqa x0 ## 1,		x4 ## 1; \
+	psrld $5,		x0 ## 1; \
+	pslld $(32 - 5),	x4 ## 1; \
+	por x4 ## 1,		x0 ## 1; \
+	pxor RK3,		x3 ## 1; \
+	pxor RK1,		x1 ## 1; \
+	movdqa x2 ## 1,		x4 ## 1; \
+	psrld $22,		x2 ## 1; \
+	pslld $(32 - 22),	x4 ## 1; \
+	por x4 ## 1,		x2 ## 1; \
+	pxor x3 ## 1,		x2 ## 1; \
+		pxor RK0,		x0 ## 2; \
+		pxor RK2,		x2 ## 2; \
+		movdqa x0 ## 2,		x4 ## 2; \
+		psrld $5,		x0 ## 2; \
+		pslld $(32 - 5),	x4 ## 2; \
+		por x4 ## 2,		x0 ## 2; \
+		pxor RK3,		x3 ## 2; \
+		pxor RK1,		x1 ## 2; \
+		movdqa x2 ## 2,		x4 ## 2; \
+		psrld $22,		x2 ## 2; \
+		pslld $(32 - 22),	x4 ## 2; \
+		por x4 ## 2,		x2 ## 2; \
+		pxor x3 ## 2,		x2 ## 2; \
+	pxor x3 ## 1,		x0 ## 1; \
+	movdqa x1 ## 1,		x4 ## 1; \
+	pslld $7,		x4 ## 1; \
+	pxor x1 ## 1,		x0 ## 1; \
+	pxor x4 ## 1,		x2 ## 1; \
+	movdqa x1 ## 1,		x4 ## 1; \
+	psrld $1,		x1 ## 1; \
+	pslld $(32 - 1),	x4 ## 1; \
+	por x4 ## 1,		x1 ## 1; \
+		pxor x3 ## 2,		x0 ## 2; \
+		movdqa x1 ## 2,		x4 ## 2; \
+		pslld $7,		x4 ## 2; \
+		pxor x1 ## 2,		x0 ## 2; \
+		pxor x4 ## 2,		x2 ## 2; \
+		movdqa x1 ## 2,		x4 ## 2; \
+		psrld $1,		x1 ## 2; \
+		pslld $(32 - 1),	x4 ## 2; \
+		por x4 ## 2,		x1 ## 2; \
+	movdqa x3 ## 1,		x4 ## 1; \
+	psrld $7,		x3 ## 1; \
+	pslld $(32 - 7),	x4 ## 1; \
+	por x4 ## 1,		x3 ## 1; \
+	pxor x0 ## 1,		x1 ## 1; \
+	movdqa x0 ## 1,		x4 ## 1; \
+	pslld $3,		x4 ## 1; \
+	pxor x4 ## 1,		x3 ## 1; \
+	movdqa x0 ## 1,		x4 ## 1; \
+		movdqa x3 ## 2,		x4 ## 2; \
+		psrld $7,		x3 ## 2; \
+		pslld $(32 - 7),	x4 ## 2; \
+		por x4 ## 2,		x3 ## 2; \
+		pxor x0 ## 2,		x1 ## 2; \
+		movdqa x0 ## 2,		x4 ## 2; \
+		pslld $3,		x4 ## 2; \
+		pxor x4 ## 2,		x3 ## 2; \
+		movdqa x0 ## 2,		x4 ## 2; \
+	psrld $13,		x0 ## 1; \
+	pslld $(32 - 13),	x4 ## 1; \
+	por x4 ## 1,		x0 ## 1; \
+	pxor x2 ## 1,		x1 ## 1; \
+	pxor x2 ## 1,		x3 ## 1; \
+	movdqa x2 ## 1,		x4 ## 1; \
+	psrld $3,		x2 ## 1; \
+	pslld $(32 - 3),	x4 ## 1; \
+	por x4 ## 1,		x2 ## 1; \
+		psrld $13,		x0 ## 2; \
+		pslld $(32 - 13),	x4 ## 2; \
+		por x4 ## 2,		x0 ## 2; \
+		pxor x2 ## 2,		x1 ## 2; \
+		pxor x2 ## 2,		x3 ## 2; \
+		movdqa x2 ## 2,		x4 ## 2; \
+		psrld $3,		x2 ## 2; \
+		pslld $(32 - 3),	x4 ## 2; \
+		por x4 ## 2,		x2 ## 2;
+
+#define S(SBOX, x0, x1, x2, x3, x4) \
+	SBOX ## _1(x0 ## 1, x1 ## 1, x2 ## 1, x3 ## 1, x4 ## 1); \
+	SBOX ## _2(x0 ## 1, x1 ## 1, x2 ## 1, x3 ## 1, x4 ## 1); \
+	SBOX ## _1(x0 ## 2, x1 ## 2, x2 ## 2, x3 ## 2, x4 ## 2); \
+	SBOX ## _2(x0 ## 2, x1 ## 2, x2 ## 2, x3 ## 2, x4 ## 2);
+
+#define SP(SBOX, x0, x1, x2, x3, x4, i) \
+	get_key(i, 0, RK0); \
+	SBOX ## _1(x0 ## 1, x1 ## 1, x2 ## 1, x3 ## 1, x4 ## 1); \
+	get_key(i, 2, RK2); \
+	SBOX ## _1(x0 ## 2, x1 ## 2, x2 ## 2, x3 ## 2, x4 ## 2); \
+	get_key(i, 3, RK3); \
+	SBOX ## _2(x0 ## 1, x1 ## 1, x2 ## 1, x3 ## 1, x4 ## 1); \
+	get_key(i, 1, RK1); \
+	SBOX ## _2(x0 ## 2, x1 ## 2, x2 ## 2, x3 ## 2, x4 ## 2); \
+
+#define transpose_4x4(x0, x1, x2, x3, t1, t2, t3) \
+	movdqa x2,		t3; \
+	movdqa x0,		t1; \
+	unpcklps x3,		t3; \
+	movdqa x0,		t2; \
+	unpcklps x1,		t1; \
+	unpckhps x1,		t2; \
+	movdqa t3,		x1; \
+	unpckhps x3,		x2; \
+	movdqa t1,		x0; \
+	movhlps t1,		x1; \
+	movdqa t2,		t1; \
+	movlhps t3,		x0; \
+	movlhps x2,		t1; \
+	movhlps t2,		x2; \
+	movdqa x2,		x3; \
+	movdqa t1,		x2;
+
+#define read_blocks(in, x0, x1, x2, x3, t0, t1, t2) \
+	movdqu (0*4*4)(in),	x0; \
+	movdqu (1*4*4)(in),	x1; \
+	movdqu (2*4*4)(in),	x2; \
+	movdqu (3*4*4)(in),	x3; \
+	\
+	transpose_4x4(x0, x1, x2, x3, t0, t1, t2)
+
+#define write_blocks(out, x0, x1, x2, x3, t0, t1, t2) \
+	transpose_4x4(x0, x1, x2, x3, t0, t1, t2) \
+	\
+	movdqu x0,		(0*4*4)(out); \
+	movdqu x1,		(1*4*4)(out); \
+	movdqu x2,		(2*4*4)(out); \
+	movdqu x3,		(3*4*4)(out);
+
+#define xor_blocks(out, x0, x1, x2, x3, t0, t1, t2) \
+	transpose_4x4(x0, x1, x2, x3, t0, t1, t2) \
+	\
+	movdqu (0*4*4)(out),	t0; \
+	pxor t0,		x0; \
+	movdqu x0,		(0*4*4)(out); \
+	movdqu (1*4*4)(out),	t0; \
+	pxor t0,		x1; \
+	movdqu x1,		(1*4*4)(out); \
+	movdqu (2*4*4)(out),	t0; \
+	pxor t0,		x2; \
+	movdqu x2,		(2*4*4)(out); \
+	movdqu (3*4*4)(out),	t0; \
+	pxor t0,		x3; \
+	movdqu x3,		(3*4*4)(out);
+
+.align 8
+.global __serpent_enc_blk_8way
+.type   __serpent_enc_blk_8way,@function;
+
+__serpent_enc_blk_8way:
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 *	%rcx: bool, if true: xor output
+	 */
+
+	pcmpeqd RNOT, RNOT;
+
+	leaq (4*4*4)(%rdx), %rax;
+	read_blocks(%rdx, RA1, RB1, RC1, RD1, RK0, RK1, RK2);
+	read_blocks(%rax, RA2, RB2, RC2, RD2, RK0, RK1, RK2);
+
+						 K2(RA, RB, RC, RD, RE, 0);
+	S(S0, RA, RB, RC, RD, RE);		LK2(RC, RB, RD, RA, RE, 1);
+	S(S1, RC, RB, RD, RA, RE);		LK2(RE, RD, RA, RC, RB, 2);
+	S(S2, RE, RD, RA, RC, RB);		LK2(RB, RD, RE, RC, RA, 3);
+	S(S3, RB, RD, RE, RC, RA);		LK2(RC, RA, RD, RB, RE, 4);
+	S(S4, RC, RA, RD, RB, RE);		LK2(RA, RD, RB, RE, RC, 5);
+	S(S5, RA, RD, RB, RE, RC);		LK2(RC, RA, RD, RE, RB, 6);
+	S(S6, RC, RA, RD, RE, RB);		LK2(RD, RB, RA, RE, RC, 7);
+	S(S7, RD, RB, RA, RE, RC);		LK2(RC, RA, RE, RD, RB, 8);
+	S(S0, RC, RA, RE, RD, RB);		LK2(RE, RA, RD, RC, RB, 9);
+	S(S1, RE, RA, RD, RC, RB);		LK2(RB, RD, RC, RE, RA, 10);
+	S(S2, RB, RD, RC, RE, RA);		LK2(RA, RD, RB, RE, RC, 11);
+	S(S3, RA, RD, RB, RE, RC);		LK2(RE, RC, RD, RA, RB, 12);
+	S(S4, RE, RC, RD, RA, RB);		LK2(RC, RD, RA, RB, RE, 13);
+	S(S5, RC, RD, RA, RB, RE);		LK2(RE, RC, RD, RB, RA, 14);
+	S(S6, RE, RC, RD, RB, RA);		LK2(RD, RA, RC, RB, RE, 15);
+	S(S7, RD, RA, RC, RB, RE);		LK2(RE, RC, RB, RD, RA, 16);
+	S(S0, RE, RC, RB, RD, RA);		LK2(RB, RC, RD, RE, RA, 17);
+	S(S1, RB, RC, RD, RE, RA);		LK2(RA, RD, RE, RB, RC, 18);
+	S(S2, RA, RD, RE, RB, RC);		LK2(RC, RD, RA, RB, RE, 19);
+	S(S3, RC, RD, RA, RB, RE);		LK2(RB, RE, RD, RC, RA, 20);
+	S(S4, RB, RE, RD, RC, RA);		LK2(RE, RD, RC, RA, RB, 21);
+	S(S5, RE, RD, RC, RA, RB);		LK2(RB, RE, RD, RA, RC, 22);
+	S(S6, RB, RE, RD, RA, RC);		LK2(RD, RC, RE, RA, RB, 23);
+	S(S7, RD, RC, RE, RA, RB);		LK2(RB, RE, RA, RD, RC, 24);
+	S(S0, RB, RE, RA, RD, RC);		LK2(RA, RE, RD, RB, RC, 25);
+	S(S1, RA, RE, RD, RB, RC);		LK2(RC, RD, RB, RA, RE, 26);
+	S(S2, RC, RD, RB, RA, RE);		LK2(RE, RD, RC, RA, RB, 27);
+	S(S3, RE, RD, RC, RA, RB);		LK2(RA, RB, RD, RE, RC, 28);
+	S(S4, RA, RB, RD, RE, RC);		LK2(RB, RD, RE, RC, RA, 29);
+	S(S5, RB, RD, RE, RC, RA);		LK2(RA, RB, RD, RC, RE, 30);
+	S(S6, RA, RB, RD, RC, RE);		LK2(RD, RE, RB, RC, RA, 31);
+	S(S7, RD, RE, RB, RC, RA);		 K2(RA, RB, RC, RD, RE, 32);
+
+	leaq (4*4*4)(%rsi), %rax;
+
+	testb %cl, %cl;
+	jnz __enc_xor8;
+
+	write_blocks(%rsi, RA1, RB1, RC1, RD1, RK0, RK1, RK2);
+	write_blocks(%rax, RA2, RB2, RC2, RD2, RK0, RK1, RK2);
+
+	ret;
+
+__enc_xor8:
+	xor_blocks(%rsi, RA1, RB1, RC1, RD1, RK0, RK1, RK2);
+	xor_blocks(%rax, RA2, RB2, RC2, RD2, RK0, RK1, RK2);
+
+	ret;
+
+.align 8
+.global serpent_dec_blk_8way
+.type   serpent_dec_blk_8way,@function;
+
+serpent_dec_blk_8way:
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst
+	 *	%rdx: src
+	 */
+
+	pcmpeqd RNOT, RNOT;
+
+	leaq (4*4*4)(%rdx), %rax;
+	read_blocks(%rdx, RA1, RB1, RC1, RD1, RK0, RK1, RK2);
+	read_blocks(%rax, RA2, RB2, RC2, RD2, RK0, RK1, RK2);
+
+						 K2(RA, RB, RC, RD, RE, 32);
+	SP(SI7, RA, RB, RC, RD, RE, 31);	KL2(RB, RD, RA, RE, RC, 31);
+	SP(SI6, RB, RD, RA, RE, RC, 30);	KL2(RA, RC, RE, RB, RD, 30);
+	SP(SI5, RA, RC, RE, RB, RD, 29);	KL2(RC, RD, RA, RE, RB, 29);
+	SP(SI4, RC, RD, RA, RE, RB, 28);	KL2(RC, RA, RB, RE, RD, 28);
+	SP(SI3, RC, RA, RB, RE, RD, 27);	KL2(RB, RC, RD, RE, RA, 27);
+	SP(SI2, RB, RC, RD, RE, RA, 26);	KL2(RC, RA, RE, RD, RB, 26);
+	SP(SI1, RC, RA, RE, RD, RB, 25);	KL2(RB, RA, RE, RD, RC, 25);
+	SP(SI0, RB, RA, RE, RD, RC, 24);	KL2(RE, RC, RA, RB, RD, 24);
+	SP(SI7, RE, RC, RA, RB, RD, 23);	KL2(RC, RB, RE, RD, RA, 23);
+	SP(SI6, RC, RB, RE, RD, RA, 22);	KL2(RE, RA, RD, RC, RB, 22);
+	SP(SI5, RE, RA, RD, RC, RB, 21);	KL2(RA, RB, RE, RD, RC, 21);
+	SP(SI4, RA, RB, RE, RD, RC, 20);	KL2(RA, RE, RC, RD, RB, 20);
+	SP(SI3, RA, RE, RC, RD, RB, 19);	KL2(RC, RA, RB, RD, RE, 19);
+	SP(SI2, RC, RA, RB, RD, RE, 18);	KL2(RA, RE, RD, RB, RC, 18);
+	SP(SI1, RA, RE, RD, RB, RC, 17);	KL2(RC, RE, RD, RB, RA, 17);
+	SP(SI0, RC, RE, RD, RB, RA, 16);	KL2(RD, RA, RE, RC, RB, 16);
+	SP(SI7, RD, RA, RE, RC, RB, 15);	KL2(RA, RC, RD, RB, RE, 15);
+	SP(SI6, RA, RC, RD, RB, RE, 14);	KL2(RD, RE, RB, RA, RC, 14);
+	SP(SI5, RD, RE, RB, RA, RC, 13);	KL2(RE, RC, RD, RB, RA, 13);
+	SP(SI4, RE, RC, RD, RB, RA, 12);	KL2(RE, RD, RA, RB, RC, 12);
+	SP(SI3, RE, RD, RA, RB, RC, 11);	KL2(RA, RE, RC, RB, RD, 11);
+	SP(SI2, RA, RE, RC, RB, RD, 10);	KL2(RE, RD, RB, RC, RA, 10);
+	SP(SI1, RE, RD, RB, RC, RA, 9);		KL2(RA, RD, RB, RC, RE, 9);
+	SP(SI0, RA, RD, RB, RC, RE, 8);		KL2(RB, RE, RD, RA, RC, 8);
+	SP(SI7, RB, RE, RD, RA, RC, 7);		KL2(RE, RA, RB, RC, RD, 7);
+	SP(SI6, RE, RA, RB, RC, RD, 6);		KL2(RB, RD, RC, RE, RA, 6);
+	SP(SI5, RB, RD, RC, RE, RA, 5);		KL2(RD, RA, RB, RC, RE, 5);
+	SP(SI4, RD, RA, RB, RC, RE, 4);		KL2(RD, RB, RE, RC, RA, 4);
+	SP(SI3, RD, RB, RE, RC, RA, 3);		KL2(RE, RD, RA, RC, RB, 3);
+	SP(SI2, RE, RD, RA, RC, RB, 2);		KL2(RD, RB, RC, RA, RE, 2);
+	SP(SI1, RD, RB, RC, RA, RE, 1);		KL2(RE, RB, RC, RA, RD, 1);
+	S(SI0, RE, RB, RC, RA, RD);		 K2(RC, RD, RB, RE, RA, 0);
+
+	leaq (4*4*4)(%rsi), %rax;
+	write_blocks(%rsi, RC1, RD1, RB1, RE1, RK0, RK1, RK2);
+	write_blocks(%rax, RC2, RD2, RB2, RE2, RK0, RK1, RK2);
+
+	ret;
diff --git a/arch/x86/crypto/serpent_sse2_glue.c b/arch/x86/crypto/serpent_sse2_glue.c
new file mode 100644
index 0000000..d3c6938
--- /dev/null
+++ b/arch/x86/crypto/serpent_sse2_glue.c
@@ -0,0 +1,720 @@
+/*
+ * Glue Code for SSE2 assembler versions of Serpent Cipher
+ *
+ * Copyright (c) 2011 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ *
+ * Glue code based on aesni-intel_glue.c by:
+ *  Copyright (C) 2008, Intel Corp.
+ *    Author: Huang Ying <ying.huang@intel.com>
+ *
+ * CBC & ECB parts based on code (crypto/cbc.c,ecb.c) by:
+ *   Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
+ * CTR part based on code (crypto/ctr.c) by:
+ *   (C) Copyright IBM Corp. 2007 - Joy Latten <latten@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
+ * USA
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/hardirq.h>
+#include <linux/types.h>
+#include <linux/crypto.h>
+#include <linux/err.h>
+#include <crypto/algapi.h>
+#include <crypto/serpent.h>
+#include <crypto/cryptd.h>
+#include <crypto/b128ops.h>
+#include <crypto/ctr.h>
+#include <asm/i387.h>
+#include <asm/serpent.h>
+#include <crypto/scatterwalk.h>
+#include <linux/workqueue.h>
+#include <linux/spinlock.h>
+
+struct async_serpent_ctx {
+	struct cryptd_ablkcipher *cryptd_tfm;
+};
+
+static inline bool serpent_fpu_begin(bool fpu_enabled, unsigned int nbytes)
+{
+	if (fpu_enabled)
+		return true;
+
+	/* SSE2 is only used when chunk to be processed is large enough, so
+	 * do not enable FPU until it is necessary.
+	 */
+	if (nbytes < SERPENT_BLOCK_SIZE * SERPENT_PARALLEL_BLOCKS)
+		return false;
+
+	kernel_fpu_begin();
+	return true;
+}
+
+static inline void serpent_fpu_end(bool fpu_enabled)
+{
+	if (fpu_enabled)
+		kernel_fpu_end();
+}
+
+static int ecb_crypt(struct blkcipher_desc *desc, struct blkcipher_walk *walk,
+		     bool enc)
+{
+	bool fpu_enabled = false;
+	struct serpent_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	const unsigned int bsize = SERPENT_BLOCK_SIZE;
+	unsigned int nbytes;
+	int err;
+
+	err = blkcipher_walk_virt(desc, walk);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	while ((nbytes = walk->nbytes)) {
+		u8 *wsrc = walk->src.virt.addr;
+		u8 *wdst = walk->dst.virt.addr;
+
+		fpu_enabled = serpent_fpu_begin(fpu_enabled, nbytes);
+
+		/* Process multi-block batch */
+		if (nbytes >= bsize * SERPENT_PARALLEL_BLOCKS) {
+			do {
+				if (enc)
+					serpent_enc_blk_xway(ctx, wdst, wsrc);
+				else
+					serpent_dec_blk_xway(ctx, wdst, wsrc);
+
+				wsrc += bsize * SERPENT_PARALLEL_BLOCKS;
+				wdst += bsize * SERPENT_PARALLEL_BLOCKS;
+				nbytes -= bsize * SERPENT_PARALLEL_BLOCKS;
+			} while (nbytes >= bsize * SERPENT_PARALLEL_BLOCKS);
+
+			if (nbytes < bsize)
+				goto done;
+		}
+
+		/* Handle leftovers */
+		do {
+			if (enc)
+				__serpent_encrypt(ctx, wdst, wsrc);
+			else
+				__serpent_decrypt(ctx, wdst, wsrc);
+
+			wsrc += bsize;
+			wdst += bsize;
+			nbytes -= bsize;
+		} while (nbytes >= bsize);
+
+done:
+		err = blkcipher_walk_done(desc, walk, nbytes);
+	}
+
+	serpent_fpu_end(fpu_enabled);
+	return err;
+}
+
+static int ecb_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	return ecb_crypt(desc, &walk, true);
+}
+
+static int ecb_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	return ecb_crypt(desc, &walk, false);
+}
+
+static struct crypto_alg blk_ecb_alg = {
+	.cra_name		= "__ecb-serpent-sse2",
+	.cra_driver_name	= "__driver-ecb-serpent-sse2",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= SERPENT_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct serpent_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(blk_ecb_alg.cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE,
+			.setkey		= serpent_setkey,
+			.encrypt	= ecb_encrypt,
+			.decrypt	= ecb_decrypt,
+		},
+	},
+};
+
+static unsigned int __cbc_encrypt(struct blkcipher_desc *desc,
+				  struct blkcipher_walk *walk)
+{
+	struct serpent_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	const unsigned int bsize = SERPENT_BLOCK_SIZE;
+	unsigned int nbytes = walk->nbytes;
+	u128 *src = (u128 *)walk->src.virt.addr;
+	u128 *dst = (u128 *)walk->dst.virt.addr;
+	u128 *iv = (u128 *)walk->iv;
+
+	do {
+		u128_xor(dst, src, iv);
+		__serpent_encrypt(ctx, (u8 *)dst, (u8 *)dst);
+		iv = dst;
+
+		src += 1;
+		dst += 1;
+		nbytes -= bsize;
+	} while (nbytes >= bsize);
+
+	u128_xor((u128 *)walk->iv, (u128 *)walk->iv, iv);
+	return nbytes;
+}
+
+static int cbc_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	while ((nbytes = walk.nbytes)) {
+		nbytes = __cbc_encrypt(desc, &walk);
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	return err;
+}
+
+static unsigned int __cbc_decrypt(struct blkcipher_desc *desc,
+				  struct blkcipher_walk *walk)
+{
+	struct serpent_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	const unsigned int bsize = SERPENT_BLOCK_SIZE;
+	unsigned int nbytes = walk->nbytes;
+	u128 *src = (u128 *)walk->src.virt.addr;
+	u128 *dst = (u128 *)walk->dst.virt.addr;
+	u128 ivs[SERPENT_PARALLEL_BLOCKS - 1];
+	u128 last_iv;
+	int i;
+
+	/* Start of the last block. */
+	src += nbytes / bsize - 1;
+	dst += nbytes / bsize - 1;
+
+	last_iv = *src;
+
+	/* Process multi-block batch */
+	if (nbytes >= bsize * SERPENT_PARALLEL_BLOCKS) {
+		do {
+			nbytes -= bsize * (SERPENT_PARALLEL_BLOCKS - 1);
+			src -= SERPENT_PARALLEL_BLOCKS - 1;
+			dst -= SERPENT_PARALLEL_BLOCKS - 1;
+
+			for (i = 0; i < SERPENT_PARALLEL_BLOCKS - 1; i++)
+				ivs[i] = src[i];
+
+			serpent_dec_blk_xway(ctx, (u8 *)dst, (u8 *)src);
+
+			for (i = 0; i < SERPENT_PARALLEL_BLOCKS - 1; i++)
+				u128_xor(dst + (i + 1), dst + (i + 1), ivs + i);
+
+			nbytes -= bsize;
+			if (nbytes < bsize)
+				goto done;
+
+			u128_xor(dst, dst, src - 1);
+			src -= 1;
+			dst -= 1;
+		} while (nbytes >= bsize * SERPENT_PARALLEL_BLOCKS);
+
+		if (nbytes < bsize)
+			goto done;
+	}
+
+	/* Handle leftovers */
+	for (;;) {
+		__serpent_decrypt(ctx, (u8 *)dst, (u8 *)src);
+
+		nbytes -= bsize;
+		if (nbytes < bsize)
+			break;
+
+		u128_xor(dst, dst, src - 1);
+		src -= 1;
+		dst -= 1;
+	}
+
+done:
+	u128_xor(dst, dst, (u128 *)walk->iv);
+	*(u128 *)walk->iv = last_iv;
+
+	return nbytes;
+}
+
+static int cbc_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	bool fpu_enabled = false;
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	while ((nbytes = walk.nbytes)) {
+		fpu_enabled = serpent_fpu_begin(fpu_enabled, nbytes);
+		nbytes = __cbc_decrypt(desc, &walk);
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	serpent_fpu_end(fpu_enabled);
+	return err;
+}
+
+static struct crypto_alg blk_cbc_alg = {
+	.cra_name		= "__cbc-serpent-sse2",
+	.cra_driver_name	= "__driver-cbc-serpent-sse2",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= SERPENT_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct serpent_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(blk_cbc_alg.cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE,
+			.setkey		= serpent_setkey,
+			.encrypt	= cbc_encrypt,
+			.decrypt	= cbc_decrypt,
+		},
+	},
+};
+
+static inline void u128_to_be128(be128 *dst, const u128 *src)
+{
+	dst->a = cpu_to_be64(src->a);
+	dst->b = cpu_to_be64(src->b);
+}
+
+static inline void be128_to_u128(u128 *dst, const be128 *src)
+{
+	dst->a = be64_to_cpu(src->a);
+	dst->b = be64_to_cpu(src->b);
+}
+
+static inline void u128_inc(u128 *i)
+{
+	i->b++;
+	if (!i->b)
+		i->a++;
+}
+
+static void ctr_crypt_final(struct blkcipher_desc *desc,
+			    struct blkcipher_walk *walk)
+{
+	struct serpent_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	u8 *ctrblk = walk->iv;
+	u8 keystream[SERPENT_BLOCK_SIZE];
+	u8 *src = walk->src.virt.addr;
+	u8 *dst = walk->dst.virt.addr;
+	unsigned int nbytes = walk->nbytes;
+
+	__serpent_encrypt(ctx, keystream, ctrblk);
+	crypto_xor(keystream, src, nbytes);
+	memcpy(dst, keystream, nbytes);
+
+	crypto_inc(ctrblk, SERPENT_BLOCK_SIZE);
+}
+
+static unsigned int __ctr_crypt(struct blkcipher_desc *desc,
+				struct blkcipher_walk *walk)
+{
+	struct serpent_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	const unsigned int bsize = SERPENT_BLOCK_SIZE;
+	unsigned int nbytes = walk->nbytes;
+	u128 *src = (u128 *)walk->src.virt.addr;
+	u128 *dst = (u128 *)walk->dst.virt.addr;
+	u128 ctrblk;
+	be128 ctrblocks[SERPENT_PARALLEL_BLOCKS];
+	int i;
+
+	be128_to_u128(&ctrblk, (be128 *)walk->iv);
+
+	/* Process multi-block batch */
+	if (nbytes >= bsize * SERPENT_PARALLEL_BLOCKS) {
+		do {
+			/* create ctrblks for parallel encrypt */
+			for (i = 0; i < SERPENT_PARALLEL_BLOCKS; i++) {
+				if (dst != src)
+					dst[i] = src[i];
+
+				u128_to_be128(&ctrblocks[i], &ctrblk);
+				u128_inc(&ctrblk);
+			}
+
+			serpent_enc_blk_xway_xor(ctx, (u8 *)dst,
+						 (u8 *)ctrblocks);
+
+			src += SERPENT_PARALLEL_BLOCKS;
+			dst += SERPENT_PARALLEL_BLOCKS;
+			nbytes -= bsize * SERPENT_PARALLEL_BLOCKS;
+		} while (nbytes >= bsize * SERPENT_PARALLEL_BLOCKS);
+
+		if (nbytes < bsize)
+			goto done;
+	}
+
+	/* Handle leftovers */
+	do {
+		if (dst != src)
+			*dst = *src;
+
+		u128_to_be128(&ctrblocks[0], &ctrblk);
+		u128_inc(&ctrblk);
+
+		__serpent_encrypt(ctx, (u8 *)ctrblocks, (u8 *)ctrblocks);
+		u128_xor(dst, dst, (u128 *)ctrblocks);
+
+		src += 1;
+		dst += 1;
+		nbytes -= bsize;
+	} while (nbytes >= bsize);
+
+done:
+	u128_to_be128((be128 *)walk->iv, &ctrblk);
+	return nbytes;
+}
+
+static int ctr_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		     struct scatterlist *src, unsigned int nbytes)
+{
+	bool fpu_enabled = false;
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt_block(desc, &walk, SERPENT_BLOCK_SIZE);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	while ((nbytes = walk.nbytes) >= SERPENT_BLOCK_SIZE) {
+		fpu_enabled = serpent_fpu_begin(fpu_enabled, nbytes);
+		nbytes = __ctr_crypt(desc, &walk);
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	serpent_fpu_end(fpu_enabled);
+
+	if (walk.nbytes) {
+		ctr_crypt_final(desc, &walk);
+		err = blkcipher_walk_done(desc, &walk, 0);
+	}
+
+	return err;
+}
+
+static struct crypto_alg blk_ctr_alg = {
+	.cra_name		= "__ctr-serpent-sse2",
+	.cra_driver_name	= "__driver-ctr-serpent-sse2",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= 1,
+	.cra_ctxsize		= sizeof(struct serpent_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(blk_ctr_alg.cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE,
+			.ivsize		= SERPENT_BLOCK_SIZE,
+			.setkey		= serpent_setkey,
+			.encrypt	= ctr_crypt,
+			.decrypt	= ctr_crypt,
+		},
+	},
+};
+
+static int ablk_set_key(struct crypto_ablkcipher *tfm, const u8 *key,
+			unsigned int key_len)
+{
+	struct async_serpent_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	struct crypto_ablkcipher *child = &ctx->cryptd_tfm->base;
+	int err;
+
+	crypto_ablkcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_ablkcipher_set_flags(child, crypto_ablkcipher_get_flags(tfm)
+				    & CRYPTO_TFM_REQ_MASK);
+	err = crypto_ablkcipher_setkey(child, key, key_len);
+	crypto_ablkcipher_set_flags(tfm, crypto_ablkcipher_get_flags(child)
+				    & CRYPTO_TFM_RES_MASK);
+	return err;
+}
+
+static int __ablk_encrypt(struct ablkcipher_request *req)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
+	struct async_serpent_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	struct blkcipher_desc desc;
+
+	desc.tfm = cryptd_ablkcipher_child(ctx->cryptd_tfm);
+	desc.info = req->info;
+	desc.flags = 0;
+
+	return crypto_blkcipher_crt(desc.tfm)->encrypt(
+		&desc, req->dst, req->src, req->nbytes);
+}
+
+static int ablk_encrypt(struct ablkcipher_request *req)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
+	struct async_serpent_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+
+	if (!irq_fpu_usable()) {
+		struct ablkcipher_request *cryptd_req =
+			ablkcipher_request_ctx(req);
+
+		memcpy(cryptd_req, req, sizeof(*req));
+		ablkcipher_request_set_tfm(cryptd_req, &ctx->cryptd_tfm->base);
+
+		return crypto_ablkcipher_encrypt(cryptd_req);
+	} else {
+		return __ablk_encrypt(req);
+	}
+}
+
+static int ablk_decrypt(struct ablkcipher_request *req)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
+	struct async_serpent_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+
+	if (!irq_fpu_usable()) {
+		struct ablkcipher_request *cryptd_req =
+			ablkcipher_request_ctx(req);
+
+		memcpy(cryptd_req, req, sizeof(*req));
+		ablkcipher_request_set_tfm(cryptd_req, &ctx->cryptd_tfm->base);
+
+		return crypto_ablkcipher_decrypt(cryptd_req);
+	} else {
+		struct blkcipher_desc desc;
+
+		desc.tfm = cryptd_ablkcipher_child(ctx->cryptd_tfm);
+		desc.info = req->info;
+		desc.flags = 0;
+
+		return crypto_blkcipher_crt(desc.tfm)->decrypt(
+			&desc, req->dst, req->src, req->nbytes);
+	}
+}
+
+static void ablk_exit(struct crypto_tfm *tfm)
+{
+	struct async_serpent_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	cryptd_free_ablkcipher(ctx->cryptd_tfm);
+}
+
+static void ablk_init_common(struct crypto_tfm *tfm,
+			     struct cryptd_ablkcipher *cryptd_tfm)
+{
+	struct async_serpent_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	ctx->cryptd_tfm = cryptd_tfm;
+	tfm->crt_ablkcipher.reqsize = sizeof(struct ablkcipher_request) +
+		crypto_ablkcipher_reqsize(&cryptd_tfm->base);
+}
+
+static int ablk_ecb_init(struct crypto_tfm *tfm)
+{
+	struct cryptd_ablkcipher *cryptd_tfm;
+
+	cryptd_tfm = cryptd_alloc_ablkcipher("__driver-ecb-serpent-sse2", 0, 0);
+	if (IS_ERR(cryptd_tfm))
+		return PTR_ERR(cryptd_tfm);
+	ablk_init_common(tfm, cryptd_tfm);
+	return 0;
+}
+
+static struct crypto_alg ablk_ecb_alg = {
+	.cra_name		= "ecb(serpent)",
+	.cra_driver_name	= "ecb-serpent-sse2",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= SERPENT_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_serpent_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(ablk_ecb_alg.cra_list),
+	.cra_init		= ablk_ecb_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		},
+	},
+};
+
+static int ablk_cbc_init(struct crypto_tfm *tfm)
+{
+	struct cryptd_ablkcipher *cryptd_tfm;
+
+	cryptd_tfm = cryptd_alloc_ablkcipher("__driver-cbc-serpent-sse2", 0, 0);
+	if (IS_ERR(cryptd_tfm))
+		return PTR_ERR(cryptd_tfm);
+	ablk_init_common(tfm, cryptd_tfm);
+	return 0;
+}
+
+static struct crypto_alg ablk_cbc_alg = {
+	.cra_name		= "cbc(serpent)",
+	.cra_driver_name	= "cbc-serpent-sse2",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= SERPENT_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_serpent_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(ablk_cbc_alg.cra_list),
+	.cra_init		= ablk_cbc_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE,
+			.ivsize		= SERPENT_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= __ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		},
+	},
+};
+
+static int ablk_ctr_init(struct crypto_tfm *tfm)
+{
+	struct cryptd_ablkcipher *cryptd_tfm;
+
+	cryptd_tfm = cryptd_alloc_ablkcipher("__driver-ctr-serpent-sse2", 0, 0);
+	if (IS_ERR(cryptd_tfm))
+		return PTR_ERR(cryptd_tfm);
+	ablk_init_common(tfm, cryptd_tfm);
+	return 0;
+}
+
+static struct crypto_alg ablk_ctr_alg = {
+	.cra_name		= "ctr(serpent)",
+	.cra_driver_name	= "ctr-serpent-sse2",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= 1,
+	.cra_ctxsize		= sizeof(struct async_serpent_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(ablk_ctr_alg.cra_list),
+	.cra_init		= ablk_ctr_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE,
+			.ivsize		= SERPENT_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_encrypt,
+			.geniv		= "chainiv",
+		},
+	},
+};
+
+static int __init serpent_sse2_init(void)
+{
+	int err;
+
+	if (!cpu_has_xmm2) {
+		printk(KERN_INFO "SSE2 instructions are not detected.\n");
+		return -ENODEV;
+	}
+
+	err = crypto_register_alg(&blk_ecb_alg);
+	if (err)
+		goto blk_ecb_err;
+	err = crypto_register_alg(&blk_cbc_alg);
+	if (err)
+		goto blk_cbc_err;
+	err = crypto_register_alg(&blk_ctr_alg);
+	if (err)
+		goto blk_ctr_err;
+	err = crypto_register_alg(&ablk_ecb_alg);
+	if (err)
+		goto ablk_ecb_err;
+	err = crypto_register_alg(&ablk_cbc_alg);
+	if (err)
+		goto ablk_cbc_err;
+	err = crypto_register_alg(&ablk_ctr_alg);
+	if (err)
+		goto ablk_ctr_err;
+	return err;
+
+ablk_ctr_err:
+	crypto_unregister_alg(&ablk_cbc_alg);
+ablk_cbc_err:
+	crypto_unregister_alg(&ablk_ecb_alg);
+ablk_ecb_err:
+	crypto_unregister_alg(&blk_ctr_alg);
+blk_ctr_err:
+	crypto_unregister_alg(&blk_cbc_alg);
+blk_cbc_err:
+	crypto_unregister_alg(&blk_ecb_alg);
+blk_ecb_err:
+	return err;
+}
+
+static void __exit serpent_sse2_exit(void)
+{
+	crypto_unregister_alg(&ablk_ctr_alg);
+	crypto_unregister_alg(&ablk_cbc_alg);
+	crypto_unregister_alg(&ablk_ecb_alg);
+	crypto_unregister_alg(&blk_ctr_alg);
+	crypto_unregister_alg(&blk_cbc_alg);
+	crypto_unregister_alg(&blk_ecb_alg);
+}
+
+module_init(serpent_sse2_init);
+module_exit(serpent_sse2_exit);
+
+MODULE_DESCRIPTION("Serpent Cipher Algorithm, SSE2 optimized");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("serpent");
+
diff --git a/arch/x86/include/asm/serpent.h b/arch/x86/include/asm/serpent.h
new file mode 100644
index 0000000..ec463d7
--- /dev/null
+++ b/arch/x86/include/asm/serpent.h
@@ -0,0 +1,33 @@
+#ifndef ASM_X86_SERPENT_H
+#define ASM_X86_SERPENT_H
+
+#include <linux/crypto.h>
+#include <crypto/serpent.h>
+
+#define SERPENT_PARALLEL_BLOCKS 8
+
+asmlinkage void __serpent_enc_blk_8way(struct serpent_ctx *ctx, u8 *dst,
+				       const u8 *src, bool xor);
+asmlinkage void serpent_dec_blk_8way(struct serpent_ctx *ctx, u8 *dst,
+				     const u8 *src);
+
+static inline void serpent_enc_blk_xway(struct serpent_ctx *ctx, u8 *dst,
+				   const u8 *src)
+{
+	__serpent_enc_blk_8way(ctx, dst, src, false);
+}
+
+static inline void serpent_enc_blk_xway_xor(struct serpent_ctx *ctx, u8 *dst,
+				       const u8 *src)
+{
+	__serpent_enc_blk_8way(ctx, dst, src, true);
+}
+
+static inline void serpent_dec_blk_xway(struct serpent_ctx *ctx, u8 *dst,
+				   const u8 *src)
+{
+	serpent_dec_blk_8way(ctx, dst, src);
+}
+
+#endif
+
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 733208f..2df61e4 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -766,6 +766,23 @@ config CRYPTO_SERPENT
 	  See also:
 	  <http://www.cl.cam.ac.uk/~rja14/serpent.html>
 
+config CRYPTO_SERPENT_SSE2_X86_64
+	tristate "Serpent cipher algorithm (x86_64/SSE2)"
+	depends on X86 && 64BIT
+	select CRYPTO_ALGAPI
+	select CRYPTO_SERPENT
+	help
+	  Serpent cipher algorithm, by Anderson, Biham & Knudsen.
+
+	  Keys are allowed to be from 0 to 256 bits in length, in steps
+	  of 8 bits.
+
+	  This module provides Serpent cipher algorithm that processes eigth
+	  blocks parallel using SSE2 instruction set.
+
+	  See also:
+	  <http://www.cl.cam.ac.uk/~rja14/serpent.html>
+
 config CRYPTO_TEA
 	tristate "TEA, XTEA and XETA cipher algorithms"
 	select CRYPTO_ALGAPI
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 01553a6..bb54b882 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1534,6 +1534,21 @@ static int alg_test_null(const struct alg_test_desc *desc,
 /* Please keep this list sorted by algorithm name. */
 static const struct alg_test_desc alg_test_descs[] = {
 	{
+		.alg = "__cbc-serpent-sse2",
+		.test = alg_test_null,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = NULL,
+					.count = 0
+				},
+				.dec = {
+					.vecs = NULL,
+					.count = 0
+				}
+			}
+		}
+	}, {
 		.alg = "__driver-cbc-aes-aesni",
 		.test = alg_test_null,
 		.suite = {
@@ -1549,6 +1564,21 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "__driver-cbc-serpent-sse2",
+		.test = alg_test_null,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = NULL,
+					.count = 0
+				},
+				.dec = {
+					.vecs = NULL,
+					.count = 0
+				}
+			}
+		}
+	}, {
 		.alg = "__driver-ecb-aes-aesni",
 		.test = alg_test_null,
 		.suite = {
@@ -1564,6 +1594,21 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "__driver-ecb-serpent-sse2",
+		.test = alg_test_null,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = NULL,
+					.count = 0
+				},
+				.dec = {
+					.vecs = NULL,
+					.count = 0
+				}
+			}
+		}
+	}, {
 		.alg = "__ghash-pclmulqdqni",
 		.test = alg_test_null,
 		.suite = {
@@ -1746,6 +1791,21 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "cryptd(__driver-ecb-serpent-sse2)",
+		.test = alg_test_null,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = NULL,
+					.count = 0
+				},
+				.dec = {
+					.vecs = NULL,
+					.count = 0
+				}
+			}
+		}
+	}, {
 		.alg = "cryptd(__ghash-pclmulqdqni)",
 		.test = alg_test_null,
 		.suite = {
