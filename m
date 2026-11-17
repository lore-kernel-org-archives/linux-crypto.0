Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794890110;
	b=jxeNeBZtZrRQzh6+H7feuiJTOQLTKsp6RuTs7F5DH2Nu33gaGIoeXMVUgxZrIk2Up/ZT
	 NckTnFn35Vqp4HT+zIGd5wZuFp/ePxhHZUPIeDyPS0YXNWT3Y9iiGuomZA9ugieD/GA3L
	 6LECs94lnNvBcu34uCz4fbn10t3cWeOZ7p99XZcbriWu1eHPu8zrXP/xv96Ib1D9wVz3U
	 XeHICmfYq33SYLMMzf9opvley6ZgV887wFgkvpoXl9+WM/FadcKh6NjE8FqWC2LmWxgh+
	 GN5wLNHLOA+9QGGPDAqztSSzcpxpoWtGq0L0jqudO1vbEXw7pt2s4Vk2D5Ir0vLhWmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794890110;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=kv88xp0i2ySFrcN1aLaQoGF5JG/nfVb1F5vxVlAqWpE=;
	b=MC+zXKUuV9ynGo/GRzWYLtINy2brWOnevDRUBlPbZNgmt/tFfYuTMlOiCN5Qn+DO4xTV
	 HsLZJ0LVwfcnCanVLGPgX0o9Go07Ihrzytl7ye0H4oGcJ75wJoplWlKP1YKVtfrYFVbyw
	 V/MZXVKXX3Ed44M5mHFVsO7+M3DbGUsNbGauHsqOuQABudw9dZyVEcgnQQlX3FI2obQ74
	 qneC/FSaLogCcQhu6FUgc2iWXFgAlQhubLp9vlHO97bhiaMeg51iHJ6qlnyJYOw0cqL35
	 kurCOgOX+DfeP4pxeZPuYSbDFa3Zci8qodo9q0RAGsaeECUtfG5MZ1hIWU/70kCnmqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BE8CHpUb;
	arc=none smtp.remote-ip=209.85.215.200
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0CE606A33D
	for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2026 04:35:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF0CE606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BE8CHpUb
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cd66551e02cso4837134a12.2
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 20:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794890109; x=1795494909; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kv88xp0i2ySFrcN1aLaQoGF5JG/nfVb1F5vxVlAqWpE=;
        b=BE8CHpUbo1A8F2N8jud83PeFXNJ45RULrX9f9zgXBfQqak0Cx6K+B6SoqE03BX32uw
         YgXmrd8hnQP8wNcCSVE9xsnp+P3mZaPDHbhikYShnXTJmOp8rBSAySw51/TUtG9feHzA
         aGAY0nAqDK5pXLjn27Jg2GgirpSP8VcA724YKHTaLrcpBZjTlvntcDHQgwmT/ps5NxVj
         87kpzQ/XiAcg8twEjRpREUwoFBdoge08fy4NO1K144CwQ8DFXRIxop04EHJkW89I4IJm
         UkuUAaA5yJqRFW9HuFAqxNsPSGl10tUCBohyaQXTcZcMeKpCJJMgiJC2duESmxz6U7Xg
         XMqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794890109; x=1795494909;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kv88xp0i2ySFrcN1aLaQoGF5JG/nfVb1F5vxVlAqWpE=;
        b=BY95GYxJ4df/iigu+unPlUQt0fO3LzUuT6gkyWnqFwqZLF2O0cgfjPAv4MkI8b1QD5
         +Y6wtlpQiNmXc136EsVPGWjpl+SJoBC2aoGghL2ET6KtQl67n6QUgPJX35aWO7qQM/TL
         eZZLe1JN7NyfuUV+uBS/ppzYEVrqir32L3UTWjF4t+xTCSo4jeo3UPok8AGlCDKNN8XR
         zpIn00on97CRWg/L7azjQQct2oP6527mjix/rwCwSkkn1VUKVOvH2uMvNDP6xIcclRSQ
         tDaeVPvM36QrUl6xan8fDQEOeoO+ILGdfy9IxXF60G3DFdgc3bP+zprsz0bvtYfSpcy9
         p5rw==
