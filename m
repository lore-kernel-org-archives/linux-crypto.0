Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D330282F25;
	Fri, 24 Jul 2026 15:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784908418; cv=none; b=UeOij8EA8NX67NNLDWEYW6ctNbMzWNqGtrMZ3mMpoGJwP09e4MvxMrgk8qRfMN9Qnj5sBEDrMujiXkCyYs2bj8WevVOqngbrtejzvZUjGTmzHrQXjxKySryRQxejt7uicuZJmK2ktOcDKzFUnYbIYESvHivdT3E+dYq2kRWhDTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784908418; c=relaxed/simple;
	bh=MpXbUV4lFgyWeBbyAsl2A8uBOIeasIflkGfpAfI6vb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gz9O3CIHEH1uYfXv46Irj/AlzaLgw0ClPhx5IcgPSHJUPIbLypzpvWX7e3raQ05M6Y5SMycl3fD5yjG36WmqqEMa17Uz3vPBvp87pKeomcMQcSoSDEHshaGcrfzOX07GCEbTuBKVUAzhL62QXofYsxvWXzJdwtKbe3+jJDE2yOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KDmoa1B+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KDmoa1B+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714891F000E9;
	Fri, 24 Jul 2026 15:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784908416;
	bh=2pkg/l0Fg6KNScIDEKDJlmLyaPEVAH54Yt5weFxUR+A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KDmoa1B+Gj6qoarRUqhbGgjYjd4YwbQOMHypVrttD5ZBcUzGoHr6EooKSSd6xFQoP
	 6s5yVuLB6QFB0fMpjUywcfAPXtTcEbnurC6PmYF3M7bofTN6DJaLHVuTgc4Qkw/mm+
	 9PrGDGSbYmxSjgqEp1UcLzhcusI74r/chB0aoU8Ldh5aXF8Zm+nysj3ruDV0GVV+m7
	 6LGj6EjygJNrNggV6LVwcTl9u1xH+FzluoIXOpvvTB/wsXDd1e4+XnQSB+sdbwGLvG
	 XiePFDIrbL5jIMwD6dVSXy46BWgvG13GxnyH0eAdMMyBQgs2IVO1W4lgQ6H6bjSnAa
	 ZavO9ULmYSLhw==
Date: Fri, 24 Jul 2026 08:51:44 -0700
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
Message-ID: <20260724155144.GA2032@sol>
References: <20260724050645.223799-1-ebiggers@kernel.org>
 <2026072410-drained-acts-3502@gregkh>
 <CAMRc=MdJTFokXLEbJMQW3V4FAMQid50Vx3fDB+CaNGUrzX-Pwg@mail.gmail.com>
 <2026072412-decrease-sandbag-70a1@gregkh>
 <CAMRc=MeFoG0UXYOAqYhCiKBTs12EjX2-Bz4wDnbeYXmQA3-OaQ@mail.gmail.com>
 <20260724141414.GB1876@sol>
 <CAMRc=MfU1egvJwmgPEN-GXPbz8_JL2XnP-LV0T2+jG-drfXYwg@mail.gmail.com>
 <2026072455-subtly-prayer-0a8a@gregkh>
 <20260724150932.GA6763@sol>
 <2026072428-ungodly-outsource-b20c@gregkh>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026072428-ungodly-outsource-b20c@gregkh>

On Fri, Jul 24, 2026 at 05:25:46PM +0200, Greg Kroah-Hartman wrote:
> On Fri, Jul 24, 2026 at 08:09:32AM -0700, Eric Biggers wrote:
> > On Fri, Jul 24, 2026 at 05:04:46PM +0200, Greg Kroah-Hartman wrote:
> > > On Fri, Jul 24, 2026 at 02:47:48PM +0000, Bartosz Golaszewski wrote:
> > > > On Fri, 24 Jul 2026 16:14:14 +0200, Eric Biggers <ebiggers@kernel.org> said:
> > > > >
> > > > > And with the defaults QCE is *never* used.
> > > > >
> > > > 
> > > > It's almost EOD here and I'm going to disconnect for the weekend but I just
> > > > wanted to say before I leave: this has never been a reason for an aggresive
> > > > removal of any driver. We remove drivers when we stop supporting entire
> > > > platforms, not mostly unused drivers on actively *supported* platforms where
> > > > they can still be used for experimentation and testing. I'm fine with dropping
> > > > this from arm64 defconfig but with fixes, the BROKEN tag should be removed
> > > > and I definitely object to removing it from the tree. How many people still
> > > > use greybus? Should we drop it from the kernel too? And I'm saying it as
> > > > a project ARA alumni. :)
> > > 
> > > I agree, if someone is willing to maintain it, and there are actual
> > > in-kernel uses of it (meaning not just a stand-alone library that can
> > > never be called either by userspace or hardware), it should stay.
> > 
> > What would we be considering the in-kernel uses to be, then?  Just
> > wiring it up to the framework is enough, regardless of actual use?
> 
> I was meaning that we just don't want to have code lying around that is
> impossible to use.
> 
> I'll defer to the subsystem maintainer if they want to remove it or not
> here, as that's their call, not mine.
> 
> But really, if someone wants to maintain it, no matter how slow it might
> be, I don't see the harm in keeping it if it's not causing any other
> problems.

It is consuming a lot of the community's time to help maintain,
including dealing with LLM-found bugs, with no clear benefit to anyone.
Even considering *just today* we can see someone sent a bug fix:
https://lore.kernel.org/linux-crypto/20260724081537.191992-2-thorsten.blum@linux.dev/

It definitely *was* causing problems before it was disabled via the
crypto priority system (which made it unused in the kernel) and dropped
it from AF_ALG (which removed most of the unprivileged attack surface).
When anyone accidentally used it, it caused at least a huge performance
problem, and sometimes other problems too like filesystem hangs.  It was
an issue for years.

If the justification for keeping it is that it is disabled anyway, then
I hope there's not going to be a contradictory push to enable it again.

I don't think we should keep crypto drivers around just for
"experimentation and testing".

- Eric
