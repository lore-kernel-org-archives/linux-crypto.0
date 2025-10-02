Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D66186284
	for <linux-crypto@vger.kernel.org>; Thu,  2 Oct 2025 16:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759423728; cv=none; b=ozvpXOdvJ7dFcIBgcu0u0/XHrteu/K3jFE7wLOQJdO8+8fg/Dtt8ss4n7DgfXx5+L8x0UNOZiKSyE0OLKB4VDpLdNENWk5M4Kr0unhQvpKEro6KMKNZo1vNO6kVYnLCIzQ3/wBExwvE8eTGUf18wIH/d9Yn4Le8YU4+OEdTbhGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759423728; c=relaxed/simple;
	bh=UXUa16DxRQlc+YoczpHucO1ugFqhBs0jsvbBdOCdJO8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fqUy9ino+Hhy0kgiRg1eE2teVM7h9TWWA6WOX1ZqC9nUz/oA4vROb6PNvwMqKgNSuSxJa6mKHeU9hKbAPY6/36xmJblcZYiFKgP33wg6FsjniWWu4VLr19LvU0thJNUI5x8JW+DEDvJalEPO0Jbth3xbK8r6WuYGHZFVuF4eoFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j0Y94/Tq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j0Y94/Tq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37AEBC4CEF4
	for <linux-crypto@vger.kernel.org>; Thu,  2 Oct 2025 16:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759423728;
	bh=UXUa16DxRQlc+YoczpHucO1ugFqhBs0jsvbBdOCdJO8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=j0Y94/TqYpj+kjQCWs9eFlHW/1YN9UkIeBZQD85d5KgIk/tOkOxey0WUrpgbqn7/m
	 2TysR5EYWNUT1E4JsgFLLed3pNhBxyUKFVkDzbzJ0jJpiR8aQ7vZNH9D3tZCWZwFzj
	 Fnk24RzRsdAEwYRumnbEHYz+DuvVePn8RWRsSlsZnit+sJphLjYr8NjaOI1LYsG89Q
	 rFZHWlJ/T8nrt/iRHRm8w8oDCxS1krM8vsJCXLCWA4r2B8DoBjwhwWsvI5HD44gVvn
	 nVWIid8AXpqNG3TPSu2OzyteNP/gSgAvXvzJXvvPYvxdbWW3J80vKrkUUDu4DLYo3g
	 sVODSxeCsewyA==
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-58984c363ceso2236396e87.0
        for <linux-crypto@vger.kernel.org>; Thu, 02 Oct 2025 09:48:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUWJp10ZLM9xIGhYd+cv/kckVyDeOId2yC/QlQgPXdI1c1LdGpT4CFhmKcvM7WUiL+OQ4AE3OS5p8bBK1Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxTVV9wYnoW00xGmMluaV/9rSub1hmKUfUy4pzvJltWIHFPN+T
	mKIpJzaY0lg5to53BVPR2nmxevFD9saGvkh8zN6eQxtntul4C4fV8UGSQohGXp2f+XIsaZxtpiF
	pCBo3XDZX0WSlpF+aLbigQEr8bxvkv34=
X-Google-Smtp-Source: AGHT+IEqXM/Be3cRNs05VWOlXbMCnMSG6Mba0tmbOYQBA/5ovj738cWnL+OCbs5vXp6LcKhFkY87M5wOVli92mntFKw=
X-Received: by 2002:a05:6512:2397:b0:581:bdb8:6df9 with SMTP id
 2adb3069b0e04-58b00b5eb3emr1343410e87.10.1759423726612; Thu, 02 Oct 2025
 09:48:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251001210201.838686-22-ardb+git@google.com> <20251001210201.838686-26-ardb+git@google.com>
 <202510020918.7E358227@keescook>
In-Reply-To: <202510020918.7E358227@keescook>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 2 Oct 2025 18:48:35 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEK+ggQXC6pruZs2jkg6fmA7+Uv45DY4B_XqTRsRbTf2Q@mail.gmail.com>
X-Gm-Features: AS18NWAZ8uFcVmA6EvK7W0-OFglLBSKI4YbLO-lps_DOpY0PjMY5dUoH7ZngWew
Message-ID: <CAMj1kXEK+ggQXC6pruZs2jkg6fmA7+Uv45DY4B_XqTRsRbTf2Q@mail.gmail.com>
Subject: Re: [PATCH v2 04/20] crypto: aegis128-neon - Move to more abstract
 'ksimd' guard API
To: Kees Cook <kees@kernel.org>
Cc: Ard Biesheuvel <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, linux@armlinux.org.uk, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>, 
	Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 2 Oct 2025 at 18:20, Kees Cook <kees@kernel.org> wrote:
>
> On Wed, Oct 01, 2025 at 11:02:06PM +0200, Ard Biesheuvel wrote:
> > From: Ard Biesheuvel <ardb@kernel.org>
> >
> > Move away from calling kernel_neon_begin() and kernel_neon_end()
> > directly, and instead, use the newly introduced scoped_ksimd() API. This
> > permits arm64 to modify the kernel mode NEON API without affecting code
> > that is shared between ARM and arm64.
> >
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  crypto/aegis128-neon.c | 33 +++++++-------------
> >  1 file changed, 12 insertions(+), 21 deletions(-)
> >
> > diff --git a/crypto/aegis128-neon.c b/crypto/aegis128-neon.c
> > index 9ee50549e823..b41807e63bd3 100644
> > --- a/crypto/aegis128-neon.c
> > +++ b/crypto/aegis128-neon.c
> > @@ -4,7 +4,7 @@
> >   */
> >
> >  #include <asm/cpufeature.h>
> > -#include <asm/neon.h>
> > +#include <asm/simd.h>
> >
> >  #include "aegis.h"
> >  #include "aegis-neon.h"
> > @@ -24,32 +24,28 @@ void crypto_aegis128_init_simd(struct aegis_state *state,
> >                              const union aegis_block *key,
> >                              const u8 *iv)
> >  {
> > -     kernel_neon_begin();
> > -     crypto_aegis128_init_neon(state, key, iv);
> > -     kernel_neon_end();
> > +     scoped_ksimd()
> > +             crypto_aegis128_init_neon(state, key, iv);
> >  }
>
> For these cases (to avoid the indentation change), do you want to use
> just "guard" instead of "scope_guard", or do you want to explicitly
> require explicit scope context even when the scope ends at the function
> return?
>

I'm on the fence tbh. I think for future maintainability, being forced
to define the scope is perhaps better but in this case, the whole
function contains only a single line so there is little room for
confusion.
