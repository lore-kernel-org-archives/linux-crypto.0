Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16F61AE059;
	Thu, 29 Aug 2024 13:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724937192; cv=none; b=AwWLgXZ/HPohWdDzJGRCZlXs43f4GNdMVWJg2mROfwN6SPW9Vrmd6Gfgf7E/C9msRYe/JXltnn2gVM201ztXWbGJawBzYCedJgwYZxhZHADffIJYpqwQy49TPTmVbKlcdEns6UpUw1hyhyjQOPXVeGs8xa2G6md4hq6VjocPZhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724937192; c=relaxed/simple;
	bh=P0SU4Uq/KibzgxuLiStzRDjp877kavMW2p4snspj9Vw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PVvr0G2nU5RxU2wZ/TUYRdRtYRyV7q8YgZun87Jn801rqkNJjG8g1WM9Vy0bFfLmxGyjRSNEqRVl2oPYHgJUe69mh2AuXqsxD3sIxvupmLoXGrwrXF7LhiUCfMsV9Z36AqV68X6oa3zVktnVHQU6s46/+rC0F8XEdakPtWl8CYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=MPJEa5F6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="MPJEa5F6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E040C4AF0C;
	Thu, 29 Aug 2024 13:13:10 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="MPJEa5F6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1724937189;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3dmuou++vOol9G+qKlRss7jg5q3v8/cQtkGWgqWGNeA=;
	b=MPJEa5F64/6flfvGqNPKHMpR9EnBhnaMmP0DTVjgOmpmNa85ZGuzqOnFpB4R1JtL4LuW8n
	CUYbPFuoKYkS5zqXls6RHVz3mTIOx8c/JoSziQfzMO8YQyOcNgovMOc/tH5f6FVGkmLTkx
	bThCqqm8re3HL0zSBKOESus3WXjRvR4=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d4cdc9e7 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 29 Aug 2024 13:13:08 +0000 (UTC)
Date: Thu, 29 Aug 2024 15:13:06 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Xi Ruoyao <xry111@xry111.site>, Huacai Chen <chenhuacai@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
	linux-crypto@vger.kernel.org, loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org, Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: Re: [PATCH v5] LoongArch: vDSO: Wire up getrandom() vDSO
 implementation
Message-ID: <ZtBz4l--dxkNt7yG@zx2c4.com>
References: <20240829125656.19017-1-xry111@xry111.site>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240829125656.19017-1-xry111@xry111.site>

Hi Huacai & Ruoyao,

On Thu, Aug 29, 2024 at 08:56:55PM +0800, Xi Ruoyao wrote:
> Hook up the generic vDSO implementation to the LoongArch vDSO data page
> by providing the required __arch_chacha20_blocks_nostack,
> __arch_get_k_vdso_rng_data, and getrandom_syscall implementations.
> 
> Also enable the vDSO getrandom tests for LoongArch: create the symlink
> to the arch/loongarch/vdso directory, and correctly set the ARCH
> variable for LoongArch.
> 
> Signed-off-by: Xi Ruoyao <xry111@xry111.site>
> ---
>
> Passed vdso_test_getrandom and vdso_test_chacha tests.  Benchmark
> results:
> 
> vdso_test_getrandom bench-single:
> 
>        vdso: 25000000 times in 0.499490289 seconds
>        libc: 25000000 times in 6.963829873 seconds
>     syscall: 25000000 times in 6.983413486 seconds
> 
> vdso_test_getrandom bench-multi:
>        vdso: 25000000 x 256 times in 28.703710823 seconds
>        libc: 25000000 x 256 times in 356.835801784 seconds
>        syscall: 25000000 x 256 times in 338.525837197 seconds
 
Thanks for including the test results. I've also verified the
vdso_test_chacha and can confirm that passes:

zx2c4@thinkpad ~/Projects/random-linux/tools/testing/selftests/vDSO $  /home/zx2c4/Downloads/Chrome/cross-tools/bin/loongarch64-unknown-linux-gnu-gcc -std=gnu99 -D_GNU_SOURCE= -idirafter /home/zx2c4/Projects/random-linux/tools/testing/selftests/../../../tools/include -idirafter /home/zx2c4/Projects/random-linux/tools/testing/selftests/../../../arch/loongarch/include -idirafter /home/zx2c4/Projects/random-linux/tools/testing/selftests/../../../include -D__ASSEMBLY__ -Wa,--noexecstack    vdso_test_chacha.c /home/zx2c4/Projects/random-linux/tools/testing/selftests/../../../tools/arch/loongarch/vdso/vgetrandom-chacha.S  -o /home/zx2c4/Projects/random-linux/tools/testing/selftests/vDSO/vdso_test_chacha -static
zx2c4@thinkpad ~/Projects/random-linux/tools/testing/selftests/vDSO $ qemu-loongarch64 /home/zx2c4/Projects/random-linux/tools/testing/selftests/vDSO/vdso_test_chacha
TAP version 13
1..1
ok 1 chacha: PASS

So, with the asm-offsets.c snippet removed as you instructed, this is
fine for me. I'll happily queue this up for 6.12, but I'd like Huacai's
Acked-by first.

Huacai, does this look okay to you?

Thanks,
Jason
