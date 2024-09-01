Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B73E13959D;
	Sun,  1 Sep 2024 06:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725171247; cv=none; b=sH8m+p56Oz2Sa7w5DOIWXzBWiLVo1u29SMoZG01MwXIzgD2hRCv8B+SydIHJoDv2GZBncByn0Znw0Z/goNMoUXoL+jAJloHI4qO8UrE0FyrdskTqdneOzGsz8MCniHjxp0gw/+PJHZPj/QlksJtg0Unm0vtugoVzT/nyUKHCuCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725171247; c=relaxed/simple;
	bh=8r/TYoie9ZjfgF7+EdoASg241uqaCTovNC/COaJsEo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JrrwzEY2lwz8o/CzyoSffUNOStc6kbWIgB2XG+G0Be5Au3TZ+3k/oAVXSNEg8EJGo2E2m+56KVCCVZ3HYZPsMPk7FyCN4/08KsvRpnMIK/kdwDl7USNkBigA8L5Uy1542qDn5EyvJshMtQJ7xveU5rbiSTdA/jU+qYiCtG8QV0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Received: from stargazer.. (unknown [IPv6:240e:358:11b0:f100:dc73:854d:832e:2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 535361A3FE2;
	Sun,  1 Sep 2024 02:13:56 -0400 (EDT)
From: Xi Ruoyao <xry111@xry111.site>
To: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>
Cc: Xi Ruoyao <xry111@xry111.site>,
	linux-crypto@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v6 2/3] LoongArch: vDSO: Wire up getrandom() vDSO implementation
Date: Sun,  1 Sep 2024 14:13:11 +0800
Message-ID: <20240901061315.15693-3-xry111@xry111.site>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901061315.15693-1-xry111@xry111.site>
References: <20240901061315.15693-1-xry111@xry111.site>
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
 arch/loongarch/include/asm/vdso/getrandom.h |  38 +++
 arch/loongarch/include/asm/vdso/vdso.h      |   6 +
 arch/loongarch/include/asm/vdso/vsyscall.h  |   8 +
 arch/loongarch/kernel/vdso.c                |   1 +
 arch/loongarch/vdso/Makefile                |   7 +-
 arch/loongarch/vdso/vdso.lds.S              |   1 +
 arch/loongarch/vdso/vgetrandom-chacha.S     | 242 ++++++++++++++++++++
 arch/loongarch/vdso/vgetrandom.c            |  10 +
 9 files changed, 313 insertions(+), 1 deletion(-)
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
index 000000000000..f2d17daec1e2
--- /dev/null
+++ b/arch/loongarch/include/asm/vdso/getrandom.h
@@ -0,0 +1,38 @@
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
+static __always_inline ssize_t getrandom_syscall(void *_buffer, size_t _len, unsigned int _flags)
+{
+	register long ret asm("a0");
+	register long nr asm("a7") = __NR_getrandom;
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
+static __always_inline const struct vdso_rng_data *__arch_get_vdso_rng_data(void)
+{
+	return (const struct vdso_rng_data *)(get_vdso_data() + VVAR_LOONGARCH_PAGES_START * PAGE_SIZE + offsetof(struct loongarch_vdso_data, rng_data));
+}
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* __ASM_VDSO_GETRANDOM_H */
diff --git a/arch/loongarch/include/asm/vdso/vdso.h b/arch/loongarch/include/asm/vdso/vdso.h
index 5a12309d9fb5..e31ac7474513 100644
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
@@ -16,6 +19,7 @@ struct vdso_pcpu_data {
 
 struct loongarch_vdso_data {
 	struct vdso_pcpu_data pdata[NR_CPUS];
+	struct vdso_rng_data rng_data;
 };
 
 /*
@@ -63,3 +67,5 @@ static inline unsigned long get_vdso_data(void)
 }
 
 #endif /* __ASSEMBLY__ */
+
+#endif
diff --git a/arch/loongarch/include/asm/vdso/vsyscall.h b/arch/loongarch/include/asm/vdso/vsyscall.h
index 5de615383a22..b1273ce6f140 100644
--- a/arch/loongarch/include/asm/vdso/vsyscall.h
+++ b/arch/loongarch/include/asm/vdso/vsyscall.h
@@ -8,6 +8,7 @@
 #include <vdso/datapage.h>
 
 extern struct vdso_data *vdso_data;
+extern struct vdso_rng_data *vdso_rng_data;
 
 /*
  * Update the vDSO data page to keep in sync with kernel timekeeping.
@@ -19,6 +20,13 @@ struct vdso_data *__loongarch_get_k_vdso_data(void)
 }
 #define __arch_get_k_vdso_data __loongarch_get_k_vdso_data
 
+static __always_inline
+struct vdso_rng_data *__loongarch_get_k_vdso_rng_data(void)
+{
+	return vdso_rng_data;
+}
+#define __arch_get_k_vdso_rng_data __loongarch_get_k_vdso_rng_data
+
 /* The asm-generic header needs to be included after the definitions above */
 #include <asm-generic/vdso/vsyscall.h>
 
diff --git a/arch/loongarch/kernel/vdso.c b/arch/loongarch/kernel/vdso.c
index 90dfccb41c14..f6fcc52aefae 100644
--- a/arch/loongarch/kernel/vdso.c
+++ b/arch/loongarch/kernel/vdso.c
@@ -37,6 +37,7 @@ static union {
 static struct page *vdso_pages[] = { NULL };
 struct vdso_data *vdso_data = generic_vdso_data.data;
 struct vdso_pcpu_data *vdso_pdata = loongarch_vdso_data.vdata.pdata;
+struct vdso_rng_data *vdso_rng_data = &loongarch_vdso_data.vdata.rng_data;
 
 static int vdso_mremap(const struct vm_special_mapping *sm, struct vm_area_struct *new_vma)
 {
diff --git a/arch/loongarch/vdso/Makefile b/arch/loongarch/vdso/Makefile
index d724d46b07c8..40c1175823d6 100644
--- a/arch/loongarch/vdso/Makefile
+++ b/arch/loongarch/vdso/Makefile
@@ -4,7 +4,8 @@
 # Include the generic Makefile to check the built vdso.
 include $(srctree)/lib/vdso/Makefile
 
-obj-vdso-y := elf.o vgetcpu.o vgettimeofday.o sigreturn.o
+obj-vdso-y := elf.o vgetcpu.o vgettimeofday.o vgetrandom.o \
+              vgetrandom-chacha.o sigreturn.o
 
 # Common compiler flags between ABIs.
 ccflags-vdso := \
@@ -29,6 +30,10 @@ ifneq ($(c-gettimeofday-y),)
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
index 56ad855896de..6b441bde4026 100644
--- a/arch/loongarch/vdso/vdso.lds.S
+++ b/arch/loongarch/vdso/vdso.lds.S
@@ -62,6 +62,7 @@ VERSION
 		__vdso_clock_getres;
 		__vdso_clock_gettime;
 		__vdso_gettimeofday;
+		__vdso_getrandom;
 		__vdso_rt_sigreturn;
 	local: *;
 	};
diff --git a/arch/loongarch/vdso/vgetrandom-chacha.S b/arch/loongarch/vdso/vgetrandom-chacha.S
new file mode 100644
index 000000000000..7e86a50f6e85
--- /dev/null
+++ b/arch/loongarch/vdso/vgetrandom-chacha.S
@@ -0,0 +1,242 @@
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
+	/*
+	 * copy[3] = "expa", materialize it here because copy[3] shares the
+	 * same register with i which just became dead.
+	 */
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
index 000000000000..d5f258ac4a36
--- /dev/null
+++ b/arch/loongarch/vdso/vgetrandom.c
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2024 Xi Ruoyao <xry111@xry111.site>. All Rights Reserved.
+ */
+#include <linux/types.h>
+
+ssize_t __vdso_getrandom(void *buffer, size_t len, unsigned int flags, void *opaque_state, size_t opaque_len)
+{
+	return __cvdso_getrandom(buffer, len, flags, opaque_state, opaque_len);
+}
-- 
2.46.0

