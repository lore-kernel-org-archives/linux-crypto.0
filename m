Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6392328B73
	for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 07:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765785286; cv=none; b=rffQHfWZUsLxe0VnkmLLe5nJRYSPz0yZR/lCgmAcP9fZ/NpXcy98QKMPdBjY6zBIv58GOaBKjriv28hAzuZmqWlQnu5sr1ljQsZqPpJFWx5ipAwWUXlvT1Z9CvWI1cQKbcOByoE7qljfoK4ZHtJuN8AiIn1ub35Vwo56EgvGSe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765785286; c=relaxed/simple;
	bh=E30zbqw/DatD5imenKddlu5X4ygrCVqqajHRtSIb61g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YIiU7vh4e8wh1wqELvbhlCH7fWd6EYvMn/XCm4hzhWJHLv4nK1QLEMBfCihdqllx12vfK3WcMo5iuV8dTXoM83lHZm9AA1OTTpPDv4M13OYKCqvFfJv1PwctzGXPvrTYHtv5CKXa540VToXBRK2fk225L3rO5f/NT/g+yd896QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jPnTKiDp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jPnTKiDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62AB4C19424
	for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 07:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765785286;
	bh=E30zbqw/DatD5imenKddlu5X4ygrCVqqajHRtSIb61g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jPnTKiDpmMT04qwUki9f7ZwNkdxdveiIWl934aXXv9v2kt+ZTjb8KkNUvtF26rIMh
	 dTjIXUa4ZgEKjQTIlx3XxuGGvznUxXgL6GaOXuVykxljrSbf4NW8kjD1jagfdAmwpD
	 o6ooACN3+vhKzSFisW8rQaLryZUP04DAqrHeEH0/77MYMwnwFHwA2iMV6PlAGlgm8H
	 CU5sw6TVdqQZdGZRcMrJvPvL/nvwM1U3d5eGXwBKkgKOH8doTnDzSrF8TiIYB4nLVq
	 c+/Dqf8Wk23AU739OvY988mzDDL5T1r/SzUI8QaBJ62wIjsuIFpRp6vZlDdh2Xm+AK
	 nqGqYMLLaEzjg==
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-34c708702dfso904558a91.1
        for <linux-crypto@vger.kernel.org>; Sun, 14 Dec 2025 23:54:46 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUw3FalH0YnGAaye5FN6YsTSMZwgLqaZAeXZ5PbhbGuFTDYGv/ZzF63oe/NyIWPKAAA0vRjsULEUXeWQ3Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQPGJksCV2/CMP2GSADh8LLpsBtuffn55ymvNQ8twyHhxk99Yp
	iYDyHR4TunyozjMmlr5rvGiACc0vQVeZbBy4o25gjoq1/Nd4mTZSoRJMum5mVMPAHjeTp42PKFp
	OLCxvBv+QyEoZ4yx88ZeODsb/qA1vBuc=
X-Google-Smtp-Source: AGHT+IEY9Qcz49LYyQqEAUelrBl+X2gueHl8vQNtIR2vIYjPwsPH+B/0MrnYAD+Kyxfw2b75WsN5vjtnPWGg87QeZBc=
X-Received: by 2002:a17:90b:3c4f:b0:340:c179:3666 with SMTP id
 98e67ed59e1d1-34abd6c02cfmr7983221a91.8.1765785285912; Sun, 14 Dec 2025
 23:54:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <DETXT7QI62KE.F3CGH2VWX1SC@cknow-tech.com> <20251209223417.112294-1-ebiggers@kernel.org>
 <DEUFDH7FJURL.3J0FN5I19VV8F@cknow-tech.com> <CAMj1kXEQkB9MWB+PAi4XE_MuBt0ScitxTsKMDo1-7Cp-=xXOpw@mail.gmail.com>
 <20251212054020.GB4838@sol>
