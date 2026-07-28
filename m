Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECA9306754;
	Tue, 28 Jul 2026 15:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785252164; cv=none; b=cwr9AjEJws/prwrxi7btH8B2NnkqGrQqIdWXii16zgJUwGEijomz4cxryqdFEPJ8Q3HL+2k+SW43pgK2D2CTaSULVkOb7URsmGTsf9VR5ceU+ZjQ7IjFOY8yAJVl9jOqeNQqn+STagNdC4oeLYr4oTWAmmMq1aNp7o0moY2IOOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785252164; c=relaxed/simple;
	bh=AIcL2a6ir0ncVu9m2CvMw7boRAZ9HBY4FtgW1it0Hk4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rXqQ5OCNXiuF6mZJ0qsFX+DdT7bH2oFdl3R/L8K+bm+raTLO+725hCVuogYGJdbB+5SJV3+PiRS8F3ZN97ZyvD6dMcd62Jgz7d+C6Eff2NAw5m1nVelfOZ+KxxIkngBvqdS2tthQDhhI1erZPkBbO7cb6wRfVTV5o+G0XfD2xYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dWB0j1zS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dWB0j1zS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A752B1F000E9;
	Tue, 28 Jul 2026 15:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785252163;
	bh=yKw7caf9g11sYWC9aIB1I05YdyImrElt0NfZF3BzFj8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dWB0j1zSVg8/OAqbDrwzmbMbz6lsH8A9/amYwRkbuphjXxwQqtaMF4YjUMbb96OBX
	 HrINd4z3xSGqzQL49Am1SiSjc/aSOWtGY6AJUcDB5EwYsRs6yDMctV3jcwVHM1z/sT
	 rnqS2HuTC5aOnNbR4735yPignpu+eottmQuRLweUO9xuptjqsePGTWXUsjs0PNAXnY
	 a4XQHgqU53/MzKyJI5yvkUI5ipa+mWSq8lgeoE23r+yWx+ux+BA70KsuTMr4ZqcWSs
	 oAyYEvhgnmk33llNIcSl2mOtRHfXEPS5ftdNT+sXiJqk6rxL839bmzzxaIybPoOu4x
	 +wrjQ+udy27qw==
Date: Tue, 28 Jul 2026 08:22:41 -0700
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
Message-ID: <20260728152241.GA4281@quark>
References: <2026072410-drained-acts-3502@gregkh>
 <CAMRc=MdJTFokXLEbJMQW3V4FAMQid50Vx3fDB+CaNGUrzX-Pwg@mail.gmail.com>
 <2026072412-decrease-sandbag-70a1@gregkh>
 <CAMRc=MeFoG0UXYOAqYhCiKBTs12EjX2-Bz4wDnbeYXmQA3-OaQ@mail.gmail.com>
 <20260724141414.GB1876@sol>
 <CAMRc=MfU1egvJwmgPEN-GXPbz8_JL2XnP-LV0T2+jG-drfXYwg@mail.gmail.com>
 <2026072455-subtly-prayer-0a8a@gregkh>
 <20260724150932.GA6763@sol>
 <2026072428-ungodly-outsource-b20c@gregkh>
 <20260724155144.GA2032@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724155144.GA2032@sol>

On Fri, Jul 24, 2026 at 08:51:44AM -0700, Eric Biggers wrote:
> It is consuming a lot of the community's time to help maintain,
> including dealing with LLM-found bugs, with no clear benefit to anyone.
> Even considering *just today* we can see someone sent a bug fix:
> https://lore.kernel.org/linux-crypto/20260724081537.191992-2-thorsten.blum@linux.dev/

Another example:
https://lore.kernel.org/linux-crypto/d5de5a55-eb35-4ad5-8d53-12e188e156cb@oss.qualcomm.com/

> It definitely *was* causing problems before it was disabled via the
> crypto priority system (which made it unused in the kernel) and dropped
> it from AF_ALG (which removed most of the unprivileged attack surface).
> When anyone accidentally used it, it caused at least a huge performance
> problem, and sometimes other problems too like filesystem hangs.  It was
> an issue for years.

This actually seems to have been an overly-optimistic characterization!
As per
https://lore.kernel.org/linux-crypto/d5de5a55-eb35-4ad5-8d53-12e188e156cb@oss.qualcomm.com/
this driver drains the battery on every system with the module loaded,
even when no crypto requests are actually sent to it.

- Eric
