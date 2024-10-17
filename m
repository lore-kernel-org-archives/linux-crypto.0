Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46951D5AC6;
	Thu, 17 Oct 2024 22:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729204855; cv=none; b=rfY5Lv80h/9U/MzdX0iDBQp/vwz5OdxGlNEJDq53I+yTEQDAuopSbY1YfzSwja7kk9vXIspYU3irR9bAII6BwQYQ+rbt0lAFqzJ9get4MC59VSEKzhEXUrNE/+ly0Gt33DVP4KKhyWHFAAJ/DH6mMw18nAfUueD0VVHn3pCwAYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729204855; c=relaxed/simple;
	bh=3VA1s4WPyge0d7r6lC7GIiPa5t/KqR4sIxFNMwCwcv4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f2IrtqLULkdIP6Nj1JTCkJhuCqI5/W6n5dKAV51RA1y67SEFtz69Fj/VuMwauRdOEHkP9p9EkIHbcQdYenSWOu0HSKrTqXkEwsKJDYzG/uJXvklABgctriHnoiiM3gADoWTMSRU+NjLxKgTmNGF0UeOWK48kkPMSa8ZDQDMwlHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aSBUYExi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aSBUYExi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797E4C4CEC3;
	Thu, 17 Oct 2024 22:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729204855;
	bh=3VA1s4WPyge0d7r6lC7GIiPa5t/KqR4sIxFNMwCwcv4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=aSBUYEximdoPximYDL/O6tGXsFwRjqtS1IWaRGmt/LcrzbJAjaTeVbBaC3g0Rnn4K
	 mulsXBtuiWlwFqQipa0HUic1Xffh1W0I+yuThaTlDFJTd8wrXbaTrBn1MAAphcfTSn
	 tHVhACTWED48+1i/+W/0ylnVTedDWy5eMWKNRer5yBeW+vJGHHDBaJivmShf1k2zHH
	 cuxrQdjeT8iZd4e+MUBTuV05mFdEdA7VxkzhWb31KjzYdiF0PGgh2P6HKTOUAdGhOm
	 eO/ThzbZYYAR3+aMbK2IHu19eTNySR8QOkaJQx0CduckAm8Nd1JuXFvCZORylncDWp
	 WD0mRhyoY33kw==
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2fb498a92f6so18658461fa.1;
        Thu, 17 Oct 2024 15:40:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV9MEkMxAu6Q4XC1DdT13mSkYCfS0CrzMBCGfSisFRacswNPYRLbNKjYLnUeKxwM87aDlVS2JjaJGcvJuU=@vger.kernel.org, AJvYcCWsS7hy+Yy/jlqEo/nCS8dcu2frzKDcP9n5keE+D3hzEVqEkvdHeXZ3LS11NjeqwRLFe8V/sQ5aBpDeazg5@vger.kernel.org
X-Gm-Message-State: AOJu0Yzc8CVaZCqm6H6odEC4lrvRAug0IwBH3pxStoB6y++/tEmL+Ml/
	e1Hc/B4xJnqfvrzfQj4XXVsLYoZ/Pk7XYir4lIND/IW71s4awbwHFEpB7Gniy1sAyFEY6xfHqpf
	QBVoGa1wqC8ozxZQyjbYe4wDFPDA=
X-Google-Smtp-Source: AGHT+IGH9w+MXZSFQozhnFkOruBOH95ttNVlnPFuU/Che4mBA9S2VbGpFKEhXLhv0qhSUczj+tKzOiCbCgy8RkBPY3A=
X-Received: by 2002:a05:6512:308b:b0:539:f754:ae15 with SMTP id
 2adb3069b0e04-53a15445ebfmr282150e87.41.1729204853857; Thu, 17 Oct 2024
 15:40:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241017094132.2482168-4-ardb+git@google.com> <CAMj1kXFROGbn_49njp_rivEidqfgnLymOCRnfSkV_dTX_hAz9w@mail.gmail.com>
 <20241017220409.GC11717@sol.localdomain>
In-Reply-To: <20241017220409.GC11717@sol.localdomain>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 18 Oct 2024 00:40:42 +0200
X-Gmail-Original-Message-ID: <CAMj1kXG50UeOsHdXwEkEqqW9fjTZivGGqO=LdAGQaHOrZ0vrHg@mail.gmail.com>
Message-ID: <CAMj1kXG50UeOsHdXwEkEqqW9fjTZivGGqO=LdAGQaHOrZ0vrHg@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] arm64: Speed up CRC-32 using PMULL instructions
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, will@kernel.org, catalin.marinas@arm.com, 
	Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 18 Oct 2024 at 00:04, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Oct 17, 2024 at 06:30:19PM +0200, Ard Biesheuvel wrote:
> > > Ard Biesheuvel (2):
> > >   arm64/lib: Handle CRC-32 alternative in C code
> > >   arm64/crc32: Implement 4-way interleave using PMULL
> > >
> >
> > I'll need to respin this - the crc32_be code doesn't actually work correctly.
>
> Right, good catch.  It looks like it needs an rbit of the crc value at the
> beginning and end.  lib/crc32test.c doesn't actually test crc32_be_arm64_4way()
> because it runs the tests with IRQs disabled; it probably shouldn't do that.
>

Yeah, we should probably fix that.

> On a slightly related topic, since any crc32_le() and __crc32c_le() functions in
> arch/*/lib/ are automatically exposed as shash algorithms via the crypto API
> (this was already the case, but your other patch makes this more explicit by
> properly separating them from the generic implementation), I wonder if all the
> remaining arch/*/crypto/crc32*.c should be migrated to arch/*/lib/, and then
> users of crc32 and crc32c like ext4 and f2fs should just use the library
> functions instead of shash.  That would simply things greatly.  See e.g. the
> horrible hacks used in ext4_chksum() and __f2fs_crc32()...
>
> The only crc32 and crc32c implementations that *aren't* software based are those
> in drivers/crypto/stm32/stm32-crc32.c and
> drivers/crypto/inside-secure/safexcel_hash.c.  Access to those would be lost by
> going through lib.  But I strongly suspect they exist just because the hardware
> supported it and not because they are actually useful.
>

Indeed. Another case where the flexibility of the shash interface
doesn't buy us anything but overhead and complexity.
