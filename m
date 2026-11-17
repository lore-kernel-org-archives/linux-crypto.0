Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794927206;
	b=WEPapXGTqBKKdaM8yEfIMvRmZS3jwerrKjC3WclgPhChi9Q3IPz+CYpjCD7vFmI6PSZi
	 HM7LDUyNdtNS5dLYl7beZXTlkcaba3coMyW002hMsJNd8fiBkp1txfvAsyjdBTiQIRuPF
	 Aa0ZuvQSch6m40iS2dAy8sQf/nOlx1PEO8YxiYG5PpbgTpDeDxpGN9jJO65zRDJ+Qx2Ns
	 B+AHNRufgmK39T0fUSHmVXpyomvizKCzzovDnx7AdZEUILcrqjgotnpy+P7Gw6DyhF89b
	 Y0weSSDe/xs2sbht8bXyBX2hNVfi6Xo5TIoHjgi8QNQY3z3neZcu24ZRTV2avljKwRA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794927206;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=X7S9WhrU7HT6a6HLGbJXISV6nqS37iGN9IhsH89p7iQ=;
	b=e/A0wYTO3vYxzYCX0iYV1PF8hl/+9v9YMZPmLbRvLxWP3xiDHi1M/RY80VKA931CW9v3
	 jrqKruK5buGXen9QwYGnuQUy9h4Hso1gNoIuy53/ieBoavZiPFcXKft6LmGX/sdLvk6vZ
	 MX1IDRRLONviwy4dIJ/k7+ryENXNcjKmuefyZK9AB0YAJ0A4+G9z6it/M4gJda5adn276
	 9l/yL7SdqgX22dLEuUrVzlsz7dwfWpZERB7o9xtYug6/URxz+Tsz6xcx9dJBXWoCmCpjl
	 9IhCaQiNGKXuCin6ynm5W0QYG+1dAFvokpLP6thQ+4cagtAE6eqTIhHQ9cH5OvK79qg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PRyLWZA3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.52
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD95606A885
	for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2026 14:53:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5BD95606A885
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PRyLWZA3
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c506a231b88so685556566b.3
        for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2026 06:53:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794927205; cv=none;
        d=google.com; s=arc-20260327;
        b=qNrRFf8WUliOp/loBm5Q+SkLkzqWUuq0wO4UUfnsUDRtESkZA3KDjbANS2pnSjuQJi
         jtqvp+Ryj/9IZ1U6/fgEjSiGxuQIDd25G/G7cQCsUPnvzCWmWy9jDc7Cb5Jv0+X+2XIs
         U4SCdiZ/nvXtQJDabZVtwcKFZqZpcLDEiXJOz8W14c7cL/s2iLmDo+RhhlzB6cbL2w0m
         fDUpDidFR9UZejH8dxZUahwMNPG2fQTDPPnnw+ZNJap8IShrhQP1qOGIchT7qnro89NX
         TZ2pSZNGGn6hZ4ItI3MD1ZhivkvQUNXhSYHgbDr3l3d5XYwc37mcoii5NuZPi/XwZlMq
         CumA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=X7S9WhrU7HT6a6HLGbJXISV6nqS37iGN9IhsH89p7iQ=;
        fh=GTu12mGxrOVd0jsrNmotROiFD+qSbUbtSgk/QUwXg0g=;
        b=M+8XBq9/80SeJRXXyAW1sre7NtgVIidrTR1H+3kx7rvDJDW+AFo1mtOgVuTUu38Qg6
         MIKTooLOE2hmU7VoEWADjhRVW4MBxjcCOiX8F0dZFBtHcmEYjys6D0osBD37Bla8Xr2U
         sR1I8Eiwp0lnYRCJpOUdvjBIsu7+dRbUGT0r2XXDrB75AIosDOIs0aX3EpSBoltqr+DI
         9WdDrxCNWA9AhC96flkS76cxLeELJnRC1bZ93J5qG4sY2WouISnRRA53V8TdeKL3eq8A
         9iyauPVwsjAxvJ3o2/NTcjWsCbhndm16NjZBZxOVlHTVPik+oi6dBbywn1M/IABK85uw
         r5gw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794927205; x=1795532005; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=X7S9WhrU7HT6a6HLGbJXISV6nqS37iGN9IhsH89p7iQ=;
        b=PRyLWZA3jqOv1KUKVbOrHZFLu2k3IoGbkvmMYfnoaEDA5l+4bBCVR2j+mDFJG7fmbt
         J6UmyJXP79zqHo9bUZtYbZTPnB3lzzZUys+Qa7S2Z9tOj7x8DrJfVGe+RRIXWRO4Chjj
         7KbpuB3qbFdmE53WOJP20KJpkNOBMpSdiLyEzKHo5OV5EiRbfGuk7LkOuEnQKxij18jm
         9Rrw8GMbP64cnh4yhw2BIX+H4mMHrWpsh3a2EklpTa+pG1n/SduljbcQilmcccweFffY
         GOPTOjdljPstCP2AiKhrDIDP6E9oqBttBW9rNobVbP4g/dFY3jhc3C1ZIAXS9EUBpYqX
         KmEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794927205; x=1795532005;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X7S9WhrU7HT6a6HLGbJXISV6nqS37iGN9IhsH89p7iQ=;
        b=d4w7jV/w+TI/9BfJzVxxs0Koct5FO9YKOMu700knIqINF9t/t0BvMTChpyaXYo8Rpx
         +EP6HJ6tCwi9hjWQ88gVtFwV8s6nMXbTN5IFBzDhs/oc7pwa7c8laBV79AaOhkxUcRER
         fiGgIkJGp+ZVhiyA8suCGqxAOncALvZrRINjg92w6iJJsOiV8tbkx2HYFAbgv/gmiVAO
         2Zt5AnvQgTaQR5mh2Q1CBGYO6McTjdDYA/+GjwgnGZfdLDlLXHa1n6EqmxpeqkSApbAv
         9Hps8mHesstwJRogXXsacVTyXFCqdFxiqK8luyCWqZF2iKk58uMkFJP0kf+Xew/K+1wP
         6mRg==
