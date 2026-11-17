Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794890121;
	b=feQRSCuyWLWlOc10WZPneaWznyxLpv6UIdl8zqaq4wIfsNYhxHaRi9KLhQHQjPwt2sQg
	 aYHyeFfLztg0YZKqh8bC19gQfA0IyR+WKWpMWNzlwaauF5/m+FLZ1EOs+KQGapgDLwTF1
	 IbIhoXYZz60y29RrHmmpWxcfvgNy9KKZYfo9am0H8M1jCLsAJmp5xae4Nm/DRO44taJf4
	 zk3LZ7ikgGSw/hhUAgQ9Y2jrt7yDuxbLFVZmItD2XceRfPHc4nKVj2Sa5yd2QOixXN8ot
	 0kLC8u+fjzBrdgbumqNhujAHy6VdtAGbxDd6bcAywk6Ch/aXqGqOro9lMrybUePcteQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794890121;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=IAXKw3NCpczyqKMg/+5vupgdE1sofuSw9OuygiY0TQ0=;
	b=lt1Ojj23z2QLls6ldZWhYoB05QwrXV3Fh/SFYUSEGZXDYWw5MnB4X0JU5QoGf+6QDALp
	 hWsanzf4mMg5BA0my37LbzlbflLmFOwkXee8dy6hs90itGOeQQ9JF3lpokno+ZW87N8ec
	 FL9HUqCwCpSAqqM87lOCCcp+rR9xyrFOsINFEEIeDpPXPKBqIOO6uE/GbHAFsDfhOg4vx
	 vO/SxWxGMmL86tDwm5mBaO4EHY1JoRMPfOGFsrASS6uOo1T2SAPqwt4MxWGmX5sW4issm
	 ub4eAp1Mhik4suAD+fbOgdKKY1Z5/AvNiU2svcJzk/CrXIGUHf+XKtCBNBmxwINWQvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=X7JLI0V2;
	arc=none smtp.remote-ip=209.85.214.200
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70878606A880
	for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2026 04:35:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70878606A880
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=X7JLI0V2
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ed05b3eaecso30884425ad.1
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 20:35:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794890121; x=1795494921; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IAXKw3NCpczyqKMg/+5vupgdE1sofuSw9OuygiY0TQ0=;
        b=X7JLI0V2WNjLDzKZKDk+Xb30TJYqr9xX5ZGlGsFrkczz6eBt+Ob9U7L3ffcXqptWxF
         hX7h/o1AjYo4JhagVTd3kd/lWb93KUCnBf9VZuVELHlMrxozpjsPZknmzUkGsUGetPkT
         QAynG0nX/2FGs2dfcAGAzdwcOQDhRHT9dLCykTvTvvnyWh29zmodKVteINBH+iwpTJM7
         27qNd+PvmSIrDAX0E1FkEQKGkLN2mp/EM8KEEPR6g1F7OxqV3sKGdFix4/OWKykiMCis
         Sc2EAyKEI6eowTw5s/hRgOcJFT3czk+Z+1vr9+cHQhgWxLC3sbqDJgeBFcg92t0jhTFb
         tzvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794890121; x=1795494921;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IAXKw3NCpczyqKMg/+5vupgdE1sofuSw9OuygiY0TQ0=;
        b=uC1buSZlU1KIDyKjzREtFpojHEBPgAAHYkgtY9vx3ASHJw1m4+gvJhKygMpUQP5iL+
         7t4tb/n89VsCnzi6jie0un//HCxqq2kNf4CR46qQUQYIOzMGVB/gK5B2kGANVc1bxMVK
         RGQFhkFqyIduJFHt9erlZ80RXMUk6WGXJ7bEI0jpLuQmObBUM19QBDhg/Y5EfO0tWm2w
         49lJtRSPKqEo2gzuOQIrACWmqlDH1Y6lQxxA2pb27ZqVmWsNVtVdByM8yLQvv95lhUCx
         Lvze+bNedq4i5xmO4JKDOY6ZPrFmV/cWWJjUNlKiqbtCjckVU9yWtvUWT1gVGgVxBEpe
         74gw==
