Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BC629A9;
	Sun, 24 Nov 2024 17:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732468419; cv=none; b=nbrBFNC50RWMXNmQD1ZOR/mhLZbsZDonSKHMMWSyeUPttLNTF2c7OsuQtQvNzmQdoRiYHdbxZA7qX8rDhYDqmAtAtN8nK+VUuvJbidz+Y59wL0X+vc0lGr3oDlTOPrz8bGvAU9X5pWHnMpcsWV//oQ2V3pH52f0gPUrnKB/RTto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732468419; c=relaxed/simple;
	bh=VgLddvcIzz9+UK7Lv/jyucFoeBwfZMeb43hwR1RLZaY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pmi6vkVT+201GGHynWFhAfupKZucp+ut+7wGOfpYU9+TzVnVKgLN0Un6JCEZDixmIybiyFUIohdbKWSJPvi+XXspKGXPUfUp137s+rLdvT3kGrZ966CtpsIyIIPh//ixqXiiXHHDw87DMq3BG7E+X4o66sNLsE3OUV2bfHpRa/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EUFfFS7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EUFfFS7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A84C4CED6;
	Sun, 24 Nov 2024 17:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732468419;
	bh=VgLddvcIzz9+UK7Lv/jyucFoeBwfZMeb43hwR1RLZaY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=EUFfFS7sVLUJ9Fg6T2pG975BnYsLEKXW9mSOgNaBnKvpYpQo0oUd1U52ALHZN4oY4
	 kB2xVPOZk9YYFq3xxuxSGfHxnlV07NR/NuPzAujvYQ4IqdB3G/h6I0RRMxRZWo68IR
	 hGBGfvsoq/zXt6LfHx5donsXlKzdTiw7IDNFfDsvV4JG7MhfTVwyrjH7W6RV1xuw98
	 CbloiF87k4GMLib+jKC3VttPezl7dOEZhjLZfqqmPKkUtV+L284NnmS3SQwMQJIrpR
	 yA5+GHD+gLpD7k50HO7RQVTy0N9WlQF/0qhSRjJNjIrcPOyohTUM+Rvh0BYR/exZtk
	 bK0Ho8XkNY2ZQ==
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-53de27f1478so475539e87.2;
        Sun, 24 Nov 2024 09:13:39 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUZbE06AtPpCDwOAu22P5b7BjYQrIbV7P1YRTwFmdCzwftd5vZtWdSxVeHC5MzOeYbWbAi/aokJu9VJNGI=@vger.kernel.org, AJvYcCWQK+oq6VOqazByBygkFoWhLpCnv+rNor9O242u3qXZmklsBToapLgru01i2Mmv/3zb+FBq9ZxSz9na5ZwI@vger.kernel.org
X-Gm-Message-State: AOJu0YwyJ63ZVq0sLrtmdrc6bzWhPE0IEravCJJDDWUc7G0nYRwFCLbi
	MOggRjR22+ZXfRilDDVfk+QNTV5A3TtI88Xd6Tm08E/OVdjCy/A6EZnMFr4NRi1elGVbAUl8EOw
	pdak+pemuG2GSd8zz59M6kdkqik4=
X-Google-Smtp-Source: AGHT+IGvr5lmwfakmqlIkJcu6XwxF2gNioqukRxVSZG7xd4plRNby6TC62vi+qXjmI0oWhBEiwO+HWPIenKZ0FJ8oBE=
X-Received: by 2002:a05:6512:158f:b0:53d:e50a:7046 with SMTP id
 2adb3069b0e04-53de50a7236mr32923e87.9.1732468417494; Sun, 24 Nov 2024
 09:13:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <90667b2b7f773308318261f96ebefd1a67133c4c.1732464395.git.lukas@wunner.de>
 <CAMj1kXFvJGHr_iv6bFQfb89XqPFrNWH7-rV7SFy4QBSWXYC4RA@mail.gmail.com>
In-Reply-To: <CAMj1kXFvJGHr_iv6bFQfb89XqPFrNWH7-rV7SFy4QBSWXYC4RA@mail.gmail.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Sun, 24 Nov 2024 18:13:26 +0100
X-Gmail-Original-Message-ID: <CAMj1kXER7AbNyUDjtij6Ni0jVRMg11xvyhkCMKAxaKbx=dsgcQ@mail.gmail.com>
Message-ID: <CAMj1kXER7AbNyUDjtij6Ni0jVRMg11xvyhkCMKAxaKbx=dsgcQ@mail.gmail.com>
Subject: Re: [PATCH for-next/fixes] arm64/mm: Fix false-positive
 !virt_addr_valid() for kernel image