X-Forwarded-Encrypted: i=1; AL+hErFmcmFTh5CVTRLicSNyu/5noy+sH0lcV5mN8tm4SV63bH6p+lN8/gAVVlcORkxdPuysVBfiTG5gOTwPLHU=@vger.kernel.org
X-Gm-Message-State: APuU4Z8fdRt9iVwxeivDsfaaB/TOqz71lbq0SyeqI+z1uZFOevQ4yVv0
	la4fK7gf8lRZXaUVqF8Lfuo8d1HBClZiGjW1rVCbX2FOGz768lQlNcDsZEQSkW2cLzym2f9Hw+Q
	/FTeTrT1bSFk5Ciz0tNn7xrdo8LbzXWQ=
X-Gm-Gg: AYBFou1IxYQUY/ZwG3t6AkOamEOwbw5XmtKU+6lJ9BBtaGyDnUqc4z9xn/AD3Dhf3Om
	IP0u0PrSi84Xk/RZzg132Vzhb4ZycG1SWw8OHmObG18t3NHOAmYHkez4oJiZl26bZNRw0i1aeHu
	OiEOJ9jRc8/+6iF+PGRAyUITe20yzD7RuobWQ+O6riQp/Kgktu8A+G0QuKw59UhelmFFyjyHsBB
	doMOvV1aaLCWAm0bsyla5lzOgWksA6oNx2J4pscz4bI3MOsXMnJ3xC5TdZowNup5iAzMEl4TgxT
	9ACzi1T9IAt23buVI2i+d2naSS/n/WagacvrB/nGglt/lQCGtn3KNr6hK1dFiwIEMG7J1saBR2v
	FmMeavH986/qFv4se/Z8FqS1bjGpRqZTPb6A=
X-Received: by 2002:a17:907:a08a:b0:c4c:b545:f29d with SMTP id
 a640c23a62f3a-c5096545652mr1128764066b.36.1794927204517; Tue, 17 Nov 2026
 06:53:24 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261114172955.1598929-1-16567adigashreesh@gmail.com>
 <20261117000119.GH229817@google.com> <CA+-x59b-gUddP2cfHbzDrv9jupmeM1LeHkQnNXhE8_y6B+JC1A@mail.gmail.com>
 <20261117071138.GA269875@sol>
