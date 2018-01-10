From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH] arm64/kernel: don't ban ADRP to work around Cortex-A53 erratum #843419
Date: Wed, 10 Jan 2018 16:19:27 +0000
Message-ID: <20180110161927.8775-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, will.deacon@arm.com,
        catalin.marinas@arm.com, marc.zyngier@arm.com,
        mark.rutland@arm.com, dann.frazier@canonical.com,
        steve.capper@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:37981 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965818AbeAJQTg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Jan 2018 11:19:36 -0500
Received: by mail-wr0-f194.google.com with SMTP id 60so8843069wrl.5
        for <linux-crypto@vger.kernel.org>; Wed, 10 Jan 2018 08:19:36 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Working around Cortex-A53 erratum #843419 involves special handling of
ADRP instructions that end up in the last two instruction slots of a
4k page, or whose output register gets overwritten without having been
read.

Normally, this gets taken care of by the linker, which can spot such
sequences at final link time, and insert a veneer if the ADRP ends up
at a vulnerable offset. However, linux kernel modules are partially
linked binaries, and so there is no 'final link time' other than the
runtime loading of the module, at which time all the static relocations
are resolved.

For this reason, we have implemented the #843419 workaround for modules
by avoiding ADRP instructions altogether, by using the large C model,
and by passing -mpc-relative-literal-loads to recent versions of GCC
that may emit adrp/ldr pairs to perform literal loads. However, this
workaround forces us to keep literal data mixed with the instructions
in the executable .text segment, and literal data may inadvertently
turn into an exploitable speculative gadget depending on the relative
offsets of arbitrary symbols.

So let's reimplement this workaround in a way that allows us to switch
back to the small C model, and to drop the -mpc-relative-literal-loads
GCC switch, by patching affected ADRP instructions at runtime:
- ADRP instructions that do not appear at 4k relative offset 0xff8 or
  0xffc are ignored
- ADRP instructions that are within 1 MB of their target symbol are
  converted into ADR instructions
- remaining ADRP instructions are redirected via a veneer that performs
  the load using an unaffected movn/movk sequence.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/Kconfig                  |  4 +-
 arch/arm64/Makefile                 |  1 -
 arch/arm64/include/asm/module.h     |  2 +
 arch/arm64/kernel/module-plts.c     | 62 ++++++++++++++++++++
 arch/arm64/kernel/module.c          | 32 +++++++++-
 arch/arm64/kernel/reloc_test_core.c |  4 +-
 arch/arm64/kernel/reloc_test_syms.S | 12 +++-
 7 files changed, 107 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index c9a7e9e1414f..fa25de22b4fa 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -452,7 +452,7 @@ config ARM64_ERRATUM_845719
 config ARM64_ERRATUM_843419
 	bool "Cortex-A53: 843419: A load or store might access an incorrect address"
 	default y
-	select ARM64_MODULE_CMODEL_LARGE if MODULES
+	select ARM64_MODULE_PLTS if MODULES
 	help
 	  This option links the kernel with '--fix-cortex-a53-843419' and
 	  builds modules using the large memory model in order to avoid the use
@@ -1039,7 +1039,6 @@ config ARM64_MODULE_CMODEL_LARGE
 
 config ARM64_MODULE_PLTS
 	bool
-	select ARM64_MODULE_CMODEL_LARGE
 	select HAVE_MOD_ARCH_SPECIFIC
 
 config RELOCATABLE
@@ -1056,6 +1055,7 @@ config RELOCATABLE
 config RANDOMIZE_BASE
 	bool "Randomize the address of the kernel image"
 	select ARM64_MODULE_PLTS if MODULES
+	select ARM64_MODULE_CMODEL_LARGE
 	select RELOCATABLE
 	help
 	  Randomizes the virtual address at which the kernel image is
diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index bd7cb205e28a..f49aa51fce05 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -27,7 +27,6 @@ ifeq ($(CONFIG_ARM64_ERRATUM_843419),y)
 $(warning ld does not support --fix-cortex-a53-843419; kernel may be susceptible to erratum)
   else
 LDFLAGS_vmlinux		+= --fix-cortex-a53-843419
-KBUILD_CFLAGS_MODULE	+= $(call cc-option, -mpc-relative-literal-loads)
   endif
 endif
 
