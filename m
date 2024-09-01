Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FAE1411E9;
	Sun,  1 Sep 2024 08:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725180500; cv=none; b=u+I1wR5d5Mnxz994ggatK32ykvwRAnF7Kw6jCTbaeBYzM0rSzOa0axbI/00Wd6CcyWPrp0KLv/Yq2prm6oPSXp1pfve86R06yXEnYEyDN9eb1eJgdz83NexehqyIMjKNcIhNKRSLo3XWXLoZKWuIyRmJcrttJom+3NJ2M04KPGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725180500; c=relaxed/simple;
	bh=pjXvldKrL4+QQPZcVO1zoeYSy/uBdj2HWh7RjgOrnaA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I8TQzDIgN6I5MRYMTCq4FXAVqQ5urtUtz/TEXiCIJQ0WHlEEwMHgQZhMZE+vdjdBOkPd7KvLRwvgPqM5AQGcYRdw9VBXX5xavNZqo6msChYXxXt9cJyGDFQ+nh4KXuAbnXHXsmEfvxy43pVcltXGxj3hUidQ/BWwCXQOBOMjuIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ISlFnoN5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ISlFnoN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33784C4CEC9;
	Sun,  1 Sep 2024 08:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725180500;
	bh=pjXvldKrL4+QQPZcVO1zoeYSy/uBdj2HWh7RjgOrnaA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ISlFnoN5arCRnGtPvPJ0Smy0peiDMT0BoLsspWpf0NfV93dNipHhp4KsuFTFWbGBo
	 V0D4witNuCir3y9r0c5IHGRBVBoa5t5rmwVdFgnqcZJChqynuQkK4Id8KmO8oCJeUH
	 AJt9OJwb1H5cVPQnotpYNFUfPX2KjRGjukzFtXnMLoE2vh/ZkhpQ6ypXBJHdY8R5r/
	 tBzkXtN8cSIAeTXFidZwmlyokyb1TXp8yrYJTcf9ymslkB0bFpOMntF+tftBujI8zg
	 RajuGF4iScxbpbV0m8qhBjjrGjWrCE8wf0oFz56/dyAF1N/HSvVibL7/mz84YBOvX7
	 iQbsGtaKmYjzA==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5c0aa376e15so1705490a12.1;
        Sun, 01 Sep 2024 01:48:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV7PkgzXoKmY93FtlzwaISpP57fAMNrP076CSwdK+YGzkfORr6PWv9Twn0aVfushGMTcFNc67XvKl9G+plf@vger.kernel.org, AJvYcCXli+dlx+toHoC5MKvtrKff1mMKAUYb1aEmWVafmdSPckCgmAdiuh9NvvhMKWUTKkyDRmaXxMbhlV2CAoY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yywvt5yEkNfaJJto+0VrqCsAi5/7OXT2NNrWRakXWcIabejHrfg
	RhIGtKcYdgRFU7jHKnHxLWa32zu82Q5SCe0q5CghcNUJwYBr0lMD51gTo5Ja2MIDwwwxVt/wWYC
	12lKno/mSNRmBM7OaSMVtbmrE5wQ=
X-Google-Smtp-Source: AGHT+IFj/3SxxghlaLLS/83LsplN7tFsvIKDGap6QlWNBZOGvZg4gY9EzuGcNKVVGIACjPGjTGHoGI+D6QjqcfiMfuk=
X-Received: by 2002:a05:6402:1e88:b0:5bf:17f:4b7f with SMTP id
 4fb4d7f45d1cf-5c21ed54d13mr10856480a12.22.1725180498753; Sun, 01 Sep 2024
 01:48:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240901061315.15693-1-xry111@xry111.site>
In-Reply-To: <20240901061315.15693-1-xry111@xry111.site>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sun, 1 Sep 2024 16:48:07 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6q8bPAPQuw2x7w_mNFqOoKH95Xq1jJtwYD9H=cXSGPBQ@mail.gmail.com>
Message-ID: <CAAhV-H6q8bPAPQuw2x7w_mNFqOoKH95Xq1jJtwYD9H=cXSGPBQ@mail.gmail.com>
Subject: Re: [PATCH v6 0/3] LoongArch: Implement getrandom() in vDSO
To: Xi Ruoyao <xry111@xry111.site>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>, WANG Xuerui <kernel@xen0n.name>, linux-crypto@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Jinyang He <hejinyang@loongson.cn>, Tiezhu Yang <yangtiezhu@loongson.cn>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

For the whole series,
Acked-by: Huacai Chen <chenhuacai@loongson.cn>

