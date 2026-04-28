Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7467C44CF25;
	Tue, 28 Apr 2026 17:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777397423; cv=none; b=UG0cqZlWktMVR1yEVxYzKwLYvvye+kCNYpYh41QHmeYVNoIqNKjeRDKrrlBLBotyjKadWEQBYXmTPzT8As5hdB9GRZxBfxbb1OvoTAkoRr9XvgtQ176QTJtzKSoYYz4k/LFQvK8a2V46QxynOdvvpawzTgUuFQw4vjD+NE+3nxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777397423; c=relaxed/simple;
	bh=4Du2GmHMTceXjdW2lEc2m7ceM3xROI/FG08rhdrb1b8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C52GU6MFDz8OzCvhzpWRsAZt+15KKvWhcdjzwp+oPjqZ0xygDjdtFiAtg5o3LhSESoNzPHAEm57WWaSqWWGoV3ZRXlFlvNaY81ejHfra8Qg5JVW4Jk395YiCokhpmEW5IiiltqjE14S0DbNMI4FzI1Dtl4WPlizZ6REEqfhBS0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q5pQXwLm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q5pQXwLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88647C2BCAF;
	Tue, 28 Apr 2026 17:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777397423;
	bh=4Du2GmHMTceXjdW2lEc2m7ceM3xROI/FG08rhdrb1b8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q5pQXwLmrBTyTkfd7xoHcRqRtTsHzEWTg1u6t3sk0v7w+qFsEFG8L+8THDCGVWsGy
	 Pc0oW6ZnNifIQMKphwiHmrK7NBCUTuZBI+G9GDtNFHNhtFYoOE1I+z+dgWlhJLrErO
	 671lCWNFcf0+UnXXNNCjaJRYBVuhmX1OcScXuxkTiO3NjzrQYIRNologn34VDi6eFA
	 PrsbDzWD4ey8KGGqJ1JHp7VWb14FQp8IaRMyg/OYRKps4wgkz2v82p/OUh2I0V7pnR
	 mDIro+f2n0q1YS7pGTgjrGgltnfLnxmajdANLdsRkQ/yx9LPd7PcBkDvmhhfod9bcq
	 wlKeyu6LlDpEg==
Date: Tue, 28 Apr 2026 17:30:20 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Simo Sorce <simo@redhat.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, netdev@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Dmitry Safonov <dima@arista.com>
Subject: Re: [PATCH net-next v2 0/5] Reimplement TCP-AO using crypto library
Message-ID: <20260428173020.GA55526@google.com>
References: <20260427172727.9310-1-ebiggers@kernel.org>
 <CAJwJo6Z9oJSMMBUL_pbYWN6ha3n4MRpKV_aVut8E+af3JUDFkw@mail.gmail.com>
 <20260427200116.GA3454259@google.com>
 <20260427232054.GA2700@sol>
 <33613b11328d830f8683fc6ec6900da2b479ae27.camel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33613b11328d830f8683fc6ec6900da2b479ae27.camel@redhat.com>

On Tue, Apr 28, 2026 at 12:26:44PM -0400, Simo Sorce wrote:
> On Mon, 2026-04-27 at 16:20 -0700, Eric Biggers wrote:
> > On Mon, Apr 27, 2026 at 08:01:16PM +0000, Eric Biggers wrote:
> > > > - Ronald P. Bonica (the original RFC5925 author), together with Tony
> > > > Li do have an active RFC draft to support the additional algorithms
> > [...]
> > > > [1] https://www.ietf.org/archive/id/draft-bonica-tcpm-tcp-ao-algs-00.html
> > 
> > For what it's worth, that draft makes very little sense.  For example,
> > it proposes three variants of HMAC-SHA3, instead of just making the
> > modern choice of KMAC256.  And it proposes both HMAC-SHA384 and
> > HMAC-SHA512, despite them being redundant with each other after the
> > specified truncation to 128 bits.
> 
> Which is bogus in itself without proper security considerations, the
> only considerations cited is an RFC from 1997 ... clearly the pinnacle
> of cryptography advice ...
> 
> If they need a shorter hash they should make themselves a favor and use
> SHAKE and then define the desired output length and desired key size.
> That draft is just a disaster as written.
> 
> Specifically they should use KMAC128 as defined in NIST SP 800-185
> (which uses cSHAKE128 underneath).
> 
> Simo.

FWIW I left some feedback on the draft on on the tcpm mailing list
(https://mailarchive.ietf.org/arch/browse/tcpm/)

Another thing I should note is that the way TCP-AO uses HMAC-SHA1, it's
instantiated with an arbitrary-length key that might not contain full
entropy.  In contrast, the normal practice in cases like that is to do
an entropy extraction step first, e.g. see HKDF which has HKDF-Extract +
HKDF-Expand.

There's a chance this gets fixed in a future addition of HMAC-SHA256 or
whatever.  But in that case, the way the kernel happens to already
implement that algorithm (by assuming that it would be used in exactly
the same way as HMAC-SHA1) wouldn't match the eventual standard.

This is yet another reason why preemptively implementing "support" for
arbitrary algorithms wasn't a great choice...

 Eric
