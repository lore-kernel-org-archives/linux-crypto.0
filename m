Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098382F5A1A;
	Tue,  9 Dec 2025 23:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765321930; cv=none; b=S1vvng2CFHFpm5kXsh5ZsdBJ7+nX4DjjV0LV6jx0bNTuFkIBJr2nH4/dtoiuH2tdRlEZLZBpv70SkjfosnnXhJKLXy54xSGeZGMi+VwKItcXJgx2cc3DvnYD+FPSmg7E0wdRi70znwvZn7dPmD3BOff1q1SCLz5OQOEJKDhoXC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765321930; c=relaxed/simple;
	bh=dOAJWjzwU/24sx5t+aWrT0lj9C4TaECJbxIz9cLUCfk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hWTOhRAvbH89RyKtxhUjvwFuBZbHOjQQJRsI09uvU1gk/5jNiQ9TA6LN1zbI7HXGZ4ZAMicykNkJ/HDaSvg/IHYSztxtnXNCUQYhjHA28YHHTIWw8vtixwhwWSdqtERrBh05eZwTHmqXMPIVUiL16TRB5tIjcoID6c686AIuar4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MH5f5neb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MH5f5neb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB47C4CEF5;
	Tue,  9 Dec 2025 23:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765321929;
	bh=dOAJWjzwU/24sx5t+aWrT0lj9C4TaECJbxIz9cLUCfk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MH5f5nebthMzdcO/r0VOSjY+F+5gNezwlJuKLAfEsQkLR1sIsrqMvmJKmUds5+FCP
	 sYVbwqG4LLuxzvCjlkI+WJWz5CSae2qUD7FYTP+gTcDKVyYQSma3r+YpyLRgGc3Q65
	 ZPQU515jPo78fRNM+qbfyDuZzsvK2zD9zvNoEYTAJR21WfPelH5K7boV2LYKmdSGJZ
	 dcnJsus1wS7JRgSmcVuh55ZcY1I/hvDxoQGBT0+QV0V1LXBlk1+xKbBBo09tPBqAMz
	 05VyZcqL+azb23iF5rixFnAPAdUzyU44hYZuxh646/RfG9fbvdNplyR1JPWbgfCugq
	 8DsZ1j2XpU3GQ==
Date: Tue, 9 Dec 2025 15:12:07 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	Jerry Shih <jerry.shih@sifive.com>,
	"David S . Miller" <davem@davemloft.net>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Han Gao <gaohan@iscas.ac.cn>, linux-riscv@lists.infradead.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: riscv: Depend on
 RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
Message-ID: <20251209231207.GD54030@quark>
References: <20251206213750.81474-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251206213750.81474-1-ebiggers@kernel.org>

On Sat, Dec 06, 2025 at 01:37:50PM -0800, Eric Biggers wrote:
> Replace the RISCV_ISA_V dependency of the RISC-V crypto code with
> RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS, which implies RISCV_ISA_V as
> well as vector unaligned accesses being efficient.
> 
> This is necessary because this code assumes that vector unaligned
> accesses are supported and are efficient.  (It does so to avoid having
> to use lots of extra vsetvli instructions to switch the element width
> back and forth between 8 and either 32 or 64.)
> 
> This was omitted from the code originally just because the RISC-V kernel
> support for detecting this feature didn't exist yet.  Support has now
> been added, but it's fragmented into per-CPU runtime detection, a
> command-line parameter, and a kconfig option.  The kconfig option is the
> only reasonable way to do it, though, so let's just rely on that.
> 
> Fixes: eb24af5d7a05 ("crypto: riscv - add vector crypto accelerated AES-{ECB,CBC,CTR,XTS}")
> Fixes: bb54668837a0 ("crypto: riscv - add vector crypto accelerated ChaCha20")
> Fixes: 600a3853dfa0 ("crypto: riscv - add vector crypto accelerated GHASH")
> Fixes: 8c8e40470ffe ("crypto: riscv - add vector crypto accelerated SHA-{256,224}")
> Fixes: b3415925a08b ("crypto: riscv - add vector crypto accelerated SHA-{512,384}")
> Fixes: 563a5255afa2 ("crypto: riscv - add vector crypto accelerated SM3")
> Fixes: b8d06352bbf3 ("crypto: riscv - add vector crypto accelerated SM4")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

I also added:

    Reported-by: Vivian Wang <wangruikang@iscas.ac.cn>
    Closes: https://lore.kernel.org/r/b3cfcdac-0337-4db0-a611-258f2868855f@iscas.ac.cn/

- Eric