diff --git a/arch/arm64/include/asm/module.h b/arch/arm64/include/asm/module.h
index 4f766178fa6f..b6dbbe3123a9 100644
--- a/arch/arm64/include/asm/module.h
+++ b/arch/arm64/include/asm/module.h
@@ -39,6 +39,8 @@ struct mod_arch_specific {
 u64 module_emit_plt_entry(struct module *mod, void *loc, const Elf64_Rela *rela,
 			  Elf64_Sym *sym);
 
+u64 module_emit_adrp_veneer(struct module *mod, void *loc, u64 val);
+
 #ifdef CONFIG_RANDOMIZE_BASE
 extern u64 module_alloc_base;
 #else
diff --git a/arch/arm64/kernel/module-plts.c b/arch/arm64/kernel/module-plts.c
index ea640f92fe5a..b4e7fe45d337 100644
--- a/arch/arm64/kernel/module-plts.c
+++ b/arch/arm64/kernel/module-plts.c
@@ -41,6 +41,47 @@ u64 module_emit_plt_entry(struct module *mod, void *loc, const Elf64_Rela *rela,
 	return (u64)&plt[i];
 }
 
+#ifdef CONFIG_ARM64_ERRATUM_843419
+u64 module_emit_adrp_veneer(struct module *mod, void *loc, u64 val)
+{
+	struct mod_plt_sec *pltsec = !in_init(mod, loc) ? &mod->arch.core :
+							  &mod->arch.init;
+	struct plt_entry *plt = (struct plt_entry *)pltsec->plt->sh_addr;
+	int i = pltsec->plt_num_entries;
+	u32 mov0, mov1, mov2, br;
+	int rd;
+
+	/* get the destination register of the ADRP instruction */
+	rd = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RD,
+					  le32_to_cpup((__le32 *)loc));
+
+	/* generate the veneer instructions */
+	mov0 = aarch64_insn_gen_movewide(rd, (u16)~val, 0,
+					 AARCH64_INSN_VARIANT_64BIT,
+					 AARCH64_INSN_MOVEWIDE_INVERSE);
+	mov1 = aarch64_insn_gen_movewide(rd, (u16)(val >> 16), 16,
+					 AARCH64_INSN_VARIANT_64BIT,
+					 AARCH64_INSN_MOVEWIDE_KEEP);
+	mov2 = aarch64_insn_gen_movewide(rd, (u16)(val >> 32), 32,
+					 AARCH64_INSN_VARIANT_64BIT,
+					 AARCH64_INSN_MOVEWIDE_KEEP);
+	br = aarch64_insn_gen_branch_imm((u64)&plt[i].br, (u64)loc + 4,
+					 AARCH64_INSN_BRANCH_NOLINK);
+
+	plt[i] = (struct plt_entry){
+			cpu_to_le32(mov0),
+			cpu_to_le32(mov1),
+			cpu_to_le32(mov2),
+			cpu_to_le32(br)
+		};
+
+	pltsec->plt_num_entries++;
+	BUG_ON(pltsec->plt_num_entries > pltsec->plt_max_entries);
+
+	return (u64)&plt[i];
+}
+#endif
+
 #define cmp_3way(a,b)	((a) < (b) ? -1 : (a) > (b))
 
 static int cmp_rela(const void *a, const void *b)
@@ -109,6 +150,18 @@ static unsigned int count_plts(Elf64_Sym *syms, Elf64_Rela *rela, int num,
 			if (rela[i].r_addend != 0 || !duplicate_rel(rela, i))
 				ret++;
 			break;
+		case R_AARCH64_ADR_PREL_PG_HI21_NC:
+		case R_AARCH64_ADR_PREL_PG_HI21:
+			/*
+			 * Allocate veneer space for each ADRP that appears at
+			 * a vulnerable offset. At relocation time, some of
+			 * these will remain unused since some ADRP instructions
+			 * can be patched to ADR instructions instead.
+			 */
+			if (IS_ENABLED(CONFIG_ARM64_ERRATUM_843419) &&
+			    (rela[i].r_offset & 0xfff) >= 0xff8)
+				ret++;
+			break;
 		}
 	}
 	return ret;
@@ -161,6 +214,15 @@ int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
 		if (!(dstsec->sh_flags & SHF_EXECINSTR))
 			continue;
 
+		if (IS_ENABLED(CONFIG_ARM64_ERRATUM_843419) &&
+		    sechdrs[i].sh_addralign < SZ_4K)
+			/*
+			 * Increase the alignment of all executable sections to
+			 * 4k so that can we use r_offset to check whether the
+			 * ADRP instruction will end up at a vulnerable offset.
+			 */
+			sechdrs[i].sh_addralign = SZ_4K;
+
 		/* sort by type, symbol index and addend */
 		sort(rels, numrels, sizeof(Elf64_Rela), cmp_rela, NULL);
 
diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
index f469e0435903..f5fdb2eea032 100644
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -197,6 +197,32 @@ static int reloc_insn_imm(enum aarch64_reloc_op op, __le32 *place, u64 val,
 	return 0;
 }
 
