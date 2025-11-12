Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E282FFDE4
	for <linux-crypto@vger.kernel.org>; Wed, 12 Nov 2025 10:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762943556; cv=none; b=g+mNT/FANmFmNw2b7T0/LJk6AaAPP72+F798Z7vYO6h7K4ZdyB8X8D2VfRH/geNhLu89Ah1/q3ISqJPxVuTYkSjcFzG6qcCN52l2Mp+0zvfW4R8+0XQ3LvdyqTgY9KnQSX+mMkVPdlK3iDMkJPHc3qsHkzUMYaufbjAMYi2CjPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762943556; c=relaxed/simple;
	bh=ywubOylLCebiTSUrMRLnw9fCTyEak2lItra9Lxo4L9o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hNQa8V7opWwdqACsGr2NM4izKNTU+dR+MDbcc81eZaaW28CnGRxJ1ctby3CwPyUXDy+0+QezfHzODrQBRqTJdGMLBVrx9mSxy2fyrke1qaAYV5hy+K/YvZ8sbQ/Pzv7aJ6v+6E/PhtUlb4rGZibMxmSFlpVf+OBHvrIrU4Kz5VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lozUXJCC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lozUXJCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C804C4CEF7
	for <linux-crypto@vger.kernel.org>; Wed, 12 Nov 2025 10:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762943556;
	bh=ywubOylLCebiTSUrMRLnw9fCTyEak2lItra9Lxo4L9o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=lozUXJCCBKuEa9qQ4I0eArY7t6Npnh8rBdaPFD6MqAKwV6BmGNA+b2+z8M4nu8fV+
	 RoGM2BQUIPMWWhx2wf833+y4HqznotSAJeVZ+Ck87uGOmxy3D0FbdZaBZwtvTNCnOu
	 1VjmITr5UP6qo2B6GAQgZQIoq//thkwgw5C5j/IeN+jzzvV7NvO6pPb8qltA2an6FM
	 cLxpj21KNmjdeWgGa1GAEMl9dHq8sMjeYapP9Gf/VaF+R8WOidl9BrvtI/w99u47iS
	 WXoB8b8Bdl206A56coAA145gNbCesYyTAzmXnUtnFTZs3MX/3ohNhHrpTeFv9YD/ZH
	 IHoPc6t/WXcJg==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5943d1d6471so673208e87.0
        for <linux-crypto@vger.kernel.org>; Wed, 12 Nov 2025 02:32:36 -0800 (PST)
X-Gm-Message-State: AOJu0Yzlyz3ufTnp9KO53F2pKFpiIsqKJ/UjVygQ9pHBw/VTTcdz46Yw
	4IJfVWsDUl+dzhVj+L1zFeCSsJjSqj1MSPuJ9sJbGK+et0FQug7x6EKOHYsMkEZbwx5R2LzxsYQ
	TCpj/6e6tj/iBBc8Ib1+2dxqjnADG1MQ=
X-Google-Smtp-Source: AGHT+IFMI1NWnlseQ2188hDT4d4Fwv2qI5ssFRnfdwUkxpJylGlSWzLDUQSzBOICWQAiTDvP3niRGlzQ+YcXKWMiwj8=
X-Received: by 2002:a05:6512:61cd:10b0:595:7a6c:7dd3 with SMTP id
 2adb3069b0e04-5957a6c81cbmr478959e87.5.1762943554915; Wed, 12 Nov 2025
 02:32:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251109234726.638437-1-ebiggers@kernel.org> <20251109234726.638437-3-ebiggers@kernel.org>
 <CAMj1kXE1mhu7u5RwhCBA_RUGV6JSDV-GQPpq+thE-0-oVxrmfw@mail.gmail.com>
 <CAMj1kXHoH2K0dpqyrgFJ-OBmP2QrUWZD3aCfaA_eoPzGsLbPMw@mail.gmail.com> <20251111194603.GB1748@sol>
