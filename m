Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CB013B7A3
	for <linux-crypto@vger.kernel.org>; Tue, 24 Jun 2025 03:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750737091; cv=none; b=BsLjV1qIKTBO4g0ouH4dNPD5NErhlnzC30kViYiXlGKi8a19d/BNcHZBEi7kgEIb0VG4WXE3BpBY3V63wrGLnE4aNgWwo+rUW92qwq72Q+n71+9w3B5bmHeNaejw0YB40qwvs5JF1ohnC8fyS4LCu93nJzX+jbYxWRFLWOP+2Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750737091; c=relaxed/simple;
	bh=5YOgXb/Dwiek//7GZAUxgO0HK7B7LjjEiNWSaEvKKaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jE3Mc2uLsf2fEQ0TJHCp5m74v3GA4YfQLonD20nwTyTLCU6Ba1U9gonUO4pz8sGLOChDBdiMcdELrCZkZQ8NxEl8MA9GNjACscNYyDMpRWtLpUzteYDE6fxR+tcuWuW+SFy1F9ytu6NbBGD+7TZPTXIyRnbO2lJzw/UyPeCmM8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ozg5cg32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ozg5cg32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E672CC4CEE3;
	Tue, 24 Jun 2025 03:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750737091;
	bh=5YOgXb/Dwiek//7GZAUxgO0HK7B7LjjEiNWSaEvKKaw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ozg5cg32YQbHw3J87pX/+olpCf/Xqe1tc4fhxbbpIvR94d/9l9/jy1MhG/NnZTg2l
	 orrSi39Q5gJEBPNF3IjaTQr62yDDI5y3NAkYOXWvrqlnXFEvOJlbwNbZ2rkdIn7g4G
	 iZ/tMfKJV0CtCRsu5MJL2BkSjsALl8XG6LmolZQQfuwIqcVL2Ezwr221PT3jkE3Ndw
	 v77PxIhBhsnciM8iWpzIAp5wbEuKjcqqYdQPRIaMYRxHxKT46LI2Qk64AWig8+Bp4w
	 kW5VlUJ57iL2wpz+r3d9nfT46LbkAchZLwjOjljqeDwaAp/yAnJogNL8L5KI0qPhwN
	 JfKnvmtr/cc8Q==
Date: Mon, 23 Jun 2025 20:50:57 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Zhihang Shao <zhihang.shao.iscas@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org,
	herbert@gondor.apana.org.au, paul.walmsley@sifive.com,
	alex@ghiti.fr, appro@cryptogams.org, zhang.lyra@gmail.com
Subject: Re: [PATCH v4] crypto: riscv/poly1305 - import OpenSSL/CRYPTOGAMS
 implementation
Message-ID: <20250624035057.GD7127@sol>
References: <20250611033150.396172-2-zhihang.shao.iscas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611033150.396172-2-zhihang.shao.iscas@gmail.com>

Hi Zhihang,

On Wed, Jun 11, 2025 at 11:31:51AM +0800, Zhihang Shao wrote:
> From: Zhihang Shao <zhihang.shao.iscas@gmail.com>
> 
> This is a straight import of the OpenSSL/CRYPTOGAMS Poly1305
> implementation for riscv authored by Andy Polyakov.
> The file 'poly1305-riscv.pl' is taken straight from this upstream
> GitHub repository [0] at commit 33fe84bc21219a16825459b37c825bf4580a0a7b,
> and this commit fixed a bug in riscv 64bit implementation.
> 
> [0] https://github.com/dot-asm/cryptogams
> 
> Signed-off-by: Zhihang Shao <zhihang.shao.iscas@gmail.com>

