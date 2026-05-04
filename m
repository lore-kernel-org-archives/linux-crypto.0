Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5AA3E2756;
	Mon,  4 May 2026 19:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777924563; cv=none; b=ZAWzHw/VFYghb6slBFDY62G9Xxxzx4dMNqTZ/xbajTmc5uJ6xL1WG8p9qM5d3Tsj5wmmv5G+ASw2gAxjUVHLd8ZFBQftAT7381flxhSnN9NbpaQVDwDcc+53v/FapDcRtQNg9UbrdNdLbkdOmpwvMcj0DoUu619KHYlTUwRCMkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777924563; c=relaxed/simple;
	bh=KAIc5EEE66Y5PElW0pgVZFHgaNMi3+FHADgvWMfKdWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=So0x1H2UrIxAcdm3LAOvTsMzVKzY5EYyrVEKNbZjl9RuijsP5gD4QOQxWBTHN6g+sKiUQlzZYzabgry/Ozb/LS1eDjKrK7IzLwk78AvffzgW/TLiShgVW0Bnbjj7/BuZz9jmtLvCb83HwZdS/GlH+6QRBLfDZFk7bA7WHiqrMwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OcgTRtRl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OcgTRtRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85ABC2BCB9;
	Mon,  4 May 2026 19:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777924563;
	bh=KAIc5EEE66Y5PElW0pgVZFHgaNMi3+FHADgvWMfKdWU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OcgTRtRlZZDEspyTg1Onu12LgbBDru4rV+9ZJ1s7aIFypiqMCjMUxrvuYOJBRs0zq
	 wDyKe0kQQotJY8S0F6cubNA8ESfzFqpxRFCygz9UIUMzvIxNskzqo/wKShdeaBsTX1
	 UCERCF9XIhqxG07/WGYM+A0nGm2WSekP3wXDtTmu+wZH9D3eNwr8yvJps9Y70mhmky
	 33U2c9EXqRcoZF7a5GZL6S7/oE5vsAQSN+ko+1eOe3iAEKlr60q/xSSgRil0PYFVDd
	 LdXciDPZcKMiLoxfIQIh0uyUN6IqH/KVt28RTLwFtGt3nqHTi/lVireNamWSUfInr+
	 QCAcPdaXRNWsg==
Date: Mon, 4 May 2026 12:54:43 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Simon Richter <Simon.Richter@hogyros.de>
Cc: Demi Marie Obenour <demiobenour@gmail.com>,
	Jan Schaumann <jschauma@netmeister.org>, iwd@lists.linux.dev,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: AF_ALG hardening
Message-ID: <20260504195443.GA12424@sol>
References: <20260430071917.GB54208@sol>
 <177abb5d-8ba9-4bb9-8b23-9fbc868ed3cd@gmail.com>
 <20260501180028.GA2260@sol>
 <19837ef5-e5b6-45f4-8336-3ce07423dfb1@gmail.com>
 <20260501201841.GA2540@quark>
 <c13dd3c5-ddc1-431e-bc7d-2de39c551f8e@gmail.com>
 <20260502033556.GA3872267@google.com>
 <3cc88b2d-fbd6-4e47-b82c-3c685fec0581@gmail.com>
 <20260502191618.GA229884@google.com>
 <f3203014-9e0b-45a6-b031-5b7487e82ff2@hogyros.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3203014-9e0b-45a6-b031-5b7487e82ff2@hogyros.de>

On Tue, May 05, 2026 at 04:01:47AM +0900, Simon Richter wrote:
> Hi,
> 
> On 5/3/26 04:16, Eric Biggers wrote:
> 
> > On Sat, May 02, 2026 at 12:52:57AM -0400, Demi Marie Obenour wrote:
> 
> > > The simplest changes I can see are:
> 
> > > 1. Get rid of zero-copy support (splice()).
> > > 2. Get rid of AIO support.
> > > 3. Only allow software implementations.
> 
> > For (2) and (3), you can find examples of disabling asynchronous crypto
> 
> I think we need to make up our minds here.
> 
> This thread is about removing asynchronous implementations and accelerator
> support from AF_ALG, so it can support legacy applications with known-good
> implementations, while the other thread[1] is about removing everything
> *but* accelerator support from AF_ALG -- and as accelerators are typically
> asynchronous, this aspect has to stay as well.
> 

Thread [1] is a patch that removes the kernel's last
architecture-optimized implementation of MD5, which is a broken and
deprecated algorithm anyway.  So it's not just AF_ALG that's motivating
that particular patch, but also a desire to focus effort on modern
algorithms and keep the different Linux architectures consistent.  So I
think the scope of that thread is more narrow than what you're claiming.

Also, it's already been established that for now AF_ALG will have to
keep the software code used by a small set of userspace programs such as
iwd.  So no, it cannot be completely removed yet (except on systems that
don't use any of these programs, where it can be already).  However,
that doesn't mean that we shouldn't be nudging people towards better
solutions, with an eye towards future attack surface reductions.

> At least with the opposite proposals, it would be good to know which one is
> official policy.
> 
> At the same time, the third thread[2] deprecates AF_ALG because of its wonky
> security posture, while newer accelerators are implementing their own
> userspace interfaces because AF_ALG is too limited, so we're already
> replacing one CVE magnet with several independent ones, and deprecating
> AF_ALG means that future drivers will add even more of those because there
> is no longer a common framework to attach to.

It's long been clear that by far the best way to accelerate symmetric
crypto is to just put it in the CPU, or in-line in the storage or
network controller.  Indeed, that's what almost everyone does now.

So I would expect the demand for this kind of interface to symmetric
crypto to continue to decline, as it already has been for a long time.
And as you pointed out, AF_ALG doesn't work well for it anyway, which
makes AF_ALG increasingly kind of besides the point.

> Also, if AF_ALG is deprecated and the kernel no longer uses
> ahash/acrypt/acomp internally, there is no point in accelerator cards even
> registering with the crypto subsystem. Should that be an explicit policy
> "accelerator cards are outside the scope of the crypto subsystem, even if
> they implement a cryptographic algorithm"?

There are still some in-kernel users of the asynchronous crypto APIs,
for example IPsec and dm-crypt.  So I think your prediction of the
demise of these APIs is a bit premature as well.  But yes, at least for
the symmetric crypto, kernel subsystems have been been repeatedly seeing
that the async support just isn't worth it.  We'll see more kernel
subsystems switching to sync-only.  But in practice this is a gradual
transition.

Anyway, I don't think I'm proposing conflicting things.  We can and
should document a general deprecation of AF_ALG, while also helping
update userspace programs to no longer use it, while also applying
various hardening measures to reduce AF_ALG's attack surface as best we
can in the meantime.  There are multiple independent hardening measures
that could be applied, and they will be up for discussion on the
individual patches that implement them.

- Eric