To: Lukas Wunner <lukas@wunner.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Zorro Lang <zlang@redhat.com>, 
	Vegard Nossum <vegard.nossum@oracle.com>, Joey Gouly <joey.gouly@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 24 Nov 2024 at 17:38, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Sun, 24 Nov 2024 at 17:16, Lukas Wunner <lukas@wunner.de> wrote:
> >
> > Zorro reports a false-positive BUG_ON() when running crypto selftests on
> > boot:  Since commit 1e562deacecc ("crypto: rsassa-pkcs1 - Migrate to
> > sig_alg backend"), test_sig_one() invokes an RSA verify operation with a
> > test vector in the kernel's .rodata section.  The test vector is passed
> > to sg_set_buf(), which performs a virt_addr_valid() check.
> >
> > On arm64, virt_addr_valid() returns false for kernel image addresses
> > such as this one, even though they're valid virtual addresses.
> > x86 returns true for kernel image addresses, so the BUG_ON() does not
> > occur there.  In fact, x86 has been doing so for 16 years, i.e. since
> > commit af5c2bd16ac2 ("x86: fix virt_addr_valid() with
> > CONFIG_DEBUG_VIRTUAL=y, v2").
> >
> > Do the same on arm64 to avoid the false-positive BUG_ON() and to achieve
> > consistent virt_addr_valid() behavior across arches.
> >
> > Silence a WARN splat in __virt_to_phys() which occurs once the BUG_ON()
> > is avoided.
> >
> > The is_kernel_address() helper introduced herein cannot be put directly
> > in the virt_addr_valid() macro:  It has to be part of the kernel proper
> > so that it has visibility of the _text and _end symbols (referenced
> > through KERNEL_START and KERNEL_END).  These symbols are not exported,
> > so modules expanding the virt_addr_valid() macro could not access them.
> > For almost all invocations of virt_addr_valid(), __is_lm_address()
> > returns true, so jumping to the is_kernel_address() helper hardly ever
> > occurs and its performance impact is thus negligible.
> >
> > Likewise, calling is_kernel_address() from the functions in physaddr.c
> > ought to be fine as they depend on CONFIG_DEBUG_VIRTUAL=y, which is
> > explicitly described as "costly" in the Kconfig help text.  (And this
> > doesn't add much cost really.)
> >
> > Abridged stack trace:
> >
> >   kernel BUG at include/linux/scatterlist.h:187!
> >   sg_init_one()
> >   rsassa_pkcs1_verify()
> >   test_sig_one()
> >   alg_test_sig()
> >   alg_test()
> >   cryptomgr_test()
> >
> > Fixes: 1e562deacecc ("crypto: rsassa-pkcs1 - Migrate to sig_alg backend")
> > Reported-by: Zorro Lang <zlang@redhat.com>
> > Closes: https://lore.kernel.org/r/20241122045106.tzhvm2wrqvttub6k@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com/
> > Signed-off-by: Lukas Wunner <lukas@wunner.de>
> > ---
> > Just from looking at the code it seems arm's virt_addr_valid() returns
> > true for kernel image addresses, so apparently arm64 is the odd man out.
> >
>
> That is because ARM maps the kernel in the linear map, whereas arm64
> maps the kernel in the vmalloc space.
>
> vmalloc addresses cannot be used for DMA, which is why
> virt_addr_valid() rejects them. On arm64, the same applies to the
> kernel image, as well as the vmap'ed stack.
>
> > Note that this fix would have obviated the need for commit c02e7c5c6da8
> > ("arm64/mm: use lm_alias() with addresses passed to memblock_free()").
> >
>
> Your 'fix' will break other stuff: it is used, e.g., to decide whether
> __pa() may be used on the input VA, which applies a fixed translation
> on the input, rather than walk the page tables to obtain the physical
> address.
>

Apologies, I replied a little too quickly.

__pa() on arm64 permits linear addresses and kernel image addresses,
and so the kernel image is treated differently from the vmap'ed stack
and other vmalloc addresses.

However, that doesn't mean doing DMA from the kernel image is a great
idea. Allocations in the linear map are rounded up to cacheline size
to ensure that they are safe for non-coherent DMA, but this does not
apply to the kernel image. .rodata should still be safe in this
regard, but the general idea of allowing kernel image addresses in
places where DMA'able virtual addresses are expected is something we
should consider with care.