X-Forwarded-Encrypted: i=1; AL+hErEjjZx1SBpxoG9adWbVVIemKJg9ekaAW0gTQSnki/UiMHDoQzyC3Wszclq3TUSJzaNXGmK2eJboqoAdA6Y=@vger.kernel.org
X-Gm-Message-State: APuU4Z8dAdUkQrZtr1LIFZ1IHa5/zPhqt34jps5kYj9lsX4ZHkeARqQ9
	XwjNElXdlPHeGXCrRwEGUZ5SOiZou2Z23my+RvjNXvaILo9JI+ysuD/xN+aSy7McAISxbT1ev7B
	Obh4k25uUAecWZ82ZQNU4WRrjKQ==
X-Received: from pgcle3-n1.prod.google.com ([2002:a05:6a02:8b83:10b0:cdd:9295:e893])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:e347:b0:3eb:67a9:20cd with SMTP id adf61e73a8af0-3f7a6baa73fmr9854448637.18.1794890108718;
 Mon, 16 Nov 2026 20:35:08 -0800 (PST)
Date: Tue, 17 Nov 2026 04:34:53 +0000
In-Reply-To: <20261117043504.1021063-1-dylanbhatch@google.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261117043504.1021063-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.56.0.679.gc527c65306-goog
Message-ID: <20261117043504.1021063-2-dylanbhatch@google.com>
Subject: [RFC PATCH 01/12] arm64, unwind: build with .eh_frame and add
 gen_lr_unwind skeleton
From: Dylan Hatch <dylanbhatch@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Weinan Liu <wnliu@google.com>, 
	Jens Remus <jremus@linux.ibm.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-crypto@vger.kernel.org, llvm@lists.linux.dev, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Ard Biesheuvel <ardb@kernel.org>, Indu Bhagat <ibhagatgnu@gmail.com>, 
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>, live-patching@vger.kernel.org, 
	Dylan Hatch <dylanbhatch@google.com>
Content-Type: text/plain; charset="UTF-8"

Add CONFIG_ARM64_LR_UNWIND to build the kernel with .eh_frame unwind
tables while discarding .eh_frame in the final vmlinux and module linker
scripts unless CONFIG_UNWIND_PATCH_PAC_INTO_SCS is enabled. Wire up a
skeleton scripts/gen_lr_unwind host tool invoked on vmlinux.o.

Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
---
 MAINTAINERS                         |   1 +
 arch/arm64/Kconfig                  |  11 +++
 arch/arm64/include/asm/module.lds.h |   2 +-
 arch/arm64/kernel/vmlinux.lds.S     |  25 ++++-
 scripts/.gitignore                  |   1 +
 scripts/Makefile                    |   2 +
 scripts/Makefile.vmlinux_o          |   8 +-
 scripts/gen_lr_unwind.c             | 137 ++++++++++++++++++++++++++++
 scripts/link-vmlinux.sh             |   2 +-
 9 files changed, 185 insertions(+), 4 deletions(-)
 create mode 100644 scripts/gen_lr_unwind.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 93abbb315065d..c7c8673291702 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4047,6 +4047,7 @@ F:	include/linux/arm-rmi-cmds.h
 F:	include/linux/arm-rsi-cmds.h
 F:	include/linux/arm-smccc-rmi.h
 F:	include/linux/arm-smccc-rsi.h
+F:	scripts/gen_lr_unwind.c
 F:	tools/testing/selftests/arm64/
 X:	arch/arm64/boot/dts/
 X:	arch/arm64/configs/defconfig
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1075bc6618330..aa09c7ea61be3 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2506,6 +2506,17 @@ config UNWIND_PATCH_PAC_INTO_SCS
 	select UNWIND_TABLES
 	select DYNAMIC_SCS
 
+config ARM64_LR_UNWIND
+	bool "Generate exception-boundary unwind tables from .eh_frame"
+	default y
+	select UNWIND_TABLES
+	help
+	  Generate compact .lr_unwind_fde and .lr_unwind_ranges sections at
+	  build time from DWARF .eh_frame unwind information to determine how
+	  to unwind across exception boundaries (whether the return address is
+	  live in x30, saved in the frame record at [x29], or saved in the
+	  frame record at an SP-relative offset).
+
 config ARM64_CONTPTE
 	bool "Contiguous PTE mappings for user memory" if EXPERT
 	depends on TRANSPARENT_HUGEPAGE
