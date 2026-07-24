Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C90342514;
	Fri, 24 Jul 2026 15:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784905498; cv=none; b=rKuRlBHDcI7M/dBmD0aTPIB097/LgugxPFr8+8v4gMK9oUu0AP5CcuFJf5JZkDynrTMJ0esMGmCFMjldwtkFZ//y1wMjQJDFKXWn12Z5KKG6nG25f6tTVWSCkSO+fpyRkREHHpzQROsnV8v27DfbMEjCPqG9QNiMn3eiozJKR+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784905498; c=relaxed/simple;
	bh=AEC4KivREAy1374yFdIkDUWeUVyucIoFZRIdKedXkM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OqolP1qd07lXs9Kb5XV75FTkxiSdHTbdy4R/6VVJ/SRMPWHeulMrXWlq2D8/C+M7mLhLvruwskhnQny1FOv6bRxS5m7B577Us6EeN32S9PYpJdTS6c2XxiVGRYIWf8v7HUEk0weDbRpYBMGx+R1iNyYsjf+474RWnXvog5LTzOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BAk4wQ+/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BAk4wQ+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9031F000E9;
	Fri, 24 Jul 2026 15:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784905497;
	bh=J20cEnp8PovEA/g12VR916ZnfHt50GcHPHMTtaTEiVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BAk4wQ+/Wa6HGA5fWaRxaMM4erqhLgYbfehDK/3pX/9VFTbUAT0LmZV0FOCA7WAUW
	 lXh3hVmb6hP/EwvEs8l8FF4/1f0OEdvvhfGp/nqgBuD/biTEwc/KzeIbwO0Y5sh6sY
	 1qCUaFBnq6Tgf0xoqRlO/qc77rUF64i7CDr3kXIQ=
Date: Fri, 24 Jul 2026 17:04:46 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: Re: [PATCH] crypto: qce - Remove driver
Message-ID: <2026072455-subtly-prayer-0a8a@gregkh>
References: <20260724050645.223799-1-ebiggers@kernel.org>
 <2026072410-drained-acts-3502@gregkh>
 <CAMRc=MdJTFokXLEbJMQW3V4FAMQid50Vx3fDB+CaNGUrzX-Pwg@mail.gmail.com>
 <2026072412-decrease-sandbag-70a1@gregkh>
 <CAMRc=MeFoG0UXYOAqYhCiKBTs12EjX2-Bz4wDnbeYXmQA3-OaQ@mail.gmail.com>
 <20260724141414.GB1876@sol>
 <CAMRc=MfU1egvJwmgPEN-GXPbz8_JL2XnP-LV0T2+jG-drfXYwg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMRc=MfU1egvJwmgPEN-GXPbz8_JL2XnP-LV0T2+jG-drfXYwg@mail.gmail.com>

On Fri, Jul 24, 2026 at 02:47:48PM +0000, Bartosz Golaszewski wrote:
> On Fri, 24 Jul 2026 16:14:14 +0200, Eric Biggers <ebiggers@kernel.org> said:
> >
> > And with the defaults QCE is *never* used.
> >
> 
> It's almost EOD here and I'm going to disconnect for the weekend but I just
> wanted to say before I leave: this has never been a reason for an aggresive
> removal of any driver. We remove drivers when we stop supporting entire
> platforms, not mostly unused drivers on actively *supported* platforms where
> they can still be used for experimentation and testing. I'm fine with dropping
> this from arm64 defconfig but with fixes, the BROKEN tag should be removed
> and I definitely object to removing it from the tree. How many people still
> use greybus? Should we drop it from the kernel too? And I'm saying it as
> a project ARA alumni. :)

I agree, if someone is willing to maintain it, and there are actual
in-kernel uses of it (meaning not just a stand-alone library that can
never be called either by userspace or hardware), it should stay.

thanks,

greg k-h
