Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3953290AA;
	Fri, 24 Jul 2026 15:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784906758; cv=none; b=dUdCcQuqvHU3ihge/tXvbpmqfBEmKvgWEAbJ9nvOfdr/R/BSHg6XtOm7GEnRZLiG78KMdpwMu+hJE/+wSyL8+slB25CRiDYF1d4s7oG754Nt1q5URddpJ+8OnJjiPnJjAydO59EYk1KFPj+QjudAImPvt/tUudEeeNGYRxLs2Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784906758; c=relaxed/simple;
	bh=7yZKyCif7bwvKXOUHYrSOh5ClhNufKPIqxBhPxQ2hrc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ypa1efQvLqnkF3NB47p5rYAX77h6BbpSnwQFcBkgbI0N3DXakN4I0cCWZY9ixyP2DJwYvPCTQzRchC1wbTwZJEJXleHKNL058c+DhgXiqQBPjbuFDx9GO9Gpy8adUb92jyygKVhk6bqX5P8zPqvGHgFbMPz7YQjHSN7lqOzY1CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PhBbKBp2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PhBbKBp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36621F00A3D;
	Fri, 24 Jul 2026 15:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784906757;
	bh=MMI8dp4d8PY6sATbYk9KDFOebbCxDBHOK1s8U533Alo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PhBbKBp2MjpNeojbrYeoPnv2MHKD1gIjmgzezQSDBWY8ZJmyUBzA4vzXLTYBd8h3J
	 t49APow/SP+0ho4zhhuDPQRefq06heR6IDK6XNtf8Cf21NQCE0V9oE+CAHQVIcovz1
	 SYBFzLl/Hq38+HRG3i0jNDcdxHSKQc7LB6Fq5J4A=
Date: Fri, 24 Jul 2026 17:25:46 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Bartosz Golaszewski <brgl@kernel.org>, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: Re: [PATCH] crypto: qce - Remove driver
Message-ID: <2026072428-ungodly-outsource-b20c@gregkh>
References: <20260724050645.223799-1-ebiggers@kernel.org>
 <2026072410-drained-acts-3502@gregkh>
 <CAMRc=MdJTFokXLEbJMQW3V4FAMQid50Vx3fDB+CaNGUrzX-Pwg@mail.gmail.com>
 <2026072412-decrease-sandbag-70a1@gregkh>
 <CAMRc=MeFoG0UXYOAqYhCiKBTs12EjX2-Bz4wDnbeYXmQA3-OaQ@mail.gmail.com>
 <20260724141414.GB1876@sol>
 <CAMRc=MfU1egvJwmgPEN-GXPbz8_JL2XnP-LV0T2+jG-drfXYwg@mail.gmail.com>
 <2026072455-subtly-prayer-0a8a@gregkh>
 <20260724150932.GA6763@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724150932.GA6763@sol>

On Fri, Jul 24, 2026 at 08:09:32AM -0700, Eric Biggers wrote:
> On Fri, Jul 24, 2026 at 05:04:46PM +0200, Greg Kroah-Hartman wrote:
> > On Fri, Jul 24, 2026 at 02:47:48PM +0000, Bartosz Golaszewski wrote:
> > > On Fri, 24 Jul 2026 16:14:14 +0200, Eric Biggers <ebiggers@kernel.org> said:
> > > >
> > > > And with the defaults QCE is *never* used.
> > > >
> > > 
> > > It's almost EOD here and I'm going to disconnect for the weekend but I just
> > > wanted to say before I leave: this has never been a reason for an aggresive
> > > removal of any driver. We remove drivers when we stop supporting entire
> > > platforms, not mostly unused drivers on actively *supported* platforms where
> > > they can still be used for experimentation and testing. I'm fine with dropping
> > > this from arm64 defconfig but with fixes, the BROKEN tag should be removed
> > > and I definitely object to removing it from the tree. How many people still
> > > use greybus? Should we drop it from the kernel too? And I'm saying it as
> > > a project ARA alumni. :)
> > 
> > I agree, if someone is willing to maintain it, and there are actual
> > in-kernel uses of it (meaning not just a stand-alone library that can
> > never be called either by userspace or hardware), it should stay.
> 
> What would we be considering the in-kernel uses to be, then?  Just
> wiring it up to the framework is enough, regardless of actual use?

I was meaning that we just don't want to have code lying around that is
impossible to use.

I'll defer to the subsystem maintainer if they want to remove it or not
here, as that's their call, not mine.

But really, if someone wants to maintain it, no matter how slow it might
be, I don't see the harm in keeping it if it's not causing any other
problems.

thanks,

greg k-h
