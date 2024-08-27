Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A651C0DCE
	for <linux-crypto@vger.kernel.org>; Tue, 27 Aug 2024 13:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724764834; cv=none; b=Sn1thVK7l/2B/C7OKLBRGRscRfbeh3lNR2LERtucLOctr3xB4710qfVPws/ug81hzvByYBDD8R51+ic7h8AvXaRzJ2xAmCLUs/lPFFoLurtH3Jq/j0ZdbmTGzl9jhBvKoAkKpJFkgnSYMZ6E5xodznrtMYrw2bt8tkhS5gzEyOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724764834; c=relaxed/simple;
	bh=lDenvFzsMNJr0xBLRlxbqjR9eI3tHe1IHdegHOf1QTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ET+xKplz0mx6tfkZqFuKFrmRYvhH+y40No2gZ+fl+zhC8LrRWoCLfFmzt5WyqvlrBv61besdu5du8F7Qjh8oiC2OsV5mMm9fKrZ+7jxZoP/qWv1XoXBcUmOmeLb4ohxlkh2vssXVot+9jeQVFur+/0rLxR4TBHWerpJ5VaW6x2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=JTMa81Ox; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="JTMa81Ox"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1724764831;
	bh=lDenvFzsMNJr0xBLRlxbqjR9eI3tHe1IHdegHOf1QTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JTMa81Ox2204thDXQ1TiWd2cHWda87U5beEMwx8s91zIKiDEmSK8EqSVZFiastN1L
	 +28slUaM/BWNGrOSeSsGAs9jCyNhJ+up9/c9UsNI2ldAfVAEnBVd9X9k49pQDwNphc
	 sDe59zaDy/4Eg5VTtJStGmWfepDRnJ0vpYL7jGdQ=
Received: from stargazer.. (unknown [113.200.174.85])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id C4B8666F27;
	Tue, 27 Aug 2024 09:20:28 -0400 (EDT)
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
Subject: [PATCH v4 1/4] LoongArch: vDSO: Wire up getrandom() vDSO implementation
Date: Tue, 27 Aug 2024 21:20:14 +0800
Message-ID: <20240827132018.88854-2-xry111@xry111.site>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827132018.88854-1-xry111@xry111.site>
References: <20240827132018.88854-1-xry111@xry111.site>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hook up the generic vDSO implementation to the LoongArch vDSO data page
by providing the required __arch_chacha20_blocks_nostack,
__arch_get_k_vdso_rng_data, and getrandom_syscall implementations.

Signed-off-by: Xi Ruoyao <xry111@xry111.site>
---
 arch/loongarch/Kconfig                      |   1 +
 arch/loongarch/include/asm/vdso/getrandom.h |  47 ++++
 arch/loongarch/include/asm/vdso/vdso.h      |   8 +
 arch/loongarch/include/asm/vdso/vsyscall.h  |  10 +
 arch/loongarch/kernel/asm-offsets.c         |  10 +
 arch/loongarch/kernel/vdso.c                |   2 +
 arch/loongarch/vdso/Makefile                |   6 +
 arch/loongarch/vdso/vdso.lds.S              |   1 +
 arch/loongarch/vdso/vgetrandom-chacha.S     | 239 ++++++++++++++++++++
 arch/loongarch/vdso/vgetrandom.c            |  12 +
 10 files changed, 336 insertions(+)
 create mode 100644 arch/loongarch/include/asm/vdso/getrandom.h
 create mode 100644 arch/loongarch/vdso/vgetrandom-chacha.S
 create mode 100644 arch/loongarch/vdso/vgetrandom.c

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index 70f169210b52..14821c2aba5b 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -190,6 +190,7 @@ config LOONGARCH
 	select TRACE_IRQFLAGS_SUPPORT
 	select USE_PERCPU_NUMA_NODE_ID
 	select USER_STACKTRACE_SUPPORT
+	select VDSO_GETRANDOM
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
diff --git a/arch/loongarch/include/asm/vdso/vsyscall.h b/arch/loongarch/include/asm/vdso/vsyscall.h
index 5de615383a22..dbc0c8aaec59 100644
--- a/arch/loongarch/include/asm/vdso/vsyscall.h
+++ b/arch/loongarch/include/asm/vdso/vsyscall.h
@@ -8,6 +8,7 @@
 #include <vdso/datapage.h>
 
 extern struct vdso_data *vdso_data;