X-Forwarded-Encrypted: i=1; AL+hErHnA1OnMC3ncdBaehkpk4+mGFD3woOSc0DPTd2ParWtaymRIN7/GiizYTiOD89xvGDDOqoFZwZKBqGsCZE=@vger.kernel.org
X-Gm-Message-State: APuU4Z8arJYj8WGflbcleHrykQ4Q2hF85LTsX3crHKdOuuEZW2u3MWD8
	zdXcnQRjSSNxtnFUWP/SxEt9RpIaYgurumb7bDilNevkDX0Nyn5S+cdIl86/mdTweCduC74FcgD
	wffNo9QcCSaxUlXxmMrXjsX4dGw==
X-Received: from plkz11.prod.google.com ([2002:a17:902:708b:b0:2ed:e740:3702])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:da89:b0:2e9:4175:3065 with SMTP id d9443c01a7336-2ee0d9e2810mr119417075ad.4.1794890120511;
 Mon, 16 Nov 2026 20:35:20 -0800 (PST)
Date: Tue, 17 Nov 2026 04:35:01 +0000
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
Message-ID: <20261117043504.1021063-10-dylanbhatch@google.com>
Subject: [RFC PATCH 09/12] arm64/module, unwind: add .lr_unwind support for modules
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

Generate .lr_unwind_fde and .lr_unwind_ranges sections for loadable
kernel modules at modfinal link time, sort each module's FDE table in
module_finalize(), and support module IP lookups in lr_unwind_find().

Co-developed-by: Weinan Liu <wnliu@google.com>
Signed-off-by: Weinan Liu <wnliu@google.com>
Suggested-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
---
 arch/arm64/include/asm/lr_unwind.h |   7 ++
 arch/arm64/include/asm/module.h    |   6 ++
 arch/arm64/kernel/lr_unwind.c      | 125 ++++++++++++++++++++++++++++-
 arch/arm64/kernel/module.c         |  11 +++
 scripts/Makefile.modfinal          |  10 ++-
 scripts/gen_lr_unwind.c            |   4 +-
 6 files changed, 157 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/lr_unwind.h b/arch/arm64/include/asm/lr_unwind.h
index bfb6abed05f76..649009b49becf 100644
--- a/arch/arm64/include/asm/lr_unwind.h
+++ b/arch/arm64/include/asm/lr_unwind.h
@@ -113,6 +113,8 @@ static __always_inline void lr_fde_unpack_inline(u32 desc, lr_range_t ranges[4])
 #include <linux/errno.h>
 #include <linux/init.h>
 
