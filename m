Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04598198856;
	Wed, 16 Oct 2024 07:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729062775; cv=none; b=ih6OiJ4XlCi1CsxmpwSuufreLJ0qaYR8JJTKi7+SBEIsxrWblmj47bFaEVw0WE/IhCKbjN8ooODt3H/H49Qb/qj3fPBWoixCHAiQ93EnDiMmoNxkaRTBR+DMLRieszD0XDAty1dUIKaZugtCFweIIk+9tsxGv09BQvjXybFrEKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729062775; c=relaxed/simple;
	bh=ERP/V9quL5zaqNb+BLJAb9v0NmJzVN/qNhNcZIV8Ip0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ganDxFEfOFnN2+QDCuLJIT/my3XHQ5b7qlQ6SlTWTXFPwJKwCMXk7h4TdangswT2mem5g5sFJDRiiLo1OqDBj9+81B2jZt1KpQAt4l9GCOmnLYoJ6+3YB6WWlowsM/Zmeds8i3UQKPUZu2GpJrwJrqj/euMuAo+spUGZ7Mxrcfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k3tdDYMn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k3tdDYMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DE1C4CECE;
	Wed, 16 Oct 2024 07:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729062774;
	bh=ERP/V9quL5zaqNb+BLJAb9v0NmJzVN/qNhNcZIV8Ip0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=k3tdDYMnMn2EHt29yocTmwTnOkcezrB4n6Nkwgn9hfrvMwJIO6s4Uu85rWSzylBFO
	 oO0I5zsczfYgRSGtp/Rz3d8p55xYDfhGcjtmsxbI+OGVbXp5Y37jF3+d3v1Ow22TDT
	 QQaB3Q8qLqirh89B5qDDqRqIVTcNPNIzN9Z6aUow7ZHYxZBqoNtFV96rtQ0ruI0OdQ
	 jwXry9IoEQ0ytsoLC4Ey/N7mQAFCGITos4qFeBUzVtYdVIrlz3YL2PwPfsGRCUZdCO
	 7T8YMKDl87E+yyx2XknlgRI0HKc9IjdzVPpGBizxVu7SiCl65ISiz8T3+/5wQDtN+g
	 L+3BwoZqP4rlQ==
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2fb3110b964so51967261fa.1;
        Wed, 16 Oct 2024 00:12:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVtHyHvw920qqVZvaZP6Wp4zmZD4hlCLYJcF3s5Jh9FbHCm64sz4MV92kEPe2tRSMAXIAwKEiKt7oL6/Gs=@vger.kernel.org, AJvYcCXpJ9lW4TlApJQB28MsMe0q93PGqHTOCFCuOxqxjkZVIXStburHCV0mUSHuu4pxFXKERK82d5NUMUcjb7I3@vger.kernel.org
X-Gm-Message-State: AOJu0Yzc+ZkUWCHk7SwmwHHhU+DYYN+2K225DAwrfx353lbroBqSVae+
	j62PKRGxcHTQJGbcg0vTehWWg91bfodhQnNfHrRDaKaVs3UMl42u8CdZvldWgye4+vlwaH9tjhr
	Vp5YFw90UbEYoCMty0vM1vuxgC6M=
X-Google-Smtp-Source: AGHT+IE2fsDuHS8YKfzAa525WvUxixku7LEcXD/dmEJI5v5SrcLGkozp3KOoyK4IpDk+xU+agLAtLeozxYnKH4F9gWw=
X-Received: by 2002:a2e:a990:0:b0:2fb:5a7e:504f with SMTP id
 38308e7fff4ca-2fb5a7e5276mr33368691fa.35.1729062772925; Wed, 16 Oct 2024
 00:12:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241015104138.2875879-4-ardb+git@google.com> <20241015104138.2875879-6-ardb+git@google.com>
 <20241016030349.GD1138@sol.localdomain>
In-Reply-To: <20241016030349.GD1138@sol.localdomain>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 16 Oct 2024 09:12:41 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHDqD29TzE=2cw55qeKrnybgkYFCdy4jU_4E=OaUOkZNg@mail.gmail.com>
Message-ID: <CAMj1kXHDqD29TzE=2cw55qeKrnybgkYFCdy4jU_4E=OaUOkZNg@mail.gmail.com>
Subject: Re: [PATCH 2/2] arm64/crc32: Implement 4-way interleave using PMULL
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, will@kernel.org, catalin.marinas@arm.com, 
	Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 16 Oct 2024 at 05:03, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Oct 15, 2024 at 12:41:40PM +0200, Ard Biesheuvel wrote:
> > From: Ard Biesheuvel <ardb@kernel.org>
> >
> > Now that kernel mode NEON no longer disables preemption, using FP/SIMD
> > in library code which is not obviously part of the crypto subsystem is
> > no longer problematic, as it will no longer incur unexpected latencies.
> >
> > So accelerate the CRC-32 library code on arm64 to use a 4-way
> > interleave, using PMULL instructions to implement the folding.
> >
> > On Apple M2, this results in a speedup of 2 - 2.8x when using input
> > sizes of 1k - 8k. For smaller sizes, the overhead of preserving and
> > restoring the FP/SIMD register file may not be worth it, so 1k is used
> > as a threshold for choosing this code path.
> >
> > The coefficient tables were generated using code provided by Eric. [0]
> >
> > [0] https://github.com/ebiggers/libdeflate/blob/master/scripts/gen_crc32_multipliers.c
> >
> > Cc: Eric Biggers <ebiggers@kernel.org>
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  arch/arm64/lib/Makefile      |   2 +-
> >  arch/arm64/lib/crc32-glue.c  |  36 +++
> >  arch/arm64/lib/crc32-pmull.S | 240 ++++++++++++++++++++
> >  3 files changed, 277 insertions(+), 1 deletion(-)
>
> Thanks for doing this!  The new code looks good to me.  4-way does seem like the
> right choice for arm64.
>

Agreed.

> I'd recommend calling the file crc32-4way.S and the functions
> crc32*_arm64_4way(), rather than crc32-pmull.S and crc32*_pmull().  This would
> avoid confusion with a CRC implementation that is actually based entirely on
> pmull (which is possible).

I'm well aware :-)

commit 8fefde90e90c9f5c2770e46ceb127813d3f20c34
Author: Ard Biesheuvel <ardb@kernel.org>
Date:   Mon Dec 5 18:42:27 2016 +0000

    crypto: arm64/crc32 - accelerated support based on x86 SSE implementation

commit 598b7d41e544322c8c4f3737ee8ddf905a44175e
Author: Ard Biesheuvel <ardb@kernel.org>
Date:   Mon Aug 27 13:02:45 2018 +0200

    crypto: arm64/crc32 - remove PMULL based CRC32 driver

I removed it because it wasn't actually faster, although that might be
different on modern cores.

>  The proposed implementation uses the crc32
> instructions to do most of the work and only uses pmull for combining the CRCs.
> Yes, crc32c-pcl-intel-asm_64.S made this same mistake, but it is a mistake, IMO.
>

Yeah good point.
