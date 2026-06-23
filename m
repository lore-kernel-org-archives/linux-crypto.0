Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0C031F9B5;
	Tue, 23 Jun 2026 16:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782233625; cv=none; b=PzGiU0tNTRqOGbQpKhmAMX801D93CzCFVymOLfvY7510/yI2dMsf1iiP7Smoaf57MxMqZhDrrlZdDw6Kn974leCH4qBvQCT8hmzfbN8qh6TRun6JF0pAMjpZ7rRlDAcgLIsrJ4vIPpOhOPmhha3BxRQMV7qypxG8vhjoG/qmd64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782233625; c=relaxed/simple;
	bh=pmtfmTttHv80VhnbRoMdp51uivn9osClHeNyIMlCIJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r2xYRhAonlLmyp4LCs8AvD+LHLzJbqs2Vs8cr8lI7V/f0haY7W7sbl+R5lWkrmn68gEaRuCNtJRxjdNE2UXEv5PuPlGsKGgQGBhq0KCvURim8DDM/Az7blmOfz4RqfttglIeinffcddR5NXVLzyNFRDI+HKVFN52dfNS7GTsTWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RHPyjm/1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RHPyjm/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0C61F000E9;
	Tue, 23 Jun 2026 16:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782233623;
	bh=u3kovGUrue4Jo2v4uNDyok1wffUV6K5nagIQhjbCHbw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RHPyjm/1EQbVP1Bemjzl1zmRDTwcInvOraMvlq85TXa5wj8/iuz99avcG7rw2LtOA
	 6Gu7PrBK7WQUyKyT73mxLDffLrlKghaQIgWbZVe8/VbG7efJVGFFRVOrAPqTblrgUU
	 gBP5T+IztYmC7D38NFa7Zp/FGCvP9IZFfbdq+WCpQD/TS9ELNmy1SxgHFBUyP5p+8f
	 wE0O7p5r8jkZpBmQpDxgRA/2VwR/ua8Pvp7m4iCeoyQpeIRsH5E7gAm8zGevmX8q/N
	 xrV6lt5fVam9O3xbch3skkTjkMFI/L+ROL0MpDgmzRFHcEZsxwilZxDyRsRjerd9l8
	 DQp26wCAgiuaQ==
Date: Tue, 23 Jun 2026 09:52:08 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, iwd@lists.linux.dev,
	linux-hardening@vger.kernel.org, Milan Broz <gmazyland@gmail.com>,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] crypto: af_alg - Add af_alg_restrict sysctl, defaulting
 to 1
Message-ID: <20260623165208.GB1793@sol>
References: <20260622234803.6982-1-ebiggers@kernel.org>
 <CABBYNZ+QLvkYkn_EcBZ4+GopyhKqJLcfCoABYcw1VamavbSvhg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABBYNZ+QLvkYkn_EcBZ4+GopyhKqJLcfCoABYcw1VamavbSvhg@mail.gmail.com>

On Tue, Jun 23, 2026 at 11:04:14AM -0400, Luiz Augusto von Dentz wrote:
> > +===  ==================================================================
> > +0    AF_ALG is unrestricted.
> > +
> > +1    AF_ALG is supported with a limited list of algorithms. The list
> > +     is designed for compatibility with known users such as iwd and
> > +     bluez that haven't yet been fixed to use userspace crypto code.
> 
> Is the expectation that we go shopping for userspace crypto here?

Yes, same as what 99% of userspace already does.  Probably you'll just
want to link to OpenSSL, but it could be something else if you want.

- Eric
