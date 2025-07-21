Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9813469D;
	Mon, 21 Jul 2025 04:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753072044; cv=none; b=tEWIfSdU7QOaFIf781MK++9/j3l5FxKfcm3bRxzjsXmIT/g5IxNki5qpfRLdt2v/sC8DI10iy4F+8Mf+KvqHTmipRCpDHt9wP0FEJPDBs3zX4WNUhJOUG8pLiOCaOtpeyH2l0wvw3LWHdMD5LkQoswLhUq58sXMP7jEFmCn0GOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753072044; c=relaxed/simple;
	bh=8dgyfEbmJqLN/JlFQN1SsvAQKGG4nd/sA5ZvXhduMW8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kPsP5fpKTxGMgXaIqL0g5q2ZIkWcAg2VCmcQHXpLa/wFJR+jCeHDTcyX2UQQPXVKdTPfLswvh9tZBwUgsyQKa6T+gUWMkaoIip+mOrtRaCXLvyOjY3Z1sILpqExWFYrrKx5VHevBKGgjM8ND3xCeim5ZcGlkVmYdqM0A25Ziqf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=afaDesuv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="afaDesuv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4205AC4CEF7;
	Mon, 21 Jul 2025 04:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753072043;
	bh=8dgyfEbmJqLN/JlFQN1SsvAQKGG4nd/sA5ZvXhduMW8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=afaDesuvyltngPYnCxStPMJGltpe6n0jbxVO7k9kc5jGaZkw0ShY6Gre84Zdw87+L
	 g/LHaMipzzJ7cq0cs2iUOsnJTHNsbqvLXVVbx+n1lqsujXO8UvrfFqh2RDwsj0DU0j
	 0qEZ5JqdmjYuehAkRPwkRTbwb/mifWnA+SxNgM+9YbsrvtJDJHFjmUtAegBpuJndmZ
	 MNmkHgiRqvbfLdKXNqilUcv+LMCaVcRHANmDkRzBER5UYFXlL+5AkVNaQOPfzKdtmE
	 +iDI5++YcjFjxPv38Ceyg75iBUJQWoNREGvjbMCTyijXo/NLA3WDs5mHmC7cRApMZD
	 JPZzWvl1uEH1w==
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-32b561a861fso33492981fa.0;
        Sun, 20 Jul 2025 21:27:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW6Qr7RLNynF1hxziQHMUEGS2pfOD93km4kGCIJi3Ptn7Tz3+Q6Baz+T86VtGGBI1jW1hEq8beIxwwGfNU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUtWvh1HpTdNiJ8rGsJkX/dt9+BiW9fMlXnHVPAutFxNHM/J+W
	Q0MFJNh8y5muw7W3ef5nqvRB0eDBN6QB78MzoLWwJIVeqIGePhmnSVH2S/wZoYjttYgeU+Rut9n
	molSm93FMOOVamqmY1qMWEw4yDqDdeUc=
X-Google-Smtp-Source: AGHT+IGiuUNh87LCrb7VSq3AVAZccJpnT4QP0VLWGeEGeV8zpfl3Atv/V5DIVwAbktM2xN/nKA/bqHnpGEF/NTVkPkw=
X-Received: by 2002:a2e:80d4:0:b0:32b:755e:6cd7 with SMTP id
 38308e7fff4ca-3308e56e179mr51719521fa.32.1753072041588; Sun, 20 Jul 2025
 21:27:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250718220706.475240-1-ebiggers@kernel.org> <CAMj1kXG8rEGH9suNf+s26174-SDrVWaV3RcuY53ysiBbrJtKUQ@mail.gmail.com>
 <20250721041735.GA3372@sol>
