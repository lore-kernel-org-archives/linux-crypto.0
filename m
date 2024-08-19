Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B6016B396
	for <linux-crypto@vger.kernel.org>; Mon, 19 Aug 2024 12:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724071254; cv=none; b=iOnBnBxCGOf1Al54eAuaNvOpLmM9npAsmWQEbVjNUfFeyNduUMkGivb4Eoy9x4PVFWp65StpNuitgAd0rMgwKzUxVz7XFyQIqfUevHj/Hk/l+GmTdGElyQTHL3mnFv1gglD5b6kO4xpMXompIfxhPp27n6qN5tkBLlcHE6xInYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724071254; c=relaxed/simple;
	bh=LfWFvQDr2iatJwzhi4bxZutntdC6dIRnO/i0kp6H0Ig=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t6sPc8YibtyH3fusu73iGp01nSSX4HFlnwM55bihtw3KYLt4ZS2WxBXJyu/jy1gCGqk5moXqwRD27/o6AP+vb7xE5Ik5/rX9s4M+AES6UIWzOCIr0mpuYEOSiz6fEi4QxYfI/B/Nmv9vsHZrOkn3MQG+M6T9bgGhfI8KNF4eLnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q34UapCH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q34UapCH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBDEC4AF15
	for <linux-crypto@vger.kernel.org>; Mon, 19 Aug 2024 12:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724071254;
	bh=LfWFvQDr2iatJwzhi4bxZutntdC6dIRnO/i0kp6H0Ig=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=q34UapCH0xUjuGjBmuVEWpNx01J3PinW4eOtPV2lkyUe9dDyVrD/bbMyaoeKc06lK
	 +31lPpuK5r6ANqjs0/RxZpC9CJ73dKqZdEX3owFkPdbhqvp1Zp8W+6+RXST1ff+drb
	 NPOjMpTa6GJqDNQg9Hr4jRC+s98kbCDXUgMVCNA2AoNSu4yxAFZhe32WGDHUlw3029
	 kox3o4pIkF2GT8M++COB8f3ulrXawUmAdM1iJNNpl+dmW6JMS9ZqAByPLNkPswb7f/
	 4z4NkyuDZgcn8m1G8r9RsbOmJE18wfzHQ9Xsth4Rqc+3lQ/O+LfuEiB1kjOwQ4FEC8
	 e/YC/AO2JqZMw==
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2f189a2a7f8so43940571fa.2
        for <linux-crypto@vger.kernel.org>; Mon, 19 Aug 2024 05:40:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXZAk8OhSRrge/mb4ZHJC6Y108TX8PO5UqCwRfqLHpMfLIGitPeNi9MjNU766IN717SnuDizxA5/wKReNkQ76ACGaxIuLuRf2ieYsM/
X-Gm-Message-State: AOJu0YysqxNUudSfEwmmxiK8EF3aQW5gsIBydYMrJxZXUe3AnsnLLl/E
	rC7Fsd/zRZKSsgVhNA88cjzeOiOIY6iuv/yB0fOP33VMlXRZaEmFomTErLXZprRi9t2odyQ/w2H
	xU/enKA8NeBxtIFX0jbY065XjK1E=
X-Google-Smtp-Source: AGHT+IGz0jwwf5TkvEXxouu78uKMjOK2HgQDjQvqcUjC8NNidiYey0vWZI1O9paDT+z72wQ2RT7PAD1jZG8UlDu7TMQ=
X-Received: by 2002:a2e:819a:0:b0:2f3:b76c:25c4 with SMTP id
 38308e7fff4ca-2f3be600e71mr66193211fa.37.1724071252465; Mon, 19 Aug 2024
 05:40:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240816110717.10249-1-xry111@xry111.site>
In-Reply-To: <20240816110717.10249-1-xry111@xry111.site>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 19 Aug 2024 20:40:47 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5a42p6AAda=ncqCdmpHyc_tpXHjDVHq_F1pPZumfGeLw@mail.gmail.com>
Message-ID: <CAAhV-H5a42p6AAda=ncqCdmpHyc_tpXHjDVHq_F1pPZumfGeLw@mail.gmail.com>
Subject: Re:
To: Xi Ruoyao <xry111@xry111.site>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>, WANG Xuerui <kernel@xen0n.name>, linux-crypto@vger.kernel.org, 
	loongarch@lists.linux.dev, Jinyang He <hejinyang@loongson.cn>, 
	Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Ruoyao,

