Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071A31B3730
	for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2024 11:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723806516; cv=none; b=S6B2t2stHCMVXnZU44gW8m2uBpVSzso6hGYq37e3qDeuVJZIppPW4NCkkUb+y5gmyB3T1Tfp+8cJd5RuXBopuobxezk1DKiGsSDDKiUYFy9sx8aldXpsjckP8s7VyweIRxjOC5sZj5RPitmUflXWMooKh2hOcK2JhhN1EARXguI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723806516; c=relaxed/simple;
	bh=N6IxPQvc73cA34ZLFBJ+Wb3X71a6U0xPaAu/Ebm+NH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DorlV8zC83SANbVqvqsG/RbIPsDfZGMiYJhcO90eQXTKyxvnwENA6hn+USqqi8v07JB7Mxj2XaWtc44TdoFa3+cdQS30vZLAmWPZ0Je2k74oQNgpMwStGQWTC414Ao4IEK/MhfDjnKyxwBrIxhUEP041lEj6S4KG1ZDnkB/KyO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=U+c+SwVl; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="U+c+SwVl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1723806514;
	bh=N6IxPQvc73cA34ZLFBJ+Wb3X71a6U0xPaAu/Ebm+NH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U+c+SwVl+0r96mp/pcLyUErptnO0LAhYULTsdRU82Y+dS1tsw/w6jyqzjeJzgv0ND
	 /xkLT3+ecLzu5bcpp7ROPiyM/Yf41gMzn8ztorullIdBzcqMS+GoHLKJ+KH8oFl633
	 TaZCjPFpROQmPuCJEbqKK2CdGOC2Pq2BkrfE5F8c=