In-Reply-To: <20250721041735.GA3372@sol>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 21 Jul 2025 14:27:04 +1000
X-Gmail-Original-Message-ID: <CAMj1kXEtPo7FfGMfE==DtHT=yk-H1KOdSdsfmKLk=t3gQ2hYEg@mail.gmail.com>
X-Gm-Features: Ac12FXyZCID0FAxVJicIJaQrAE5BZzJiaoJ6Xq3J25u7KqcMLHoud3mAw9Ay-tY
Message-ID: <CAMj1kXEtPo7FfGMfE==DtHT=yk-H1KOdSdsfmKLk=t3gQ2hYEg@mail.gmail.com>
Subject: Re: [PATCH] lib/crypto: arm64/sha512-ce: Drop compatibility macros
 for older binutils
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 21 Jul 2025 at 14:18, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Mon, Jul 21, 2025 at 01:31:47PM +1000, Ard Biesheuvel wrote:
> > On Sat, 19 Jul 2025 at 08:07, Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > Now that the oldest supported binutils version is 2.30, the macros that
> > > emit the SHA-512 instructions as '.inst' words are no longer needed.  So
> > > drop them.  No change in the generated machine code.
> > >
> > > Changed from the original patch by Ard Biesheuvel:
> > > (https://lore.kernel.org/r/20250515142702.2592942-2-ardb+git@google.com):
> > >  - Reduced scope to just SHA-512
> > >  - Added comment that explains why "sha3" is used instead of "sha2"
> > >
> > > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> >
> > Acked-by: Ard Biesheuvel <ardb@kernel.org>
> >
> > Nit below
> >
> > > ---
> > >
> > > This patch is targeting libcrypto-next
> > >
> > >  lib/crypto/arm64/sha512-ce-core.S | 27 +++++++--------------------
> > >  1 file changed, 7 insertions(+), 20 deletions(-)
> > >
> > > diff --git a/lib/crypto/arm64/sha512-ce-core.S b/lib/crypto/arm64/sha512-ce-core.S
> > > index 7d870a435ea38..eaa485244af52 100644
> > > --- a/lib/crypto/arm64/sha512-ce-core.S
> > > +++ b/lib/crypto/arm64/sha512-ce-core.S
> > > @@ -10,30 +10,17 @@
> > >   */
> > >
> > >  #include <linux/linkage.h>
> > >  #include <asm/assembler.h>
> > >
> > > -       .irp            b,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19
> > > -       .set            .Lq\b, \b
> > > -       .set            .Lv\b\().2d, \b
> > > -       .endr
> > > -
> > > -       .macro          sha512h, rd, rn, rm
> > > -       .inst           0xce608000 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
> > > -       .endm
> > > -
> > > -       .macro          sha512h2, rd, rn, rm
> > > -       .inst           0xce608400 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
> > > -       .endm
> > > -
> > > -       .macro          sha512su0, rd, rn
> > > -       .inst           0xcec08000 | .L\rd | (.L\rn << 5)
> > > -       .endm
> > > -
> > > -       .macro          sha512su1, rd, rn, rm
> > > -       .inst           0xce608800 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
> > > -       .endm
> > > +       /*
> > > +        * While SHA-512 is part of the SHA-2 family of algorithms, the
> > > +        * corresponding arm64 instructions are actually part of the "sha3" CPU
> > > +        * feature.  (Except in binutils 2.30 through 2.42, which used "sha2".
> >
> > Nit: the ARM ARM describes these features as FEAT_SHA256, FEAT_SHA512
> > and FEAT_SHA3, and the latter two happen to have appeared in the same
> > architecture revision. So this is likely just the GCC/binutils devs
> > getting confused, and assuming a) that SHA-3 implies SHA-2 (which is
> > silly if you know the difference) and b) SHA512 has anything to do
> > with SHA-3.
>
> How does the following look?
>
>         /*
>          * We have to specify the "sha3" feature here, since the GNU and clang
>          * assemblers both consider the SHA-512 instructions to be part of the
>          * "sha3" feature.  (Except binutils 2.30 through 2.42, which used
>          * "sha2".  But "sha3" implies "sha2", so "sha3" still works in those
>          * versions.)  "sha3" doesn't make a lot of sense, since SHA-512 is part
>          * of the SHA-2 family of algorithms, and also the Arm Architecture
>          * Reference Manual defines FEAT_SHA512 and FEAT_SHA3 separately.
>          * Regardless, we must use "sha3" to be compatible with the assemblers.
>          */
>

LGTM

> By the way, the ARM ARM does actually have the following:
>
>     If FEAT_SHA256 is implemented, then FEAT_SHA1 is implemented.
>     If FEAT_SHA512 is implemented, then FEAT_SHA256 and FEAT_SHA1 are implemented.
>     If FEAT_SHA3 is implemented, then FEAT_SHA256 and FEAT_SHA1 are implemented.
>
> So some of the SHAs do imply other ones.  But notably absent is
> FEAT_SHA3 implying FEAT_SHA512...

Yeah, and such policies usually evaporate into thin air as soon as
Apple decides to implement something different, so they tend to be
rather meaningless. (E.g, FEAT_SME used to imply FEAT_SVE but it no
longer does)
