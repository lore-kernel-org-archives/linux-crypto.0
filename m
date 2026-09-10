Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B9349481A;
	Thu, 10 Sep 2026 14:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789049699; cv=none; b=GbzLqfNXAIemeR1zPxrX1C3NZMqSqTjlf5+ovb9IovV5tWe7kBNBhA2W2kMdkwWJdo7BY/F8EksEhLU8p6MrmKtZhH4OO+817cK/mu18S/qon2Xw8T74aVgibCxn4shAYRGtYwfZAH16Z0zG1To99ygOVvZog+Upsa0uhov0bvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789049699; c=relaxed/simple;
	bh=vZb+To3dn7nxMqAF+xniM1hj6OZWHwB4F6mWcKx9Qw8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hreJcXSvc/iUepvLXXcmhwDBH+vJg5WWyKm50zivo0BVtA34p3ElEyvMqI/nfsy/QxcE63XkTgu4JBFKGbD+XALSSGD9zTXBqjTEC95rF7tSiFekiRAtgUwaCrMmaE3cxwVJRcpq+/LG+Blori7tQQTLc8lgRDFxoBHh14K/x1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=niPBdpix; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="niPBdpix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0281F000FF;
	Thu, 10 Sep 2026 14:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789049698;
	bh=aaH94r2pnTGyhZ2s2DCtMt9jAIlcwDGgoPae43u3KbI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=niPBdpixKg9E9hqQj+GTyb42eVqDLarLNBGOOajS0BYsqMl6xxrV2LQ5OtyQkYEEY
	 4Ta6rgMg8Ik1nw2cS2V9VsO7QgTwjlx1i4ayNDlfGFs/bNK3XrVMHw3tWLqgN5Z6CZ
	 Ppw5qTar0i9NxUqC6AfaeVbUB3jrkFhpWKisjhC4wLIWyVIrh64Q45UnHydlWziIuF
	 vtoq/d6Dc85jiyZCOPKYlntu0vzvT2gHx5+AdagFeOKbE7M1eGVJ8OaE+8h78vy/J6
	 SPMM4iZHxysLD5C06I907FHrcU+orF4ce+WOOTLOEU2biAyop0fu6zOGBmYejd3o+C
	 6U0FlgGyyTocw==
Date: Thu, 10 Sep 2026 09:14:56 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: Joachim Vandersmissen <joachim@jvdsn.com>,
	"David S. Miller" <davem@davemloft.net>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: testmgr - block Crypto API xxhash64 in FIPS mode
Message-ID: <20260910141456.GA1936@quark>
References: <20260303060509.246038-1-git@jvdsn.com>
 <abTuFto8Tc3mhRRe@gondor.apana.org.au>
 <64592fee-1956-4a70-a751-9ac3335cfc27@jvdsn.com>
 <9926908a-5f08-43ba-99dd-b83c7067d52b@redhat.com>
 <83d09aa1-729a-47a2-a8e9-381c74e92f42@jvdsn.com>
 <48f12b65-428d-4809-9735-18876b09e759@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48f12b65-428d-4809-9735-18876b09e759@redhat.com>

On Thu, Sep 10, 2026 at 10:57:32AM +0200, Thomas Huth wrote:
> On 10/09/2026 05.24, Joachim Vandersmissen wrote:
> > Hi Thomas,
> > 
> > On 9/9/26 9:36 AM, Thomas Huth wrote:
> > > On 15/03/2026 01.43, Joachim Vandersmissen wrote:
> > > > Hi Herbert,
> > > > 
> > > > I don't think this one can be applied yet since dm-integrity
> > > > still uses xxhash64 through the crypto API. This would break
> > > > fips=1 systems that use it.
> > > 
> > > Out of curiosity: Wouldn't such a system be FIPS-incompliant anyway?
> > > If xxhash64 isn't FIPS-compliant, nobody should use it for
> > > dm-integrity there, right? So I doubt that there are any systems out
> > > there that use fips=1 and use xxhash64 at the same time?
> > 
> > There is a risk that users may not know that xxhash64 is not FIPS
> > compliant and would still use it. Especially considering it was marked
> > as "fips_allowed = 1" for a while.
> 
> So isn't that a very bad situation? They think they are FIPS compliant, but
> actually they are not since they use an unapproved algorithm by accident.
> Maybe it would be better to include this patch so that they are aware of the
> mistake? If there is really somebody running into this issue, they could
> boot once with fips=0, fix their system, reboot again with fips=1 and
> finally be really compliant. Sounds like the better solution to me. WDYT?

As described in the dm-integrity documentation, dm-integrity supports
non-cryptographic checksums for protection from accidental corruption.
That use case is no different from any other use case of a checksum.

It's also no different from using crc32 or crc32c, which similarly have
fips_allowed=1 and this patch completely ignores.

The solution is not banning checksums or making any other code change,
but rather just doing what it seems everyone has already been doing:
documenting in their FIPS security policy that checksums are only for
use cases that are not "security functions".

- Eric
