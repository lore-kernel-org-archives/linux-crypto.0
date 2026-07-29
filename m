Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F6F382281;
	Wed, 29 Jul 2026 17:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785346718; cv=none; b=oQ7tDCEVLAf8pmJvpIn1TdbOWgU5nOAQFotqgm/DM41iq1zqNlYeEsxS1dBy9l1Ntx5aZXemEmQiTR1GlLqK+xtVz882cAYhrJyHoshcMHZNyn21vZMpqjsiHbYuWqjKs5KQ9z82T4aKFrGb/K5lhvhswnNugrXtshPdHBTPkTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785346718; c=relaxed/simple;
	bh=FA10+TJS4GmhE1ciZHYAohR+nudOYWInadsjiG68Xvg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pnaiQfsQr6A5b7NAQF5CTiAgZ8qP6y4xCGFK5mOMxT2858npdTzjEEBSe+hfZUSKGOYFFULIMNP9sycbQXdeoJIlLje069dE0RO7pItoxNPIvQL1lKUW8mPx3ZOGG1FOOhAyH6iz33xYoxkjD686q9N/LzbrJ30+dZ6fkmKLy40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WL1ksy9k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WL1ksy9k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB401F000E9;
	Wed, 29 Jul 2026 17:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785346711;
	bh=ovttOnJiDeqpmyIhx6sFDE+BfoHo1gmKUBQh2Vi1bb4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WL1ksy9k2ADLdlp4kAEC30y2vC66MEl7DPMkQPZ9mhjRebWbqd9+uLjPwZMjR75zo
	 oA3wqOubjgP6BS1tz8Gm55mMh/FS2WyGdWiRJ1Q5kjq2P6fps9oiN5iW3MKqk9SJXD
	 UARBLYBOeFDIryVgcHDRIYMFOvGahbXjgAh1FuUdda89ZW6GAchXekC3kzhGTLIDVI
	 Ez3U94KDtQ4VWFVAzvNQ3Alw96pJ57TLGB8SIIqAuWR5WCD12GIVkyiKnadm1sauBW
	 yp2Hp1ojIT5bJ0FarBl6CtCR5mC+aqrMws20zc4SUNmj71LlBRZx9gdcIuhF5MVg1D
	 Mur3cJwH1Bhgw==
Date: Wed, 29 Jul 2026 10:38:29 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] crypto: qce - Remove driver
Message-ID: <20260729173829.GB4454@quark>
References: <2026072412-decrease-sandbag-70a1@gregkh>
 <CAMRc=MeFoG0UXYOAqYhCiKBTs12EjX2-Bz4wDnbeYXmQA3-OaQ@mail.gmail.com>
 <20260724141414.GB1876@sol>
 <CAMRc=MfU1egvJwmgPEN-GXPbz8_JL2XnP-LV0T2+jG-drfXYwg@mail.gmail.com>
 <2026072455-subtly-prayer-0a8a@gregkh>
 <20260724150932.GA6763@sol>
 <2026072428-ungodly-outsource-b20c@gregkh>
 <20260724155144.GA2032@sol>
 <20260728152241.GA4281@quark>
 <CAMRc=Mch_3fFqq+khutEMQG3P-ojBE2dnLy_U2_gDV4e1ro6aA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMRc=Mch_3fFqq+khutEMQG3P-ojBE2dnLy_U2_gDV4e1ro6aA@mail.gmail.com>

On Wed, Jul 29, 2026 at 05:02:08AM -0700, Bartosz Golaszewski wrote:
> On Tue, 28 Jul 2026 17:22:41 +0200, Eric Biggers <ebiggers@kernel.org> said:
> > On Fri, Jul 24, 2026 at 08:51:44AM -0700, Eric Biggers wrote:
> >> It is consuming a lot of the community's time to help maintain,
> >> including dealing with LLM-found bugs, with no clear benefit to anyone.
> >> Even considering *just today* we can see someone sent a bug fix:
> >> https://lore.kernel.org/linux-crypto/20260724081537.191992-2-thorsten.blum@linux.dev/
> >
> > Another example:
> > https://lore.kernel.org/linux-crypto/d5de5a55-eb35-4ad5-8d53-12e188e156cb@oss.qualcomm.com/
> >
> Are you seriously complaining about people sending fixes to a driver we want
> to see fixed? We don't remove maintained drivers, this has been the kernel
> policy for years. Unfortunately if we want to fix it, then it'll take some
> work involving sending patches to the mailing list.

This again completely misses the point.  The point is that maintenance
is a community effort, and just because you have a M: entry (without a
git tree) doesn't mean it isn't taking time from other people too.

Now if it actually provided a benefit to users that generally would be
fine.  But in reality it just causes problems (with the possible
exception of the one point raised today where the driver is "needed" to
power off the hardware, though that part is broken too).

- Eric