In-Reply-To: <20261117071138.GA269875@sol>
From: Shreesh Adiga <16567adigashreesh@gmail.com>
Date: Tue, 17 Nov 2026 20:23:12 +0530
X-Gm-Features: AclHuK8TZCS1RHOO8XdKCyXSbCsts9xLPSrwPGWNmo44krkYBAKOx9PV_WBRA-4
Message-ID: <CA+-x59bs6N_HLs=HRrR4xxR3Cru-d1PXvuwBwj0UoTpNygGJRQ@mail.gmail.com>
Subject: Re: [PATCH v2] lib/crc: arm64: Add NEON PMULL+EOR3 crc64_nvme implementation
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Demian Shulhan <demyansh@gmail.com>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 17, 2026 at 12:41=E2=80=AFPM Eric Biggers <ebiggers@kernel.org>=
 wrote:
>
> On Tue, Nov 17, 2026 at 12:20:08PM +0530, Shreesh Adiga wrote:
> > Hi Eric,
> >
> > On Tue, Nov 17, 2026 at 5:31=E2=80=AFAM Eric Biggers <ebiggers@kernel.o=
rg> wrote:
> > > Was crc_kunit run?  It already has a benchmark in it.
> > No, I have access to only one aarch64 device that is Android Mediatek
> > Dimensity 9400 SoC without root access.
> > Therefore I can't run crc_kunit on that, instead I have done userspace
> > comparisons for the same kernel with libbenchmark.
> > This is based on my earlier work for FFmpeg:
> > https://code.ffmpeg.org/FFmpeg/FFmpeg/pulls/21651
> > I also have Corporate MacOS M5 and did check inside Ubuntu VM but that
> > is not accurate due to virtualization.
>
> Well, this is a kernel patch.  Contributors are expected to test their
> kernel patches.  It can at least be done with QEMU.
Okay have run and will be running the below commands for future arm patches=
:
./tools/testing/kunit/kunit.py run --arch=3Darm
--cross_compile=3Darm-linux-gnueabihf-
--kunitconfig=3D/tmp/a32.kunitconfig --qemu_args=3D'-cpu max'
--build_dir=3D.kunit-arm 'crc.*'
./tools/testing/kunit/kunit.py run --arch=3Darm64
--cross_compile=3Daarch64-linux-gnu- --kunitconfig=3Dlib/crc
--build_dir=3D.kunit-arm64 'crc.*'

These were suggestions by LLM tools though and I can see they're green.
As mentioned I don't have a measurable benchmark device so I can't
include them via kunit.
For testing correctness I am having a libfuzzer userspace differential
fuzzer test that measures exactness between the earlier single fold
case with generic scalar tail with the newer 4x folding with partial
block handling.

>
> > > Note that this is missing several optimizations compared to the x86
> > > version (lib/crc/x86/crc-pclmul-template.S), including using
> > > fold_consts_2x for a tail of 'len & 32', efficiently handling lengths
> > > that aren't a multiple of 16 bytes, and reducing to the final CRC in =
two
> > > carryless multiplication instructions rather than three.
> > I was looking at the crc-pclmul-template.S code and I have a few querie=
s.
> > In this aarch64 version we only dispatch to this SIMD routine only
> > when len>=3D128.
> > Since we have 128 bytes available, do we have to add the tail of `len
> > & 32` handling?
>
> It's still useful, since the length mod 64 might be >=3D 32.
Okay this makes sense, the len mod 64 >=3D32 I wasn't aware of before.
One follow-up query regarding the efficient handling of lengths not
multiple of 16 bytes, I have the implementation similar to DPDK's code
https://github.com/DPDK/dpdk/blob/main/lib/net/net_crc_neon.c#L222
However it seems like vqtbl1q_u8/vcgezq_s8 is not available on
AArch32. Instead some kernel code like crypto/aegis128-neon-inner.c
have their own emulation of that intrinsic using vtbl2_u8.
Can I have this partial block logic only for AArch64, or should I
include the emulation logic and enable it for both since it is shared
code? For now I'm assuming AArch64 is sufficient and I won't change
the dispatch logic for AArch32 so that it can pass multiple of 16 and
process the tail using scalar loop.

Thanks,
Shreesh
