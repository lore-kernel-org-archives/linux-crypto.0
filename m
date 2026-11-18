Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794976574;
	b=jtnjfsQTmTu1PBvf7K0nVArHwWPs/PnflH8Nx/U0O/+akhDN0GGtVrmdgUET4VapN8Gt
	 WfHooXBO7JRIj3glmqJLSjY+edXqyBb8oV05NIY4sB51wPv4cANDs1itLO0VjepNZwTO1
	 Ipys0I0RaEDGtnCD4Om/UxHQb3Ho2TFJ+FdOBe6wnR/Wd+e0suoJDS6xP4qfnoDC8JTeO
	 5ae4P+2bDGg4Pyp+g5m8vWHELvEJ2am4ntHv4HnxIbPbFNygwZBmPdoq6cHk4R8mTeXs8
	 TQluJn8ilZMrKQxOSPQv06Xdeu+ofV504CEl88L+eit790yHEMxAsYSH8GWrM7EYo7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794976574;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Zv6Ve44e7E+hrSCaR8bZ2DyZqC8Hq7EAx1HNjqOEg9U=;
	b=BMFmFDI/2uCn5YlbfM1PnqXC6p3Q5xzdC0KAHFZ/JozDZZ+ZZzUu8r3v9C4Ck8n18+aq
	 bBuuNx2i9WPoetAqsKJS8fLDQp/OjteVVI3qiL9ztIXqkrayIB0ZJTSYdWfxf22kMH7w4
	 4r8gmCNV2IN19pVQcMnMX8pcPTo7Plhh34ZARK66MEQpfdv0eGEvqWZBMQVC8Jbks7jRc
	 iQZkJaWs7bYEd8dTFP9GEr4LwYqQRYTiONdaKLD8FBSysHUz+7DWl3yHCS1PEIKKIHs73
	 Ag79oHR8yHyJq/Mtqqzcm3a1Pt4GTAr/2UCOKU0SLP4LpxTFIsVJ+TisCJ06ptUxdNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GcsvGQsf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4B4606A31C;
	Wed, 18 Nov 2026 04:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GcsvGQsf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425671F000C5;
	Wed, 18 Nov 2026 04:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794976574;
	bh=Zv6Ve44e7E+hrSCaR8bZ2DyZqC8Hq7EAx1HNjqOEg9U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GcsvGQsflFWZA4dgaL0KMKazjpiQAqajOW0TASeHvBJzs85PR1HrF3F8ROk4PrSKX
	 PZ118/T0DmcCauzx2ycibY7cFGrmdeAMJm2SmJjgAcG/MAq2L/tEIiQIJhiNr9MAff
	 g+xt3g5jqng05yGWH6ZpoBL2129QUpBamHw9ZRkNVszq0YvyKXqG1awckVworMSAIR
	 nB6DLHP1n6x453VXxAmq/LIz5UmHx7v2eQbh3MjkyzM3nKsqAs4Dg7bSgfmNJNR8tt
	 Lc3z9duyyPKJcG8k8f/zjDho31+MeyR/7yK8uKz1Z9Ugl4Acv7/b2WtD0zQHUEj+7I
	 TKUhcy1OKiCIg==
Message-ID: <sashiko-outbox-220109@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 06/12] scripts/gen_lr_unwind: add --dump option to
 inspect .lr_unwind tables
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dylan Hatch" <dylanbhatch@google.com>, "Catalin Marinas" <catalin.marinas@arm.com>, "Will
 Deacon" <will@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, "Nathan
 Chancellor" <nathan@kernel.org>, "Nicolas Schier" <nsc@kernel.org>, "Nick
 Desaulniers" <ndesaulniers@google.com>, "Bill Wendling" <morbo@google.com>, "Justin
 Stitt" <justinstitt@google.com>, "Weinan Liu" <wnliu@google.com>, "Jens
 Remus" <jremus@linux.ibm.com>, linux-kbuild@vger.kernel.org, linux-crypto@vger.kernel.org, "Josh
 Poimboeuf" <jpoimboe@kernel.org>, "Steven Rostedt" <rostedt@goodmis.org>, "Ard
 Biesheuvel" <ardb@kernel.org>, "Indu Bhagat" <ibhagatgnu@gmail.com>, "Prasanna
 Kumar T S M" <ptsm@linux.microsoft.com>, live-patching@vger.kernel.org
In-Reply-To: <20261117043504.1021063-7-dylanbhatch@google.com>
References: <20261117043504.1021063-1-dylanbhatch@google.com>
 <20261117043504.1021063-7-dylanbhatch@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 04:36:12 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Low] scripts/gen_lr_unwind: missing SHN_XINDEX handling in
  dump_lr_unwind()
- [Low] scripts/gen_lr_unwind: broken dump_lr_unwind() on ET_EXEC/ET_DYN
  with relas
--

commit 28070d4daa3cf7bb2b0ad3b96252120bc29dcba2
Author: Dylan Hatch <dylanbhatch@google.com>

scripts/gen_lr_unwind: add --dump option to inspect .lr_unwind tables

This commit adds a --dump (-d) option to scripts/gen_lr_unwind to print
.lr_unwind FDEs and instruction ranges in human-readable form for both
relocatable and linked ELF files.

> diff --git a/scripts/gen_lr_unwind.c b/scripts/gen_lr_unwind.c
> index f65edd86ac78c..2058601ec6135 100644
> --- a/scripts/gen_lr_unwind.c
> +++ b/scripts/gen_lr_unwind.c

