From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/6] MODSIGN: Add indications of module ELF types
Date: Wed, 14 Feb 2007 19:09:54 +0000
Message-ID: <20070214190954.6438.3461.stgit@warthog.cambridge.redhat.com>
References: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, davej@redhat.com,
	arjan@infradead.org, linux-crypto@vger.kernel.org,
	dhowells@redhat.com
To: torvalds@osdl.org, akpm@osdl.org, herbert.xu@redhat.com
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932479AbXBNTLP@vger.kernel.org>
In-Reply-To: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add per-arch indications of module ELF types and relocation table entry types.

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 include/asm-alpha/module.h   |    3 +++
 include/asm-arm/module.h     |    5 +++++
 include/asm-cris/module.h    |    5 +++++
 include/asm-h8300/module.h   |    5 +++++
 include/asm-i386/module.h    |    5 +++++
 include/asm-ia64/module.h    |    5 +++++
 include/asm-m32r/module.h    |    5 +++++
 include/asm-m68k/module.h    |    5 +++++
 include/asm-mips/module.h    |   12 ++++++++++--
 include/asm-parisc/module.h  |    8 ++++++++
 include/asm-powerpc/module.h |   10 ++++++++++
 include/asm-s390/module.h    |    3 +++
 include/asm-sh/module.h      |    5 +++++
 include/asm-sparc/module.h   |    5 +++++
 include/asm-sparc64/module.h |    5 +++++
 include/asm-um/module-i386.h |    4 ++++
 include/asm-v850/module.h    |    5 +++++
 include/asm-x86_64/module.h  |    5 +++++
 18 files changed, 98 insertions(+), 2 deletions(-)

diff --git a/include/asm-alpha/module.h b/include/asm-alpha/module.h
index 7b63743..3d5a3ea 100644
--- a/include/asm-alpha/module.h
+++ b/include/asm-alpha/module.h
@@ -6,6 +6,7 @@ struct mod_arch_specific
 	unsigned int gotsecindex;
 };
 
+#define MODULES_ARE_ELF64
 #define Elf_Sym Elf64_Sym
 #define Elf_Shdr Elf64_Shdr
 #define Elf_Ehdr Elf64_Ehdr
@@ -13,6 +14,8 @@ struct mod_arch_specific
 #define Elf_Dyn Elf64_Dyn
 #define Elf_Rel Elf64_Rel
 #define Elf_Rela Elf64_Rela
+#define ELF_R_TYPE(X)	ELF64_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF64_R_SYM(X)
 
 #define ARCH_SHF_SMALL SHF_ALPHA_GPREL
 
diff --git a/include/asm-arm/module.h b/include/asm-arm/module.h
index 24b168d..f1558f3 100644
--- a/include/asm-arm/module.h
+++ b/include/asm-arm/module.h
@@ -6,9 +6,14 @@ struct mod_arch_specific
 	int foo;
 };
 
+#define MODULES_ARE_ELF32
 #define Elf_Shdr	Elf32_Shdr
 #define Elf_Sym		Elf32_Sym
 #define Elf_Ehdr	Elf32_Ehdr
+#define Elf_Rel		Elf32_Rel
+#define Elf_Rela	Elf32_Rela
+#define ELF_R_TYPE(X)	ELF32_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF32_R_SYM(X)
 
 /*
  * Include the ARM architecture version.
diff --git a/include/asm-cris/module.h b/include/asm-cris/module.h
index 7ee7231..03f7b2e 100644
--- a/include/asm-cris/module.h
+++ b/include/asm-cris/module.h
@@ -3,7 +3,12 @@
 /* cris is simple */
 struct mod_arch_specific { };
 
+#define MODULES_ARE_ELF32
 #define Elf_Shdr Elf32_Shdr
 #define Elf_Sym Elf32_Sym
 #define Elf_Ehdr Elf32_Ehdr
+#define Elf_Rel Elf32_Rel
+#define Elf_Rela Elf32_Rela
+#define ELF_R_TYPE(X)	ELF32_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF32_R_SYM(X)
 #endif /* _ASM_CRIS_MODULE_H */
diff --git a/include/asm-h8300/module.h b/include/asm-h8300/module.h
index de23231..b1c08e2 100644
--- a/include/asm-h8300/module.h
+++ b/include/asm-h8300/module.h
@@ -4,9 +4,14 @@
  * This file contains the H8/300 architecture specific module code.
  */
 struct mod_arch_specific { };
+#define MODULES_ARE_ELF32
 #define Elf_Shdr Elf32_Shdr
 #define Elf_Sym Elf32_Sym
 #define Elf_Ehdr Elf32_Ehdr