+extern struct vdso_rng_data *vdso_rng_data;
 
 /*
  * Update the vDSO data page to keep in sync with kernel timekeeping.
@@ -19,6 +20,15 @@ struct vdso_data *__loongarch_get_k_vdso_data(void)
 }
 #define __arch_get_k_vdso_data __loongarch_get_k_vdso_data
 
+#ifdef CONFIG_VDSO_GETRANDOM
+static __always_inline
+struct vdso_rng_data *__loongarch_get_k_vdso_rng_data(void)
+{
+	return vdso_rng_data;
+}
+#define __arch_get_k_vdso_rng_data __loongarch_get_k_vdso_rng_data
+#endif
+
 /* The asm-generic header needs to be included after the definitions above */
 #include <asm-generic/vdso/vsyscall.h>
 
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
index 90dfccb41c14..2af05ba5f121 100644
--- a/arch/loongarch/kernel/vdso.c
+++ b/arch/loongarch/kernel/vdso.c
@@ -22,6 +22,7 @@
 #include <vdso/helpers.h>
 #include <vdso/vsyscall.h>
 #include <vdso/datapage.h>
+#include <generated/asm-offsets.h>
 #include <generated/vdso-offsets.h>
 
 extern char vdso_start[], vdso_end[];
@@ -37,6 +38,7 @@ static union {
 static struct page *vdso_pages[] = { NULL };
 struct vdso_data *vdso_data = generic_vdso_data.data;
 struct vdso_pcpu_data *vdso_pdata = loongarch_vdso_data.vdata.pdata;
+struct vdso_rng_data *vdso_rng_data = &loongarch_vdso_data.vdata.rng_data;
 
 static int vdso_mremap(const struct vm_special_mapping *sm, struct vm_area_struct *new_vma)
 {
diff --git a/arch/loongarch/vdso/Makefile b/arch/loongarch/vdso/Makefile
index d724d46b07c8..252ed56aa489 100644
--- a/arch/loongarch/vdso/Makefile
+++ b/arch/loongarch/vdso/Makefile
@@ -6,6 +6,8 @@ include $(srctree)/lib/vdso/Makefile
 
 obj-vdso-y := elf.o vgetcpu.o vgettimeofday.o sigreturn.o
 
+obj-vdso-$(CONFIG_VDSO_GETRANDOM) += vgetrandom.o vgetrandom-chacha.o
+
 # Common compiler flags between ABIs.
 ccflags-vdso := \
 	$(filter -I%,$(KBUILD_CFLAGS)) \
@@ -29,6 +31,10 @@ ifneq ($(c-gettimeofday-y),)
   CFLAGS_vgettimeofday.o += -include $(c-gettimeofday-y)
 endif
 
+ifneq ($(c-getrandom-y),)
+  CFLAGS_vgetrandom.o += -include $(c-getrandom-y)
+endif
+
 # VDSO linker flags.
 ldflags-y := -Bsymbolic --no-undefined -soname=linux-vdso.so.1 \
 	$(filter -E%,$(KBUILD_CFLAGS)) -nostdlib -shared \
diff --git a/arch/loongarch/vdso/vdso.lds.S b/arch/loongarch/vdso/vdso.lds.S
index 56ad855896de..2c965a597d9e 100644
--- a/arch/loongarch/vdso/vdso.lds.S
+++ b/arch/loongarch/vdso/vdso.lds.S
@@ -63,6 +63,7 @@ VERSION
 		__vdso_clock_gettime;
 		__vdso_gettimeofday;
 		__vdso_rt_sigreturn;
+		__vdso_getrandom;
 	local: *;
 	};
 }
