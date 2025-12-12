Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F50248F6A;
	Fri, 12 Dec 2025 05:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765518027; cv=none; b=HEXlg9V8bBji2nIgULTt5EXvuHy0g7rOczF9qvHcrUTf9Zq/s82U2u0NvOCctaGEgEuYTF7d+z80EBfReus6UHKZuIyq6hGZcm4AO4A9MbC+KfYZnZOEi8lg/Kk/IxhcuFYT6wquzGWm/R5Gw9U1ZOdCFE7tum3F2hYbRYkfUIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765518027; c=relaxed/simple;
	bh=9lv9rkuazkepyHsEe5BLEaVyoz3/43JZv/bu12Tj3Pw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QYLKCPMKOQgfIJ6Xm0sX9H3Mu4jlnWisEJmfJdRxJ+OH3goCS085XTcRjcsaGoRd2jTv3w3VHMJhc3u496dfdy3r03GHH1ylpleAu256vH0735UApM1yffh7njtmvdDILZRJ9bbrThd2NgwAcXu+OsTxD7FfC953u1yVu1YL53Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gU1t6+ZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gU1t6+ZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED84C4CEF1;
	Fri, 12 Dec 2025 05:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765518027;
	bh=9lv9rkuazkepyHsEe5BLEaVyoz3/43JZv/bu12Tj3Pw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gU1t6+ZT6MpXHesyb60y9ESy+M0WLM/LGl+C8zwHBP8gCj7BFHJe8cTFyBDZpOWED
	 rTZ9xNdh1WZYbH55D6EBrU+HjJF19JicUvKbHRXNrHCxiYra6uzhwNQp++nHMAMpe2
	 oa3HlQvAug8WzEjKVoW7SqivNTfO6pbnPih/kdLg1Yyr48spmJhC8O2pAJLFkUa8B/
	 mrfvZl8ZdzAXejidtkcaUhXD2KfUnjOJEFdrBeav3JDFHON3hlbdGZIfozwdz2vD+s
	 2CDcghZSN3VBQmA1wRBCx7OXYMvDMoZhvX2QlWZlY76RgZtt9ygmsTPyIjTaF2Bj7G
	 6D9RcMVU5BFTg==
Date: Thu, 11 Dec 2025 21:40:20 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Diederik de Haas <diederik@cknow-tech.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: arm64/ghash - Fix incorrect output from
 ghash-neon
Message-ID: <20251212054020.GB4838@sol>
References: <DETXT7QI62KE.F3CGH2VWX1SC@cknow-tech.com>
 <20251209223417.112294-1-ebiggers@kernel.org>
 <DEUFDH7FJURL.3J0FN5I19VV8F@cknow-tech.com>
 <CAMj1kXEQkB9MWB+PAi4XE_MuBt0ScitxTsKMDo1-7Cp-=xXOpw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXEQkB9MWB+PAi4XE_MuBt0ScitxTsKMDo1-7Cp-=xXOpw@mail.gmail.com>

On Wed, Dec 10, 2025 at 06:31:44PM +0900, Ard Biesheuvel wrote:
> On Wed, 10 Dec 2025 at 18:22, Diederik de Haas <diederik@cknow-tech.com> wrote:
> >
> > On Tue Dec 9, 2025 at 11:34 PM CET, Eric Biggers wrote:
> > > Commit 9a7c987fb92b ("crypto: arm64/ghash - Use API partial block
> > > handling") made ghash_finup() pass the wrong buffer to
> > > ghash_do_simd_update().  As a result, ghash-neon now produces incorrect
> > > outputs when the message length isn't divisible by 16 bytes.  Fix this.
> >
> > I was hoping to not have to do a 'git bisect', but this is much better
> > :-D I can confirm that this patch fixes the error I was seeing, so
> >
> > Tested-by: Diederik de Haas <diederik@cknow-tech.com>
> >
> > > (I didn't notice this earlier because this code is reached only on CPUs
> > > that support NEON but not PMULL.  I haven't yet found a way to get
> > > qemu-system-aarch64 to emulate that configuration.)
> >
> > https://www.qemu.org/docs/master/system/arm/raspi.html indicates it can
> > emulate various Raspberry Pi models. I've only tested it with RPi 3B+
> > (bc of its wifi+bt chip), but I wouldn't be surprised if all RPi models
> > would have this problem? Dunno if QEMU emulates that though.
> >
> 
> All 64-bit RPi models except the RPi5 are affected by this, as those
> do not implement the crypto extensions. So I would expect QEMU to do
> the same.
> 
> It would be nice, though, if we could emulate this on the mach-virt
> machine model too. It should be fairly trivial to do, so if there is
> demand for this I can look into it.

I'm definitely interested in it.  I'm already testing multiple "-cpu"
options, and it's easy to add more.

With qemu-system-aarch64 I'm currently only using "-M virt", since the
other machine models I've tried don't boot with arm64 defconfig,
including "-M raspi3b" and "-M raspi4b".

There may be some tricks I'm missing.  Regardless, expanding the
selection of available CPUs for "-M virt" would be helpful.  Either by
adding "real" CPUs that have "interesting" combinations of features, or
by just allowing turning features off like
"-cpu max,aes=off,pmull=off,sha256=off".  (Certain features like sve can
already be turned off in that way, but not the ones relevant to us.)

- Eric
