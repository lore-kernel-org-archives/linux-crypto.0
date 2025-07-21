Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B588139B;
	Mon, 21 Jul 2025 04:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753071504; cv=none; b=ZqnGDXRsdD/djQI1Ar3eWK42Y+mqirG9kPS2NB6sctFti2PFoC33fB3OlrnKhTN5pN3yKsqVDFFv/MV6oiyrw94+3Dc4SeIeAl4EoPhZGMQ67jLJwyg0Uzb0nbfOaSY9sSJbSCsWrpb1ca7LOsI8/nVxopS8+xF36B3VgLG+9rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753071504; c=relaxed/simple;
	bh=seQWfNuMVmyihCKpCTMeU9CJJYqh/Fo379bjZ/VmuxQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TC6XAmeLklyh2a6IQdapzutIhUeMwVFdEt7TtWvOKbBZCNZlDDgbxjNW8frFwP+Zj8tTa3fp7exAGe/wSbuqQL1t4Z42jNUOCk/TwRETwn94/XujtnKyDYaSq+T/rpKjGYL0jefJX5tZCEQKvXrJYHpJHjY4t92L30PezlJPhX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YTtMxOTP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YTtMxOTP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81797C4CEF1;
	Mon, 21 Jul 2025 04:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753071503;
	bh=seQWfNuMVmyihCKpCTMeU9CJJYqh/Fo379bjZ/VmuxQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YTtMxOTPjd7MKWNvvkeeVPk9smErtwp04Rb17iw342NCepv5QlT7ben5f0G/Qhbq3
	 3NdeICgNq2VYTmcpqbNT248HVbm4AhezD5xfOuV89RTqlqh77miE0CTsDBh7oq243f
	 Vu8682zZlzi4KhrlAjb44waI9kRdaiNjHk5WMcPEXcHmSFZkbN1ZEuzFTVcFL3/oJw
	 nWlmEchS5ZLohmMTQnPcYiwNBKarV3qioKaOpMt7gG+DvJs4pAz4Arxk8inWWIXZPJ
	 nGrOIWB1l5JSYhHqVNg+HiQUH1EecI9+ml8roM288Se7xh60NtlfLONex0/f8ocLtM
	 SWaNymQ6dtgmw==
Date: Sun, 20 Jul 2025 21:17:35 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH] lib/crypto: arm64/sha512-ce: Drop compatibility macros
 for older binutils
Message-ID: <20250721041735.GA3372@sol>
References: <20250718220706.475240-1-ebiggers@kernel.org>
 <CAMj1kXG8rEGH9suNf+s26174-SDrVWaV3RcuY53ysiBbrJtKUQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXG8rEGH9suNf+s26174-SDrVWaV3RcuY53ysiBbrJtKUQ@mail.gmail.com>

On Mon, Jul 21, 2025 at 01:31:47PM +1000, Ard Biesheuvel wrote:
> On Sat, 19 Jul 2025 at 08:07, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > Now that the oldest supported binutils version is 2.30, the macros that
> > emit the SHA-512 instructions as '.inst' words are no longer needed.  So
> > drop them.  No change in the generated machine code.
> >
> > Changed from the original patch by Ard Biesheuvel:
> > (https://lore.kernel.org/r/20250515142702.2592942-2-ardb+git@google.com):
> >  - Reduced scope to just SHA-512
> >  - Added comment that explains why "sha3" is used instead of "sha2"
> >
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> 
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> 
> Nit below
> 
> > ---
> >
> > This patch is targeting libcrypto-next
> >
> >  lib/crypto/arm64/sha512-ce-core.S | 27 +++++++--------------------
> >  1 file changed, 7 insertions(+), 20 deletions(-)
> >
> > diff --git a/lib/crypto/arm64/sha512-ce-core.S b/lib/crypto/arm64/sha512-ce-core.S
> > index 7d870a435ea38..eaa485244af52 100644
> > --- a/lib/crypto/arm64/sha512-ce-core.S
> > +++ b/lib/crypto/arm64/sha512-ce-core.S
> > @@ -10,30 +10,17 @@
> >   */
> >
> >  #include <linux/linkage.h>
> >  #include <asm/assembler.h>
> >
> > -       .irp            b,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19
> > -       .set            .Lq\b, \b
> > -       .set            .Lv\b\().2d, \b
> > -       .endr
> > -
> > -       .macro          sha512h, rd, rn, rm
> > -       .inst           0xce608000 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
> > -       .endm
> > -
> > -       .macro          sha512h2, rd, rn, rm
> > -       .inst           0xce608400 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
> > -       .endm
> > -
> > -       .macro          sha512su0, rd, rn
> > -       .inst           0xcec08000 | .L\rd | (.L\rn << 5)
> > -       .endm
> > -
> > -       .macro          sha512su1, rd, rn, rm
> > -       .inst           0xce608800 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
> > -       .endm
> > +       /*
> > +        * While SHA-512 is part of the SHA-2 family of algorithms, the
> > +        * corresponding arm64 instructions are actually part of the "sha3" CPU
> > +        * feature.  (Except in binutils 2.30 through 2.42, which used "sha2".
> 
> Nit: the ARM ARM describes these features as FEAT_SHA256, FEAT_SHA512
> and FEAT_SHA3, and the latter two happen to have appeared in the same
> architecture revision. So this is likely just the GCC/binutils devs
> getting confused, and assuming a) that SHA-3 implies SHA-2 (which is
> silly if you know the difference) and b) SHA512 has anything to do
> with SHA-3.

How does the following look?

	/*
	 * We have to specify the "sha3" feature here, since the GNU and clang
	 * assemblers both consider the SHA-512 instructions to be part of the
	 * "sha3" feature.  (Except binutils 2.30 through 2.42, which used
	 * "sha2".  But "sha3" implies "sha2", so "sha3" still works in those
	 * versions.)  "sha3" doesn't make a lot of sense, since SHA-512 is part
	 * of the SHA-2 family of algorithms, and also the Arm Architecture
	 * Reference Manual defines FEAT_SHA512 and FEAT_SHA3 separately.
	 * Regardless, we must use "sha3" to be compatible with the assemblers.
	 */

By the way, the ARM ARM does actually have the following:

    If FEAT_SHA256 is implemented, then FEAT_SHA1 is implemented.
    If FEAT_SHA512 is implemented, then FEAT_SHA256 and FEAT_SHA1 are implemented.
    If FEAT_SHA3 is implemented, then FEAT_SHA256 and FEAT_SHA1 are implemented.

So some of the SHAs do imply other ones.  But notably absent is
FEAT_SHA3 implying FEAT_SHA512...

- Eric
