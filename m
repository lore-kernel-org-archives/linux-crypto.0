Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5087B328B55;
	Tue, 11 Nov 2025 19:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762890465; cv=none; b=tfcip99/WOpxGwHbURYtkWrTE6aglF9KZ5NmZ/0k/VhQ+Csi8hSiJw6TktWtIJe2i608W3IrYkOkZWw+kI18fypx+zSR/75Rjmi+eDeJNPUiOysmPb5Aj+wuA29iny4bIdtZZgvW9CH6kmCjSlj7Fi5IUL1ZuJHl091OE4THC3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762890465; c=relaxed/simple;
	bh=mCWzpThDjN5TvH7+u9w2bjcbob9OsN/ZO/i3S0cLekY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UJjaAL19AbOtyZaHoeEr2ERnDWk2mYkHZEeg48HXJFD7FtYoGRAATPvg7AtGhoL1ZE6hUjhCPkRaOlaflqO0p79JhApDfKSRyK1LyQNfzHX8weLFYQCq4AIZYD4yMt2h6kY3ZdLKfly4g/NrNZ4VJOLDVy66BH0UfIeRKtBVO74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ulGRTYcF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ulGRTYcF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC2AC4CEFB;
	Tue, 11 Nov 2025 19:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762890464;
	bh=mCWzpThDjN5TvH7+u9w2bjcbob9OsN/ZO/i3S0cLekY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ulGRTYcFEuZimkoAP/r0AD2cIzkKuHt5KfougKS4nXxolAjtb8zU7bfDKFn9SE6Fo
	 QTic7e2gPOvOCbSbnNNfKp3dL+cply1xTky+wOuDfmjYvHLLljjv1IfmpLcLgKnQyx
	 qDSO8KCIsYuBMIAXixeXc5fiDPLLlU4pmj1Ia4509y7R9l6mDU8LAPKzSHW0e0KwuF
	 wBaj0VQX9OS3mkh0Bw8zjgOehw/syCPaWdebgfe+0zf22BZmIBHebPgia+GlSxLvz6
	 HKIJhAXdMiipdJGZtEJwma4lVQ160SL1bn0BPcbL4xk5JwAU7A9jZyw/P1ELXt0DLE
	 Ug3MrRju2GOjQ==
Date: Tue, 11 Nov 2025 11:46:03 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org
Subject: Re: [PATCH 2/9] lib/crypto: polyval: Add POLYVAL library
Message-ID: <20251111194603.GB1748@sol>
References: <20251109234726.638437-1-ebiggers@kernel.org>
 <20251109234726.638437-3-ebiggers@kernel.org>
 <CAMj1kXE1mhu7u5RwhCBA_RUGV6JSDV-GQPpq+thE-0-oVxrmfw@mail.gmail.com>
 <CAMj1kXHoH2K0dpqyrgFJ-OBmP2QrUWZD3aCfaA_eoPzGsLbPMw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHoH2K0dpqyrgFJ-OBmP2QrUWZD3aCfaA_eoPzGsLbPMw@mail.gmail.com>