I wanted to let you know that I haven't forgotten about this.  However, the
kernel currently lacks a proper test for Poly1305, and Poly1305 has some edge
cases that are prone to bugs.  So I'd like to find some time to add a proper
Poly1305 test and properly review this.  Also, I'm in the middle of fixing how
the kernel's architecture-optimized crypto code is integrated; for example, I've
just moved arch/*/lib/crypto/ to lib/crypto/.

There will also need to be benchmark results that show that this code is
actually worthwhile, on both RV32 and RV64.  I am planning for the
poly1305_kunit test to have a benchmark built-in, after which it will be
straightforward to collect these.

(The "perlasm" file does have some benchmark results in a comment, but they do
not necessarily apply to the Poly1305 code in the kernel.)

So this isn't a perfect time to be adding a new Poly1305 implementation, as
we're not quite ready for it.  But I'd indeed like to take this eventually.

A few comments below:

> diff --git a/arch/riscv/lib/crypto/Makefile b/arch/riscv/lib/crypto/Makefile
> index b7cb877a2c07..93ddb62ef0f9 100644
> --- a/arch/riscv/lib/crypto/Makefile
> +++ b/arch/riscv/lib/crypto/Makefile
> @@ -3,5 +3,23 @@
>  obj-$(CONFIG_CRYPTO_CHACHA_RISCV64) += chacha-riscv64.o
>  chacha-riscv64-y := chacha-riscv64-glue.o chacha-riscv64-zvkb.o
>  
> +obj-$(CONFIG_CRYPTO_POLY1305_RISCV) += poly1305-riscv.o
> +poly1305-riscv-y := poly1305-core.o poly1305-glue.o
> +AFLAGS_poly1305-core.o += -Dpoly1305_init=poly1305_block_init_arch
> +AFLAGS_poly1305-core.o += -Dpoly1305_blocks=poly1305_blocks_arch
> +AFLAGS_poly1305-core.o += -Dpoly1305_emit=poly1305_emit_arch
> +
>  obj-$(CONFIG_CRYPTO_SHA256_RISCV64) += sha256-riscv64.o
>  sha256-riscv64-y := sha256.o sha256-riscv64-zvknha_or_zvknhb-zvkb.o
> +
> +ifeq ($(CONFIG_64BIT),y)
> +PERLASM_ARCH := 64
> +else
> +PERLASM_ARCH := void
> +endif
> +
> +quiet_cmd_perlasm = PERLASM $@
> +      cmd_perlasm = $(PERL) $(<) $(PERLASM_ARCH) $(@)
> +
> +$(obj)/%-core.S: $(src)/%-riscv.pl
> +	$(call cmd,perlasm)

Missing:

    clean-files += poly1305-core.S

> diff --git a/arch/riscv/lib/crypto/poly1305-glue.c b/arch/riscv/lib/crypto/poly1305-glue.c
> new file mode 100644
> index 000000000000..ddc73741faf5
> --- /dev/null
> +++ b/arch/riscv/lib/crypto/poly1305-glue.c
> @@ -0,0 +1,37 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * OpenSSL/Cryptogams accelerated Poly1305 transform for riscv
> + *
> + * Copyright (C) 2025 Institute of Software, CAS.
> + */
> +
> +#include <asm/hwcap.h>
> +#include <asm/simd.h>
> +#include <crypto/internal/poly1305.h>
> +#include <linux/cpufeature.h>
> +#include <linux/jump_label.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/unaligned.h>

Reduce the include list to:

#include <crypto/internal/poly1305.h>
#include <linux/export.h>
#include <linux/module.h>

> +.globl	poly1305_init
> +.type	poly1305_init,\@function
> +poly1305_init:
> +#ifdef	__riscv_zicfilp
> +	lpad	0
> +#endif

The 'lpad' instructions aren't present in the upstream CRYPTOGAMS source.

If they are necessary, this addition needs to be documented.

But they appear to be unnecessary.

> +#ifndef	__CHERI_PURE_CAPABILITY__
> +	andi	$tmp0,$inp,7		# $inp % 8
> +	andi	$inp,$inp,-8		# align $inp
> +	slli	$tmp0,$tmp0,3		# byte to bit offset
> +#endif
> +	ld	$in0,0($inp)
> +	ld	$in1,8($inp)
> +#ifndef	__CHERI_PURE_CAPABILITY__
> +	beqz	$tmp0,.Laligned_key
> +
> +	ld	$tmp2,16($inp)
> +	neg	$tmp1,$tmp0		# implicit &63 in sll
> +	srl	$in0,$in0,$tmp0
> +	sll	$tmp3,$in1,$tmp1
> +	srl	$in1,$in1,$tmp0
> +	sll	$tmp2,$tmp2,$tmp1
> +	or	$in0,$in0,$tmp3
> +	or	$in1,$in1,$tmp2
> +
> +.Laligned_key:

This code is going through a lot of trouble to work on RISC-V CPUs that don't
support efficient misaligned memory accesses.  That includes issuing loads of
memory outside the bounds of the given buffer, which is questionable (even if
it's guaranteed to not cross a page boundary).

Is there any chance we can just make the RISC-V Poly1305 code be conditional on
CONFIG_RISCV_EFFICIENT_UNALIGNED_ACCESS=y?  Or do people not actually use that?

The rest of the kernel's RISC-V crypto code, which is based on the vector
extension, just assumes that efficient misaligned memory accesses are supported.

On a related topic, if this patch is accepted, the result will be inconsistent
optimization of ChaCha vs. Poly1305, which are usually paired:

    (1) ChaCha optimized with the RISC-V vector extension
    (2) Poly1305 optimized with RISC-V scalar instructions

Surely a RISC-V vector extension optimized Poly1305 is going to be needed too?

But with that being the case, will a RISC-V scalar optimized Poly1305 actually
be worthwhile to add too?  Especially without optimized ChaCha alongside it?

- Eric