Why no subject?

On Fri, Aug 16, 2024 at 7:07=E2=80=AFPM Xi Ruoyao <xry111@xry111.site> wrot=
e:
>
> Subject: [PATCH v3 0/2] LoongArch: Implement getrandom() in vDSO
>
> For the rationale to implement getrandom() in vDSO see [1].
>
> The vDSO getrandom() needs a stack-less ChaCha20 implementation, so we
> need to add architecture-specific code and wire it up with the generic
> code.  Both generic LoongArch implementation and Loongson SIMD eXtension
> based implementation are added.  To dispatch them at runtime without
> invoking cpucfg on each call, the alternative runtime patching mechanism
> is extended to cover the vDSO.
>
> The implementation is tested with the kernel selftests added by the last
> patch in [1].  I had to make some adjustments to make it work on
> LoongArch (see [2], I've not submitted the changes as at now because I'm
> unsure about the KHDR_INCLUDES addition).  The vdso_test_getrandom
> bench-single result:
>
>        vdso: 25000000 times in 0.647855257 seconds (generic)
>        vdso: 25000000 times in 0.601068605 seconds (LSX)
>        libc: 25000000 times in 6.948168864 seconds
>     syscall: 25000000 times in 6.990265548 seconds
>
> The vdso_test_getrandom bench-multi result:
>
>        vdso: 25000000 x 256 times in 35.322187834 seconds (generic)
>        vdso: 25000000 x 256 times in 29.183885426 seconds (LSX)
>        libc: 25000000 x 256 times in 356.628428409 seconds
>        syscall: 25000000 x 256 times in 334.764602866 seconds
I don't see significant improvements about LSX here, so I prefer to
just use the generic version to avoid complexity (I remember Linus
said the whole of __vdso_getrandom is not very useful).


Huacai

>
> [1]:https://lore.kernel.org/all/20240712014009.281406-1-Jason@zx2c4.com/
> [2]:https://github.com/xry111/linux/commits/xry111/la-vdso-v3/
>
> [v2]->v3:
> - Add a generic LoongArch implementation for which LSX isn't needed.
>
> v1->v2:
> - Properly send the series to the list.
>
> [v2]:https://lore.kernel.org/all/20240815133357.35829-1-xry111@xry111.sit=
e/
>
> Xi Ruoyao (3):
>   LoongArch: vDSO: Wire up getrandom() vDSO implementation
>   LoongArch: Perform alternative runtime patching on vDSO
>   LoongArch: vDSO: Add LSX implementation of vDSO getrandom()
>
>  arch/loongarch/Kconfig                      |   1 +
>  arch/loongarch/include/asm/vdso/getrandom.h |  47 ++++
>  arch/loongarch/include/asm/vdso/vdso.h      |   8 +
>  arch/loongarch/kernel/asm-offsets.c         |  10 +
>  arch/loongarch/kernel/vdso.c                |  14 +-
>  arch/loongarch/vdso/Makefile                |   6 +
>  arch/loongarch/vdso/memset.S                |  24 ++
>  arch/loongarch/vdso/vdso.lds.S              |   7 +
>  arch/loongarch/vdso/vgetrandom-chacha-lsx.S | 162 +++++++++++++
>  arch/loongarch/vdso/vgetrandom-chacha.S     | 252 ++++++++++++++++++++
>  arch/loongarch/vdso/vgetrandom.c            |  19 ++
>  11 files changed, 549 insertions(+), 1 deletion(-)
>  create mode 100644 arch/loongarch/include/asm/vdso/getrandom.h
>  create mode 100644 arch/loongarch/vdso/memset.S
>  create mode 100644 arch/loongarch/vdso/vgetrandom-chacha-lsx.S
>  create mode 100644 arch/loongarch/vdso/vgetrandom-chacha.S
>  create mode 100644 arch/loongarch/vdso/vgetrandom.c
>
> --
> 2.46.0
>