On Sun, Sep 1, 2024 at 2:13=E2=80=AFPM Xi Ruoyao <xry111@xry111.site> wrote=
:
>
> Implement stack-less ChaCha20 and wire it with the generic vDSO
> getrandom code.  It passes vdso_test_chacha test, and the
> vdso_test_getrandom results:
>
> bench-single:
>
>    vdso: 25000000 times in 0.527882568 seconds
>    libc: 25000000 times in 6.963153452 seconds
> syscall: 25000000 times in 6.980286094 seconds
>
> bench-multi:
>
>    vdso: 25000000 x 256 times in 29.405172862 seconds
>    libc: 25000000 x 256 times in 355.692605551 seconds
>    syscall: 25000000 x 256 times in 338.481559154 seconds
>
> bench-single in an unshared time namespace:
>
>    vdso: 25000000 times in 0.528282411 seconds
>    libc: 25000000 times in 6.966410240 seconds
> syscall: 25000000 times in 6.976614579 seconds
>
> Cc: linux-crypto@vger.kernel.org
> Cc: loongarch@lists.linux.dev
> Cc: linux-kernel@vger.kernel.org
> Cc: Jinyang He <hejinyang@loongson.cn>
> Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
> Cc:     Thomas Gleixner <tglx@linutronix.de>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: Arnd Bergmann <arnd@arndb.de>
>
> [v5]->v6:
> - Rebase onto crng/random.git.
> - Separate selftest patch from the implementation patch again (both I
>   and Huacai perfer this way).
> - Add a patch to provide a __vdso_getrandom prototype shared by all
>   ports, similar to the __vdso_gettimeofday prototype added by Arnd in
>   commit 42874e4eb35b ("arch: vdso: consolidate gettime prototypes").
> - Stop breaking lines at 80 characters for C code.
> - In vdso.lds.S and Makefile, keep sigreturn the last in the lists.
>
> [v4]->v5:
> - Rebase onto crng/random.git:
>   - Remove two selftest patches.
>   - Remove __arch_chacha20_blocks_nostack forward declaration.
> - Squash the remaining selftest patch into the vDSO getrandom
>   implementation patch.
> - Remove ifdef CONFIG_VDSO_GETRANDOM and $(CONFIG_VDSO_GETRANDOM) as
>   they are always true in arch/loongarch.
> - Remove asm-offsets.c change which has been already unneeded in v4.
> - Add comment about rematerializing the constant in the assembly code.
> - Add prototype for __vdso_getrandom to silence a -Wmissing-prototype
>   warning.
>
> [v3]->v4:
> - Remove LSX implementation, which isn't much faster than the generic
>   implementaion.
> - Rebase onto crng/random.git:
>   - Define __arch_get_k_vdso_rng_data instead of using inline asm to
>     provide the _vdso_rng_data symbol in a magic way.
>   - Remove memset.S.
>   - Use c-getrandom-y to easily include the generic C code.
>   - The benchmark results seem better than v3, maybe related to the TLS
>     refactoring in random.git.
> - Add patches for selftests.
>
> [v2]->v3:
> - Add a generic LoongArch implementation for which LSX isn't needed.
>
> v1->v2:
> - Properly send the series to the list.
>
> [v5]:https://lore.kernel.org/all/20240829125656.19017-1-xry111@xry111.sit=
e/
> [v4]:https://lore.kernel.org/all/20240827132018.88854-1-xry111@xry111.sit=
e/
> [v3]:https://lore.kernel.org/all/20240816110717.10249-1-xry111@xry111.sit=
e/
> [v2]:https://lore.kernel.org/all/20240815133357.35829-1-xry111@xry111.sit=
e/
>
> Xi Ruoyao (3):
>   arch: vDSO: Add a __vdso_getrandom prototype for all architectures
>   LoongArch: vDSO: Wire up getrandom() vDSO implementation
>   selftests/vDSO: Enable vdso getrandom tests for LoongArch
>
>  arch/loongarch/Kconfig                      |   1 +
>  arch/loongarch/include/asm/vdso/getrandom.h |  38 +++
>  arch/loongarch/include/asm/vdso/vdso.h      |   6 +
>  arch/loongarch/include/asm/vdso/vsyscall.h  |   8 +
>  arch/loongarch/kernel/vdso.c                |   1 +
>  arch/loongarch/vdso/Makefile                |   7 +-
>  arch/loongarch/vdso/vdso.lds.S              |   1 +
>  arch/loongarch/vdso/vgetrandom-chacha.S     | 242 ++++++++++++++++++++
>  arch/loongarch/vdso/vgetrandom.c            |  10 +
>  arch/x86/entry/vdso/vgetrandom.c            |   2 -
>  include/vdso/getrandom.h                    |   5 +
>  tools/arch/loongarch/vdso                   |   1 +
>  tools/testing/selftests/vDSO/Makefile       |   4 +-
>  13 files changed, 321 insertions(+), 5 deletions(-)
>  create mode 100644 arch/loongarch/include/asm/vdso/getrandom.h
>  create mode 100644 arch/loongarch/vdso/vgetrandom-chacha.S
>  create mode 100644 arch/loongarch/vdso/vgetrandom.c
>  create mode 120000 tools/arch/loongarch/vdso
>
>
> base-commit: 0dfed8092247b5e179f52d27b93533bce3eaf5ba
> --
> 2.46.0
>
>
