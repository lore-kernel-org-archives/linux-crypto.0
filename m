Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0054B1514F8;
	Mon, 15 Dec 2025 20:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765829774; cv=none; b=tNzdUVoQ6Zlc6KDxyjFU1mRMbSSZkyhU+LMsQUGs4uAz/05p4w+84+FXTjPz9wzAmZl1c/HBXgnueEVYIq+8tEwPGMaqUZo5h0FSKjPBw3oc1IMFmrUPrUuyo1DNueEsxHnu8yJNEgJofeihJtwe1nccXscLzMkSBHq001y9A3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765829774; c=relaxed/simple;
	bh=lF8AfJF90zeVvajpf257VP8+PAS/iA+1OUWO0EJGo4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZLyDxKeT+7shhfXJjIHFO1DE1J46PHKBcVQ2uuk2XkTf4By71fwxComCPF/O0v/GWVH0h0Q5fsWG6CZbU1EPydRJufz1iUJ9Fq6K2Y/0o7RtjDARXGTUVxg+aLW2yoRHZ6/K1KeU5fQq1hVwiruJwAReTCIguwY5v1yt1G0r3vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gTq7jxl+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gTq7jxl+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E44DC4CEF5;
	Mon, 15 Dec 2025 20:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765829773;
	bh=lF8AfJF90zeVvajpf257VP8+PAS/iA+1OUWO0EJGo4Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gTq7jxl+/X4t0clkH+mEIN1Yg389a3M1yJZlum/0+HWjs0BADwL0wGHgJE2yuY56G
	 BY2dQ0dXnWxEsVWSdJe4hqMGCzyh5sRgqf2VUyDrteCmtp4ljq93GTSPvK9Xp0qqG0
	 bf39yzzPeKqFVFzbEe8n93pn1mHzt8YQghp1i8rC/fkyWiTHTKTwgBHOaxs9YXV1Zp
	 KPO9xp0g+xQKuR7S6e9WocY5rOmKO+YSVUbO9i0bH16S+U+Od5e5R5P0w3Zk8WSYmt
	 FfjLs4qx3LdNpN0VkOuB1gHDxqiW6QUkLG1pTXEbLL2jqub0IYwiviCRP9AZpCe05U
	 kof8RhLgE7img==
Date: Mon, 15 Dec 2025 20:16:11 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Diederik de Haas <diederik@cknow-tech.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: arm64/ghash - Fix incorrect output from
 ghash-neon
Message-ID: <20251215201611.GB10539@google.com>
References: <DETXT7QI62KE.F3CGH2VWX1SC@cknow-tech.com>
 <20251209223417.112294-1-ebiggers@kernel.org>
 <DEUFDH7FJURL.3J0FN5I19VV8F@cknow-tech.com>
 <CAMj1kXEQkB9MWB+PAi4XE_MuBt0ScitxTsKMDo1-7Cp-=xXOpw@mail.gmail.com>
 <20251212054020.GB4838@sol>
 <CAMj1kXHVq1NWA28jKxBrHHi1JOPoGXEamC7uMgTOmFwzmcYxRA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHVq1NWA28jKxBrHHi1JOPoGXEamC7uMgTOmFwzmcYxRA@mail.gmail.com>

On Mon, Dec 15, 2025 at 04:54:34PM +0900, Ard Biesheuvel wrote:
> > > All 64-bit RPi models except the RPi5 are affected by this, as those
> > > do not implement the crypto extensions. So I would expect QEMU to do
> > > the same.
> > >
> > > It would be nice, though, if we could emulate this on the mach-virt
> > > machine model too. It should be fairly trivial to do, so if there is
> > > demand for this I can look into it.
> >
> > I'm definitely interested in it.  I'm already testing multiple "-cpu"
> > options, and it's easy to add more.
> >
> > With qemu-system-aarch64 I'm currently only using "-M virt", since the
> > other machine models I've tried don't boot with arm64 defconfig,
> > including "-M raspi3b" and "-M raspi4b".
> >
> > There may be some tricks I'm missing.  Regardless, expanding the
> > selection of available CPUs for "-M virt" would be helpful.  Either by
> > adding "real" CPUs that have "interesting" combinations of features, or
> > by just allowing turning features off like
> > "-cpu max,aes=off,pmull=off,sha256=off".  (Certain features like sve can
> > already be turned off in that way, but not the ones relevant to us.)
> >
> 
> There are some architectural rules around which combinations of crypto
> extensions are permitted:
> - PMULL implies AES, and there is no way for the ID registers to
> describe a CPU that has PMULL but not AES
> - SHA256 implies SHA1 (but the ID register fields are independent)
> - SHA3 and SHA512 both imply SHA256+SHA1
> - SVE versions are not allowed to be implemented unless the plain NEON
> version is implemented as well
> -  FEAT_Crypto has different meanings for v8.0, v8.2 and v9.x
> 
> So it would be much easier, also in terms of future maintenance, to
> have a simple 'crypto=off' setting that applies to all emulated CPU
> models, given that disabling all crypto on any given compliant CPU
> will never result in something that the architecture does not permit.
> 
> Would that work for you?

I thought it had been established that the "crypto" grouping of features
(as implemented by gcc and clang) doesn't reflect the actual hardware
feature fields and is misleading because additional crypto extensions
continue to be added.

I'm not sure that applies here, but just something to consider.

There's certainly no need to support emulating combinations of features
that no hardware actually implements.  So yes, if that means "crypto" is
the right choice, that sounds fine.

- Eric