Received: from stargazer.. (unknown [IPv6:240e:457:1000:1603:4ab7:c07d:7ab1:44b2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 8BEDD66F27;
	Fri, 16 Aug 2024 07:08:28 -0400 (EDT)
From: Xi Ruoyao <xry111@xry111.site>
To: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>
Cc: Xi Ruoyao <xry111@xry111.site>,
	linux-crypto@vger.kernel.org,
	loongarch@lists.linux.dev,
	Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 3/3] LoongArch: vDSO: Add LSX implementation of vDSO getrandom()
Date: Fri, 16 Aug 2024 19:07:16 +0800
Message-ID: <20240816110717.10249-4-xry111@xry111.site>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240816110717.10249-1-xry111@xry111.site>
References: <20240816110717.10249-1-xry111@xry111.site>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's 7% faster in vdso_test_getrandom bench-single test and 21% faster
in vdso_test_getrandom bench-multi test than the generic LoongArch
implementation.

Signed-off-by: Xi Ruoyao <xry111@xry111.site>
---
 arch/loongarch/vdso/Makefile                |   4 +
 arch/loongarch/vdso/vgetrandom-chacha-lsx.S | 162 ++++++++++++++++++++
 arch/loongarch/vdso/vgetrandom-chacha.S     |  13 ++
 3 files changed, 179 insertions(+)
 create mode 100644 arch/loongarch/vdso/vgetrandom-chacha-lsx.S

diff --git a/arch/loongarch/vdso/Makefile b/arch/loongarch/vdso/Makefile
index c8c5d9a7c80c..cab92c3a70a4 100644
--- a/arch/loongarch/vdso/Makefile
+++ b/arch/loongarch/vdso/Makefile
@@ -8,6 +8,10 @@ obj-vdso-y := elf.o vgetcpu.o vgettimeofday.o sigreturn.o
 
 obj-vdso-$(CONFIG_VDSO_GETRANDOM) += vgetrandom.o vgetrandom-chacha.o memset.o
 
+ifdef CONFIG_CPU_HAS_LSX
+obj-vdso-$(CONFIG_VDSO_GETRANDOM) += vgetrandom-chacha-lsx.o
+endif
+
 # Common compiler flags between ABIs.
 ccflags-vdso := \
 	$(filter -I%,$(KBUILD_CFLAGS)) \
diff --git a/arch/loongarch/vdso/vgetrandom-chacha-lsx.S b/arch/loongarch/vdso/vgetrandom-chacha-lsx.S
new file mode 100644
index 000000000000..6d8c886d78c8
--- /dev/null
+++ b/arch/loongarch/vdso/vgetrandom-chacha-lsx.S
@@ -0,0 +1,162 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2024 Xi Ruoyao <xry111@xry111.site>. All Rights Reserved.
+ *
+ * Based on arch/x86/entry/vdso/vgetrandom-chacha.S:
+ *
+ * Copyright (C) 2022-2024 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights
+ * Reserved.
+ */
+
+#include <asm/asm.h>
+#include <asm/regdef.h>
+#include <linux/linkage.h>
+
+.section	.rodata
+.align 4
+CONSTANTS:	.octa 0x6b20657479622d323320646e61707865
+
+.text
+
+/*
+ * Loongson SIMD eXtension implementation of ChaCha20. Produces a given
+ * positive number of blocks of output with a nonce of 0, taking an input
+ * key and 8-byte counter. Importantly does not spill to the stack. Its
+ * arguments are:
+ *
+ *	a0: output bytes
+ *	a1: 32-byte key input
+ *	a2: 8-byte counter input/output
+ *	a3: number of 64-byte blocks to write to output
+ */
+SYM_FUNC_START(__arch_chacha20_blocks_nostack_lsx)
+#define output		a0
+#define key		a1
+#define counter		a2
+#define nblocks		a3
+#define i		t0
+/* LSX registers vr0-vr23 are caller-save. */
+#define state0		$vr0
+#define state1		$vr1
+#define state2		$vr2
+#define state3		$vr3
+#define copy0		$vr4
+#define copy1		$vr5
+#define copy2		$vr6
+#define copy3		$vr7
+#define one		$vr8
+
+	/* copy0 = "expand 32-byte k" */
+	la.pcrel	t1, CONSTANTS
+	vld		copy0, t1, 0
+	/* copy1, copy2 = key */
+	vld		copy1, key, 0
+	vld		copy2, key, 0x10
+	/* copy3 = counter || zero nonce */
+	vldrepl.d	copy3, counter, 0
+	vinsgr2vr.d	copy3, zero, 1
+	/* one = 1 || 0 */
+	vldi		one, 0b0110000000001
+	vinsgr2vr.d	one, zero, 1
+
+.Lblock:
+	/* state = copy */
+	vori.b		state0, copy0, 0
+	vori.b		state1, copy1, 0
+	vori.b		state2, copy2, 0
+	vori.b		state3, copy3, 0
+
+	li.w		i, 10
+.Lpermute:
+	/* state0 += state1, state3 = rotl32(state3 ^ state0, 16) */
+	vadd.w		state0, state0, state1
+	vxor.v		state3, state3, state0
+	vrotri.w	state3, state3, 16
+
+	/* state2 += state3, state1 = rotl32(state1 ^ state2, 12) */
+	vadd.w		state2, state2, state3
+	vxor.v		state1, state1, state2
+	vrotri.w	state1, state1, 20
+
+	/* state0 += state1, state3 = rotl32(state3 ^ state0, 8) */
+	vadd.w		state0, state0, state1
+	vxor.v		state3, state3, state0
+	vrotri.w	state3, state3, 24
+
+	/* state2 += state3, state1 = rotl32(state1 ^ state2, 7) */
+	vadd.w		state2, state2, state3
+	vxor.v		state1, state1, state2
+	vrotri.w	state1, state1, 25
+
+	/* state1[0,1,2,3] = state1[1,2,3,0] */
+	vshuf4i.w	state1, state1, 0b00111001
+	/* state2[0,1,2,3] = state2[2,3,0,1] */
+	vshuf4i.w	state2, state2, 0b01001110
+	/* state3[0,1,2,3] = state3[1,2,3,0] */
+	vshuf4i.w	state3, state3, 0b10010011
+
+	/* state0 += state1, state3 = rotl32(state3 ^ state0, 16) */
+	vadd.w		state0, state0, state1
+	vxor.v		state3, state3, state0
+	vrotri.w	state3, state3, 16
+
+	/* state2 += state3, state1 = rotl32(state1 ^ state2, 12) */
+	vadd.w		state2, state2, state3
+	vxor.v		state1, state1, state2
+	vrotri.w	state1, state1, 20
+
+	/* state0 += state1, state3 = rotl32(state3 ^ state0, 8) */
+	vadd.w		state0, state0, state1
+	vxor.v		state3, state3, state0
+	vrotri.w	state3, state3, 24
+
+	/* state2 += state3, state1 = rotl32(state1 ^ state2, 7) */
+	vadd.w		state2, state2, state3
+	vxor.v		state1, state1, state2
+	vrotri.w	state1, state1, 25
+
+	/* state1[0,1,2,3] = state1[3,0,1,2] */
+	vshuf4i.w	state1, state1, 0b10010011
+	/* state2[0,1,2,3] = state2[2,3,0,1] */
+	vshuf4i.w	state2, state2, 0b01001110
+	/* state3[0,1,2,3] = state3[1,2,3,0] */
+	vshuf4i.w	state3, state3, 0b00111001
+
+	addi.w		i, i, -1
+	bnez		i, .Lpermute
+
+	/* output0 = state0 + copy0 */
+	vadd.w		state0, state0, copy0
+	vst		state0, output, 0
+	/* output1 = state1 + copy1 */
+	vadd.w		state1, state1, copy1
+	vst		state1, output, 0x10
+	/* output2 = state2 + copy2 */
+	vadd.w		state2, state2, copy2
+	vst		state2, output, 0x20
+	/* output3 = state3 + copy3 */
+	vadd.w		state3, state3, copy3
+	vst		state3, output, 0x30
+
+	/* ++copy3.counter */
+	vadd.d		copy3, copy3, one
+
+	/* output += 64 */
+	PTR_ADDI	output, output, 64
+	/* --nblocks */
+	PTR_ADDI	nblocks, nblocks, -1
+	bnez		nblocks, .Lblock
+
+	/* counter = copy3.counter */
+	vstelm.d	copy3, counter, 0, 0
+
+	/* Zero out the potentially sensitive regs, in case nothing uses these again. */
+	vldi		state0, 0
+	vldi		state1, 0
+	vldi		state2, 0
+	vldi		state3, 0
+	vldi		copy1, 0
+	vldi		copy2, 0
+
+	jr		ra
+SYM_FUNC_END(__arch_chacha20_blocks_nostack_lsx)
diff --git a/arch/loongarch/vdso/vgetrandom-chacha.S b/arch/loongarch/vdso/vgetrandom-chacha.S
index 2e42198f2faf..1931119e12a6 100644
--- a/arch/loongarch/vdso/vgetrandom-chacha.S
+++ b/arch/loongarch/vdso/vgetrandom-chacha.S
@@ -7,6 +7,11 @@
 #include <asm/regdef.h>
 #include <linux/linkage.h>
 
+#ifdef CONFIG_CPU_HAS_LSX
+# include <asm/alternative-asm.h>
+# include <asm/cpu.h>
+#endif
+
 .text
 
 /* Salsa20 quarter-round */
@@ -78,8 +83,16 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
 	 * The ABI requires s0-s9 saved, and sp aligned to 16-byte.
 	 * This does not violate the stack-less requirement: no sensitive data
 	 * is spilled onto the stack.
+	 *
+	 * Rewrite the very first instruction to jump to the LSX implementation
+	 * if LSX is available.
 	 */
+#ifdef CONFIG_CPU_HAS_LSX
+	ALTERNATIVE __stringify(PTR_ADDI sp, sp, (-SZREG * 10) & STACK_ALIGN), \
+		    "b __arch_chacha20_blocks_nostack_lsx", CPU_FEATURE_LSX
+#else
 	PTR_ADDI	sp, sp, (-SZREG * 10) & STACK_ALIGN
+#endif
 	REG_S		s0, sp, 0
 	REG_S		s1, sp, SZREG
 	REG_S		s2, sp, SZREG * 2
-- 
2.46.0