+struct module;
+
 struct lr_unwind_section {
 	const struct lr_fde	*fdes;
 	unsigned int		num_fdes;
@@ -123,12 +125,17 @@ struct lr_unwind_section {
 #ifdef CONFIG_ARM64_LR_UNWIND
 
 void __init init_lr_unwind_table(void);
+void lr_unwind_module_init(struct module *mod, void *fdes, size_t fdes_size,
+			   const void *ranges, size_t ranges_size);
 int lr_unwind_find(unsigned long ip, enum lr_unwind_mode *mode,
 		   unsigned int *sp_off);
 
 #else /* !CONFIG_ARM64_LR_UNWIND */
 
 static inline void __init init_lr_unwind_table(void) {}
+static inline void lr_unwind_module_init(struct module *mod, void *fdes,
+					 size_t fdes_size, const void *ranges,
+					 size_t ranges_size) {}
 static inline int lr_unwind_find(unsigned long ip, enum lr_unwind_mode *mode,
 				 unsigned int *sp_off)
 {
diff --git a/arch/arm64/include/asm/module.h b/arch/arm64/include/asm/module.h
index fb9b88eebeb15..3b6457875e453 100644
--- a/arch/arm64/include/asm/module.h
+++ b/arch/arm64/include/asm/module.h
@@ -6,6 +6,7 @@
 #define __ASM_MODULE_H
 
 #include <asm-generic/module.h>
+#include <asm/lr_unwind.h>
 
 struct mod_plt_sec {
 	int			plt_shndx;
@@ -17,6 +18,11 @@ struct mod_arch_specific {
 	struct mod_plt_sec	core;
 	struct mod_plt_sec	init;
 
+#ifdef CONFIG_ARM64_LR_UNWIND
+	struct lr_unwind_section lr_unwind_sec;
+	bool			lr_unwind_init;
+#endif
+
 	/* for CONFIG_DYNAMIC_FTRACE */
 	struct plt_entry	*ftrace_trampolines;
 	struct plt_entry	*init_ftrace_trampolines;
diff --git a/arch/arm64/kernel/lr_unwind.c b/arch/arm64/kernel/lr_unwind.c
index 53e2c78a8bdaf..d554c2e1e57e2 100644
--- a/arch/arm64/kernel/lr_unwind.c
+++ b/arch/arm64/kernel/lr_unwind.c
@@ -5,11 +5,15 @@
 
 #define pr_fmt(fmt)	"lr_unwind: " fmt
 
+#include <linux/cleanup.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/kprobes.h>
 #include <linux/limits.h>
+#include <linux/module.h>
 #include <linux/printk.h>
+#include <linux/rcupdate.h>
+#include <linux/sort.h>
 
 #include <asm/lr_unwind.h>
 #include <asm/sections.h>
@@ -17,10 +21,20 @@
 static bool lr_unwind_init __ro_after_init;
 static struct lr_unwind_section kernel_lr_sec __ro_after_init;
 
+#ifdef CONFIG_MODULES
+static const char *objname(const struct lr_unwind_section *sec)
+{
+	if (sec == &kernel_lr_sec)
+		return "vmlinux";
+
+	return container_of(sec, struct module, arch.lr_unwind_sec)->name;
+}
+#else
 static const char *objname(const struct lr_unwind_section *sec)
 {
 	return "vmlinux";
 }
+#endif
 
 #define dbg_sec(sec, fmt, ...) \
 	pr_debug("(%s): " fmt, objname(sec), ##__VA_ARGS__)
@@ -55,10 +69,36 @@ static __always_inline bool is_kernel_ip_valid(unsigned long ip)
 	return false;
 }
 
+#ifdef CONFIG_MODULES
+static __always_inline bool within_mod_mem(unsigned long ip,
+					   const struct module_memory *mem)
+{
+	return ip - (unsigned long)mem->base < mem->size;
+}
+
+static __always_inline bool
+is_sec_module_ip_valid(const struct lr_unwind_section *sec, unsigned long ip)
+{
+	struct module *mod = container_of(sec, struct module, arch.lr_unwind_sec);
+
+	return within_mod_mem(ip, &mod->mem[MOD_TEXT]) ||
+	       within_mod_mem(ip, &mod->mem[MOD_INIT_TEXT]);
+}
+#else
+static __always_inline bool
+is_sec_module_ip_valid(const struct lr_unwind_section *sec, unsigned long ip)
+{
+	return false;
+}
+#endif
+
 static __always_inline bool is_sec_ip_valid(const struct lr_unwind_section *sec,
 					    unsigned long ip)
 {
-	return is_kernel_ip_valid(ip);
+	if (sec == &kernel_lr_sec)
+		return is_kernel_ip_valid(ip);
+
+	return is_sec_module_ip_valid(sec, ip);
 }
 
 static __always_inline int __find_fde(const struct lr_unwind_section *sec,
@@ -151,9 +191,31 @@ static __always_inline int __lr_unwind_find(const struct lr_unwind_section *sec,
 	return -EINVAL;
 }
 
+#ifdef CONFIG_MODULES
+static noinline int __lr_unwind_find_module(unsigned long ip,
+					    enum lr_unwind_mode *mode,
+					    unsigned int *sp_off)
+{
+	struct module *mod;
+
+	guard(preempt_notrace)();
+
+	mod = __module_text_address(ip);
+	/* Pairs with smp_store_release() in lr_unwind_module_init() */
+	if (mod && smp_load_acquire(&mod->arch.lr_unwind_init))
+		return __lr_unwind_find(&mod->arch.lr_unwind_sec,
+					ip, mode, sp_off);
+
+	return -EINVAL;
+}
+NOKPROBE_SYMBOL(__lr_unwind_find_module);
+#endif
+
 noinstr int lr_unwind_find(unsigned long ip, enum lr_unwind_mode *mode,
 			   unsigned int *sp_off)
 {
+	int ret = -EINVAL;
+
 	if (!mode || !sp_off)
 		return -EINVAL;
 
@@ -164,7 +226,16 @@ noinstr int lr_unwind_find(unsigned long ip, enum lr_unwind_mode *mode,
 		return __lr_unwind_find(&kernel_lr_sec, ip, mode, sp_off);
 	}
 
-	return -EINVAL;
+#ifdef CONFIG_MODULES
+	if (!rcu_is_watching())
+		return -EINVAL;
+
+	instrumentation_begin();
+	ret = __lr_unwind_find_module(ip, mode, sp_off);
+	instrumentation_end();
+#endif
+
+	return ret;
 }
 NOKPROBE_SYMBOL(lr_unwind_find);
 
@@ -272,3 +343,53 @@ void __init init_lr_unwind_table(void)
 	lr_unwind_init = true;
 	dbg_print_section(&kernel_lr_sec);
 }
+
+#ifdef CONFIG_MODULES
+
+static int lr_unwind_sort_cmp_fde(const void *a, const void *b)
+{
+	return cmp_int(lr_fde_start_addr(a), lr_fde_start_addr(b));
+}
+
+static void lr_unwind_sort_swap_fde(void *a, void *b, int size)
+{
+	struct lr_fde *x = a, *y = b, tmp = *x;
+	int delta = b - a;
+
+	x->start_offset = y->start_offset + delta;
+	x->range_desc = y->range_desc;
+	y->start_offset = tmp.start_offset - delta;
+	y->range_desc = tmp.range_desc;
+}
+
+void lr_unwind_module_init(struct module *mod, void *fdes, size_t fdes_size,
+			   const void *ranges, size_t ranges_size)
+{
+	struct lr_unwind_section *sec = &mod->arch.lr_unwind_sec;
+
+	if (!fdes_size || (fdes_size % sizeof(struct lr_fde)) ||
+	    (ranges_size % sizeof(lr_range_t))) {
+		pr_warn("invalid .lr_unwind section sizes in module %s\n",
+			mod->name);
+		return;
+	}
+
+	sec->fdes = fdes;
+	sec->num_fdes = fdes_size / sizeof(struct lr_fde);
+	sec->ranges = ranges;
+	sec->num_ranges = ranges_size / sizeof(lr_range_t);
+
+	sort(fdes, sec->num_fdes, sizeof(struct lr_fde),
+	     lr_unwind_sort_cmp_fde, lr_unwind_sort_swap_fde);
+
+	if (lr_unwind_validate_section(sec)) {
+		pr_warn("invalid .lr_unwind section in module %s\n", mod->name);
+		return;
+	}
+
+	/* Ensure table is initialized before lr_unwind_find() observes it */
+	smp_store_release(&mod->arch.lr_unwind_init, true);
+	dbg_print_section(sec);
+}
+
+#endif /* CONFIG_MODULES */
diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
index 24adb581af0eb..685b4301df96e 100644
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -21,6 +21,7 @@
 
 #include <asm/alternative.h>
 #include <asm/insn.h>
+#include <asm/lr_unwind.h>
 #include <asm/scs.h>
 #include <asm/sections.h>
 #include <asm/text-patching.h>
@@ -515,5 +516,15 @@ int module_finalize(const Elf_Ehdr *hdr,
 		}
 	}
 
+	s = find_section(hdr, sechdrs, ".lr_unwind_fde");
+	if (s) {
+		const Elf_Shdr *r = find_section(hdr, sechdrs,
+						 ".lr_unwind_ranges");
+
+		lr_unwind_module_init(me, (void *)s->sh_addr, s->sh_size,
+				      r ? (const void *)r->sh_addr : NULL,
+				      r ? r->sh_size : 0);
+	}
+
 	return module_init_ftrace_plt(hdr, sechdrs, me);
 }
diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
index 01a37ec872b90..301393dbb9dd3 100644
--- a/scripts/Makefile.modfinal
+++ b/scripts/Makefile.modfinal
@@ -32,11 +32,17 @@ ifneq ($(WARN_ON_UNUSED_TRACEPOINTS),)
 cmd_check_tracepoint = $(objtree)/scripts/tracepoint-update --module $<;
 endif
 
+ifdef CONFIG_ARM64_LR_UNWIND
+cmd_gen_lr_unwind = ; $(objtree)/scripts/gen_lr_unwind $@ && \
+	$(OBJCOPY) --remove-section=.eh_frame --remove-section=.rela.eh_frame $@
+endif
+
 quiet_cmd_ld_ko_o = LD [M]  $@
       cmd_ld_ko_o =							\
 	$(LD) -r $(KBUILD_LDFLAGS)					\
 		$(KBUILD_LDFLAGS_MODULE) $(LDFLAGS_MODULE)		\
-		-T $(objtree)/scripts/module.lds -o $@ $(filter %.o, $^)
+		-T $(objtree)/scripts/module.lds -o $@ $(filter %.o, $^) \
+	$(cmd_gen_lr_unwind)
 
 quiet_cmd_btf_ko = BTF [M] $@
       cmd_btf_ko = 							\
@@ -47,7 +53,7 @@ quiet_cmd_btf_ko = BTF [M] $@
 	fi;
 
 # Re-generate module BTFs if either module's .ko or vmlinux changed
-%.ko: %.o %.mod.o .module-common.o $(objtree)/scripts/module.lds $(and $(CONFIG_DEBUG_INFO_BTF_MODULES),$(KBUILD_BUILTIN),$(objtree)/vmlinux) FORCE
+%.ko: %.o %.mod.o .module-common.o $(objtree)/scripts/module.lds $(if $(CONFIG_ARM64_LR_UNWIND),$(objtree)/scripts/gen_lr_unwind) $(and $(CONFIG_DEBUG_INFO_BTF_MODULES),$(KBUILD_BUILTIN),$(objtree)/vmlinux) FORCE
 	+$(call if_changed,ld_ko_o)
 ifdef CONFIG_DEBUG_INFO_BTF_MODULES
 	+$(if $(newer-prereqs),$(call cmd,btf_ko))
diff --git a/scripts/gen_lr_unwind.c b/scripts/gen_lr_unwind.c
index 2058601ec6135..cc6b8790e00d8 100644
--- a/scripts/gen_lr_unwind.c
+++ b/scripts/gen_lr_unwind.c
@@ -797,12 +797,12 @@ int main(int argc, char *argv[])
 		goto out;
 	}
 
-	if (!ctx.eh_sec || !ctx.rela_eh_sec || !ctx.symtab_shndx) {
+	if (!ctx.eh_sec || !ctx.rela_eh_sec) {
 		ret = 0;
 		goto out;
 	}
 
-	if (!parse_eh_frame(&ctx) &&
+	if (ctx.symtab_shndx && !parse_eh_frame(&ctx) &&
 	    (!ctx.nr_fdes ||
 	     !emit_lr_unwind_sections(fname, &ctx, shnum, shstrndx)))
 		ret = 0;
-- 
2.56.0.679.gc527c65306-goog