In-Reply-To: <20251212054020.GB4838@sol>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 15 Dec 2025 16:54:34 +0900
X-Gmail-Original-Message-ID: <CAMj1kXHVq1NWA28jKxBrHHi1JOPoGXEamC7uMgTOmFwzmcYxRA@mail.gmail.com>
X-Gm-Features: AQt7F2qXhVr5OpktRHt7yVwu384BIXMp0tpqIhhUDEHp0V7UDx3ZjeXmSEiyyJU
Message-ID: <CAMj1kXHVq1NWA28jKxBrHHi1JOPoGXEamC7uMgTOmFwzmcYxRA@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm64/ghash - Fix incorrect output from ghash-neon
To: Eric Biggers <ebiggers@kernel.org>
Cc: Diederik de Haas <diederik@cknow-tech.com>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, linux-arm-kernel@lists.infradead.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 12 Dec 2025 at 06:40, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, Dec 10, 2025 at 06:31:44PM +0900, Ard Biesheuvel wrote:
> > On Wed, 10 Dec 2025 at 18:22, Diederik de Haas <diederik@cknow-tech.com> wrote:
> > >
> > > On Tue Dec 9, 2025 at 11:34 PM CET, Eric Biggers wrote:
> > > > Commit 9a7c987fb92b ("crypto: arm64/ghash - Use API partial block
> > > > handling") made ghash_finup() pass the wrong buffer to
> > > > ghash_do_simd_update().  As a result, ghash-neon now produces incorrect
> > > > outputs when the message length isn't divisible by 16 bytes.  Fix this.
> > >
> > > I was hoping to not have to do a 'git bisect', but this is much better
> > > :-D I can confirm that this patch fixes the error I was seeing, so
> > >
> > > Tested-by: Diederik de Haas <diederik@cknow-tech.com>
> > >
> > > > (I didn't notice this earlier because this code is reached only on CPUs
> > > > that support NEON but not PMULL.  I haven't yet found a way to get
> > > > qemu-system-aarch64 to emulate that configuration.)
> > >
> > > https://www.qemu.org/docs/master/system/arm/raspi.html indicates it can
> > > emulate various Raspberry Pi models. I've only tested it with RPi 3B+
> > > (bc of its wifi+bt chip), but I wouldn't be surprised if all RPi models
> > > would have this problem? Dunno if QEMU emulates that though.
> > >
> >
> > All 64-bit RPi models except the RPi5 are affected by this, as those
> > do not implement the crypto extensions. So I would expect QEMU to do
> > the same.
> >
> > It would be nice, though, if we could emulate this on the mach-virt
> > machine model too. It should be fairly trivial to do, so if there is
> > demand for this I can look into it.
>
> I'm definitely interested in it.  I'm already testing multiple "-cpu"
> options, and it's easy to add more.
>
> With qemu-system-aarch64 I'm currently only using "-M virt", since the
> other machine models I've tried don't boot with arm64 defconfig,
> including "-M raspi3b" and "-M raspi4b".
>
> There may be some tricks I'm missing.  Regardless, expanding the
> selection of available CPUs for "-M virt" would be helpful.  Either by
> adding "real" CPUs that have "interesting" combinations of features, or
> by just allowing turning features off like
> "-cpu max,aes=off,pmull=off,sha256=off".  (Certain features like sve can
> already be turned off in that way, but not the ones relevant to us.)
>

There are some architectural rules around which combinations of crypto
extensions are permitted:
- PMULL implies AES, and there is no way for the ID registers to
describe a CPU that has PMULL but not AES
- SHA256 implies SHA1 (but the ID register fields are independent)
- SHA3 and SHA512 both imply SHA256+SHA1
- SVE versions are not allowed to be implemented unless the plain NEON
version is implemented as well
-  FEAT_Crypto has different meanings for v8.0, v8.2 and v9.x

So it would be much easier, also in terms of future maintenance, to
have a simple 'crypto=off' setting that applies to all emulated CPU
models, given that disabling all crypto on any given compliant CPU
will never result in something that the architecture does not permit.

Would that work for you?
