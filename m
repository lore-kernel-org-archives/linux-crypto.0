Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A14479892
	for <linux-crypto@vger.kernel.org>; Sun,  4 Oct 2026 18:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791137005; cv=none; b=Qj0VQKhqNGUr0DU66wyoI8itBdsUd8M2M+ntunlNNM3kBzsQwCEUnCQJ49iWUY1D7QKiLbwVBBW1TXCjxefgD/jC6Uxu5qA2ZVETrnnJ0ORRaeU9W+DKH0PWusjJkjtZSsI3jJbdH/Osfs16snDZ71I1u4sUp9mrMEKwb+Eoe8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791137005; c=relaxed/simple;
	bh=dNKM+sahtRYM7Fk0yEqNixvM/s91PnZHoKUvFlUKi/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iyeSTdeZ/bicMNZ3bQKldGS/QeVKxJInbjIroW5iWrZCvEwH8w2X1FPXWAWBfKfErPtdqmKH0YtxJ/QjEb5Y/ThI6npMNyCLClXUTXqr3y5QzK/dtxWzS3kYEFHv9oKM9pwIkc+jwrSCWZxBT46ttBAPAkSQSqWbNeKwzwBeuok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=InMqn0R5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="InMqn0R5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A171F000FF;
	Sun,  4 Oct 2026 18:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791137000;
	bh=Iq/0zGgwz7z19bg3mZHaHi5SzqsONlQc1uYFxb3hszA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=InMqn0R5e/6MxNV2kjat6PZgw4gr6MZPEuPcZFnHp2wFPNOMY1N+GLSFLkdSA37Sv
	 p/t7hLe9QG6GpNRBeTQg0yuU8XwBeFKgyKJrmyuByx+Ma7/eOqi5t8HuYmlltGkanV
	 tofvADGBMOVMD0xEYF5zpRBGBQ2xMepQlzrBwA3aja269UaUhuxXFWPvq5kYVDJyN8
	 uDU/8KuXZeb1Cq1gsZjw7B3n2N91XaYKTgY9YpZJqrxXQXnHcvJVE5gdMtCm5PrFN2
	 wD0oY3/co3ZekJk2An1k96tAG43Ib5Rq9onF/w7+3xWFXaGtKOOsrEiojnmhBLVKPq
	 m+xUJKKWmOACw==
Date: Sun, 4 Oct 2026 20:03:16 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: Martin Willi <martin@strongswan.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: x86/chacha: Add a 16-block AVX-512 variant
Message-ID: <20261004180316.GE1906@quark>
References: <20260722153247.630519-1-martin@strongswan.org>
 <20260722232424.GA50619@quark>
 <aaca79db6bd81c539b1f1698603c7249be48a7b7.camel@strongswan.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aaca79db6bd81c539b1f1698603c7249be48a7b7.camel@strongswan.org>

On Thu, Jul 23, 2026 at 01:03:50PM +0200, Martin Willi wrote:
> Hi Eric,
> 
> > This is very similar to the existing chacha_8block_xor_avx512vl(), just
> > with 512-bit vectors instead of 256-bit.  They even use the same CPU
> > instruction set extensions: there are actually no cases where a CPU can
> > run chacha_8block_xor_avx512vl() but not chacha_16block_xor_avx512()
> > (the choice of vector length is just going to be made by policy).
> > 
> > Given that, could we consolidate these implementations?
> 
> Yes, it is doable, but with some constraints:
> 
>  * In the 512-bit version, adding the initial state to the result uses
>    a small optimization with re-broadcasting, so it differs from the
>    256-bit variant. That optimization can be applied to the 256-bit
>    version for a unification, but would mean a change to it.
>  * The larger part of the interleaving tail is different and will
>    require separate code paths.
> 
> So the net win is shared broadcasting/doubleround at the cost of some
> macro complexity. I'll give it a try.
> 
> > Well, this is one of the cases where
> > cpu_has_xfeatures(XFEATURE_MASK_AVX512) was already required by the
> > existing code (since all AVX512 bits need to be enabled for any EVEX
> > coded instructions to work, even on xmm/ymm).  But it was never checked,
> > and no one ever noticed.  I would just continue to leave it out.
> > 
> > You can also drop the check of X86_FEATURE_AVX512F, which is implied by
> > X86_FEATURE_AVX512VL and X86_FEATURE_AVX512BW already.
> 
> Ok, will do so.

Hi Martin, is there any update on this?

- Eric