+#define Elf_Rel Elf32_Rel
+#define Elf_Rela Elf32_Rela
+#define ELF_R_TYPE(X)	ELF32_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF32_R_SYM(X)
 
 #define MODULE_SYMBOL_PREFIX "_"
 
diff --git a/include/asm-i386/module.h b/include/asm-i386/module.h
index 02f8f54..42ab093 100644
--- a/include/asm-i386/module.h
+++ b/include/asm-i386/module.h
@@ -6,9 +6,14 @@ struct mod_arch_specific
 {
 };
 
+#define MODULES_ARE_ELF32
 #define Elf_Shdr Elf32_Shdr
 #define Elf_Sym Elf32_Sym
 #define Elf_Ehdr Elf32_Ehdr
+#define Elf_Rel Elf32_Rel
+#define Elf_Rela Elf32_Rela
+#define ELF_R_TYPE(X)	ELF32_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF32_R_SYM(X)
 
 #ifdef CONFIG_M386
 #define MODULE_PROC_FAMILY "386 "
diff --git a/include/asm-ia64/module.h b/include/asm-ia64/module.h
index d2da61e..191355a 100644
--- a/include/asm-ia64/module.h
+++ b/include/asm-ia64/module.h
@@ -23,9 +23,14 @@ struct mod_arch_specific {
 	unsigned int next_got_entry;	/* index of next available got entry */
 };
 
+#define MODULES_ARE_ELF64
 #define Elf_Shdr	Elf64_Shdr
 #define Elf_Sym		Elf64_Sym
 #define Elf_Ehdr	Elf64_Ehdr
+#define Elf_Rel		Elf64_Rel
+#define Elf_Rela	Elf64_Rela
+#define ELF_R_TYPE(X)	ELF64_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF64_R_SYM(X)
 
 #define MODULE_PROC_FAMILY	"ia64"
 #define MODULE_ARCH_VERMAGIC	MODULE_PROC_FAMILY \
diff --git a/include/asm-m32r/module.h b/include/asm-m32r/module.h
index eb73ee0..7146455 100644
--- a/include/asm-m32r/module.h
+++ b/include/asm-m32r/module.h
@@ -3,8 +3,13 @@
 
 struct mod_arch_specific { };
 
+#define MODULES_ARE_ELF32
 #define Elf_Shdr	Elf32_Shdr
 #define Elf_Sym		Elf32_Sym
 #define Elf_Ehdr	Elf32_Ehdr
+#define Elf_Rel		Elf32_Rel
+#define Elf_Rela	Elf32_Rela
+#define ELF_R_TYPE(X)	ELF32_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF32_R_SYM(X)
 
 #endif /* _ASM_M32R_MODULE_H */
diff --git a/include/asm-m68k/module.h b/include/asm-m68k/module.h
index c6d75af..ee98908 100644
--- a/include/asm-m68k/module.h
+++ b/include/asm-m68k/module.h
@@ -1,7 +1,12 @@
 #ifndef _ASM_M68K_MODULE_H
 #define _ASM_M68K_MODULE_H
 struct mod_arch_specific { };
+#define MODULES_ARE_ELF32
 #define Elf_Shdr Elf32_Shdr
 #define Elf_Sym Elf32_Sym
 #define Elf_Ehdr Elf32_Ehdr
+#define Elf_Rel Elf32_Rel
+#define Elf_Rela Elf32_Rela
+#define ELF_R_TYPE(X)	ELF32_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF32_R_SYM(X)
 #endif /* _ASM_M68K_MODULE_H */
diff --git a/include/asm-mips/module.h b/include/asm-mips/module.h
index 399d03f..694f979 100644
--- a/include/asm-mips/module.h
+++ b/include/asm-mips/module.h
@@ -33,11 +33,15 @@ typedef struct {
 } Elf64_Mips_Rela;
 
 #ifdef CONFIG_32BIT
-
+#define MODULES_ARE_ELF32
 #define Elf_Shdr	Elf32_Shdr
 #define Elf_Sym		Elf32_Sym
 #define Elf_Ehdr	Elf32_Ehdr
 #define Elf_Addr	Elf32_Addr
+#define Elf_Rel		Elf32_Rel
+#define Elf_Rela	Elf32_Rela
+#define ELF_R_TYPE(X)	ELF32_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF32_R_SYM(X)
 
 #define Elf_Mips_Rel	Elf32_Rel
 #define Elf_Mips_Rela	Elf32_Rela
