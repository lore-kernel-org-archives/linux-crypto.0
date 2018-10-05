From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 2/9] arm64: kernel: add arch support for patchable function pointers
Date: Fri,  5 Oct 2018 10:13:26 +0200
Message-ID: <20181005081333.15018-3-ard.biesheuvel@linaro.org>
References: <20181005081333.15018-1-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181005081333.15018-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Implement arm64 support for patchable function pointers by emitting
them as branch instructions (and a couple of NOPs in case the new
target is out of range of a normal branch instruction.)

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/Kconfig           |  1 +
 arch/arm64/include/asm/ffp.h | 35 ++++++++++++++++++++
 arch/arm64/kernel/insn.c     | 22 ++++++++++++
 3 files changed, 58 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1b1a0e95c751..db8c9e51c56d 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -102,6 +102,7 @@ config ARM64
 	select HAVE_ALIGNED_STRUCT_PAGE if SLUB
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_BITREVERSE
+	select HAVE_ARCH_FFP
 	select HAVE_ARCH_HUGE_VMAP
 	select HAVE_ARCH_JUMP_LABEL
 	select HAVE_ARCH_KASAN if !(ARM64_16K_PAGES && ARM64_VA_BITS_48)
diff --git a/arch/arm64/include/asm/ffp.h b/arch/arm64/include/asm/ffp.h
new file mode 100644
index 000000000000..678dc1262218
--- /dev/null
+++ b/arch/arm64/include/asm/ffp.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __ASM_FFP_H
+#define __ASM_FFP_H
+
+struct ffp {
+	u32	insn[5];
+	u32	def_branch;
+};
+
+#define DECLARE_FFP(_fn, _def)						\
+	extern typeof(_def) _fn;					\
+	extern struct ffp const __ffp_ ## _fn
+
+#define DEFINE_FFP(_fn, _def)						\
+	DECLARE_FFP(_fn, _def);						\
+	asm("	.pushsection	\".text\", \"ax\", %progbits	\n"	\
+	    "	.align		3				\n"	\
+	    "	.globl		" #_fn "			\n"	\
+	    "	.globl		__ffp_" #_fn "			\n"	\
+	    #_fn " :						\n"	\
+	    "__ffp_" #_fn " :					\n"	\
+	    "		b	" #_def "			\n"	\
+	    "		nop					\n"	\
+	    "		nop					\n"	\
+	    "		nop					\n"	\
+	    "		nop					\n"	\
+	    "		b	" #_def "			\n"	\
+	    "	.popsection					\n");	\
+	EXPORT_SYMBOL(__ffp_ ## _fn)
+
+extern void ffp_set_target(const struct ffp *m, void *new_fn);
+extern void ffp_reset_target(const struct ffp *m);
+
+#endif
diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
index 2b3413549734..a2ed547fd171 100644
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -30,6 +30,7 @@
 #include <asm/cacheflush.h>
 #include <asm/debug-monitors.h>
 #include <asm/fixmap.h>
+#include <asm/ffp.h>
 #include <asm/insn.h>
 #include <asm/kprobes.h>
 
@@ -1603,3 +1604,24 @@ u32 aarch64_insn_gen_extr(enum aarch64_insn_variant variant,
 	insn = aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RN, insn, Rn);
 	return aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RM, insn, Rm);
 }
+
+void ffp_set_target(const struct ffp *m, void *new_fn)
+{
+	u32 branch = aarch64_insn_gen_branch_imm((u64)m, (u64)new_fn,
+						 AARCH64_INSN_BRANCH_NOLINK);
+
+	if (branch == AARCH64_BREAK_FAULT) {
+		/* TODO out of range - use a PLT sequence instead */
+	} else {
+		aarch64_insn_patch_text((void *[]){ (void *)m }, &branch, 1);
+	}
+}
+EXPORT_SYMBOL(ffp_set_target);
+
+void ffp_reset_target(const struct ffp *m)
+{
+	u32 branch = le32_to_cpu(m->def_branch);
+
+	aarch64_insn_patch_text((void *[]){ (void *)m }, &branch, 1);
+}
+EXPORT_SYMBOL(ffp_reset_target);
-- 
2.11.0