On Tue, Nov 11, 2025 at 08:42:29AM +0100, Ard Biesheuvel wrote:
> On Mon, 10 Nov 2025 at 16:21, Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > Hi,
> >
> > On Mon, 10 Nov 2025 at 00:49, Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > Add support for POLYVAL to lib/crypto/.
> > >
> > > This will replace the polyval crypto_shash algorithm and its use in the
> > > hctr2 template, simplifying the code and reducing overhead.
> > >
> > > Specifically, this commit introduces the POLYVAL library API and a
> > > generic implementation of it.  Later commits will migrate the existing
> > > architecture-optimized implementations of POLYVAL into lib/crypto/ and
> > > add a KUnit test suite.
> > >
> > > I've also rewritten the generic implementation completely, using a more
> > > modern approach instead of the traditional table-based approach.  It's
> > > now constant-time, requires no precomputation or dynamic memory
> > > allocations, decreases the per-key memory usage from 4096 bytes to 16
> > > bytes, and is faster than the old polyval-generic even on bulk data
> > > reusing the same key (at least on x86_64, where I measured 15% faster).
> > > We should do this for GHASH too, but for now just do it for POLYVAL.
> > >
> >
> > Very nice.
> >
> > GHASH might suffer on 32-bit, I suppose, but taking this approach at
> > least on 64-bit also for GHASH would be a huge improvement.
> >
> > I had a stab at replacing the int128 arithmetic with
> > __builtin_bitreverse64(), but it seems to make little difference (and
> > GCC does not support it [yet]). I've tried both arm64 and x86, and the
> > perf delta (using your kunit benchmark) is negligible in either case.
> 
> Sigh. I intended to only apply the generic patch and the kunit test,
> but applied the whole series in the end, which explains perfectly why
> x86_64 and arm64 performance are identical, given that the generic
> code isn't even used.
> 
> So trying this again, on a Cortex-A72 without Crypto Extensions, I do
> get a ~30% performance improvement doing the below. I haven't
> re-tested x86, but given that it does not appear to have a native
> scalar bit reverse instruction (or __builtin_bitreverse64() is broken
> for it), there is probably no point in finding out.
> 
> Not saying we should do this for POLYVAL, but something to keep in
> mind for gf128mul.c perhaps.
> 
> 
> --- a/lib/crypto/polyval.c
> +++ b/lib/crypto/polyval.c
> @@ -42,11 +42,48 @@
>   * 256-bit => 128-bit reduction algorithm.
>   */
> 
> -#ifdef CONFIG_ARCH_SUPPORTS_INT128
> +#if defined(CONFIG_ARCH_SUPPORTS_INT128) ||
> __has_builtin(__builtin_bitreverse64)
> 
>  /* Do a 64 x 64 => 128 bit carryless multiplication. */
>  static void clmul64(u64 a, u64 b, u64 *out_lo, u64 *out_hi)
>  {
> +       u64 a0 = a & 0x1111111111111111;
> +       u64 a1 = a & 0x2222222222222222;
> +       u64 a2 = a & 0x4444444444444444;
> +       u64 a3 = a & 0x8888888888888888;
> +
> +       u64 b0 = b & 0x1111111111111111;
> +       u64 b1 = b & 0x2222222222222222;
> +       u64 b2 = b & 0x4444444444444444;
> +       u64 b3 = b & 0x8888888888888888;
> +
> +#if __has_builtin(__builtin_bitreverse64)
> +#define brev64 __builtin_bitreverse64
> +       u64 c0 = (a0 * b0) ^ (a1 * b3) ^ (a2 * b2) ^ (a3 * b1);
> +       u64 c1 = (a0 * b1) ^ (a1 * b0) ^ (a2 * b3) ^ (a3 * b2);
> +       u64 c2 = (a0 * b2) ^ (a1 * b1) ^ (a2 * b0) ^ (a3 * b3);
> +       u64 c3 = (a0 * b3) ^ (a1 * b2) ^ (a2 * b1) ^ (a3 * b0);
> +
> +       a0 = brev64(a0);
> +       a1 = brev64(a1);
> +       a2 = brev64(a2);
> +       a3 = brev64(a3);
> +
> +       b0 = brev64(b0);
> +       b1 = brev64(b1);
> +       b2 = brev64(b2);
> +       b3 = brev64(b3);
> +
> +       u64 d0 = (a0 * b0) ^ (a1 * b3) ^ (a2 * b2) ^ (a3 * b1);
> +       u64 d1 = (a0 * b1) ^ (a1 * b0) ^ (a2 * b3) ^ (a3 * b2);
> +       u64 d2 = (a0 * b2) ^ (a1 * b1) ^ (a2 * b0) ^ (a3 * b3);
> +       u64 d3 = (a0 * b3) ^ (a1 * b2) ^ (a2 * b1) ^ (a3 * b0);
> +
> +       *out_hi = ((brev64(d0) >> 1) & 0x1111111111111111) ^
> +                 ((brev64(d1) >> 1) & 0x2222222222222222) ^
> +                 ((brev64(d2) >> 1) & 0x4444444444444444) ^
> +                 ((brev64(d3) >> 1) & 0x8888888888888888);

Yeah, that's an interesting idea!  So if we bit-reflect the inputs, do
an n x n => n multiplication, and bit-reflect the output and right-shift
it by 1, we get the high half of the desired n x n => 2n multiplication.
(This relies on the fact that carries are being discarded.)  Then we
don't need an instruction that does an n x n => 2n multiplication or
produces the high half of it.

The availability of hardware bit-reversal is limited, though.  arm32,
arm64, and mips32r6 have it.  But all of those also have a "multiply
high" instruction.  So the 30% performance improvement you saw on arm64
seems surprising to me, as umulh should have been used.  (I verified
that it's indeed used in the generated asm with both gcc and clang.)

The available bit-reversal abstractions aren't too great either, with
__builtin_bitreverse64() being clang-specific and <linux/bitrev.h>
having a table-based, i.e. non-constant-time, fallback.  So presumably
we'd need to add our own which is guaranteed to use the actual
instructions and not some slow and/or table-based fallback.

I'll definitely look into this more later when bringing this improvement
to GHASH too.  But for now I think we should go with the version I have
in my patch.

- Eric
