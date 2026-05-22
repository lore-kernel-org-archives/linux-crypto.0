Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A85349CEC;
	Fri, 22 May 2026 17:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779472118; cv=none; b=OJ2Nl1Ya9s72lROpZDPQec4iv11B26n4l0fNFBtHu0fyUtBzca/LklO2paHbqHZguFrgqcqHJarphdcxPBrWTCSYHP4r4IZ7n/DfFwClnEp6ORhIlfM8XoyMv3ddMnMpf4aD9PczkkNZ7Q+GdtbaA9P5r9FniLqre4rQQIAJU0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779472118; c=relaxed/simple;
	bh=jjNc7O/VrGYTOCr8u4dL3WyzelCtlJwXiGmWN4VLCx0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j6Jowo7xgL1qR8z1ccdG2v4m/DFRO2e78iP3npxxYY7y3ZcGcBLLwHJVFsNArc301JwzVk/gPDuUU4zlHiMBwzFPLzewiQGqSxz6yk4JZ05uZNc44bHqGGklK7G0fDWLFo89bLti4Gj+gYvmgpu4PsynRf13rZ/o3kypB/vlhU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oHIgADCS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oHIgADCS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA2C1F000E9;
	Fri, 22 May 2026 17:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779472117;
	bh=oCFSp9JikkHzvDq1wlGaZyxEcGGgE5UOAkJkMWAY5ks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oHIgADCS/FCvriCsoDzhXlivKNG0DT9dWnfujLqdchEdKOuFmbxSocN/5VMt906MI
	 KjbLzvLE6QcEJB+WGucFlbOGmWOAypobFMgvqLgnyPXHvRYiLTJ1G4a5TraBdWcwAA
	 AJehrZFVv89cYM/3oBN8Bic9SoQbUD6sDwAUGH2J+FDC3kvHZxdv6wpfm89kx1n6HN
	 +EMcHE1/NXipFjl3cgPHXp18Ev6Nl4VXI1TMHRUb5FgFcYjddHtn9BIzQag/bT8oRn
	 yswv9VxMpfg02xx/wSAduSNjN0dny4KHG1huRoehL+lCnAtUc9lfWTbpZl1bhQGo1b
	 M2pYDhBQuLDTg==
Date: Fri, 22 May 2026 17:48:35 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Qunqin Zhao <zhaoqunqin@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
	Yinggang Gu <guyinggang@loongson.cn>, Lee Jones <lee@kernel.org>,
	kernel test robot <lkp@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: loongson - Select CRYPTO_RNG
Message-ID: <20260522174835.GA1894319@google.com>
References: <20260522022525.12976-1-ebiggers@kernel.org>
 <CAAhV-H5cDnWKxBobwRErRyvG8671e6VXsBe6w1RkX9rfn7CVFA@mail.gmail.com>
 <20260522025722.GD5937@quark>
 <d71adfa1-8895-e741-b72f-c5e99d5fb9e6@loongson.cn>
 <20260522040310.GF5937@quark>
 <bc3acf15-808d-4141-7f1f-4a7a7f856c6c@loongson.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bc3acf15-808d-4141-7f1f-4a7a7f856c6c@loongson.cn>

On Fri, May 22, 2026 at 02:40:38PM +0800, Qunqin Zhao wrote:
> 
> 在 2026/5/22 下午12:03, Eric Biggers 写道:
> > On Fri, May 22, 2026 at 11:41:15AM +0800, Qunqin Zhao wrote:
> > > 在 2026/5/22 上午10:57, Eric Biggers 写道:
> > > > On Fri, May 22, 2026 at 10:52:42AM +0800, Huacai Chen wrote:
> > > > > On Fri, May 22, 2026 at 10:26 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > > > > > This driver registers a rng_alg, so it requires CRYPTO_RNG.
> > > > > > 
> > > > > > Fixes: 766b2d724c8d ("crypto: loongson - add Loongson RNG driver support")
> > > > > > Reported-by: kernel test robot <lkp@intel.com>
> > > > > > Closes: https://lore.kernel.org/oe-kbuild-all/202605201622.qWOiiZTV-lkp@intel.com/
> > > > > > Cc: stable@vger.kernel.org
> > > > > > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> > > > > Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
> > > > > > ---
> > > > > >    drivers/crypto/loongson/Kconfig | 1 +
> > > > > >    1 file changed, 1 insertion(+)
> > > > > > 
> > > > By the way, do any of the loongson people have any comment on what they
> > > > think the point of this driver is?  It's not registered with the actual
> > > To provide an AF_ALG-based random number generation interface for other
> > > modules and user-space programs.
> > > 
> > > Thanks,
> > > 
> > > Qunqin
> > AF_ALG is a userspace interface; it's not available for in-kernel use.
> > If you mean using crypto_rng directly, note that no kernel code actually
> > uses it other than the tests, the implementation of AF_ALG, and the
> > FIPS-specific code which uses drbg.c specifically.
> > 
> > So, the first half of your justification doesn't make any sense.
> > 
> > As far as the second half: why would a userspace program do that instead
> > of just using the regular Linux RNG (/dev/urandom)?

Could you answer this question?  If there's no answer to this question,
then there's no use case for this driver as-is.

> > AFAIK, the only reason to use a HW RNG directly is for certification
> > reasons.
> > 
> > However, there's also already an interface for that: /dev/hw_random.
> > 
> > So AF_ALG seems completely redundant for this case.
> 
> To be honest, I previously assumed that the `hw_random` was designed
> strictly and exclusively for the TRNG mode.
> 
> Is it architecturally acceptable or common practice for a PRNG mode to
> utilize `hw_random` as well?
> 
> Thanks,

So the Loongson RNG is a PRNG?  Where does it get its entropy from, and
what is its security strength?

- Eric