[ ... ]

> @@ -478,6 +487,225 @@ static int emit_lr_unwind_sections(const char *fnam=
e, struct lr_unwind_ctx *ctx,
> +static int dump_lr_unwind(struct lr_unwind_ctx *ctx, const Elf64_Shdr *s=
hdrs,
> +			  unsigned int shnum, const char *shstrtab)
> +{
> +	const struct lr_fde *fdes;
> +	const Elf64_Rela *relas =3D NULL;
> +	const lr_range_t *ranges =3D NULL;
> +	size_t nr_fdes, nr_ranges =3D 0;
> +	const Elf64_Sym *elf_syms =3D NULL;
> +	size_t nr_elf_syms =3D 0;
> +	const char *strtab =3D NULL;
> +	struct dump_sym *dsyms =3D NULL;
> +	size_t nr_dsyms =3D 0;
> +	bool is_rel =3D (((const Elf64_Ehdr *)ctx->map)->e_type =3D=3D ET_REL);
> +
> +	if (ctx->fde_sec) {
> +		fdes =3D ctx->map + ctx->fde_sec->sh_offset;
> +		nr_fdes =3D ctx->fde_sec->sh_size / sizeof(struct lr_fde);
> +		if (ctx->rela_fde_sec)
> +			relas =3D ctx->map + ctx->rela_fde_sec->sh_offset;
> +		if (ctx->ranges_sec) {
> +			ranges =3D ctx->map + ctx->ranges_sec->sh_offset;
> +			nr_ranges =3D ctx->ranges_sec->sh_size / sizeof(lr_range_t);
> +		}
> +	} else {

[ ... ]

> +	if (ctx->symtab_shndx) {
> +		const Elf64_Shdr *sym_sec =3D &shdrs[ctx->symtab_shndx];
> +
> +		elf_syms =3D ctx->map + sym_sec->sh_offset;
> +		nr_elf_syms =3D sym_sec->sh_size / sizeof(Elf64_Sym);
> +		strtab =3D ctx->map + shdrs[sym_sec->sh_link].sh_offset;
> +
> +		dsyms =3D malloc(nr_elf_syms * sizeof(*dsyms));
> +		if (!dsyms)
> +			return -1;
> +
> +		for (size_t i =3D 0; i < nr_elf_syms; i++) {
> +			const Elf64_Sym *s =3D &elf_syms[i];
> +			unsigned char type =3D ELF64_ST_TYPE(s->st_info);
> +			const char *name =3D strtab + s->st_name;
> +
> +			if (s->st_shndx =3D=3D SHN_UNDEF ||
> +			    s->st_shndx >=3D SHN_LORESERVE)
> +				continue;

[Severity: Low]
Does skipping symbols with st_shndx >=3D SHN_LORESERVE here and when
formatting FDE relocations below drop all sections at or above index
0xff00?

main() and emit_lr_unwind_sections() handle objects with >=3D SHN_LORESERVE
sections, such as vmlinux.o built with per-function sections, where symbols
in those sections have st_shndx =3D=3D SHN_XINDEX and store their 32-bit
section index in the SHT_SYMTAB_SHNDX section.  Without resolving
SHN_XINDEX in both places, dump_lr_unwind() omits the section name, offset,
and function name for any FDE targeting a section >=3D SHN_LORESERVE.

> +			if (type !=3D STT_FUNC && type !=3D STT_NOTYPE)
> +				continue;
> +			if (!name[0] || name[0] =3D=3D '$' ||
> +			    !strncmp(name, ".L", 2))
> +				continue;
> +
> +			dsyms[nr_dsyms++] =3D (struct dump_sym){
> +				.addr =3D s->st_value,
> +				.shndx =3D is_rel ? s->st_shndx : 0,
> +				.is_func =3D (type =3D=3D STT_FUNC),
> +				.name =3D name,
> +			};
> +		}

[ ... ]

> +		printf("FDE[%zu] ", i);
> +		if (relas && elf_syms) {
> +			u32 sym_idx =3D ELF64_R_SYM(relas[i].r_info);
> +
> +			if (sym_idx < nr_elf_syms) {
> +				const Elf64_Sym *sym =3D &elf_syms[sym_idx];
> +				unsigned int shndx =3D sym->st_shndx;
> +				u64 off =3D sym->st_value + relas[i].r_addend;
> +
> +				if (shndx < shnum && shndx < SHN_LORESERVE) {
> +					const char *sec_name =3D
> +						shstrtab + shdrs[shndx].sh_name;
> +					const struct dump_sym *ds =3D
> +						find_dump_sym(dsyms, nr_dsyms,
> +							      shndx, off);

[Severity: Low]
On an ET_EXEC or ET_DYN binary linked with --emit-relocs so that
.rela.lr_unwind_fde is still present, does taking the relas branch break
symbol resolution and address output?

When !is_rel, dsyms entries are populated with .shndx =3D 0, so calling
find_dump_sym() here with non-zero sym->st_shndx never matches any symbol.
In addition, sym->st_value is already a virtual address rather than a
section-relative offset, and if .lr_unwind_fde has been sorted in place,
relas[i] no longer matches fdes[i].  Should relas only be used when is_rel
is true, falling back to the PC-relative fde->start_offset branch for
ET_EXEC and ET_DYN?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117043504.1021=
063-1-dylanbhatch@google.com?part=3D6
