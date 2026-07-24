Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5670A36164D;
	Fri, 24 Jul 2026 15:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784905886; cv=none; b=QYGY91M5BFJ0cWOyw3k4dMNuSQzj1r+ofpELIdW5DE95RcBaZeRFaiNRwC6tIYvFr8tDBEtTQzShP6KXyONcFOkjALeA1YV0+3Ft8ELueDtqyQRfHe0DezvdTFdQwRcbv4Hgs1SJnSuI7iQ3eWT/uwfKpt5PB6uJ6zrLp/oECsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784905886; c=relaxed/simple;
	bh=qKU4GW/+b0QewGx2kYZ6Ay90WNbMY48rNwsLNKk/lL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NTUmvyn0mdlWiijNqGh5oyKfthsuGPl6TNQt9bROPtnAYLNEcWEubvnYnurPJgaZvNEebMYcruHldv4iCkPaM+nJnGTmtbv6jHnmNvHUW+OsTBjWV/cWnYI9kcvE0r5PLZ8aG9xtV+dedj4chQDKGE1CSsu9kzQ7GLfTySMD8iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aKhfvHI6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aKhfvHI6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777591F000E9;
	Fri, 24 Jul 2026 15:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784905883;
	bh=uuUNKxqY+LG3qQIlLd9qfr9KhKPVbYZ6sV4UqffU++M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aKhfvHI6bLFKFB7z6X+qsS4QCJnBrahaBRx3Q/JMuLtPQG+QZ82AtxdGJOSLjb6+P
	 hZuxyfmpixjWi7OE8NnL1tGUa6DudXfIQcogi+bjXFosj5udX2QSa+0E3fRZ5drm63
	 4ZKF57Cqj4rJIIWBdADeDjPOO7h0uUKLR2z2T1lKkZPliw+GRU4JKdSrAH+sABAIsR
	 xwT64UfzODvP53K1U8a6BooGb1uYn+C8+BbeqvQNhTon/oNb/P0TnwDR9kCqzrRZYz
	 QOtPqW6bQ/OLf8qMXXg/CMtpC4kw7fGsk7m1uu4u8lzIBHS9nEmY91V1v1lFfYBdMW
	 6zXqy4qAEz1ew==
Date: Fri, 24 Jul 2026 08:09:32 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bartosz Golaszewski <brgl@kernel.org>, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: Re: [PATCH] crypto: qce - Remove driver
Message-ID: <20260724150932.GA6763@sol>
References: <20260724050645.223799-1-ebiggers@kernel.org>
 <2026072410-drained-acts-3502@gregkh>
 <CAMRc=MdJTFokXLEbJMQW3V4FAMQid50Vx3fDB+CaNGUrzX-Pwg@mail.gmail.com>
 <2026072412-decrease-sandbag-70a1@gregkh>
 <CAMRc=MeFoG0UXYOAqYhCiKBTs12EjX2-Bz4wDnbeYXmQA3-OaQ@mail.gmail.com>
 <20260724141414.GB1876@sol>
 <CAMRc=MfU1egvJwmgPEN-GXPbz8_JL2XnP-LV0T2+jG-drfXYwg@mail.gmail.com>
 <2026072455-subtly-prayer-0a8a@gregkh>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026072455-subtly-prayer-0a8a@gregkh>

On Fri, Jul 24, 2026 at 05:04:46PM +0200, Greg Kroah-Hartman wrote:
> On Fri, Jul 24, 2026 at 02:47:48PM +0000, Bartosz Golaszewski wrote:
> > On Fri, 24 Jul 2026 16:14:14 +0200, Eric Biggers <ebiggers@kernel.org> said:
> > >
> > > And with the defaults QCE is *never* used.
> > >
> > 
> > It's almost EOD here and I'm going to disconnect for the weekend but I just
> > wanted to say before I leave: this has never been a reason for an aggresive
> > removal of any driver. We remove drivers when we stop supporting entire
> > platforms, not mostly unused drivers on actively *supported* platforms where
> > they can still be used for experimentation and testing. I'm fine with dropping
> > this from arm64 defconfig but with fixes, the BROKEN tag should be removed
> > and I definitely object to removing it from the tree. How many people still
> > use greybus? Should we drop it from the kernel too? And I'm saying it as
> > a project ARA alumni. :)
> 
> I agree, if someone is willing to maintain it, and there are actual
> in-kernel uses of it (meaning not just a stand-alone library that can
> never be called either by userspace or hardware), it should stay.

What would we be considering the in-kernel uses to be, then?  Just
wiring it up to the framework is enough, regardless of actual use?

- Eric
