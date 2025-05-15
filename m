Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008D325B682;
	Thu, 15 May 2025 18:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747333294; cv=none; b=EITWMxO2g2A3FMur9f59l0BF4cbjkkZRyy6Tnm3nMZsSlifoHCoMiRULWH3PUwLvDooUE/kE9HdqLtJEdUNET9hb2gvfb1BdrUMW2F6mC1dyQNKjbdevTDNgRO6oAnrDnYvyfQz5pJcmdPNflO3s1thR7+gVi+AwUiTz0KrFh9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747333294; c=relaxed/simple;
	bh=FxFfDzDgOp986k0H7VfACOZfr9TqwD1Xt+WZdTe4qYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hHDToM1UCI/Z49nBtu/gIb1CoZxmGnKA2UhL+bd0apWCqPdapuWTJZWAnx/UpsBhulogc7bbgQ6RCHP+QFxIfTeUYxWc6juJ/BUCHU1IhFgiLl3TPC1ff0Xk1LM7wvQiElIJCB9HcwC6mytHB4tmh+FUgTERaOH4eowRsyFb7j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zcib9lV2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zcib9lV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD50DC4CEE7;
	Thu, 15 May 2025 18:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747333293;
	bh=FxFfDzDgOp986k0H7VfACOZfr9TqwD1Xt+WZdTe4qYg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zcib9lV2xe8z2dUxIYZ3PyJ1POiKAPw5mjTzXsGPkgYQHy34aBinzuLp+gFDhX6BU
	 jAW0xLKEIfoaMpPCz1Og7HDRVQDfvjsM2BTnmJAr6/b1N8BSw/wBX4HgCc4aWCPY/S
	 b3FKX2Rlq73wPCqRWjJhcnM2WDZQLZ6VyHzgkdD5JpUDBUID+RQczdfQdHlMKQx/gu
	 wYiHdZYBsxfZBFN/C3U8bFjvNxrOde+8orkgmfDB1+5Mtib6yA5RTQmJf0BMHviAeU
	 lNIz/Y+d94d/0NrDXywYkAh4RHkcwN5LvDSnw+pyDZ+l4ZyJTYc8u+alQuAwfuFGbg
	 elNOWNRYI3F5Q==
Date: Thu, 15 May 2025 11:21:31 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Klaus Kudielka <klaus.kudielka@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Corentin Labbe <clabbe.montjoie@gmail.com>,
	regressions@lists.linux.dev, linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH] crypto: marvell/cesa - Avoid empty transfer descriptor
Message-ID: <20250515182131.GC1411@quark>
References: <aB8W4iuvjvAZSJoc@gondor.apana.org.au>
 <41680c5d41ed568e8c65451843e3ff212fd340c4.camel@gmail.com>
 <aB8t1ZTVBexqGlcm@gondor.apana.org.au>
 <dcb0b04e479d6f3cfed87795d100ea09e4fbcf53.camel@gmail.com>
 <aCAX8rj2ie4QMnTo@gondor.apana.org.au>
 <28184fb96e2de8a0af32816f5ff1b3d776b57217.camel@gmail.com>
 <aCMOyWVte4tw85_F@gondor.apana.org.au>
 <8e9b45bdafe6ac3f12bcbb5fce5bc9949566344f.camel@gmail.com>
 <aCQm0aHYnI6ciyPz@gondor.apana.org.au>
 <20dde00750d803a9a364ded99dab1e3e22daec77.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20dde00750d803a9a364ded99dab1e3e22daec77.camel@gmail.com>

On Thu, May 15, 2025 at 07:53:03PM +0200, Klaus Kudielka wrote:
> On Wed, 2025-05-14 at 13:14 +0800, Herbert Xu wrote:
> > 
> > Sorry, should've mentioned that this goes on top of the current
> > cryptodev tree:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/log/
> > 
> 
> Okay, so now I have two printk patches on top of the current cryptodev tree.
> 
> I have enabled CRYPTO_SELFTESTS
> 
> - Three successful reboot / modprobe marvell-cesa. All self-tests passed.
> - But the whole self-tests sequence now take approx. 2 minutes, instead of 15 seconds with plain v6.15-rc5
> - And the journal gets huge. 24k lines. I am attaching a gzipped version, hope this works.
> 
> Best regards, Klaus

CRYPTO_SELFTESTS now enables the full set of crypto self-tests, which for the
past 6 years have been needed to be run anyway to properly validate the drivers;
just developers often forgot to enable them because they were under a separate
kconfig option that had a confusing name.  So the longer test time is expected.
It's unfortunate that it takes 2 minutes on the platform you're testing (on most
platforms it's much faster), but presumably that is still okay since it's just a
development option?  People shouldn't be expecting to run these tests in
production kernels.  (But even if they are for some reason, the test time also
remains configurable via kernel command-line options.)

- Eric
