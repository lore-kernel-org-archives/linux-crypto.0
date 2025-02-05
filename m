Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E281FCD07;
	Wed,  5 Feb 2025 16:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738773015; cv=none; b=IwZTCxlIGwZKUM5dlBuw+CF0A2Sa9FK0eNOlS1aPZ6TPXda3XWUFNfj59iqHqDD8+/F7GkfO4d871mUshfO7e3K8kLRIeLXWNndpBcWXwh6xg3a1sDuGut6tNTOycZ/YiGIRagYpu8VTjdaR/fHxf15uLePCrX0mG5U4dyI9+74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738773015; c=relaxed/simple;
	bh=+6aRCaTOfyio0lD6Nw0WgylHhIrEaav3y6vOHne/HNM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kDi8Phek9eKTA+75vJs7NH1HreluFsyWAkh0T0TXGfEYDX7DJ/hdrKT/n6YHpgrm8TwTtAyR3T33bnEun9df2Lg0uxg6btbBlzlND8PrlrPkm1m44kMXL39xPQVvmCovo5/XRWs0ClvSJLzFINYBfnLpNhcEFxh1V1ardOd4geY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O5k97lnm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O5k97lnm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E9BC4CED1;
	Wed,  5 Feb 2025 16:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738773014;
	bh=+6aRCaTOfyio0lD6Nw0WgylHhIrEaav3y6vOHne/HNM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O5k97lnmHoTCWPHwhXO4sMZQ+ZVHFuBDyOUF+AVba3Vvh1td7KZFGSP8TjEEKgY2f
	 EbbEslN/TE620B2ceOqQ00z86QFEiH0yfElimctL165QIPD1M/UEKq3r2W8UASpOzu
	 SBxMyNRBXavz6kIC6ntm7AQ4ugor0w/ND7eLB8HjRagjWsTDXs02lTf/ghNxnKU5ev
	 v5mdhiPNYnm+BxBia25hS5WJy1TeHZuuNGGQFNW7Jb7KOnjEXYmrRuQ7i+vVuNCDKS
	 ulfaC6xywoffDRvpFBSVg8UsWFlRgjpLWJrZ2FiOipmMiQ6XrA5nFbhHgNNhmCwSuu
	 zzTrDBxsbpBVw==
Date: Wed, 5 Feb 2025 08:30:12 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Zhihang Shao <zhihang.shao.iscas@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org, ardb@kernel.org
Subject: Re: [PATCH v3] riscv: Optimize crct10dif with zbc extension
Message-ID: <20250205163012.GB1474@sol.localdomain>
References: <20250205065815.91132-1-zhihang.shao.iscas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250205065815.91132-1-zhihang.shao.iscas@gmail.com>

On Wed, Feb 05, 2025 at 02:58:15PM +0800, Zhihang Shao wrote:
> The current CRC-T10DIF algorithm on RISC-V platform is based on
> table-lookup optimization.
> Given the previous work on optimizing crc32 calculations with zbc
> extension, it is believed that this will be equally effective for
> accelerating crc-t10dif.
> 
> Therefore this patch offers an implementation of crc-t10dif using zbc
> extension. This can detect whether the current runtime environment
> supports zbc feature and, if so, uses it to accelerate crc-t10dif
> calculations.
> 
> This patch is updated due to the patchset of updating kernel's
> CRC-T10DIF library in 6.14, which is finished by Eric Biggers.
> Also, I used crc_kunit.c to test the performance of crc-t10dif optimized
> by crc extension.
> 
> Signed-off-by: Zhihang Shao <zhihang.shao.iscas@gmail.com>
> ---
>  arch/riscv/Kconfig                |   1 +
>  arch/riscv/lib/Makefile           |   1 +
>  arch/riscv/lib/crc-t10dif-riscv.c | 132 ++++++++++++++++++++++++++++++
>  3 files changed, 134 insertions(+)
>  create mode 100644 arch/riscv/lib/crc-t10dif-riscv.c

Acked-by: Eric Biggers <ebiggers@kernel.org>
Tested-by: Eric Biggers <ebiggers@kernel.org>

This can go through the riscv tree.

Some minor comments below.

> +static inline u64 crct10dif_prep(u16 crc, unsigned long const *ptr)
> +{
> +	return ((u64)crc << 48) ^ (__force u64)__cpu_to_be64(*ptr);
> +}
> +
> +#elif __riscv_xlen == 32
> +#define STEP_ORDER 2
> +#define CRCT10DIF_POLY_QT_BE 0xf65a57f8
> +
> +static inline u32 crct10dif_prep(u16 crc, unsigned long const *ptr)
> +{
> +	return ((u32)crc << 16) ^ (__force u32)__cpu_to_be32(*ptr);
> +}

Maybe use 'const __be64 *' and 'const __be32 *' for the pointer, and use
be64_to_cpu() and be32_to_cpu().  Then the __force cast won't be needed.

> +static inline u16 crct10dif_zbc(unsigned long s)
> +{
> +	u16 crc;
> +
> +	asm volatile   (".option push\n"
> +			".option arch,+zbc\n"
> +			"clmulh %0, %1, %2\n"
> +			"xor    %0, %0, %1\n"
> +			"clmul  %0, %0, %3\n"
> +			".option pop\n"
> +			: "=&r" (crc)
> +			: "r"(s),
> +			  "r"(CRCT10DIF_POLY_QT_BE),
> +			  "r"(CRCT10DIF_POLY)
> +			:);
> +
> +	return crc;
> +}

A comment mentioning that this is using Barrett reduction would be helpful.

BTW, this is fine for an initial implementation, but eventually we'll probably
want to make it fold multiple words at a time to take advantage of
instruction-level parallelism, like the x86 PCLMULQDQ code does.  We also might
be able to share code among all the CRC variants like what I'm doing for x86.

> +#define STEP (1 << STEP_ORDER)
> +#define OFFSET_MASK (STEP - 1)

You can just remove the above #defines and use 'sizeof(unsigned long)' directly.
You can even use the % and / operators since the compiler optimizes them.
arch/x86/lib/crc32-glue.c does this.

> +	p = (unsigned char const *)p_ul;

Please use 'const u8 *'.

Thanks!

- Eric
