Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9564917A30E;
	Thu, 17 Apr 2025 17:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744909746; cv=none; b=hnL+TR64QRiQKce3Kgyj8mUDFVjNY7IRRpuuQ5kooFHJL90J122N6qPnfsPuL5AVmcH9buGEoi1HrMGHknrHWLm5RX0VbtNdDPNh3iv8RhnnUuVVc15zpoDvAmS4tOvfdz7CZxXoZDN2XJkv/9Nd4lTWowe8aUnLPB3tnmJZOtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744909746; c=relaxed/simple;
	bh=aXl1F7DYGZK/3+f9nUBSaSrK3fpSv8lUhV4sdPl1Pzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=USniXFoOSQYGofXE8xjJ4aJNTjX/p34e1eiUlQqDaEqc/xUm5JeLTLXY7g314Kr/DEBv2QriTGVA6kYNeCQjMh1PnDjb+q0TgcJKxKz1Ptcb4BHRrK2glqnPqmBIqmckF3OwnOgsisoLx+ZFEAWkaui3Ei8eXCw+Mh8pWbDf+pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=by+shk2p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="by+shk2p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51871C4CEE4;
	Thu, 17 Apr 2025 17:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744909746;
	bh=aXl1F7DYGZK/3+f9nUBSaSrK3fpSv8lUhV4sdPl1Pzo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=by+shk2pyqFJi+oU8vs4I6gsrXz3huX4Z9IWciIC6ih2uPa6SHpEsEEPCAodQvdLg
	 ugshnCu9bMRvUWjP2sOA4TGQbNtmN9wnnEK6P80HzEdeDOVmsnqx+Gz8mRfXTMfL6g
	 OHsN+ebMBW2CDMz/Ud8cWVuxMv9cwnajxiy7D2S6zD6Q63Gm5P51HaE1uf2LmUp+CO
	 KF/n7h2PfNE+2BrIE82RrEmMNqruQ/AIaGTDsGLBbxkD/Jy4Rs1swBWhECQaiguYSN
	 Y0r5XkaTlb+sEYNa3gfO42r0JRDj7rCLmkIc6S2wYGtzmmYedOUWfOmKrD4jGYiaEE
	 /aDFiuUcgpEXw==
Date: Thu, 17 Apr 2025 10:09:02 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Qingfang Deng <dqfext@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Christoph =?iso-8859-1?Q?M=FCllner?= <christoph.muellner@vrull.eu>,
	Heiko Stuebner <heiko.stuebner@vrull.eu>,
	Qingfang Deng <qingfang.deng@siflower.com.cn>
Subject: Re: [RFC PATCH] crypto: riscv: scalar accelerated GHASH
Message-ID: <20250417170902.GC800@quark.localdomain>
References: <20250417064940.68469-1-dqfext@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250417064940.68469-1-dqfext@gmail.com>

On Thu, Apr 17, 2025 at 02:49:38PM +0800, Qingfang Deng wrote:
> +static __always_inline u64 riscv_zbb_swab64(u64 val)
> +{
> +	asm (".option push\n"
> +	     ".option arch,+zbb\n"
> +	     "rev8 %0, %1\n"
> +	     ".option pop\n"
> +	     : "=r" (val) : "r" (val));
> +	return val;
> +}
> +
> +static __always_inline __uint128_t get_unaligned_be128(const u8 *p)
> +{
> +	__uint128_t val;
> +#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> +	val = *(__uint128_t *)p;
> +	val = riscv_zbb_swab64(val >> 64) | (__uint128_t)riscv_zbb_swab64(val) << 64;
> +#else
> +	val = (__uint128_t)p[0] << 120;
> +	val |= (__uint128_t)p[1] << 112;
> +	val |= (__uint128_t)p[2] << 104;
> +	val |= (__uint128_t)p[3] << 96;
> +	val |= (__uint128_t)p[4] << 88;
> +	val |= (__uint128_t)p[5] << 80;
> +	val |= (__uint128_t)p[6] << 72;
> +	val |= (__uint128_t)p[7] << 64;
> +	val |= (__uint128_t)p[8] << 56;
> +	val |= (__uint128_t)p[9] << 48;
> +	val |= (__uint128_t)p[10] << 40;
> +	val |= (__uint128_t)p[11] << 32;
> +	val |= (__uint128_t)p[12] << 24;
> +	val |= (__uint128_t)p[13] << 16;
> +	val |= (__uint128_t)p[14] << 8;
> +	val |= (__uint128_t)p[15];
> +#endif
> +	return val;
> +}
> +
> +static __always_inline void put_unaligned_be128(__uint128_t val, u8 *p)
> +{
> +#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> +	*(__uint128_t *)p = riscv_zbb_swab64(val >> 64) | (__uint128_t)riscv_zbb_swab64(val) << 64;
> +#else
> +	p[0] = val >> 120;
> +	p[1] = val >> 112;
> +	p[2] = val >> 104;
> +	p[3] = val >> 96;
> +	p[4] = val >> 88;
> +	p[5] = val >> 80;
> +	p[6] = val >> 72;
> +	p[7] = val >> 64;
> +	p[8] = val >> 56;
> +	p[9] = val >> 48;
> +	p[10] = val >> 40;
> +	p[11] = val >> 32;
> +	p[12] = val >> 24;
> +	p[13] = val >> 16;
> +	p[14] = val >> 8;
> +	p[15] = val;
> +#endif
> +}

Please help properly optimize swab*() and {get,put}_unaligned_* for RISC-V
first, before considering random hacks like this.

https://lore.kernel.org/r/20250403-riscv-swab-v3-0-3bf705d80e33@iencinas.com
is working on swab*().

> +		/* Multiplication (without Karatsuba) */
> +		t0 = clmul128(p_lo, k_lo);
> +		t1 = clmul128(p_lo, k_hi);
> +		t2 = clmul128(p_hi, k_lo);
> +		t3 = clmul128(p_hi, k_hi);
> +		mid = t1 ^ t2;
> +		lo = t0 ^ (mid << 64);
> +		hi = t3 ^ (mid >> 64);

There is no need to explicitly XOR 'mid << 64' into lo and 'mid >> 64' into hi.
Take a look at how arch/x86/crypto/aes-gcm-*.S do it.

Also, since this is only doing one block at a time and does not use Karatsuba
multiplication, the single-step reduction would work well here.  See
aes-gcm-aesni-x86_64.S.

- Eric
