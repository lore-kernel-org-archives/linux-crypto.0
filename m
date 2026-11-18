Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794976571;
	b=oaW4LN49eZA4kB1URm0cmcmMfxYAh9/eEbV9ptjjjdRZwin/rRy4AWoyuV3VBJrRIL0+
	 +v6v307C5M3cjbXEKR7rGeUWWfuF/IXshvlsie/2wbPQSyzjIq4+4jV+/NmPhGs8Gdvuz
	 nnuO9/BkmkfjbNvxYEmrFiYv34KP8zKvjOvUZBYgQKSvrGFsB3RiZUB0r1V1ng7orvcCZ
	 zj6PhAeOrwOz2xZMLMnaipmOogtkYbZMz9e1IVihSloJq0POLw0GpTa39zjX0+kr0jsGM
	 w43DpAhKIXX2i23WBcPQwrXtoiK2YEZETkEhOxi5O9TZ2IP/tujb+X1iiJGCkn7/dAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794976571;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bWhsupzqST2YDFi7Z+kA7bV2+V+suTkSyOFZvZUSV1o=;
	b=rccn0YI9P6qdknGdUT/Ddh2I2BQKqW70d00lKJP4elUZuSXdup/06pyRZZqLUo3gw2kj
	 6YEAn4cDZgfmL7UKwkyKoYQZzKtH0sQGSMU7eZ9H4RWiTYZ+oHHLQIkzNVlVgpWM2fdOV
	 Ki6+BqeiPSI4Gtgai2fo+BQo0DBwRs73GOMjddMGxyRLJ0A0lvfVcgjYF7C0M9QWE5ttA
	 stf44GD0S+ecnvA4/08r3X6IjqIaWk6Q5BbeTqFeim81d8gyKYWACAPjL0anxUo3JQtIs
	 wvvHKOmL0TtCHBwWQJzlkJpFI4WKjVSBOmVVgZeCICwBaQmWm7j4DQw5AkwVzf3D/ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OqxBkg5A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7D6606A31C;
	Wed, 18 Nov 2026 04:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OqxBkg5A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523351F000C4;
	Wed, 18 Nov 2026 04:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794976571;
	bh=bWhsupzqST2YDFi7Z+kA7bV2+V+suTkSyOFZvZUSV1o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OqxBkg5AzXNpXHN+3oGuA0Wfiu7mnxm3mVT/iooavwTUoOKNQt9YVpv7KCbgryvj0
	 +eNweuRsg9E/D+ae0mKIh1UsAaJur38WQN8CWR6ti8l2VYixp6lFlnaJWDhJinVsQW
	 CrxxPaWTYbYG+sNb00Eu1eeepDAMRptZM23kQq8uuNVVOmKuLKTQCjxcfGnJbCZdg+
	 bl0TEVuAdZxktI7rZFl4QJoBZ6qIn2Yw114kL/Ulg8QeYHoEF0bc6/Rhc0U1kR4R7B
	 cQnIhnoLO0o8NRg/CIAPKsQjep21WQLv77uP+MNNzKEggyfkFv42o5sTsLvTVKKobb
	 FzjWzqyBsZAjQ==
Message-ID: <sashiko-outbox-220104@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 01/12] arm64, unwind: build with .eh_frame and add
 gen_lr_unwind skeleton
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
In-Reply-To: <20261117043504.1021063-2-dylanbhatch@google.com>
References: <20261117043504.1021063-1-dylanbhatch@google.com>
 <20261117043504.1021063-2-dylanbhatch@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 04:36:09 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] scripts/gen_lr_unwind: unswapped little-endian ELF reads in
  main()
--

commit 4321126beda1768f44ea752930b88bd2f0c6cb2c
Author: Dylan Hatch <dylanbhatch@google.com>

arm64, unwind: build with .eh_frame and add gen_lr_unwind skeleton

This commit adds CONFIG_ARM64_LR_UNWIND to build the kernel with
.eh_frame unwind tables while discarding them in the final linker
scripts, and wires up a skeleton scripts/gen_lr_unwind host tool invoked
on vmlinux.o.

> diff --git a/scripts/gen_lr_unwind.c b/scripts/gen_lr_unwind.c
> new file mode 100644
> index 0000000000000..1b52662838653
> --- /dev/null
> +++ b/scripts/gen_lr_unwind.c
[ ... ]
> +	ehdr =3D ctx.map;
> +	if (memcmp(ehdr->e_ident, ELFMAG, SELFMAG) ||
> +	    ehdr->e_ident[EI_CLASS] !=3D ELFCLASS64 ||
> +	    ehdr->e_ident[EI_DATA] !=3D ELFDATA2LSB ||
> +	    ehdr->e_type !=3D ET_REL ||
> +	    ehdr->e_machine !=3D EM_AARCH64) {
> +		fprintf(stderr, "gen_lr_unwind: %s is not an AArch64 ET_REL ELF\n",
> +			argv[1]);
> +		goto out;
> +	}
> +
> +	shdrs =3D ctx.map + ehdr->e_shoff;
> +	shnum =3D ehdr->e_shnum =3D=3D SHN_UNDEF ? shdrs[0].sh_size : ehdr->e_s=
hnum;
> +	shstrndx =3D ehdr->e_shstrndx =3D=3D SHN_XINDEX ?
> +		   shdrs[0].sh_link : ehdr->e_shstrndx;
> +	shstrtab =3D ctx.map + shdrs[shstrndx].sh_offset;
> +
> +	for (unsigned int i =3D 0; i < shnum; i++) {
> +		const char *name =3D shstrtab + shdrs[i].sh_name;

[Severity: Low]
Do these Elf64_Ehdr and Elf64_Shdr field reads need little-endian-to-host
conversion?  Cross-compiling an arm64 kernel on a big-endian host will
reject vmlinux.o at the e_type / e_machine check and misinterpret the
section header offsets.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117043504.1021=
063-1-dylanbhatch@google.com?part=3D1