In-Reply-To: <20251111194603.GB1748@sol>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 12 Nov 2025 11:32:23 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHZ9vaMHNvBb1ByjazwqJANv0pATGE7q0X=RmgsxS5i+w@mail.gmail.com>
X-Gm-Features: AWmQ_bk9G0YzBoCkb5nXtZ33vCph-hbQkuXNLFM_L9tnc29akWRGwOHjoeGq1aU
Message-ID: <CAMj1kXHZ9vaMHNvBb1ByjazwqJANv0pATGE7q0X=RmgsxS5i+w@mail.gmail.com>
Subject: Re: [PATCH 2/9] lib/crypto: polyval: Add POLYVAL library
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-arm-kernel@lists.infradead.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 11 Nov 2025 at 20:47, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Nov 11, 2025 at 08:42:29AM +0100, Ard Biesheuvel wrote:
> > On Mon, 10 Nov 2025 at 16:21, Ard Biesheuvel <ardb@kernel.org> wrote:
> > >
> > > Hi,
> > >
> > > On Mon, 10 Nov 2025 at 00:49, Eric Biggers <ebiggers@kernel.org> wrote:
> > > >
> > > > Add support for POLYVAL to lib/crypto/.
> > > >
> > > > This will replace the polyval crypto_shash algorithm and its use in the
> > > > hctr2 template, simplifying the code and reducing overhead.
> > > >
> > > > Specifically, this commit introduces the POLYVAL library API and a
> > > > generic implementation of it.  Later commits will migrate the existing
> > > > architecture-optimized implementations of POLYVAL into lib/crypto/ and
> > > > add a KUnit test suite.
> > > >
> > > > I've also rewritten the generic implementation completely, using a more
> > > > modern approach instead of the traditional table-based approach.  It's
> > > > now constant-time, requires no precomputation or dynamic memory
> > > > allocations, decreases the per-key memory usage from 4096 bytes to 16
> > > > bytes, and is faster than the old polyval-generic even on bulk data
> > > > reusing the same key (at least on x86_64, where I measured 15% faster).
> > > > We should do this for GHASH too, but for now just do it for POLYVAL.
> > > >
> > >
> > > Very nice.
> > >
> > > GHASH might suffer on 32-bit, I suppose, but taking this approach at
> > > least on 64-bit also for GHASH would be a huge improvement.
> > >
> > > I had a stab at replacing the int128 arithmetic with
> > > __builtin_bitreverse64(), but it seems to make little difference (and
> > > GCC does not support it [yet]). I've tried both arm64 and x86, and the
> > > perf delta (using your kunit benchmark) is negligible in either case.
> >
> > Sigh. I intended to only apply the generic patch and the kunit test,
> > but applied the whole series in the end, which explains perfectly why
> > x86_64 and arm64 performance are identical, given that the generic
> > code isn't even used.
> >
> > So trying this again, on a Cortex-A72 without Crypto Extensions, I do
> > get a ~30% performance improvement doing the below. I haven't
> > re-tested x86, but given that it does not appear to have a native
> > scalar bit reverse instruction (or __builtin_bitreverse64() is broken
> > for it), there is probably no point in finding out.
> >
> > Not saying we should do this for POLYVAL, but something to keep in
> > mind for gf128mul.c perhaps.
> >
> >
> > --- a/lib/crypto/polyval.c
> > +++ b/lib/crypto/polyval.c
> > @@ -42,11 +42,48 @@
> >   * 256-bit => 128-bit reduction algorithm.
> >   */
> >
> > -#ifdef CONFIG_ARCH_SUPPORTS_INT128
> > +#if defined(CONFIG_ARCH_SUPPORTS_INT128) ||
> > __has_builtin(__builtin_bitreverse64)
> >
> >  /* Do a 64 x 64 => 128 bit carryless multiplication. */
> >  static void clmul64(u64 a, u64 b, u64 *out_lo, u64 *out_hi)
> >  {
> > +       u64 a0 = a & 0x1111111111111111;
> > +       u64 a1 = a & 0x2222222222222222;
> > +       u64 a2 = a & 0x4444444444444444;
> > +       u64 a3 = a & 0x8888888888888888;
> > +
> > +       u64 b0 = b & 0x1111111111111111;
> > +       u64 b1 = b & 0x2222222222222222;
> > +       u64 b2 = b & 0x4444444444444444;
> > +       u64 b3 = b & 0x8888888888888888;
> > +
> > +#if __has_builtin(__builtin_bitreverse64)
> > +#define brev64 __builtin_bitreverse64
> > +       u64 c0 = (a0 * b0) ^ (a1 * b3) ^ (a2 * b2) ^ (a3 * b1);
> > +       u64 c1 = (a0 * b1) ^ (a1 * b0) ^ (a2 * b3) ^ (a3 * b2);
> > +       u64 c2 = (a0 * b2) ^ (a1 * b1) ^ (a2 * b0) ^ (a3 * b3);
> > +       u64 c3 = (a0 * b3) ^ (a1 * b2) ^ (a2 * b1) ^ (a3 * b0);
> > +
> > +       a0 = brev64(a0);
> > +       a1 = brev64(a1);
> > +       a2 = brev64(a2);
> > +       a3 = brev64(a3);
> > +
> > +       b0 = brev64(b0);
> > +       b1 = brev64(b1);
> > +       b2 = brev64(b2);
> > +       b3 = brev64(b3);
> > +
> > +       u64 d0 = (a0 * b0) ^ (a1 * b3) ^ (a2 * b2) ^ (a3 * b1);
> > +       u64 d1 = (a0 * b1) ^ (a1 * b0) ^ (a2 * b3) ^ (a3 * b2);
> > +       u64 d2 = (a0 * b2) ^ (a1 * b1) ^ (a2 * b0) ^ (a3 * b3);
> > +       u64 d3 = (a0 * b3) ^ (a1 * b2) ^ (a2 * b1) ^ (a3 * b0);
> > +
> > +       *out_hi = ((brev64(d0) >> 1) & 0x1111111111111111) ^
> > +                 ((brev64(d1) >> 1) & 0x2222222222222222) ^
> > +                 ((brev64(d2) >> 1) & 0x4444444444444444) ^
> > +                 ((brev64(d3) >> 1) & 0x8888888888888888);
>
> Yeah, that's an interesting idea!  So if we bit-reflect the inputs, do
> an n x n => n multiplication, and bit-reflect the output and right-shift
> it by 1, we get the high half of the desired n x n => 2n multiplication.
> (This relies on the fact that carries are being discarded.)  Then we
> don't need an instruction that does an n x n => 2n multiplication or
> produces the high half of it.
>
> The availability of hardware bit-reversal is limited, though.  arm32,
> arm64, and mips32r6 have it.  But all of those also have a "multiply
> high" instruction.  So the 30% performance improvement you saw on arm64
> seems surprising to me, as umulh should have been used.  (I verified
> that it's indeed used in the generated asm with both gcc and clang.)
>

Yeah - it might be just the compiler making a mess of things. GCC is
already considerably faster than Clang doing the u128 arithmetic (75
vs 67 MB/s on RPi4). But the bit reverse code manages 85 MB/s [which
is only 26% faster btw, so a bit less than when I tried this the other
day].

I re-tested Apple M2 (which doesn't need this code, but for
comparison), and there the GCC generated u128 code is as fast or
slightly faster than the Clang generated bitreverse code.

So I guess this is more a matter of fixing the u128 related codegen on Clang.


> The available bit-reversal abstractions aren't too great either, with
> __builtin_bitreverse64() being clang-specific and <linux/bitrev.h>
> having a table-based, i.e. non-constant-time, fallback.  So presumably
> we'd need to add our own which is guaranteed to use the actual
> instructions and not some slow and/or table-based fallback.
>

__builtin_bitreverse64() does exist on x86 too, but generates a huge
pile of code, so the mere availability is not a good reason to use it
either.

> I'll definitely look into this more later when bringing this improvement
> to GHASH too.  But for now I think we should go with the version I have
> in my patch.
>

For now, definitely. And I'll see if I can file a Clang bug somewhere.
But I don't think we'll be making use of bitreverse for GHASH either.