diff --git a/arch/arm64/include/asm/module.lds.h b/arch/arm64/include/asm/module.lds.h
index 603f92a8a73ed..84e5fa0250435 100644
--- a/arch/arm64/include/asm/module.lds.h
+++ b/arch/arm64/include/asm/module.lds.h
@@ -4,7 +4,7 @@ SECTIONS {
 	.text.ftrace_trampoline 0 : { BYTE(0) }
 	.init.text.ftrace_trampoline 0 : { BYTE(0) }
 
-#ifdef CONFIG_UNWIND_TABLES
+#ifdef CONFIG_UNWIND_PATCH_PAC_INTO_SCS
 	/*
 	 * Currently, we only use unwind info at module load time, so we can
 	 * put it into the .init allocation.
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 1869b44ae1909..b8f2963d10030 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -144,15 +144,35 @@ jiffies = jiffies_64;
 #define TRAMP_TEXT
 #endif
 
-#ifdef CONFIG_UNWIND_TABLES
+#ifdef CONFIG_UNWIND_PATCH_PAC_INTO_SCS
 #define UNWIND_DATA_SECTIONS				\
 	.eh_frame : {					\
 		__pi___eh_frame_start = .;		\
 		*(.eh_frame)				\
 		__pi___eh_frame_end = .;		\
 	}
+#define EH_FRAME_DISCARDS
 #else
 #define UNWIND_DATA_SECTIONS
+#define EH_FRAME_DISCARDS	*(.eh_frame)
+#endif
+
+#ifdef CONFIG_ARM64_LR_UNWIND
+#define LR_UNWIND_SECTIONS				\
+	. = ALIGN(4);					\
+	.lr_unwind_fde : {				\
+		__start_lr_unwind_fde = .;		\
+		KEEP(*(.lr_unwind_fde))			\
+		__stop_lr_unwind_fde = .;		\
+	}						\
+	. = ALIGN(2);					\
+	.lr_unwind_ranges : {				\
+		__start_lr_unwind_ranges = .;		\
+		KEEP(*(.lr_unwind_ranges))		\
+		__stop_lr_unwind_ranges = .;		\
+	}
+#else
+#define LR_UNWIND_SECTIONS
 #endif
 
 /*
@@ -184,6 +204,7 @@ SECTIONS
 		*(.interp .dynamic)
 		*(.dynsym .dynstr .hash .gnu.hash)
 		*(.ARM.attributes)
+		EH_FRAME_DISCARDS
 	}
 
 	. = KIMAGE_VADDR;
@@ -212,6 +233,8 @@ SECTIONS
 	/* everything from this point to __init_begin will be marked RO NX */
 	RO_DATA(PAGE_SIZE)
 
+	LR_UNWIND_SECTIONS
+
 	HYPERVISOR_RODATA_SECTIONS
 
 #ifdef CONFIG_NVHE_EL2_TRACING
diff --git a/scripts/.gitignore b/scripts/.gitignore
index 7004565439107..a56a49fee309c 100644
--- a/scripts/.gitignore
+++ b/scripts/.gitignore
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 /asn1_compiler
 /gen_init_cpio
+/gen_lr_unwind
 /gen_packed_field_checks
 /generate_rust_target
 /insert-sys-cert
diff --git a/scripts/Makefile b/scripts/Makefile
index d7fbb7ca098b1..cb5af9339e4ac 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -12,6 +12,7 @@ hostprogs-always-$(CONFIG_SYSTEM_EXTRA_CERTIFICATE)	+= insert-sys-cert
 hostprogs-always-$(CONFIG_RUST_KERNEL_DOCTESTS)		+= rustdoc_test_builder
 hostprogs-always-$(CONFIG_RUST_KERNEL_DOCTESTS)		+= rustdoc_test_gen
 hostprogs-always-$(CONFIG_TRACEPOINTS)			+= tracepoint-update
+hostprogs-always-$(CONFIG_ARM64_LR_UNWIND)		+= gen_lr_unwind
 
 kallsyms-objs := kallsyms.o kallsyms-sysmap.o elf-parse.o
 sorttable-objs := sorttable.o elf-parse.o
@@ -31,6 +32,7 @@ rustdoc_test_builder-rust := y
 rustdoc_test_gen-rust := y
 
 HOSTCFLAGS_tracepoint-update.o = -I$(srctree)/tools/include
+HOSTCFLAGS_gen_lr_unwind.o = -I$(srctree)/tools/include
 HOSTCFLAGS_kallsyms.o = -I$(srctree)/tools/include
 HOSTCFLAGS_kallsyms-sysmap.o = -I$(srctree)/tools/include
 HOSTCFLAGS_elf-parse.o = -I$(srctree)/tools/include
diff --git a/scripts/Makefile.vmlinux_o b/scripts/Makefile.vmlinux_o
index 0b37bd5dc3a49..362382ec58b15 100644
--- a/scripts/Makefile.vmlinux_o
+++ b/scripts/Makefile.vmlinux_o
@@ -57,6 +57,10 @@ objtool-args = $(vmlinux-objtool-args-y) --link
 
 vmlinux-o-ld-args-$(CONFIG_BUILTIN_MODULE_RANGES)	+= -Map=$@.map
 
+gen_lr_unwind := $(objtree)/scripts/gen_lr_unwind
+cmd_gen_lr_unwind = $(if $(CONFIG_ARM64_LR_UNWIND), ; $(gen_lr_unwind) $@)
+cmd_gen_lr_unwinddep = $(if $(CONFIG_ARM64_LR_UNWIND), { echo ; echo '$@: $$(wildcard $(gen_lr_unwind))' ; } >> $(dot-target).cmd)
+
 quiet_cmd_ld_vmlinux.o = LD      $@
       cmd_ld_vmlinux.o = \
 	$(LD) ${KBUILD_LDFLAGS} -r -o $@ \
@@ -64,13 +68,15 @@ quiet_cmd_ld_vmlinux.o = LD      $@
 	$(addprefix -T , $(initcalls-lds)) \
 	--whole-archive vmlinux.a --no-whole-archive \
 	--start-group $(KBUILD_VMLINUX_LIBS) --end-group \
-	$(cmd_objtool)
+	$(cmd_objtool) \
+	$(cmd_gen_lr_unwind)
 
 cmd_check_function_names = $(srctree)/scripts/check-function-names.sh $@
 
 define rule_ld_vmlinux.o
 	$(call cmd_and_savecmd,ld_vmlinux.o)
 	$(call cmd,gen_objtooldep)
+	$(call cmd,gen_lr_unwinddep)
 	$(call cmd,check_function_names)
 endef
 
diff --git a/scripts/gen_lr_unwind.c b/scripts/gen_lr_unwind.c
new file mode 100644
index 0000000000000..1b52662838653
--- /dev/null
+++ b/scripts/gen_lr_unwind.c
@@ -0,0 +1,137 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Generate .lr_unwind_fde and .lr_unwind_ranges sections from .eh_frame
+ * for arm64 exception-boundary unwinding.
+ */
+
+#include <elf.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <unistd.h>
+
+struct lr_unwind_ctx {
+	const void	*map;
+	size_t		map_size;
+
+	const Elf64_Shdr *eh_sec;
+	const Elf64_Shdr *rela_eh_sec;
+	const Elf64_Shdr *fde_sec;
+	unsigned int	symtab_shndx;
+};
+
+static int parse_eh_frame(struct lr_unwind_ctx *ctx)
+{
+	/* TODO: Parse CIEs/FDEs from .eh_frame and .rela.eh_frame */
+	(void)ctx;
+	return 0;
+}
+
+static int emit_lr_unwind_sections(const char *fname, struct lr_unwind_ctx *ctx,
+				   unsigned int orig_shnum,
+				   unsigned int shstrndx)
+{
+	/* TODO: Emit .lr_unwind_fde, .rela.lr_unwind_fde, and .lr_unwind_ranges */
+	(void)fname;
+	(void)ctx;
+	(void)orig_shnum;
+	(void)shstrndx;
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	struct lr_unwind_ctx ctx = { 0 };
+	unsigned int shnum, shstrndx;
+	const Elf64_Ehdr *ehdr;
+	const Elf64_Shdr *shdrs;
+	const char *shstrtab;
+	struct stat sb;
+	int fd, ret = 1;
+
+	if (argc != 2) {
+		fprintf(stderr, "Usage: %s <file>\n", argv[0]);
+		return 1;
+	}
+
+	fd = open(argv[1], O_RDONLY);
+	if (fd < 0) {
+		fprintf(stderr, "gen_lr_unwind: cannot open %s: %s\n",
+			argv[1], strerror(errno));
+		return 1;
+	}
+	if (fstat(fd, &sb) < 0 || (size_t)sb.st_size < sizeof(Elf64_Ehdr)) {
+		fprintf(stderr, "gen_lr_unwind: invalid file %s\n", argv[1]);
+		close(fd);
+		return 1;
+	}
+
+	ctx.map_size = sb.st_size;
+	ctx.map = mmap(NULL, ctx.map_size, PROT_READ, MAP_PRIVATE, fd, 0);
+	close(fd);
+	if (ctx.map == MAP_FAILED) {
+		fprintf(stderr, "gen_lr_unwind: mmap failed on %s: %s\n",
+			argv[1], strerror(errno));
+		return 1;
+	}
+
+	ehdr = ctx.map;
+	if (memcmp(ehdr->e_ident, ELFMAG, SELFMAG) ||
+	    ehdr->e_ident[EI_CLASS] != ELFCLASS64 ||
+	    ehdr->e_ident[EI_DATA] != ELFDATA2LSB ||
+	    ehdr->e_type != ET_REL ||
+	    ehdr->e_machine != EM_AARCH64) {
+		fprintf(stderr, "gen_lr_unwind: %s is not an AArch64 ET_REL ELF\n",
+			argv[1]);
+		goto out;
+	}
+
+	shdrs = ctx.map + ehdr->e_shoff;
+	shnum = ehdr->e_shnum == SHN_UNDEF ? shdrs[0].sh_size : ehdr->e_shnum;
+	shstrndx = ehdr->e_shstrndx == SHN_XINDEX ?
+		   shdrs[0].sh_link : ehdr->e_shstrndx;
+	shstrtab = ctx.map + shdrs[shstrndx].sh_offset;
+
+	for (unsigned int i = 0; i < shnum; i++) {
+		const char *name = shstrtab + shdrs[i].sh_name;
+
+		if (!strcmp(name, ".lr_unwind_fde"))
+			ctx.fde_sec = &shdrs[i];
+		else if (!strcmp(name, ".eh_frame") ||
+			 !strcmp(name, ".init.eh_frame"))
+			ctx.eh_sec = &shdrs[i];
+		else if (!strcmp(name, ".rela.eh_frame") ||
+			 !strcmp(name, ".rela.init.eh_frame"))
+			ctx.rela_eh_sec = &shdrs[i];
+		else if (!strcmp(name, ".symtab"))
+			ctx.symtab_shndx = i;
+	}
+
+	if (ctx.fde_sec) {
+		ret = 0;
+		goto out;
+	}
+
+	if (!ctx.eh_sec || !ctx.rela_eh_sec || !ctx.symtab_shndx) {
+		ret = 0;
+		goto out;
+	}
+
+	if (!parse_eh_frame(&ctx) &&
+	    !emit_lr_unwind_sections(argv[1], &ctx, shnum, shstrndx))
+		ret = 0;
+	else
+		fprintf(stderr, "gen_lr_unwind: failed to generate .lr_unwind for %s\n",
+			argv[1]);
+
+out:
+	if (ctx.map)
+		munmap((void *)ctx.map, ctx.map_size);
+	return ret;
+}
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index d5710e900bd40..9c8bfb6ff05e0 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -61,7 +61,7 @@ vmlinux_link()
 	shift
 
 	if is_enabled CONFIG_LTO_CLANG || is_enabled CONFIG_X86_KERNEL_IBT ||
-	   is_enabled CONFIG_KLP_BUILD; then
+	   is_enabled CONFIG_KLP_BUILD || is_enabled CONFIG_ARM64_LR_UNWIND; then
 		# Use vmlinux.o instead of performing the slow LTO link again.
 		objs=vmlinux.o
 		libs=
-- 
2.56.0.679.gc527c65306-goog

