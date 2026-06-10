Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB73134D901;
	Wed, 10 Jun 2026 18:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781116745; cv=none; b=rnwaKcR8FhV+BrjtLDgCylkEtFQgG8LiEU8aips/VEbqFtlMFBjCFNyfOvOHdIqWdqx4CFCDrn1Dvfc7/ymvaYJIVE+QPEs9V4SHNr6MzVu04UbambkZigSG2EAA3DR1O7OzCnLGQy48p+hq2bYyHO/Hgd/JWSuk22Aj5BzmmFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781116745; c=relaxed/simple;
	bh=GxMar0oLEIQoe7sHtEEfoKoR0HEcjBy+/l3pVm1wND8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mFCVGnNzWYgejpEOzB4ZPX5+64K0DQixJ6qnEI5vGhajbKvHT9JcHTy1aMf8h6LJl/tAQ6a61KZph0iZ5EGqWmGzMWd5YRDn07GCUC97tNKS32SmxH/nk9aLc/MQe2jv7VSaImiqYv8ixMsTGTu1+4ihpZ0IN7KSyaHqcyhU86Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L1ObFPr2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L1ObFPr2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DC01F00893;
	Wed, 10 Jun 2026 18:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781116744;
	bh=4o1VtWCXoWoxZBd6EawCUnJfQ/1lp18t/RARZHM0h5E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=L1ObFPr2OvgTYrOIIO4/YtP6lSqMh682GiOhOkJWrOkn11BH1KN8+D4dLayTtyAQk
	 OCKltKKSoaFudM5UTbZ+sDqvJaKgF28LSWLxitUx48re7IN69YoiqhAv4HE7aKihIh
	 +XbGlAD2J3OJ+EZixK+Wo8iw8K4CDmoLOe6pazU99tWs+FmU0aQMs8QPKLuPd74MHr
	 w9hezWha/VMuYab5un8ehjztSILHjkRN9dG/0/4SoZ9dQxe4+t+NbkaUDyKD2FemYq
	 IwsHPk29AfT229gyPnvy6kNFwH4JnlrUTfsyf8BymvScuBdBtvXClCOzC7Z+Q/4Ui3
	 qm9lGdnlcUozw==
Date: Wed, 10 Jun 2026 18:39:02 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-samsung-soc@vger.kernel.org,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: exynos-rng - Remove exynos-rng driver
Message-ID: <20260610183902.GA1158828@google.com>
References: <20260531175932.32171-1-ebiggers@kernel.org>
 <CADrjBPo3BpSk49oasf_9g06xrBMkw+NiKo10xDKjWr8sJ+Zc-Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADrjBPo3BpSk49oasf_9g06xrBMkw+NiKo10xDKjWr8sJ+Zc-Q@mail.gmail.com>

On Wed, Jun 10, 2026 at 03:46:54PM +0100, Peter Griffin wrote:
> Hi Eric,
> 
> On Sun, 31 May 2026 at 19:02, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > This driver has no purpose.  It doesn't feed into the Linux RNG, nor
> > does it implement the hwrng interface.  It is accessible only via the
> > "rng" algorithm type of AF_ALG, which isn't used in practice.  Everyone
> > uses either the Linux RNG, or rarely /dev/hwrng.
> >
> > Moreover, this is a PRNG whose only source of entropy is the 160-bit
> > seed the user passes in.  So this can be used only by a user who already
> > has a source of cryptographically secure random numbers, such as
> > /dev/random.  Which they can, and do, just use in the first place.
> >
> > Just remove this driver.  There's no need to keep useless code around.
> >
> > Note that the other crypto_rng drivers in drivers/crypto/ are similarly
> > unused and are being removed too.  This commit just handles exynos-rng.
> >
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> > ---
> 
> If the driver is being removed, should the binding documentation for
> this driver not also be deleted (see
> Documentation/devicetree/bindings/rng/samsung,exynos4-rng.yaml)?
> 
> Peter

In other discussions I've been told that devicetree bindings are
hardware descriptions that should still exist even if there is no
driver.  It doesn't make a lot of sense, but it seems to be what the
devicetree people want.  I expect there would be objections to removing
this binding.

- Eric