diff --git a/arch/loongarch/vdso/vgetrandom-chacha.S b/arch/loongarch/vdso/vgetrandom-chacha.S
new file mode 100644
index 000000000000..2e42198f2faf
--- /dev/null
+++ b/arch/loongarch/vdso/vgetrandom-chacha.S
@@ -0,0 +1,239 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2024 Xi Ruoyao <xry111@xry111.site>. All Rights Reserved.
+ */
+
+#include <asm/asm.h>
+#include <asm/regdef.h>
+#include <linux/linkage.h>
+
+.text
+
+/* Salsa20 quarter-round */
+.macro	QR	a b c d
+	add.w		\a, \a, \b
+	xor		\d, \d, \a
+	rotri.w		\d, \d, 16
+
+	add.w		\c, \c, \d
+	xor		\b, \b, \c
+	rotri.w		\b, \b, 20
+
+	add.w		\a, \a, \b
+	xor		\d, \d, \a
+	rotri.w		\d, \d, 24
+
+	add.w		\c, \c, \d
+	xor		\b, \b, \c
+	rotri.w		\b, \b, 25
+.endm
+
+/*
+ * Very basic LoongArch implementation of ChaCha20. Produces a given positive
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
+
+/* We don't need a frame pointer */
+#define s9		fp
+
+#define output		a0
+#define key		a1
+#define counter		a2
+#define nblocks		a3
+#define i		a4
+#define state0		s0
+#define state1		s1
+#define state2		s2
+#define state3		s3
+#define state4		s4
+#define state5		s5
+#define state6		s6
+#define state7		s7
+#define state8		s8
+#define state9		s9
+#define state10		a5
+#define state11		a6
+#define state12		a7
+#define state13		t0
+#define state14		t1
+#define state15		t2
+#define cnt_lo		t3
+#define cnt_hi		t4
+#define copy0		t5
+#define copy1		t6
+#define copy2		t7
+
+/* Reuse i as copy3 */
+#define copy3		i
+
+	/*
+	 * The ABI requires s0-s9 saved, and sp aligned to 16-byte.
+	 * This does not violate the stack-less requirement: no sensitive data
+	 * is spilled onto the stack.
+	 */
+	PTR_ADDI	sp, sp, (-SZREG * 10) & STACK_ALIGN
+	REG_S		s0, sp, 0
+	REG_S		s1, sp, SZREG
+	REG_S		s2, sp, SZREG * 2
+	REG_S		s3, sp, SZREG * 3
+	REG_S		s4, sp, SZREG * 4
+	REG_S		s5, sp, SZREG * 5
+	REG_S		s6, sp, SZREG * 6
+	REG_S		s7, sp, SZREG * 7
+	REG_S		s8, sp, SZREG * 8
+	REG_S		s9, sp, SZREG * 9
+
+	li.w		copy0, 0x61707865
+	li.w		copy1, 0x3320646e
+	li.w		copy2, 0x79622d32
+
+	ld.w		cnt_lo, counter, 0
+	ld.w		cnt_hi, counter, 4
+
+.Lblock:
+	/* state[0,1,2,3] = "expand 32-byte k" */
+	move		state0, copy0
+	move		state1, copy1
+	move		state2, copy2
+	li.w		state3, 0x6b206574
+
+	/* state[4,5,..,11] = key */
+	ld.w		state4, key, 0
+	ld.w		state5, key, 4
+	ld.w		state6, key, 8
+	ld.w		state7, key, 12
+	ld.w		state8, key, 16
+	ld.w		state9, key, 20
+	ld.w		state10, key, 24
+	ld.w		state11, key, 28
+
+	/* state[12,13] = counter */
+	move		state12, cnt_lo
+	move		state13, cnt_hi
+
+	/* state[14,15] = 0 */
+	move		state14, zero
+	move		state15, zero
+
+	li.w		i, 10
+.Lpermute:
+	/* odd round */
+	QR		state0, state4, state8, state12
+	QR		state1, state5, state9, state13
+	QR		state2, state6, state10, state14
+	QR		state3, state7, state11, state15
+
+	/* even round */
+	QR		state0, state5, state10, state15
+	QR		state1, state6, state11, state12
+	QR		state2, state7, state8, state13
+	QR		state3, state4, state9, state14
+
+	addi.w		i, i, -1
+	bnez		i, .Lpermute
+
+	/* copy[3] = "expa" */
+	li.w		copy3, 0x6b206574
+
+	/* output[0,1,2,3] = copy[0,1,2,3] + state[0,1,2,3] */
+	add.w		state0, state0, copy0
+	add.w		state1, state1, copy1
+	add.w		state2, state2, copy2
+	add.w		state3, state3, copy3
+	st.w		state0, output, 0
+	st.w		state1, output, 4
+	st.w		state2, output, 8
+	st.w		state3, output, 12
+
+	/* from now on state[0,1,2,3] are scratch registers  */
+
+	/* state[0,1,2,3] = lo32(key) */
+	ld.w		state0, key, 0
+	ld.w		state1, key, 4
+	ld.w		state2, key, 8
+	ld.w		state3, key, 12
+
+	/* output[4,5,6,7] = state[0,1,2,3] + state[4,5,6,7] */
+	add.w		state4, state4, state0
+	add.w		state5, state5, state1
+	add.w		state6, state6, state2
+	add.w		state7, state7, state3
+	st.w		state4, output, 16
+	st.w		state5, output, 20
+	st.w		state6, output, 24
+	st.w		state7, output, 28
+
+	/* state[0,1,2,3] = hi32(key) */
+	ld.w		state0, key, 16
+	ld.w		state1, key, 20
+	ld.w		state2, key, 24
+	ld.w		state3, key, 28
+
+	/* output[8,9,10,11] = state[0,1,2,3] + state[8,9,10,11] */
+	add.w		state8, state8, state0
+	add.w		state9, state9, state1
+	add.w		state10, state10, state2
+	add.w		state11, state11, state3
+	st.w		state8, output, 32
+	st.w		state9, output, 36
+	st.w		state10, output, 40
+	st.w		state11, output, 44
+
+	/* output[12,13,14,15] = state[12,13,14,15] + [cnt_lo, cnt_hi, 0, 0] */
+	add.w		state12, state12, cnt_lo
+	add.w		state13, state13, cnt_hi
+	st.w		state12, output, 48
+	st.w		state13, output, 52
+	st.w		state14, output, 56
+	st.w		state15, output, 60
+
+	/* ++counter  */
+	addi.w		cnt_lo, cnt_lo, 1
+	sltui		state0, cnt_lo, 1
+	add.w		cnt_hi, cnt_hi, state0
+
+	/* output += 64 */
+	PTR_ADDI	output, output, 64
+	/* --nblocks */
+	PTR_ADDI	nblocks, nblocks, -1
+	bnez		nblocks, .Lblock
+
+	/* counter = [cnt_lo, cnt_hi] */
+	st.w		cnt_lo, counter, 0
+	st.w		cnt_hi, counter, 4
+
+	/*
+	 * Zero out the potentially sensitive regs, in case nothing uses these
+	 * again. As at now copy[0,1,2,3] just contains "expand 32-byte k" and
+	 * state[0,...,9] are s0-s9 those we'll restore in the epilogue, so we
+	 * only need to zero state[11,...,15].
+	 */
+	move		state10, zero
+	move		state11, zero
+	move		state12, zero
+	move		state13, zero
+	move		state14, zero
+	move		state15, zero
+
+	REG_L		s0, sp, 0
+	REG_L		s1, sp, SZREG
+	REG_L		s2, sp, SZREG * 2
+	REG_L		s3, sp, SZREG * 3
+	REG_L		s4, sp, SZREG * 4
+	REG_L		s5, sp, SZREG * 5
+	REG_L		s6, sp, SZREG * 6
+	REG_L		s7, sp, SZREG * 7
+	REG_L		s8, sp, SZREG * 8
+	REG_L		s9, sp, SZREG * 9
+	PTR_ADDI	sp, sp, -((-SZREG * 10) & STACK_ALIGN)
+
+	jr		ra
+SYM_FUNC_END(__arch_chacha20_blocks_nostack)
diff --git a/arch/loongarch/vdso/vgetrandom.c b/arch/loongarch/vdso/vgetrandom.c
new file mode 100644
index 000000000000..b9142a5b5d77
--- /dev/null
+++ b/arch/loongarch/vdso/vgetrandom.c
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2024 Xi Ruoyao <xry111@xry111.site>. All Rights Reserved.
+ */
+#include <linux/types.h>
+
+ssize_t __vdso_getrandom(void *buffer, size_t len, unsigned int flags,
+			 void *opaque_state, size_t opaque_len)
+{
+	return __cvdso_getrandom(buffer, len, flags, opaque_state,
+				 opaque_len);
+}
-- 
2.46.0

