Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D37142904;
	Sun,  1 Sep 2024 08:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725180294; cv=none; b=f+8cp1ke71uTN0KX7ihILDOeu3KI3+f/WLOH5fBeI5aWyUQUe6pAKKW9vC73BWOTWanx8g4U1JgW7yF00jXE+IzfBeJTzwwCWY4rlPRq9IBdm31m8MvfnIX2SgBRgZT+ueJUQoi7mnSvEZsxVrE4VoSmn8d4xDqCVOpjEnE+k+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725180294; c=relaxed/simple;
	bh=u2foKDpuiO0hIiLaVcawsskClBWa14MMbkCXMARwkPw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ajjW7kKTDj1JC63W8lP6MmY3GM6ooGnBOoV5QsSy/P/FKB+2ITc/jaRSxZz2Ke6vhI50EhqVMgf8fDAfXhUqo+QMl1TMFPZv2/6StIA7r8cGxuRGRR5FVsFUQsd98wJBSxWlSIP7hcxsIBGPsX9JVnI7PjEXPWUULtDUkvtMWCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BqVXy8jX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BqVXy8jX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3038C4AF09;
	Sun,  1 Sep 2024 08:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725180293;
	bh=u2foKDpuiO0hIiLaVcawsskClBWa14MMbkCXMARwkPw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=BqVXy8jXthKr6KIRfWFbD/hKrmfKoPMlKT3Wdm8OmZUsiWN3wQ5SIDwIdJx7C4iPy
	 f7gVjnlTCYgmkWDF85cYjl9lZvthnSzUTstMy2QoCsFD4DFNtrqr1QOQCZ4kLlC8lV
	 F0xrXffnt2ogSPzZy8Xva4GfDgfs79juHL4vbrdjU0R6Vh/5ZlYjaUmEXumj1F73xe
	 cCVsgxY5omkRnB6prZkzNbQ8A9BzZE1hdDinajb820R/XGWFO2viIXG+mDYvVBekxL
	 LIlQHiAO5kNMmM7XDN9dOqiDpM9M9sQDIEPSnhrZQUOlu3WbSLOHhhUu5m+z7QhKgQ
	 repXCC6Ejp1UA==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5bf009cf4c0so3225455a12.1;
        Sun, 01 Sep 2024 01:44:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUihBbGBZeYLPRQDVj0yLuwy0iiFaIlLxxnFl3w5OYNA0dnPZVXmpdekH32A0K7eUjb6wm14iQARdkuIug=@vger.kernel.org, AJvYcCWhy51LHSH0wELwU3/MjtyXQEYArDROLoTB9lSBy4qUFZMDOpdZbdHxVZVGwRQ53fsg3o7XKBU/x63oH0UL@vger.kernel.org
X-Gm-Message-State: AOJu0YzWvaqCWnmqMvzHRcUvlNWbJ0aPXaWajHQ4WtrzpYe4WbKtuGFO
	pLnziB3LvAGK+Dh37V7/prBkA97xGv7GETKhPUhJcFMyaKS6y4xLvajmpK5XwuRFFupRekL5Jw5
	KZT+wHNvJWopHf9pgHHj/nMVGneA=
X-Google-Smtp-Source: AGHT+IEb1+t00NRyi798ZmWHmnZe3q8JbBxOfI+YZ0BKOvIdUf83eVBOLl6yudT2uLr2Q9l4MnIwgg3QIoNe2gKCrRQ=
X-Received: by 2002:a05:6402:90c:b0:5c2:43a0:47e3 with SMTP id
 4fb4d7f45d1cf-5c243a04904mr2187407a12.36.1725180292452; Sun, 01 Sep 2024
 01:44:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240901061315.15693-1-xry111@xry111.site> <20240901061315.15693-2-xry111@xry111.site>
In-Reply-To: <20240901061315.15693-2-xry111@xry111.site>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sun, 1 Sep 2024 16:44:40 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4nE3s7e=ouh04VH=yY2iR+ofuEkv8p=2cChJi=jw=pMw@mail.gmail.com>
Message-ID: <CAAhV-H4nE3s7e=ouh04VH=yY2iR+ofuEkv8p=2cChJi=jw=pMw@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] arch: vDSO: Add a __vdso_getrandom prototype for
 all architectures
To: Xi Ruoyao <xry111@xry111.site>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>, WANG Xuerui <kernel@xen0n.name>, linux-crypto@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Jinyang He <hejinyang@loongson.cn>, Tiezhu Yang <yangtiezhu@loongson.cn>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Ruoyao,

On Sun, Sep 1, 2024 at 2:13=E2=80=AFPM Xi Ruoyao <xry111@xry111.site> wrote=
:
>
> Without a prototype, we'll have to add a prototype for each architecture
> implementing vDSO getrandom.  As most architectures will likely have the
> vDSO getrandom implemented in a near future, and we'd like to keep the
> declarations compatible everywhere (to ease the Glibc work), we should
> really just have one copy of the prototype.
>
> Suggested-by: Huacai Chen <chenhuacai@kernel.org>
> Signed-off-by: Xi Ruoyao <xry111@xry111.site>
> ---
>  arch/x86/entry/vdso/vgetrandom.c | 2 --
>  include/vdso/getrandom.h         | 5 +++++
>  2 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/entry/vdso/vgetrandom.c b/arch/x86/entry/vdso/vgetr=
andom.c
> index 52d3c7faae2e..430862b8977c 100644
> --- a/arch/x86/entry/vdso/vgetrandom.c
> +++ b/arch/x86/entry/vdso/vgetrandom.c
> @@ -6,8 +6,6 @@
>
>  #include "../../../../lib/vdso/getrandom.c"
>
> -ssize_t __vdso_getrandom(void *buffer, size_t len, unsigned int flags, v=
oid *opaque_state, size_t opaque_len);
> -
>  ssize_t __vdso_getrandom(void *buffer, size_t len, unsigned int flags, v=
oid *opaque_state, size_t opaque_len)
>  {
>         return __cvdso_getrandom(buffer, len, flags, opaque_state, opaque=
_len);
> diff --git a/include/vdso/getrandom.h b/include/vdso/getrandom.h
> index 4cf02e678f5e..08b47b002bf7 100644
> --- a/include/vdso/getrandom.h
> +++ b/include/vdso/getrandom.h
> @@ -56,4 +56,9 @@ struct vgetrandom_state {
>   */
>  extern void __arch_chacha20_blocks_nostack(u8 *dst_bytes, const u32 *key=
, u32 *counter, size_t nblocks);
>
> +/**
Though in this file there are already comments beginning with /**, but
it seems the kernel's code style suggests beginning with /*.

Huacai

> + * __vdso_getrandom: Prototype of vDSO getrandom.
> + */
> +extern ssize_t __vdso_getrandom(void *buffer, size_t len, unsigned int f=
lags, void *opaque_state, size_t opaque_len);
> +
>  #endif /* _VDSO_GETRANDOM_H */
> --
> 2.46.0
>
