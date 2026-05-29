Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C62330676;
	Fri, 29 May 2026 19:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780083716; cv=none; b=YjGF41PWx4SmnW+O0+v83r7shdaCgos8fZ6YyzTsdCehdbFa4QvbVPgWhk0KugdNGbMXkYYSfIw9Id4iTcHBjQgjCEizNtqi0zDFy+zJWTN9afHu4H67R8H6xugutDLZMiTvw7JFofeZvIfHKbP00XESbpC03ewJ7ivY+OGKLQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780083716; c=relaxed/simple;
	bh=F3x/2SgMCNTcd2ANwzmBaAqs/uTC28e9kXuAYITisBA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BXwPMDFo1kIq8cZnGeSUjedrEoLWSLzDwVwDyMN3LgfsD232HTt/APs8UNXutnBbcLCR2FrgnvjD5PJWuGlPiDxENKARdWD1XxtMA9cqDaKV3NccJXUXrvsSAC6mpG4QosAZQCrxriv9tEgyybtTVOfbXuXeObxIEHP72m+8LMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N82RkD+A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N82RkD+A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 401231F00893;
	Fri, 29 May 2026 19:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780083714;
	bh=PVL1fgCYNQNbfGvmIgyZvmai4Ca8jPd8nUCpL+b5j+w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=N82RkD+Au9NUqfH6VFKACTfa6rn1e+dWFN6H5xhDd/jKzekSGBC6gNYAGBB7OU7u/
	 +8PDk4DWSRNaMXdxlHS1uWKZfIch955zUSnFxgUD8dkD7bjVrw33XXmm5zuJVYTPQe
	 DNF6XRHwfb1QI5senSPQoeRcQaJt2W4vVxOuCF9tLgV0qKi1BqJMJkaPzXCIgwrpXY
	 Sk7AAZbdLFYgyhFbbvHRDtNObBcdnkLt4GVbT15/tRk7Pf4SfQ0vo3FTvF2R8bKSbu
	 P2gq0K0o9oWXNXNZRdEuarQYLzcP72lsEAKpxf8cTypKpRqTfaP7sLLaN91ojVql2t
	 C6CXrYJEjcgeA==
Date: Fri, 29 May 2026 12:41:52 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: Tianchu Chen <tianchu.chen@linux.dev>, herbert@gondor.apana.org.au,
	davem@davemloft.net, wens@kernel.org, jernej.skrabec@gmail.com,
	samuel@sholland.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: sun4i-ss - clamp PRNG seed length to prevent
 heap overflow
Message-ID: <20260529194152.GA3628@quark>
References: <af749a8447bd7f0e9dd26ca6c87e9c6afecb09d9@linux.dev>
 <4d4407c05835a50413fa1e974e3aa3f4abfe2d5b@linux.dev>
 <20260529161057.GA2706@sol>
 <ahnIbpBLyn5z_siT@Red>
 <20260529173341.GA566433@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260529173341.GA566433@google.com>

On Fri, May 29, 2026 at 05:33:41PM +0000, Eric Biggers wrote:
> On Fri, May 29, 2026 at 07:10:06PM +0200, Corentin Labbe wrote:
> > Le Fri, May 29, 2026 at 09:10:57AM -0700, Eric Biggers a écrit :
> > > On Fri, May 29, 2026 at 08:08:01AM +0000, Tianchu Chen wrote:
> > > > From: Tianchu Chen <flynnnchen@tencent.com>
> > > > 
> > > > sun4i_ss_prng_seed() copies the user-supplied seed into ss->seed
> > > > using the user-provided length with no bounds check. The crypto core
> > > > does not enforce slen <= seedsize before calling into the driver, so a
> > > > userspace caller via AF_ALG setsockopt(ALG_SET_KEY) can pass up to
> > > > sysctl_optmem_max bytes, overflowing the fixed-size buffer and
> > > > corrupting adjacent heap memory.
> > > > 
> > > > Clamp the copy length to the buffer size, matching the approach used by
> > > > loongson-rng for oversized seeds.
> > > > 
> > > > Discovered by Atuin - Automated Vulnerability Discovery Engine.
> > > > 
> > > > Fixes: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
> > > > ---
> > > > v2: Silently clamp oversized seeds with min_t instead of returning
> > > >     -EINVAL (Herbert Xu).
> > > 
> > > sun4i-ss-prng.c is useless, is still broken, and should just be deleted.
> > 
> > Hello
> > 
> > useless ? clearly no, it helped a lot on devices where it is.
> 
> The only way this code is reachable is via "rng" algorithm type in
> AF_ALG, which is almost never used.  Everyone just uses the regular
> Linux RNG (/dev/random etc) instead, as they should.
> 
> In fact, anyone were to accidentally use this it would be a security
> vulnerability, seeing as sun4i_ss_prng_generate() doesn't actually fill
> in all the bytes that were requested.  It also doesn't wait for the FIFO
> to be ready when reading data from it.
> 
> Is it possible that there's a misunderstanding here and you think this
> provides entropy to the regular Linux RNG?  It doesn't.  hwrng does
> that, crypto_rng does not.
> 
> The correct fix is to mark CRYPTO_DEV_SUN8I_CE_PRNG as BROKEN or remove
> it entirely.  Doing otherwise is not responsible.

Looking into it a bit more, just removing CRYPTO_DEV_SUN4I_SS_PRNG is
clearly the way to go.  This patch does it:
https://lore.kernel.org/linux-crypto/20260529193648.18172-1-ebiggers@kernel.org

- Eric
