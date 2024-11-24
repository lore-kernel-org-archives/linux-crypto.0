Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B842500AF;
	Sun, 24 Nov 2024 16:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732466348; cv=none; b=NIo2Jkk7+D/k+O/8nma97aif/v6knxWe2bBzrsKU/XvSfp9hqq84mO/EhlE03dAh5Cl4dWk3xGhrq7+lKHDnSJz30In8tXN3rn8FdpWw4TfJ9UFz3DNR+Z7QmZ8p54Vd5Lb6Pveq6dFkW0atnU43u3v06kH/1rYH+rfJFF+u+bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732466348; c=relaxed/simple;
	bh=jByVBdlafYu4w8mrN5BxnUp1xRnOAjKq51MrjnXW4pY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q8FyMpPlR/qsPGuCV1eInHaMV5airCYayDowrkZ+J4Z3nd6kY5yLF3Ek9/Jacf5Ywhr96btplIAQYVm9gqb+/dWh22/YeNRCwNQ5Nd3F5bgKSMCzueb2ovebFv2VrzXK6ZxgEn5PjpIHGV/zbL5N64+ds5d8U/srs2hmLrnEL1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bEnA9LUj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bEnA9LUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E65C4CED6;
	Sun, 24 Nov 2024 16:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732466347;
	bh=jByVBdlafYu4w8mrN5BxnUp1xRnOAjKq51MrjnXW4pY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=bEnA9LUjdyJ7mLN+GIrULDaE8FPzYVYlcE8Z7eONq82GDx66xlChj/V30+FU5iNTe
	 isQFv2SMhAKoHBVkLRsMEcqbRbOkYWtCCjh4dGU2StiGa1Hb7RB8VAGQPtRMlV5iwE
	 9v40leU9JvmQFCxncN7EqQ1Popg095jW3bkHdGRE1SAGR1fvn+nCx7I8J74MiluamW
	 xJyfpwV/+qTI0cazcsituIDXg1WppULK3CDegFRv8YEm1pDIiTK+6Pz6IkMWkVSiv8
	 lc3eMQkWwWboLuZjWXppW89mX6JgJIiZZoSvAbb9aBRsdN20MC0ShFoaPdAVpuY/5N
	 YSo8ifWZCSNHQ==
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2ffa8df8850so24463731fa.3;
        Sun, 24 Nov 2024 08:39:07 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUFrxpE0kcI8ifb3WjRe6t+DgldNmFM6wuUcfZ3bO9uLLAyJbnYmunAIJJk+bnLL9BIXaBFjMio9AXC4PI=@vger.kernel.org, AJvYcCW4OADD1aSS7kpFpER7Uc6VWQ0kaIaGde7OPM9CbWfsBkKjSLoTTj0UjBW6RjRHO++hNyv6hzulrq5NvTPj@vger.kernel.org
X-Gm-Message-State: AOJu0YxXUe8XRVyPT68Fam2pZ5ifFAsb3ZZR0QqpVTdbHSdKtK5DlTqE
	oJyNDTP7LA4E5fEjQ3ll0C+eDlb4gw0mQ60yKyMh8uQqTz77aklL9Ft4rlTH55uxz/CPh3/rWTY
	0G9k7dGcctF6H0MjB5Py1iZebNYk=
X-Google-Smtp-Source: AGHT+IGadZZ6ClGvE0SMotIjvPDoOKeR8vaTuEqsfngsYooVDYV/m2h8Vmf2LQysynH3zmzZ9Kwo9Gj99CJMze57yro=
X-Received: by 2002:a05:6512:3ba6:b0:53d:9ff8:ea08 with SMTP id
 2adb3069b0e04-53dd369fb33mr4687009e87.16.1732466346196; Sun, 24 Nov 2024
 08:39:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <90667b2b7f773308318261f96ebefd1a67133c4c.1732464395.git.lukas@wunner.de>
In-Reply-To: <90667b2b7f773308318261f96ebefd1a67133c4c.1732464395.git.lukas@wunner.de>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Sun, 24 Nov 2024 17:38:55 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFvJGHr_iv6bFQfb89XqPFrNWH7-rV7SFy4QBSWXYC4RA@mail.gmail.com>
Message-ID: <CAMj1kXFvJGHr_iv6bFQfb89XqPFrNWH7-rV7SFy4QBSWXYC4RA@mail.gmail.com>
Subject: Re: [PATCH for-next/fixes] arm64/mm: Fix false-positive
 !virt_addr_valid() for kernel image
To: Lukas Wunner <lukas@wunner.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Zorro Lang <zlang@redhat.com>, 
	Vegard Nossum <vegard.nossum@oracle.com>, Joey Gouly <joey.gouly@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 24 Nov 2024 at 17:16, Lukas Wunner <lukas@wunner.de> wrote:
>
> Zorro reports a false-positive BUG_ON() when running crypto selftests on
> boot:  Since commit 1e562deacecc ("crypto: rsassa-pkcs1 - Migrate to
> sig_alg backend"), test_sig_one() invokes an RSA verify operation with a
> test vector in the kernel's .rodata section.  The test vector is passed
> to sg_set_buf(), which performs a virt_addr_valid() check.
>
> On arm64, virt_addr_valid() returns false for kernel image addresses
> such as this one, even though they're valid virtual addresses.
> x86 returns true for kernel image addresses, so the BUG_ON() does not
> occur there.  In fact, x86 has been doing so for 16 years, i.e. since
> commit af5c2bd16ac2 ("x86: fix virt_addr_valid() with
> CONFIG_DEBUG_VIRTUAL=y, v2").
>
> Do the same on arm64 to avoid the false-positive BUG_ON() and to achieve
> consistent virt_addr_valid() behavior across arches.
>
> Silence a WARN splat in __virt_to_phys() which occurs once the BUG_ON()
> is avoided.
>
> The is_kernel_address() helper introduced herein cannot be put directly
> in the virt_addr_valid() macro:  It has to be part of the kernel proper
> so that it has visibility of the _text and _end symbols (referenced
> through KERNEL_START and KERNEL_END).  These symbols are not exported,
> so modules expanding the virt_addr_valid() macro could not access them.
> For almost all invocations of virt_addr_valid(), __is_lm_address()
> returns true, so jumping to the is_kernel_address() helper hardly ever
> occurs and its performance impact is thus negligible.
>
> Likewise, calling is_kernel_address() from the functions in physaddr.c
> ought to be fine as they depend on CONFIG_DEBUG_VIRTUAL=y, which is
> explicitly described as "costly" in the Kconfig help text.  (And this
> doesn't add much cost really.)
>
> Abridged stack trace:
>
>   kernel BUG at include/linux/scatterlist.h:187!
>   sg_init_one()
>   rsassa_pkcs1_verify()
>   test_sig_one()
>   alg_test_sig()
>   alg_test()
>   cryptomgr_test()
>
> Fixes: 1e562deacecc ("crypto: rsassa-pkcs1 - Migrate to sig_alg backend")
> Reported-by: Zorro Lang <zlang@redhat.com>
> Closes: https://lore.kernel.org/r/20241122045106.tzhvm2wrqvttub6k@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com/
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> ---
> Just from looking at the code it seems arm's virt_addr_valid() returns
> true for kernel image addresses, so apparently arm64 is the odd man out.
>

That is because ARM maps the kernel in the linear map, whereas arm64
maps the kernel in the vmalloc space.

vmalloc addresses cannot be used for DMA, which is why
virt_addr_valid() rejects them. On arm64, the same applies to the
kernel image, as well as the vmap'ed stack.

> Note that this fix would have obviated the need for commit c02e7c5c6da8
> ("arm64/mm: use lm_alias() with addresses passed to memblock_free()").
>

Your 'fix' will break other stuff: it is used, e.g., to decide whether
__pa() may be used on the input VA, which applies a fixed translation
on the input, rather than walk the page tables to obtain the physical
address.


>  arch/arm64/include/asm/memory.h | 6 +++++-
>  arch/arm64/mm/init.c            | 7 +++++++
>  arch/arm64/mm/physaddr.c        | 6 +++---
>  3 files changed, 15 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
> index b9b9929..bb83315 100644
> --- a/arch/arm64/include/asm/memory.h
> +++ b/arch/arm64/include/asm/memory.h
> @@ -416,9 +416,13 @@ static inline unsigned long virt_to_pfn(const void *kaddr)
>  })
>  #endif /* CONFIG_DEBUG_VIRTUAL */
>
> +bool is_kernel_address(unsigned long x);
> +
>  #define virt_addr_valid(addr)  ({                                      \
>         __typeof__(addr) __addr = __tag_reset(addr);                    \
> -       __is_lm_address(__addr) && pfn_is_map_memory(virt_to_pfn(__addr));      \
> +       (__is_lm_address(__addr) ||                                     \
> +        is_kernel_address((unsigned long)__addr)) &&                   \
> +       pfn_is_map_memory(virt_to_pfn(__addr));                         \
>  })
>
>  void dump_mem_limit(void);
> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> index d21f67d..2e8a00f 100644
> --- a/arch/arm64/mm/init.c
> +++ b/arch/arm64/mm/init.c
> @@ -156,6 +156,13 @@ static void __init zone_sizes_init(void)
>         free_area_init(max_zone_pfns);
>  }
>
> +bool is_kernel_address(unsigned long x)
> +{
> +       return x >= (unsigned long) KERNEL_START &&
> +              x <= (unsigned long) KERNEL_END;
> +}
> +EXPORT_SYMBOL(is_kernel_address);
> +
>  int pfn_is_map_memory(unsigned long pfn)
>  {
>         phys_addr_t addr = PFN_PHYS(pfn);
> diff --git a/arch/arm64/mm/physaddr.c b/arch/arm64/mm/physaddr.c
> index cde44c1..2d6755b 100644
> --- a/arch/arm64/mm/physaddr.c
> +++ b/arch/arm64/mm/physaddr.c
> @@ -9,7 +9,8 @@
>
>  phys_addr_t __virt_to_phys(unsigned long x)
>  {
> -       WARN(!__is_lm_address(__tag_reset(x)),
> +       WARN(!__is_lm_address(__tag_reset(x)) &&
> +            !is_kernel_address(__tag_reset(x)),
>              "virt_to_phys used for non-linear address: %pK (%pS)\n",
>               (void *)x,
>               (void *)x);
> @@ -24,8 +25,7 @@ phys_addr_t __phys_addr_symbol(unsigned long x)
>          * This is bounds checking against the kernel image only.
>          * __pa_symbol should only be used on kernel symbol addresses.
>          */
> -       VIRTUAL_BUG_ON(x < (unsigned long) KERNEL_START ||
> -                      x > (unsigned long) KERNEL_END);
> +       VIRTUAL_BUG_ON(!is_kernel_address(x));
>         return __pa_symbol_nodebug(x);
>  }
>  EXPORT_SYMBOL(__phys_addr_symbol);
> --
> 2.43.0
>
>
