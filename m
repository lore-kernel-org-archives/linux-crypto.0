Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3311A01CA
	for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2024 13:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728899; cv=none; b=bor14y1K0cqkWIHeXvwFRE8ghNQ6NE7w6CXW3Gq7K7WuVDA+oipwMu9uz7ByGo7CL8w1g0sv/YihCQrAWIEF1DoX/4aaGiobfzmQ0+f1jfJfZaEn1JzGyU+SKBmI3DCFWPsDh4g4SuP3WnJht6Sopv828fFI3WVMWG4YskaIYIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728899; c=relaxed/simple;
	bh=pF48jEj/DQCNr9GpC4KryAAa5ej+HNT+pmVtjTy633U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bg8mJ6Gpn+4TY7iBWeiExe5ZCC12F8up97M24MCQ4OlMUOr7G/YMnaYJBuSPA+5dZt1rEyWtJT24jKe7cQDrAOmTYyticUZEx3Op14tZ4TV7Sjtn2rl0eE8HPgJqM3mzReeqsi0ePZlzVpK5h5DjPTHegsnMhW28oADKPceWGJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=BiFKPmL8; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="BiFKPmL8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1723728896;
	bh=pF48jEj/DQCNr9GpC4KryAAa5ej+HNT+pmVtjTy633U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BiFKPmL8dcAY0VvfF+YOnB4OJiRPzp+DLD0r2HrApWtKz1TmCP9QWxGAfT5DckHu6
	 +KUNo4Itgxm9okfoOCtT3lJWIu/SbtV54FDXESECARcZSw5Uk2hmN6gYVyy+uQJHQ5
	 TJ2C/PZf62NWXNVnwiz9INDeau/9s9Bu6Jh5CdW4=
