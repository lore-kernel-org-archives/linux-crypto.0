Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE5C3B059A;
	Wed, 29 Jul 2026 14:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785337036; cv=none; b=NtSHp0uDN9q2FwQz99exbqTTaFQMcWTJX+5nqR8q6gfJqQ6OwSloNXUdByqcH7FCySHpPdVFpWRreTGofzmVTfLFpZlXhIPgEq8jetXXT9I5Q4JPA05vfEEc95kQDRqb2+p8h2njfd5y4qDfSUqE4iQMZH4qMYZtr4cBXg2+lUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785337036; c=relaxed/simple;
	bh=n7Elm20DLEpPPSgneHHWkKuMDsylzXLxtGnkdzQYqbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kFI5z2DBWygvond0vcXX++OLKyTVxt7u5FkZjjQWY6g3PndDJgtU3PWGf/M9n9XVGzrhY6ylkPuGPmW5ZFoJtpInU+9il703GDE1Ic+ewMluG1abweivGaN6tUjLzSOvSl9uMqh68YzVoc7ieg1w5d3Mw2zKBAnjPko1Q5OM6To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d9pZ74GY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d9pZ74GY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287D41F000E9;
	Wed, 29 Jul 2026 14:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785337035;
	bh=U6fguuMQvA/MfWZg3bKEs0LttFy2V+qGCa/r7RiorQI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d9pZ74GYFz+/wO7yEUYQUYA4eG563SinZFbj3AmpkDhau19ceInU2IR8UkDvWy0HZ
	 QabS27Ngd0NcrctZMeg1dFQTmkcaCOADDqUYCoQTv8Zg7FRmPh4Jha8g1R7ZG0s13S
	 DNLDXaurX4sYP2dY5tezpWvFsO9P6mIm3XOd8kB+3+Sdj/fFjp4+ldIC5Id9CRyZMb
	 ylpjn+DthbU2NQXMu1WNCFt1LwPxThL+BYlIDG3RMT+6v0OxDLFHzJjd+KdGyJYFhZ
	 ARRmFE6duFxV0922w97ZOm+o0mi0aFedUoelkCJmWQUipABA0nDGaMjkvZwJ6B355y
	 KSa4I4OljZakg==
Date: Wed, 29 Jul 2026 07:55:20 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Konrad Dybcio <konradybcio@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Bartosz Golaszewski <brgl@kernel.org>, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: Re: [PATCH] crypto: qce - Remove driver
Message-ID: <20260729145520.GA1702@sol>
References: <2026072412-decrease-sandbag-70a1@gregkh>
 <CAMRc=MeFoG0UXYOAqYhCiKBTs12EjX2-Bz4wDnbeYXmQA3-OaQ@mail.gmail.com>
 <20260724141414.GB1876@sol>
 <CAMRc=MfU1egvJwmgPEN-GXPbz8_JL2XnP-LV0T2+jG-drfXYwg@mail.gmail.com>
 <2026072455-subtly-prayer-0a8a@gregkh>
 <20260724150932.GA6763@sol>
 <2026072428-ungodly-outsource-b20c@gregkh>
 <20260724155144.GA2032@sol>
 <20260728152241.GA4281@quark>
 <15904301-fd03-45e5-b909-dfce52449726@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15904301-fd03-45e5-b909-dfce52449726@kernel.org>

On Wed, Jul 29, 2026 at 10:02:27AM +0200, Konrad Dybcio wrote:
> On 7/28/26 5:22 PM, Eric Biggers wrote:
> > On Fri, Jul 24, 2026 at 08:51:44AM -0700, Eric Biggers wrote:
> >> It is consuming a lot of the community's time to help maintain,
> >> including dealing with LLM-found bugs, with no clear benefit to anyone.
> >> Even considering *just today* we can see someone sent a bug fix:
> >> https://lore.kernel.org/linux-crypto/20260724081537.191992-2-thorsten.blum@linux.dev/
> > 
> > Another example:
> > https://lore.kernel.org/linux-crypto/d5de5a55-eb35-4ad5-8d53-12e188e156cb@oss.qualcomm.com/
> > 
> >> It definitely *was* causing problems before it was disabled via the
> >> crypto priority system (which made it unused in the kernel) and dropped
> >> it from AF_ALG (which removed most of the unprivileged attack surface).
> >> When anyone accidentally used it, it caused at least a huge performance
> >> problem, and sometimes other problems too like filesystem hangs.  It was
> >> an issue for years.
> > 
> > This actually seems to have been an overly-optimistic characterization!
> > As per
> > https://lore.kernel.org/linux-crypto/d5de5a55-eb35-4ad5-8d53-12e188e156cb@oss.qualcomm.com/
> > this driver drains the battery on every system with the module loaded,
> > even when no crypto requests are actually sent to it.
> 
> Unfortunately removing it drains way more battery, because the buses
> never hit sync_state and are kept at their maximum frequencies:
> 
> [   18.021823] qnoc-glymur interconnect-1: sync_state() pending due to 1dfa000.crypto
> [   18.029605] qnoc-glymur 16e0000.interconnect: sync_state() pending due to 1dfa000.crypto
> 
> (it transiently also pins DRAM and friends to max-freq which absolutely
> kills battery life)

Isn't that easily fixable by marking the node as "disabled" in the
device tree, or even just deleting it entirely?

- Eric
