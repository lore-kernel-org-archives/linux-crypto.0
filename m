Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794890117;
	b=OwpH+xg4DT2gVwq6B7w5xwIKhYMhn6c4MUS3W/+TepnaMbg234hZGmbWc140UckDP3Rj
	 IRinzgkU6BBhCFluXqEraFVD9MyBSnyyJeYE55Z8hC8YQUmUKM1PqUwL32v5JXrqR11rh
	 xByJFowQYYQqTsUQfQvK95FySv89MkscazVOk/bEDU4m0NVTdWTPMT+7M/hHWHLof4GMt
	 Iwu9o+RWX7BdXOXTK5elydu4XWOfEs0Lu2diCHOtJXKU+XnIeJ/3qgaWYis9IoyiUe5He
	 +5URkq+ThvWobyvZDVMepkFi/MZSRbnQ91TX56flBUL9TCu/l8m55T7xCxbME0zCleg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794890117;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=T9/NqaAntZwSlf5Fz/R2wLuVPSPsxm3+6aPKCupi3FE=;
	b=ks6v3ypmdGUMy8gsAMA/y53KT4xLC/9VRoTw0BhFEXP9xidKo74JyRDKjVCYXW+aBWby
	 DKXg7r+JNYIfacFJZ7QiV7JnE0LoASI0EaoD6PUGdZRO0pcedJzYmVx1kjYDNpsIg6Zh4
	 4Vj5ieGOfiEg099eIN19D9805BngWUQ7DFubU8hSVeZSfWgRtQrMd17OjkVgxBdu7mUlv
	 dx/3hFWXxInWx5KKw0cUqMNhNQYMoiqW4Ch4Sehd0ovWXYaGA1bC18KFYAf/koj3nuOd0
	 ftizx4f1tqqlUQjOz8A8brFDPfy7ZLuTpaMk4L/1BtEEM62hYpSKGdlvdV148vZh4Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="lRm/KDRI";
	arc=none smtp.remote-ip=209.85.216.69
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F077260A261F
	for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2026 04:35:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F077260A261F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=lRm/KDRI
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3b08aee6b3eso3876655a91.3
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 20:35:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794890116; x=1795494916; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T9/NqaAntZwSlf5Fz/R2wLuVPSPsxm3+6aPKCupi3FE=;
        b=lRm/KDRISPIGTbTIjJY+0i6GPVwIVwWBS3s5pHWI2El0XhUcnQCcM7w063yqV6cVkW
         Ymr3q20vH2lOjI9MOlgctv7+vc9N5wLqv9qB2mjfrig6z7A8PjzAc1SSqJ6TdBpoVH5d
         PiGz1nfQJFbq2sCbiNWZKBnZvf9wnjBlfTElZkLo7S/9SLI6wOQEUepEaS9Y1xq9/dh1
         oOKiKsXLmdjSA/Q+HdYms3vVj6OUOsu5opj55vmXVijWxZYBXQOxLLlOt1jXmirNNJ+g
         4auN2CqOKBJuZc1FH9yOrTDK+fh/imoEi+LU9w+PLkzBWNEs7CBipfUrB6uNUSjNCrPK
         s60Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794890116; x=1795494916;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T9/NqaAntZwSlf5Fz/R2wLuVPSPsxm3+6aPKCupi3FE=;
        b=DuVhpErB91beqPZHsBxvEX4eMs44luPxVe0v+69NFL53iLpvkcRNL2y2ytp1tK179H
         /FGt07AdDA1SEu6jQgKEDciiAFxHVxUV4tyRw7zA5bsU+qnu8FWRxpstwJkM6QN2vAKT
         3SoJn2+DSoKh5QBfBORbZK05MkNonHZYBxLuTRX6xfGWlv5Sa1rkQWY0gY46Bn79PVBj
         HTIU8PIfxSFfwlS077XnI5TpUtPfdoYQhOrlAU3x+lqKqr1mEra0CqbWirfg7yYfOG5t
         uEI2RIfvAP17UpmAZKRm8/oTFRH+sVAOIBlC3zq4xY6woTbrTQqU5DDK4fFS+YiDDSkb
         3wNg==