Received: from stargazer.. (unknown [IPv6:240e:456:1030:181:abd4:6e7f:e826:ac0f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id D7CCE66F26;
	Thu, 15 Aug 2024 09:34:50 -0400 (EDT)
From: Xi Ruoyao <xry111@xry111.site>
To: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>
Cc: linux-crypto@vger.kernel.org,
	loongarch@lists.linux.dev,
	Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Arnd Bergmann <arnd@arndb.de>,
	Xi Ruoyao <xry111@xry111.site>
Subject: [PATCH v2 2/2] LoongArch: vDSO: Wire up getrandom() vDSO implementation
Date: Thu, 15 Aug 2024 21:33:57 +0800
Message-ID: <20240815133357.35829-3-xry111@xry111.site>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815133357.35829-1-xry111@xry111.site>
References: <20240815133357.35829-1-xry111@xry111.site>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hook up the generic vDSO implementation to the LoongArch vDSO data page:
embed struct vdso_rng_data into struct loongarch_vdso_data, and use
assembler hack to resolve the symbol name "_vdso_rng_data" (which is
expected by the generic vDSO implementation) to the rng_data field in
loongarch_vdso_data.

The vDSO function requires a ChaCha20 implementation that does not write
to the stack, yet can still do an entire ChaCha20 permutation, so
provide this using LSX.  For processors lacking LSX just fallback to a
getrandom() syscall.

The compiler (GCC 14.2) calls memset() for initializing a "large" struct
in a cold path of the generic vDSO getrandom() code.  There seems no way
to prevent it from calling memset(), and it's a cold path so the
performance does not matter, so just provide a naive memset()
implementation for vDSO.

Signed-off-by: Xi Ruoyao <xry111@xry111.site>
---
 arch/loongarch/Kconfig                      |   1 +
 arch/loongarch/include/asm/vdso/getrandom.h |  47 ++++++
 arch/loongarch/include/asm/vdso/vdso.h      |   8 +
 arch/loongarch/kernel/asm-offsets.c         |  10 ++
 arch/loongarch/kernel/vdso.c                |   6 +
 arch/loongarch/vdso/Makefile                |   2 +
 arch/loongarch/vdso/memset.S                |  24 +++
 arch/loongarch/vdso/vdso.lds.S              |   1 +
 arch/loongarch/vdso/vgetrandom-alt.S        |  19 +++
 arch/loongarch/vdso/vgetrandom-chacha.S     | 162 ++++++++++++++++++++
 arch/loongarch/vdso/vgetrandom.c            |  16 ++
 11 files changed, 296 insertions(+)
 create mode 100644 arch/loongarch/include/asm/vdso/getrandom.h
 create mode 100644 arch/loongarch/vdso/memset.S
 create mode 100644 arch/loongarch/vdso/vgetrandom-alt.S
 create mode 100644 arch/loongarch/vdso/vgetrandom-chacha.S
 create mode 100644 arch/loongarch/vdso/vgetrandom.c

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index 70f169210b52..56b3fc8feb0b 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -190,6 +190,7 @@ config LOONGARCH
 	select TRACE_IRQFLAGS_SUPPORT
 	select USE_PERCPU_NUMA_NODE_ID
 	select USER_STACKTRACE_SUPPORT
+	select VDSO_GETRANDOM if CPU_HAS_LSX
 	select ZONE_DMA32
 
 config 32BIT
diff --git a/arch/loongarch/include/asm/vdso/getrandom.h b/arch/loongarch/include/asm/vdso/getrandom.h
new file mode 100644
index 000000000000..a369588a4ebf
--- /dev/null
+++ b/arch/loongarch/include/asm/vdso/getrandom.h
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2024 Xi Ruoyao <xry111@xry111.site>. All Rights Reserved.
+ */
+#ifndef __ASM_VDSO_GETRANDOM_H
+#define __ASM_VDSO_GETRANDOM_H
+
+#ifndef __ASSEMBLY__
+
+#include <asm/unistd.h>
+#include <asm/vdso/vdso.h>
+
+static __always_inline ssize_t getrandom_syscall(void *_buffer,
+						 size_t _len,
+						 unsigned int _flags)
+{
+	register long ret asm("a0");
+	register long int nr asm("a7") = __NR_getrandom;
+	register void *buffer asm("a0") = _buffer;
+	register size_t len asm("a1") = _len;
+	register unsigned int flags asm("a2") = _flags;
+
+	asm volatile(
+	"      syscall 0\n"
+	: "+r" (ret)
+	: "r" (nr), "r" (buffer), "r" (len), "r" (flags)
+	: "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7", "$t8",
+	  "memory");
+
+	return ret;
+}
+
+static __always_inline const struct vdso_rng_data *__arch_get_vdso_rng_data(
+	void)
+{
+	return (const struct vdso_rng_data *)(
+		get_vdso_data() +
+		VVAR_LOONGARCH_PAGES_START * PAGE_SIZE +
+		offsetof(struct loongarch_vdso_data, rng_data));
+}
+
+extern void __arch_chacha20_blocks_nostack(u8 *dst_bytes, const u32 *key,
+					   u32 *counter, size_t nblocks);
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* __ASM_VDSO_GETRANDOM_H */
diff --git a/arch/loongarch/include/asm/vdso/vdso.h b/arch/loongarch/include/asm/vdso/vdso.h
index 5a12309d9fb5..a2e24c3007e2 100644
--- a/arch/loongarch/include/asm/vdso/vdso.h
+++ b/arch/loongarch/include/asm/vdso/vdso.h
@@ -4,6 +4,9 @@
  * Copyright (C) 2020-2022 Loongson Technology Corporation Limited
  */
 
+#ifndef _ASM_VDSO_VDSO_H
+#define _ASM_VDSO_VDSO_H
+
 #ifndef __ASSEMBLY__
 
 #include <asm/asm.h>
@@ -16,6 +19,9 @@ struct vdso_pcpu_data {
 
 struct loongarch_vdso_data {
 	struct vdso_pcpu_data pdata[NR_CPUS];
+#ifdef CONFIG_VDSO_GETRANDOM
+	struct vdso_rng_data rng_data;
+#endif
 };
 
 /*
@@ -63,3 +69,5 @@ static inline unsigned long get_vdso_data(void)
 }
 
 #endif /* __ASSEMBLY__ */
+
+#endif
diff --git a/arch/loongarch/kernel/asm-offsets.c b/arch/loongarch/kernel/asm-offsets.c
index bee9f7a3108f..86f6d8a6dc23 100644
--- a/arch/loongarch/kernel/asm-offsets.c
+++ b/arch/loongarch/kernel/asm-offsets.c
@@ -14,6 +14,7 @@
 #include <asm/ptrace.h>
 #include <asm/processor.h>
 #include <asm/ftrace.h>
+#include <asm/vdso/vdso.h>
 
 static void __used output_ptreg_defines(void)
 {
@@ -321,3 +322,12 @@ static void __used output_kvm_defines(void)
 	OFFSET(KVM_GPGD, kvm, arch.pgd);
 	BLANK();
 }
+
+#ifdef CONFIG_VDSO_GETRANDOM
+static void __used output_vdso_rng_defines(void)
+{
+	COMMENT("LoongArch VDSO getrandom offsets.");
+	OFFSET(VDSO_RNG_DATA, loongarch_vdso_data, rng_data);
+	BLANK();
+}
+#endif
diff --git a/arch/loongarch/kernel/vdso.c b/arch/loongarch/kernel/vdso.c
index d606ddf65b97..d500436f252b 100644
--- a/arch/loongarch/kernel/vdso.c
+++ b/arch/loongarch/kernel/vdso.c
@@ -23,6 +23,7 @@
 #include <vdso/helpers.h>
 #include <vdso/vsyscall.h>
 #include <vdso/datapage.h>
+#include <generated/asm-offsets.h>
 #include <generated/vdso-offsets.h>
 
 extern char vdso_start[], vdso_end[];
@@ -35,6 +36,11 @@ static union {
 	struct loongarch_vdso_data vdata;
 } loongarch_vdso_data __page_aligned_data;
 
+#ifdef CONFIG_VDSO_GETRANDOM
+asm(".globl _vdso_rng_data\n"
+    ".set _vdso_rng_data, loongarch_vdso_data + " __stringify(VDSO_RNG_DATA));
+#endif
+
 static struct page *vdso_pages[] = { NULL };
 struct vdso_data *vdso_data = generic_vdso_data.data;
 struct vdso_pcpu_data *vdso_pdata = loongarch_vdso_data.vdata.pdata;
diff --git a/arch/loongarch/vdso/Makefile b/arch/loongarch/vdso/Makefile
index 2ddf0480e710..4be33ec54d1d 100644
--- a/arch/loongarch/vdso/Makefile
+++ b/arch/loongarch/vdso/Makefile
@@ -6,6 +6,8 @@ include $(srctree)/lib/vdso/Makefile
 
 obj-vdso-y := elf.o vgetcpu.o vgettimeofday.o sigreturn.o
 
+obj-vdso-$(CONFIG_VDSO_GETRANDOM) += vgetrandom.o vgetrandom-chacha.o vgetrandom-alt.o memset.o
+
 # Common compiler flags between ABIs.
 ccflags-vdso := \
 	$(filter -I%,$(KBUILD_CFLAGS)) \
diff --git a/arch/loongarch/vdso/memset.S b/arch/loongarch/vdso/memset.S
new file mode 100644
index 000000000000..ec1531683936
--- /dev/null
+++ b/arch/loongarch/vdso/memset.S
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * A copy of __memset_generic from arch/loongarch/lib/memset.S for vDSO.
+ *
+ * Copyright (C) 2020-2024 Loongson Technology Corporation Limited
+ */
+
+#include <asm/regdef.h>
+#include <linux/linkage.h>
+
+SYM_FUNC_START(memset)
+	move	a3, a0
+	beqz	a2, 2f
+
+1:	st.b	a1, a0, 0
+	addi.d	a0, a0, 1
+	addi.d	a2, a2, -1
+	bgt	a2, zero, 1b
+
+2:	move	a0, a3
+	jr	ra
+SYM_FUNC_END(memset)
+
+.hidden memset
diff --git a/arch/loongarch/vdso/vdso.lds.S b/arch/loongarch/vdso/vdso.lds.S
index 746d31bd4e90..ac63dc080bc9 100644
--- a/arch/loongarch/vdso/vdso.lds.S
+++ b/arch/loongarch/vdso/vdso.lds.S
@@ -69,6 +69,7 @@ VERSION
 		__vdso_clock_gettime;
 		__vdso_gettimeofday;
 		__vdso_rt_sigreturn;
+		__vdso_getrandom;
 	local: *;
 	};
 }
diff --git a/arch/loongarch/vdso/vgetrandom-alt.S b/arch/loongarch/vdso/vgetrandom-alt.S
new file mode 100644
index 000000000000..655b9f0dfece
--- /dev/null
+++ b/arch/loongarch/vdso/vgetrandom-alt.S
@@ -0,0 +1,19 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2024 Xi Ruoyao <xry111@xry111.site>. All Rights Reserved.
+ *
+ */
+
+#include <asm/alternative-asm.h>
+#include <asm/cpu.h>
+#include <asm/unistd.h>
+#include <asm/regdef.h>
+#include <linux/linkage.h>
+
+SYM_FUNC_START(__vdso_getrandom)
+	ALTERNATIVE	__stringify(li.w a7, __NR_getrandom; syscall 0; jr ra), \
+			"b __vdso_getrandom_lsx", CPU_FEATURE_LSX
+SYM_FUNC_END(__vdso_getrandom)
+
+.weak	getrandom
+.set	getrandom, __vdso_getrandom
diff --git a/arch/loongarch/vdso/vgetrandom-chacha.S b/arch/loongarch/vdso/vgetrandom-chacha.S
new file mode 100644
index 000000000000..be385b04c3ea
--- /dev/null
+++ b/arch/loongarch/vdso/vgetrandom-chacha.S
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
+ * Very basic SSE2 implementation of ChaCha20. Produces a given positive
+ * number of blocks of output with a nonce of 0, taking an input key and
+ * 8-byte counter. Importantly does not spill to the stack. Its arguments
+ * are:
+ *
+ *	a0: output bytes
+ *	a1: 32-byte key input
+ *	a2: 8-byte counter input/output
+ *	a3: number of 64-byte blocks to write to output
+ */
+SYM_FUNC_START(__arch_chacha20_blocks_nostack)
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
+SYM_FUNC_END(__arch_chacha20_blocks_nostack)
diff --git a/arch/loongarch/vdso/vgetrandom.c b/arch/loongarch/vdso/vgetrandom.c
new file mode 100644
index 000000000000..fd09c3847b65
--- /dev/null
+++ b/arch/loongarch/vdso/vgetrandom.c
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2024 Xi Ruoyao <xry111@xry111.site>. All Rights Reserved.
+ */
+#include <linux/types.h>
+
+#include "../../../../lib/vdso/getrandom.c"
+
+typeof(__cvdso_getrandom) __vdso_getrandom_lsx;
+
+ssize_t __vdso_getrandom_lsx(void *buffer, size_t len, unsigned int flags,
+			     void *opaque_state, size_t opaque_len)
+{
+	return __cvdso_getrandom(buffer, len, flags, opaque_state,
+				 opaque_len);
+}
-- 
2.46.0

