Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB9F2E0902
	for <linux-crypto@vger.kernel.org>; Tue, 16 Dec 2025 08:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765872935; cv=none; b=OtHzpx9bL51W3o2JL17yAhH+cgWqtBYe2R/pCJ/sZUx+6v+yvm/jMa9TgeQ6Xd6fOgNmjIpwC4JDYqfklPH3OzBZK935tG/WIpNjPw4h+NHl6jmNXYyrXxNg0mX3b0KyNKVQzlR3ou7/knaLS7pkwEvQFryM3Qa7AgJsJ1ufEmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765872935; c=relaxed/simple;
	bh=8WZ8g0mEy7Er2G04e2JUBtm/40jHjH98gpeADHyNXhE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CFoYUJGUj6ClVK6alZUKKUxV2Ci45XkPVHcVRA2iiZBzBMWfh2GbOI7GDzeq2SSEqPyBKBCtl8MBD5D1ohJnmowxjON8+huuWz4uzRIEPlT6khfmKH4ge/lVcxrDkH9uIVICvSO1P6PYHcz+Czd754ahYxMZJhtgClijONOt7AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pyFSCL7G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pyFSCL7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC9FC16AAE
	for <linux-crypto@vger.kernel.org>; Tue, 16 Dec 2025 08:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765872935;
	bh=8WZ8g0mEy7Er2G04e2JUBtm/40jHjH98gpeADHyNXhE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=pyFSCL7GgqVhLbXa23lLjElfLh7TXxsMghJEwKpU9kVAOwuJArRA8eInWC9RGImCw
	 FDC96m2XWA7cQtTOlR0cGbBWCaaE48b4umCh4WxHzlFV1sqJ+jPeYiPfEzH2rqvMtP
	 uC2xAXAJbCx+oCS/+2Pn7zRy8JdD1jVAIZAaaEfCcC40iOfq9uAhonwFceHam5ZHjM
	 jxg6VtvXxQYDxxnLt/ZzEu5LNwCXc8pSBCUG5slq/oWvHI5LIXQmmRVxmts179y4Ky
	 hl3WlSALUH+ScpWRJ1wcYa/oy6Bar+S71JgebrZ/4lVbPxUbqJfYLma7+xNqFpG4A/
	 3GE/uoZQPRe6w==
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7f121c00dedso5321896b3a.0
        for <linux-crypto@vger.kernel.org>; Tue, 16 Dec 2025 00:15:35 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVHvm/sr8ISgpc/QM3p5HkApDgcJo3E4KTUyLfoziqdZrl7kSx2Z92lImAVRXObPNcJ0JAT+07VgDQaG7c=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAPEvErTFcX9N+tSBYd7m0sFLuXIhdDC28VjLS9g2mf39jPeJw
	CoSqfar1L6YgVguTlcAy5JZL1Dmz5a0vRW+Nfi+RkkHenPBN2tzm5iYDVZzquj/+ltHdMwjZcob
	cd/wP830BIfDrgL8bknyY6bm69+VR5DA=
X-Google-Smtp-Source: AGHT+IF+nSHWTz8ec1cHbhpAFGpdip3Xir5QUqV2r4tGwxPTtzoVhw3Dt2GTzD3aYLJg7Rgnn+OPW44rF20NqRmFkic=
X-Received: by 2002:a05:6a20:a128:b0:358:dc7d:a2be with SMTP id
 adf61e73a8af0-369addc8fb9mr13155966637.17.1765872934696; Tue, 16 Dec 2025
 00:15:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <DETXT7QI62KE.F3CGH2VWX1SC@cknow-tech.com> <20251209223417.112294-1-ebiggers@kernel.org>
 <DEUFDH7FJURL.3J0FN5I19VV8F@cknow-tech.com> <CAMj1kXEQkB9MWB+PAi4XE_MuBt0ScitxTsKMDo1-7Cp-=xXOpw@mail.gmail.com>
 <20251212054020.GB4838@sol> <CAMj1kXHVq1NWA28jKxBrHHi1JOPoGXEamC7uMgTOmFwzmcYxRA@mail.gmail.com>
 <20251215201611.GB10539@google.com>
In-Reply-To: <20251215201611.GB10539@google.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 16 Dec 2025 09:15:21 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGQvjcN7gEH_fsxQ-0KW7_Mj93i0LQ8aT6WQTCPiMMcQA@mail.gmail.com>
X-Gm-Features: AQt7F2o-6y27Rl5dgpbF5DqaZ0Tye3uoKErnof0JTlUHQQ7ApPmcPSBBL8_U4C8
Message-ID: <CAMj1kXGQvjcN7gEH_fsxQ-0KW7_Mj93i0LQ8aT6WQTCPiMMcQA@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm64/ghash - Fix incorrect output from ghash-neon
To: Eric Biggers <ebiggers@kernel.org>
Cc: Diederik de Haas <diederik@cknow-tech.com>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, linux-arm-kernel@lists.infradead.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 15 Dec 2025 at 21:16, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Mon, Dec 15, 2025 at 04:54:34PM +0900, Ard Biesheuvel wrote:
> > > > All 64-bit RPi models except the RPi5 are affected by this, as those
> > > > do not implement the crypto extensions. So I would expect QEMU to do
> > > > the same.
> > > >
> > > > It would be nice, though, if we could emulate this on the mach-virt
> > > > machine model too. It should be fairly trivial to do, so if there is
> > > > demand for this I can look into it.
> > >
> > > I'm definitely interested in it.  I'm already testing multiple "-cpu"
> > > options, and it's easy to add more.
> > >
> > > With qemu-system-aarch64 I'm currently only using "-M virt", since the
> > > other machine models I've tried don't boot with arm64 defconfig,
> > > including "-M raspi3b" and "-M raspi4b".
> > >
> > > There may be some tricks I'm missing.  Regardless, expanding the
> > > selection of available CPUs for "-M virt" would be helpful.  Either by
> > > adding "real" CPUs that have "interesting" combinations of features, or
> > > by just allowing turning features off like
> > > "-cpu max,aes=off,pmull=off,sha256=off".  (Certain features like sve can
> > > already be turned off in that way, but not the ones relevant to us.)
> > >
> >
> > There are some architectural rules around which combinations of crypto
> > extensions are permitted:
> > - PMULL implies AES, and there is no way for the ID registers to
> > describe a CPU that has PMULL but not AES
> > - SHA256 implies SHA1 (but the ID register fields are independent)
> > - SHA3 and SHA512 both imply SHA256+SHA1
> > - SVE versions are not allowed to be implemented unless the plain NEON
> > version is implemented as well
> > -  FEAT_Crypto has different meanings for v8.0, v8.2 and v9.x
> >
> > So it would be much easier, also in terms of future maintenance, to
> > have a simple 'crypto=off' setting that applies to all emulated CPU
> > models, given that disabling all crypto on any given compliant CPU
> > will never result in something that the architecture does not permit.
> >
> > Would that work for you?
>
> I thought it had been established that the "crypto" grouping of features
> (as implemented by gcc and clang) doesn't reflect the actual hardware
> feature fields and is misleading because additional crypto extensions
> continue to be added.
>
> I'm not sure that applies here, but just something to consider.
>

You are right, this is why 'crypto=on' can never mean anything other
than 'do not disable the crypto extensions that this particular CPU
type provides' But that does not mean 'crypto=off' is equally
problematic.

> There's certainly no need to support emulating combinations of features
> that no hardware actually implements.  So yes, if that means "crypto" is
> the right choice, that sounds fine.
>

OK, I'll have a stab at that and cc you on the patches.