X-Forwarded-Encrypted: i=1; AL+hErF8kZESKm3XUd2a1ntnkhF7hw6e1FJfPBoF70WVHwa/5ETTl+TqqCgg03Pe8KTj7RCS51BLVmy7vEiDVpQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z/bibAnaK2gd9a7S2O6SnkqEPAjjMao3/X80/c/Tmh3t+tZclY8
	B/EqiX7Q50TmtASflUMVGMfapOtEFRMn3vFHIJa3tZrXvS2/hh1wgCc7ZwA2IgVtlF0eHbSAmoE
	Tmskvxz6TStXN4kxUh092FJuEGw==
X-Received: from plqw18.prod.google.com ([2002:a17:902:a712:b0:2e9:4ce7:154a])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f710:b0:2e8:93b1:49cc with SMTP id d9443c01a7336-2ee0dc2a5a9mr131239395ad.35.1794890115946;
 Mon, 16 Nov 2026 20:35:15 -0800 (PST)
Date: Tue, 17 Nov 2026 04:34:58 +0000
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
Message-ID: <20261117043504.1021063-7-dylanbhatch@google.com>
Subject: [RFC PATCH 06/12] scripts/gen_lr_unwind: add --dump option to inspect
 .lr_unwind tables
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

Add a --dump (-d) flag to scripts/gen_lr_unwind to dump .lr_unwind FDEs
and instruction ranges in human-readable format. Support dumping both
linked/post-processed objects containing .lr_unwind_fde and individual
relocatable .o files containing only .eh_frame.

Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
---
 scripts/gen_lr_unwind.c | 268 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 257 insertions(+), 11 deletions(-)