@@ -48,11 +52,15 @@ typedef struct {
 #endif
 
 #ifdef CONFIG_64BIT
-
+#define MODULES_ARE_ELF64
 #define Elf_Shdr	Elf64_Shdr
 #define Elf_Sym		Elf64_Sym
 #define Elf_Ehdr	Elf64_Ehdr
 #define Elf_Addr	Elf64_Addr
+#define Elf_Rel		Elf64_Rel
+#define Elf_Rela	Elf64_Rela
+#define ELF_R_TYPE(X)	ELF64_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF64_R_SYM(X)
 
 #define Elf_Mips_Rel	Elf64_Mips_Rel
 #define Elf_Mips_Rela	Elf64_Mips_Rela
diff --git a/include/asm-parisc/module.h b/include/asm-parisc/module.h
index 00f0688..ebd9a5e 100644
--- a/include/asm-parisc/module.h
+++ b/include/asm-parisc/module.h
@@ -4,17 +4,25 @@
  * This file contains the parisc architecture specific module code.
  */
 #ifdef __LP64__
+#define MODULES_ARE_ELF64
 #define Elf_Shdr Elf64_Shdr
 #define Elf_Sym Elf64_Sym
 #define Elf_Ehdr Elf64_Ehdr
 #define Elf_Addr Elf64_Addr
+#define Elf_Rel Elf64_Rel
 #define Elf_Rela Elf64_Rela
+#define ELF_R_TYPE(X)	ELF64_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF64_R_SYM(X)
 #else
+#define MODULES_ARE_ELF32
 #define Elf_Shdr Elf32_Shdr
 #define Elf_Sym Elf32_Sym
 #define Elf_Ehdr Elf32_Ehdr
 #define Elf_Addr Elf32_Addr
+#define Elf_Rel Elf32_Rel
 #define Elf_Rela Elf32_Rela
+#define ELF_R_TYPE(X)	ELF32_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF32_R_SYM(X)
 #endif
 
 struct unwind_table;
diff --git a/include/asm-powerpc/module.h b/include/asm-powerpc/module.h
index e5f14b1..f9baae1 100644
--- a/include/asm-powerpc/module.h
+++ b/include/asm-powerpc/module.h
@@ -52,16 +52,26 @@ struct mod_arch_specific {
  */
 
 #ifdef __powerpc64__
+#    define MODULES_ARE_ELF64
 #    define Elf_Shdr	Elf64_Shdr
 #    define Elf_Sym	Elf64_Sym
 #    define Elf_Ehdr	Elf64_Ehdr
+#    define Elf_Rel Elf64_Rel
+#    define Elf_Rela Elf64_Rela
+#    define ELF_R_TYPE(X)	ELF64_R_TYPE(X)
+#    define ELF_R_SYM(X)	ELF64_R_SYM(X)
 #    ifdef MODULE
 	asm(".section .stubs,\"ax\",@nobits; .align 3; .previous");
 #    endif
 #else
+#    define MODULES_ARE_ELF32
 #    define Elf_Shdr	Elf32_Shdr
 #    define Elf_Sym	Elf32_Sym
 #    define Elf_Ehdr	Elf32_Ehdr
+#    define Elf_Rel Elf32_Rel
+#    define Elf_Rela Elf32_Rela
+#    define ELF_R_TYPE(X)	ELF32_R_TYPE(X)
+#    define ELF_R_SYM(X)	ELF32_R_SYM(X)
 #    ifdef MODULE
 	asm(".section .plt,\"ax\",@nobits; .align 3; .previous");
 	asm(".section .init.plt,\"ax\",@nobits; .align 3; .previous");
diff --git a/include/asm-s390/module.h b/include/asm-s390/module.h
index 1cc1c5a..b64dab0 100644
--- a/include/asm-s390/module.h
+++ b/include/asm-s390/module.h
@@ -29,14 +29,17 @@ struct mod_arch_specific
 };
 
 #ifdef __s390x__
+#define MODULES_ARE_ELF64
 #define ElfW(x) Elf64_ ## x
 #define ELFW(x) ELF64_ ## x
 #else
+#define MODULES_ARE_ELF32
 #define ElfW(x) Elf32_ ## x
 #define ELFW(x) ELF32_ ## x
 #endif
 
 #define Elf_Addr ElfW(Addr)
+#define Elf_Rel ElfW(Rel)
 #define Elf_Rela ElfW(Rela)
 #define Elf_Shdr ElfW(Shdr)
 #define Elf_Sym ElfW(Sym)
diff --git a/include/asm-sh/module.h b/include/asm-sh/module.h
index 118d5a2..c3cf495 100644
--- a/include/asm-sh/module.h
+++ b/include/asm-sh/module.h
@@ -9,9 +9,14 @@ struct mod_arch_specific {
 	/* Nothing to see here .. */
 };
 
+#define MODULES_ARE_ELF32
 #define Elf_Shdr		Elf32_Shdr
 #define Elf_Sym			Elf32_Sym
 #define Elf_Ehdr		Elf32_Ehdr
+#define Elf_Rel			Elf32_Rel
+#define Elf_Rela		Elf32_Rela
+#define ELF_R_TYPE(X)	ELF32_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF32_R_SYM(X)
 
 #ifdef CONFIG_CPU_LITTLE_ENDIAN
 # ifdef CONFIG_CPU_SH2
diff --git a/include/asm-sparc/module.h b/include/asm-sparc/module.h
index cbd9e67..e2921e2 100644
--- a/include/asm-sparc/module.h
+++ b/include/asm-sparc/module.h
@@ -1,7 +1,12 @@
 #ifndef _ASM_SPARC_MODULE_H
 #define _ASM_SPARC_MODULE_H
 struct mod_arch_specific { };
+#define MODULES_ARE_ELF32
 #define Elf_Shdr Elf32_Shdr
 #define Elf_Sym Elf32_Sym
 #define Elf_Ehdr Elf32_Ehdr
+#define Elf_Rel Elf32_Rel
+#define Elf_Rela Elf32_Rela
+#define ELF_R_TYPE(X)	ELF32_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF32_R_SYM(X)
 #endif /* _ASM_SPARC_MODULE_H */
diff --git a/include/asm-sparc64/module.h b/include/asm-sparc64/module.h
index 3d77ba4..2e7ca17 100644
--- a/include/asm-sparc64/module.h
+++ b/include/asm-sparc64/module.h
@@ -1,7 +1,12 @@
 #ifndef _ASM_SPARC64_MODULE_H
 #define _ASM_SPARC64_MODULE_H
 struct mod_arch_specific { };
+#define MODULES_ARE_ELF64
 #define Elf_Shdr Elf64_Shdr
 #define Elf_Sym Elf64_Sym
 #define Elf_Ehdr Elf64_Ehdr
+#define Elf_Rel Elf64_Rel
+#define Elf_Rela Elf64_Rela
+#define ELF_R_TYPE(X)	ELF64_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF64_R_SYM(X)
 #endif /* _ASM_SPARC64_MODULE_H */
diff --git a/include/asm-um/module-i386.h b/include/asm-um/module-i386.h
index 5ead4a0..b441057 100644
--- a/include/asm-um/module-i386.h
+++ b/include/asm-um/module-i386.h
@@ -9,5 +9,9 @@ struct mod_arch_specific
 #define Elf_Shdr Elf32_Shdr
 #define Elf_Sym Elf32_Sym
 #define Elf_Ehdr Elf32_Ehdr
+#define Elf_Rel Elf32_Rel
+#define Elf_Rela Elf32_Rela
+#define ELF_R_TYPE(X)	ELF32_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF32_R_SYM(X)
 
 #endif
diff --git a/include/asm-v850/module.h b/include/asm-v850/module.h
index 2c2f494..48752f3 100644
--- a/include/asm-v850/module.h
+++ b/include/asm-v850/module.h
@@ -31,9 +31,14 @@ struct mod_arch_specific
 	unsigned int core_plt_section, init_plt_section;
 };
 
+#define MODULES_ARE_ELF32
 #define Elf_Shdr Elf32_Shdr
 #define Elf_Sym Elf32_Sym
 #define Elf_Ehdr Elf32_Ehdr
+#define Elf_Rel Elf32_Rel
+#define Elf_Rela Elf32_Rela
+#define ELF_R_TYPE(X)	ELF32_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF32_R_SYM(X)
 
 /* Make empty sections for module_frob_arch_sections to expand. */
 #ifdef MODULE
diff --git a/include/asm-x86_64/module.h b/include/asm-x86_64/module.h
index 67f8f69..3a7373a 100644
--- a/include/asm-x86_64/module.h
+++ b/include/asm-x86_64/module.h
@@ -3,8 +3,13 @@
 
 struct mod_arch_specific {}; 
 
+#define MODULES_ARE_ELF64
 #define Elf_Shdr Elf64_Shdr
 #define Elf_Sym Elf64_Sym
 #define Elf_Ehdr Elf64_Ehdr
+#define Elf_Rel Elf64_Rel
+#define Elf_Rela Elf64_Rela
+#define ELF_R_TYPE(X)	ELF64_R_TYPE(X)
+#define ELF_R_SYM(X)	ELF64_R_SYM(X)
 
 #endif 