+static bool reloc_adrp_erratum_843419(struct module *mod, __le32 *place,
+				      u64 val)
+{
+	if (!IS_ENABLED(CONFIG_ARM64_ERRATUM_843419))
+		return false;
+
+	/* only ADRP instructions at the end of a 4k page are affected */
+	if (((u64)place & 0xfff) < 0xff8)
+		return false;
+
+	/* patch ADRP to ADR if it is in range */
+	if (!reloc_insn_imm(RELOC_OP_PREL, place, val & ~0xfff, 0, 21,
+			    AARCH64_INSN_IMM_ADR)) {
+		((u8 *)place)[3] &= 0x7f; /* clear opcode bit 31 */
+	} else {
+		u32 insn;
+
+		/* out of range for ADR -> emit a veneer */
+		val = module_emit_adrp_veneer(mod, place, val & ~0xfff);
+		insn = aarch64_insn_gen_branch_imm((u64)place, val,
+						   AARCH64_INSN_BRANCH_NOLINK);
+		*place = cpu_to_le32(insn);
+	}
+	return true;
+}
+
 int apply_relocate_add(Elf64_Shdr *sechdrs,
 		       const char *strtab,
 		       unsigned int symindex,
@@ -336,14 +362,16 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 			ovf = reloc_insn_imm(RELOC_OP_PREL, loc, val, 0, 21,
 					     AARCH64_INSN_IMM_ADR);
 			break;
-#ifndef CONFIG_ARM64_ERRATUM_843419
 		case R_AARCH64_ADR_PREL_PG_HI21_NC:
 			overflow_check = false;
 		case R_AARCH64_ADR_PREL_PG_HI21:
+			if (reloc_adrp_erratum_843419(me, loc, val)) {
+				ovf = false;
+				break;
+			}
 			ovf = reloc_insn_imm(RELOC_OP_PAGE, loc, val, 12, 21,
 					     AARCH64_INSN_IMM_ADR);
 			break;
-#endif
 		case R_AARCH64_ADD_ABS_LO12_NC:
 		case R_AARCH64_LDST8_ABS_LO12_NC:
 			overflow_check = false;
diff --git a/arch/arm64/kernel/reloc_test_core.c b/arch/arm64/kernel/reloc_test_core.c
index c124752a8bd3..a70489c584c7 100644
--- a/arch/arm64/kernel/reloc_test_core.c
+++ b/arch/arm64/kernel/reloc_test_core.c
@@ -28,6 +28,7 @@ asmlinkage u64 absolute_data16(void);
 asmlinkage u64 signed_movw(void);
 asmlinkage u64 unsigned_movw(void);
 asmlinkage u64 relative_adrp(void);
+asmlinkage u64 relative_adrp_far(void);
 asmlinkage u64 relative_adr(void);
 asmlinkage u64 relative_data64(void);
 asmlinkage u64 relative_data32(void);
@@ -43,9 +44,8 @@ static struct {
 	{ "R_AARCH64_ABS16",		absolute_data16, UL(SYM16_ABS_VAL) },
 	{ "R_AARCH64_MOVW_SABS_Gn",	signed_movw, UL(SYM64_ABS_VAL) },
 	{ "R_AARCH64_MOVW_UABS_Gn",	unsigned_movw, UL(SYM64_ABS_VAL) },
-#ifndef CONFIG_ARM64_ERRATUM_843419
 	{ "R_AARCH64_ADR_PREL_PG_HI21",	relative_adrp, (u64)&sym64_rel },
-#endif
+	{ "R_AARCH64_ADR_PREL_PG_HI21",	relative_adrp_far, (u64)&printk },
 	{ "R_AARCH64_ADR_PREL_LO21",	relative_adr, (u64)&sym64_rel },
 	{ "R_AARCH64_PREL64",		relative_data64, (u64)&sym64_rel },
 	{ "R_AARCH64_PREL32",		relative_data32, (u64)&sym64_rel },
diff --git a/arch/arm64/kernel/reloc_test_syms.S b/arch/arm64/kernel/reloc_test_syms.S
index e1edcefeb02d..f333b4b7880d 100644
--- a/arch/arm64/kernel/reloc_test_syms.S
+++ b/arch/arm64/kernel/reloc_test_syms.S
@@ -43,15 +43,21 @@ ENTRY(unsigned_movw)
 	ret
 ENDPROC(unsigned_movw)
 
-#ifndef CONFIG_ARM64_ERRATUM_843419
-
+	.align	12
+	.space	0xff8
 ENTRY(relative_adrp)
 	adrp	x0, sym64_rel
 	add	x0, x0, #:lo12:sym64_rel
 	ret
 ENDPROC(relative_adrp)
 
-#endif
+	.align	12
+	.space	0xffc
+ENTRY(relative_adrp_far)
+	adrp	x0, printk
+	add	x0, x0, #:lo12:printk
+	ret
+ENDPROC(relative_adrp_far)
 
 ENTRY(relative_adr)
 	adr	x0, sym64_rel
-- 
2.11.0