diff --git a/scripts/gen_lr_unwind.c b/scripts/gen_lr_unwind.c
index f65edd86ac78c..2058601ec6135 100644
--- a/scripts/gen_lr_unwind.c
+++ b/scripts/gen_lr_unwind.c
@@ -35,6 +35,8 @@ struct lr_unwind_ctx {
 	const Elf64_Shdr *eh_sec;
 	const Elf64_Shdr *rela_eh_sec;
 	const Elf64_Shdr *fde_sec;
+	const Elf64_Shdr *rela_fde_sec;
+	const Elf64_Shdr *ranges_sec;
 	unsigned int	symtab_shndx;
 
 	const Elf64_Rela *eh_relas;
@@ -67,6 +69,13 @@ struct elf_writer {
 	size_t		str_sz;
 };
 
+struct dump_sym {
+	u64		addr;
+	unsigned int	shndx;
+	bool		is_func;
+	const char	*name;
+};
+
 static int append_fde_entry(struct lr_unwind_ctx *ctx,
 			    const Elf64_Rela *eh_rela,
 			    s64 byte_off, u32 desc)
@@ -478,6 +487,225 @@ static int emit_lr_unwind_sections(const char *fname, struct lr_unwind_ctx *ctx,
 	return ret;
 }
 
+static int cmp_dump_sym(const void *a, const void *b)
+{
+	const struct dump_sym *sa = a, *sb = b;
+
+	if (sa->shndx != sb->shndx)
+		return sa->shndx < sb->shndx ? -1 : 1;
+	if (sa->addr != sb->addr)
+		return sa->addr < sb->addr ? -1 : 1;
+	if (sa->is_func != sb->is_func)
+		return sa->is_func ? 1 : -1;
+	return 0;
+}
+
+static const struct dump_sym *find_dump_sym(const struct dump_sym *syms,
+					    size_t nr_syms,
+					    unsigned int shndx, u64 addr)
+{
+	size_t lo = 0, hi = nr_syms;
+	const struct dump_sym *best = NULL;
+
+	while (lo < hi) {
+		size_t mid = lo + (hi - lo) / 2;
+		const struct dump_sym *s = &syms[mid];
+
+		if ((shndx && s->shndx < shndx) ||
+		    ((!shndx || s->shndx == shndx) && s->addr <= addr)) {
+			if (!shndx || s->shndx == shndx)
+				best = s;
+			lo = mid + 1;
+		} else {
+			hi = mid;
+		}
+	}
+
+	return best;
+}
+
+static const char *mode_name(enum lr_unwind_mode mode)
+{
+	switch (mode) {
+	case LR_UNWIND_LIVE:
+		return "LIVE";
+	case LR_UNWIND_FP:
+		return "FP";
+	case LR_UNWIND_SP:
+		return "SP";
+	default:
+		return "UNKNOWN";
+	}
+}
+
+static int dump_lr_unwind(struct lr_unwind_ctx *ctx, const Elf64_Shdr *shdrs,
+			  unsigned int shnum, const char *shstrtab)
+{
+	const struct lr_fde *fdes;
+	const Elf64_Rela *relas = NULL;
+	const lr_range_t *ranges = NULL;
+	size_t nr_fdes, nr_ranges = 0;
+	const Elf64_Sym *elf_syms = NULL;
+	size_t nr_elf_syms = 0;
+	const char *strtab = NULL;
+	struct dump_sym *dsyms = NULL;
+	size_t nr_dsyms = 0;
+	bool is_rel = (((const Elf64_Ehdr *)ctx->map)->e_type == ET_REL);
+
+	if (ctx->fde_sec) {
+		fdes = ctx->map + ctx->fde_sec->sh_offset;
+		nr_fdes = ctx->fde_sec->sh_size / sizeof(struct lr_fde);
+		if (ctx->rela_fde_sec)
+			relas = ctx->map + ctx->rela_fde_sec->sh_offset;
+		if (ctx->ranges_sec) {
+			ranges = ctx->map + ctx->ranges_sec->sh_offset;
+			nr_ranges = ctx->ranges_sec->sh_size / sizeof(lr_range_t);
+		}
+	} else {
+		if (!ctx->eh_sec || !ctx->rela_eh_sec || !ctx->symtab_shndx) {
+			fprintf(stderr, "No .lr_unwind_fde or .eh_frame section found\n");
+			return -1;
+		}
+		if (parse_eh_frame(ctx) < 0)
+			return -1;
+		fdes = ctx->fdes;
+		nr_fdes = ctx->nr_fdes;
+		relas = ctx->fde_relas;
+		ranges = ctx->ranges;
+		nr_ranges = ctx->nr_ranges;
+	}
+
+	if (ctx->symtab_shndx) {
+		const Elf64_Shdr *sym_sec = &shdrs[ctx->symtab_shndx];
+
+		elf_syms = ctx->map + sym_sec->sh_offset;
+		nr_elf_syms = sym_sec->sh_size / sizeof(Elf64_Sym);
+		strtab = ctx->map + shdrs[sym_sec->sh_link].sh_offset;
+
+		dsyms = malloc(nr_elf_syms * sizeof(*dsyms));
+		if (!dsyms)
+			return -1;
+
+		for (size_t i = 0; i < nr_elf_syms; i++) {
+			const Elf64_Sym *s = &elf_syms[i];
+			unsigned char type = ELF64_ST_TYPE(s->st_info);
+			const char *name = strtab + s->st_name;
+
+			if (s->st_shndx == SHN_UNDEF ||
+			    s->st_shndx >= SHN_LORESERVE)
+				continue;
+			if (type != STT_FUNC && type != STT_NOTYPE)
+				continue;
+			if (!name[0] || name[0] == '$' ||
+			    !strncmp(name, ".L", 2))
+				continue;
+
+			dsyms[nr_dsyms++] = (struct dump_sym){
+				.addr = s->st_value,
+				.shndx = is_rel ? s->st_shndx : 0,
+				.is_func = (type == STT_FUNC),
+				.name = name,
+			};
+		}
+
+		qsort(dsyms, nr_dsyms, sizeof(*dsyms), cmp_dump_sym);
+	}
+
+	for (size_t i = 0; i < nr_fdes; i++) {
+		const struct lr_fde *fde = &fdes[i];
+		u32 desc = fde->range_desc;
+		u32 sp_off = LR_FDE_SP_OFF_BYTES(desc);
+		lr_range_t inline_ranges[4];
+		const lr_range_t *r_list;
+		u32 r_cnt, total_insns = 0, insn_off = 0;
+
+		if (desc & LR_FDE_INLINE) {
+			lr_fde_unpack_inline(desc, inline_ranges);
+			r_list = inline_ranges;
+			r_cnt = 4;
+		} else {
+			u32 idx = LR_OOL_IDX(desc);
+
+			r_cnt = LR_OOL_COUNT(desc);
+			if (idx + r_cnt > nr_ranges) {
+				free(dsyms);
+				return -1;
+			}
+			r_list = &ranges[idx];
+		}
+
+		for (u32 j = 0; j < r_cnt; j++)
+			total_insns += LR_RANGE_LEN(r_list[j]);
+
+		printf("FDE[%zu] ", i);
+		if (relas && elf_syms) {
+			u32 sym_idx = ELF64_R_SYM(relas[i].r_info);
+
+			if (sym_idx < nr_elf_syms) {
+				const Elf64_Sym *sym = &elf_syms[sym_idx];
+				unsigned int shndx = sym->st_shndx;
+				u64 off = sym->st_value + relas[i].r_addend;
+
+				if (shndx < shnum && shndx < SHN_LORESERVE) {
+					const char *sec_name =
+						shstrtab + shdrs[shndx].sh_name;
+					const struct dump_sym *ds =
+						find_dump_sym(dsyms, nr_dsyms,
+							      shndx, off);
+
+					if (ds)
+						printf("%s+0x%lx <%s+0x%lx>",
+						       sec_name,
+						       (unsigned long)off,
+						       ds->name,
+						       (unsigned long)(off - ds->addr));
+					else
+						printf("%s+0x%lx", sec_name,
+						       (unsigned long)off);
+				}
+			}
+		} else if (ctx->fde_sec) {
+			u64 field_addr = ctx->fde_sec->sh_addr +
+					 i * sizeof(struct lr_fde);
+			u64 pc = field_addr + (s64)fde->start_offset;
+			const struct dump_sym *ds =
+				find_dump_sym(dsyms, nr_dsyms, 0, pc);
+
+			if (ds)
+				printf("0x%016lx <%s+0x%lx>", (unsigned long)pc,
+				       ds->name, (unsigned long)(pc - ds->addr));
+			else
+				printf("0x%016lx", (unsigned long)pc);
+		}
+
+		if (desc & LR_FDE_INLINE)
+			printf(" (len=0x%x, inline, sp_off=0x%x):\n",
+			       total_insns << 2, sp_off);
+		else
+			printf(" (len=0x%x, ool[%u..%u), sp_off=0x%x):\n",
+			       total_insns << 2, LR_OOL_IDX(desc),
+			       LR_OOL_IDX(desc) + r_cnt, sp_off);
+
+		for (u32 j = 0; j < r_cnt; j++) {
+			u32 len = LR_RANGE_LEN(r_list[j]);
+			enum lr_unwind_mode mode = LR_RANGE_MODE(r_list[j]);
+
+			if (!len)
+				continue;
+			printf("  [+0x%04x..+0x%04x) %4u insns  %s",
+			       insn_off << 2, (insn_off + len) << 2,
+			       len, mode_name(mode));
+			if (mode == LR_UNWIND_SP)
+				printf(" (sp+0x%x)", sp_off);
+			printf("\n");
+			insn_off += len;
+		}
+	}
+
+	free(dsyms);
+	return 0;
+}
+
 int main(int argc, char *argv[])
 {
 	struct lr_unwind_ctx ctx = { 0 };
@@ -485,22 +713,29 @@ int main(int argc, char *argv[])
 	const Elf64_Ehdr *ehdr;
 	const Elf64_Shdr *shdrs;
 	const char *shstrtab;
+	const char *fname;
+	bool dump = false;
 	struct stat sb;
 	int fd, ret = 1;
 
-	if (argc != 2) {
-		fprintf(stderr, "Usage: %s <file>\n", argv[0]);
+	if (argc == 3 && (!strcmp(argv[1], "--dump") || !strcmp(argv[1], "-d"))) {
+		dump = true;
+		fname = argv[2];
+	} else if (argc == 2 && argv[1][0] != '-') {
+		fname = argv[1];
+	} else {
+		fprintf(stderr, "Usage: %s [--dump] <file>\n", argv[0]);
 		return 1;
 	}
 
-	fd = open(argv[1], O_RDONLY);
+	fd = open(fname, O_RDONLY);
 	if (fd < 0) {
 		fprintf(stderr, "gen_lr_unwind: cannot open %s: %s\n",
-			argv[1], strerror(errno));
+			fname, strerror(errno));
 		return 1;
 	}
 	if (fstat(fd, &sb) < 0 || (size_t)sb.st_size < sizeof(Elf64_Ehdr)) {
-		fprintf(stderr, "gen_lr_unwind: invalid file %s\n", argv[1]);
+		fprintf(stderr, "gen_lr_unwind: invalid file %s\n", fname);
 		close(fd);
 		return 1;
 	}
@@ -510,7 +745,7 @@ int main(int argc, char *argv[])
 	close(fd);
 	if (ctx.map == MAP_FAILED) {
 		fprintf(stderr, "gen_lr_unwind: mmap failed on %s: %s\n",
-			argv[1], strerror(errno));
+			fname, strerror(errno));
 		return 1;
 	}
 
@@ -518,10 +753,12 @@ int main(int argc, char *argv[])
 	if (memcmp(ehdr->e_ident, ELFMAG, SELFMAG) ||
 	    ehdr->e_ident[EI_CLASS] != ELFCLASS64 ||
 	    ehdr->e_ident[EI_DATA] != ELFDATA2LSB ||
-	    ehdr->e_type != ET_REL ||
+	    (!dump && ehdr->e_type != ET_REL) ||
+	    (dump && ehdr->e_type != ET_REL && ehdr->e_type != ET_EXEC &&
+	     ehdr->e_type != ET_DYN) ||
 	    ehdr->e_machine != EM_AARCH64) {
-		fprintf(stderr, "gen_lr_unwind: %s is not an AArch64 ET_REL ELF\n",
-			argv[1]);
+		fprintf(stderr, "gen_lr_unwind: unsupported ELF file %s\n",
+			fname);
 		goto out;
 	}
 
@@ -536,6 +773,10 @@ int main(int argc, char *argv[])
 
 		if (!strcmp(name, ".lr_unwind_fde"))
 			ctx.fde_sec = &shdrs[i];
+		else if (!strcmp(name, ".rela.lr_unwind_fde"))
+			ctx.rela_fde_sec = &shdrs[i];
+		else if (!strcmp(name, ".lr_unwind_ranges"))
+			ctx.ranges_sec = &shdrs[i];
 		else if (!strcmp(name, ".eh_frame") ||
 			 !strcmp(name, ".init.eh_frame"))
 			ctx.eh_sec = &shdrs[i];
@@ -546,6 +787,11 @@ int main(int argc, char *argv[])
 			ctx.symtab_shndx = i;
 	}
 
+	if (dump) {
+		ret = dump_lr_unwind(&ctx, shdrs, shnum, shstrtab) ? 1 : 0;
+		goto out;
+	}
+
 	if (ctx.fde_sec) {
 		ret = 0;
 		goto out;
@@ -558,11 +804,11 @@ int main(int argc, char *argv[])
 
 	if (!parse_eh_frame(&ctx) &&
 	    (!ctx.nr_fdes ||
-	     !emit_lr_unwind_sections(argv[1], &ctx, shnum, shstrndx)))
+	     !emit_lr_unwind_sections(fname, &ctx, shnum, shstrndx)))
 		ret = 0;
 	else
 		fprintf(stderr, "gen_lr_unwind: failed to generate .lr_unwind for %s\n",
-			argv[1]);
+			fname);
 
 out:
 	if (ctx.map)
-- 
2.56.0.679.gc527c65306-goog

