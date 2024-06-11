Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9487E782;
	Tue, 11 Jun 2024 03:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718075597; cv=none; b=LoD/akvGenPtMSvrALJIFc03dal0UpaTlrHbCyoWIROG2groArH+ItGfegfB4y/5rHhYBAApz3+64wuPeQR4DgXi4lxE78j7cAmbigqcHJGseFWVCIUiAeEKRp483O5Skt1eFrP7naKtu899Dl4oZBrK6lC6ft8CJbGhpaAAiRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718075597; c=relaxed/simple;
	bh=ZMZKxxJuYo9eKsMIOrsBuBANLaKNn9wG+ufnOZCOjg8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uOiL7pU8mmL9DlYfcGS7JL8LViL4KXc0hs3jkiX5QYVKOj/uZ8Zilke8+N4xtEMaQZCIkwwYJLD8f9aIJQ/A153UCGSCyv5k2N5foKSiu7RmpE/ZzDthdrydHXdisp2eo9CIEN0M6iBi4emwuKllUJP+fddswIuoflcYY2vSuFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qwrt7Btc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qwrt7Btc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA24C2BBFC;
	Tue, 11 Jun 2024 03:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718075596;
	bh=ZMZKxxJuYo9eKsMIOrsBuBANLaKNn9wG+ufnOZCOjg8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qwrt7BtcqvK3RqTdB+lO3NW2bXjr5H6ZeRZRK31zbrHc2Dw8811Rc9KWlhaRKnwpg
	 kaGVXt8lp+WTZDw2EJeZ2b/rKVU7nX9BoGIcCLyGcvHDtBtjW12M7yR0i371HyNbj7
	 W0d603VGCTb8cU2/jQxFXpkiQQ8tvE9jDRu54Qr2kcfu84Z85k4Esc0YMVKzD5c3An
	 T22n5eTOYz6MzRZe+nbjkJHaVZqRsbDhvwilQlC7bCrQMyer7dqSP0ynMcCVYCM74t
	 DaMBqK+kHk57pPXIlLqXiBmUTouhB+0NLMdTrdoAsbCosCP+8BhzYxOy6xfxfH/bqd
	 C/1n6fqamoA2w==
Date: Mon, 10 Jun 2024 20:13:14 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kamlesh Gurudasani <kamlesh@ti.com>, kristo@kernel.org, will@kernel.org,
	akpm@linux-foundation.org, davem@davemloft.net,
	mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
	robh@kernel.org, krzysztof.kozlowski+dt@linaro.org,
	conor+dt@kernel.org, vigneshr@ti.com, catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 0/6] Add support for MCRC64 engine to calculate 64-bit
 CRC in Full-CPU mode
Message-ID: <20240611031314.GA2557@sol.localdomain>
References: <20240524-mcrc64-upstream-v3-0-24b94d8e8578@ti.com>
 <87tti098af.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
 <Zme3EcW4Uz8kTbTt@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zme3EcW4Uz8kTbTt@gondor.apana.org.au>

On Tue, Jun 11, 2024 at 10:31:45AM +0800, Herbert Xu wrote:
> On Mon, Jun 10, 2024 at 08:03:44PM +0530, Kamlesh Gurudasani wrote:
> > <kamlesh@ti.com> writes:
> > 
> > > From: Kamlesh Gurudasani <kamlesh@ti.com>
> > >
> > > MCRC64 engine calculates 64-bit cyclic redundancy checks (CRC)
> > > according to the ISO 3309 standard.
> > 
> > Could you please review this and let me know if any changes are needed
> > to get it merged.
> 
> Eric Biggers had concerns about adding this to the kernel.  I'd
> like know if he's OK with this or not.
> 

I thought the rule is that there needs to be an in-kernel user to add algorithms
to the crypto API?  Is there any precedent for adding new algorithms purely so
that accelerators that implement them can be accessed from userspace via AF_ALG?

Even if acceptable, the motivation for this one does seem weak, given that a
userspace software implementation would actually be faster.  It could be
marginally useful for freeing up the CPU for other tasks if the inputs being
processed are very large (probably at least several megabytes), though.

- Eric
