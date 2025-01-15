Received: from mail.manjaro.org (mail.manjaro.org [116.203.91.91])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA78157484;
	Wed, 15 Jan 2025 17:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.91.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736961709; cv=none; b=qEx6+620LnH6/a3j3BNBQeUc6rWR+O0RA/N4MZOGYKlktJpdl2IavEF6JvOcZXMuZLOQOrKx+dESljJZEpNclYSYhJDDK0Ts+krZz4ArznvMcUjlvJAe6IDJIUx4lpzOfG/1UFmFja5L+Hk7t0wyg9GhI1IcCG1svQlI//XT/Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736961709; c=relaxed/simple;
	bh=IJUwc4zso3QtUCW6kdMvNmN6FG6SVcRQWWAJ2D9jEog=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=rLmv5NM2Yh4H2HVSrK9fmMu+Fo1I181a0bT04EFTo5xioXx2k6NeAxhLg3lIosmRdqFZCo8lC+lpAwskxQrcq6CKNfG+ileAqmQWFRwhtDPDBcW7ODxVHPiwcqSX12eLmQevsyKihBfu6aXLV4ShEJi9eGEDm7N4sewn5Z0Y+mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org; spf=pass smtp.mailfrom=manjaro.org; dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b=LA8heUvq; arc=none smtp.client-ip=116.203.91.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manjaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b="LA8heUvq"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
	t=1736961704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WhM7IvapTmdAMz7yj3U0bztVvcJQwiBm2s3IZDhjWG4=;
	b=LA8heUvqT9PKJ8z6KFj4pj/kT1S1icirFOJFghEahCCoNgjjMODDRa4dzVkpQ+iTNCezSv
	cnyZ6mlpEvLU/jESzAQeK5yG8lAI3ARDqE8XTsNaodBiCBVBucNEbP0gBR+M4oUxgLsEKc
	w9t0i87VRvwnM/w7nV3tHr5uQk8Py9fdKhwTd5QH3vD9UX7PSwgM6zK7pBBmdtMj+jO9IY
	GTqlk0J0YEd9uAv5g3dIyEKDUsMUHx+TDx2xzRDRNXH2F0dweYgUmwQgjsuGgXOZykuFd1
	l4LMs8Q13hdOWmQSaymVGFEHWCZTb3cWaCERbhKcuIi9SFFuUhJ/Gy0GfXiyVw==
Date: Wed, 15 Jan 2025 18:21:42 +0100
From: Dragan Simic <dsimic@manjaro.org>
To: Diederik de Haas <didi.debian@cknow.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 olivia@selenic.com, herbert@gondor.apana.org.au, heiko@sntech.de
Subject: Re: [PATCH 3/3] hwrng: Don't default to HW_RANDOM when UML_RANDOM is
 the trigger
In-Reply-To: <D72QIRDR2M26.3R77PKFX7VWZ2@cknow.org>
References: <cover.1736946020.git.dsimic@manjaro.org>
 <3d3f93bd1f8b9629e48b9ad96099e33069a455c1.1736946020.git.dsimic@manjaro.org>
 <D72QIRDR2M26.3R77PKFX7VWZ2@cknow.org>
Message-ID: <78b97c27314bfa1c7f0f17a90e623821@manjaro.org>
X-Sender: dsimic@manjaro.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=dsimic@manjaro.org smtp.mailfrom=dsimic@manjaro.org

Hello Diederik,

On 2025-01-15 15:59, Diederik de Haas wrote:
> On Wed Jan 15, 2025 at 2:07 PM CET, Dragan Simic wrote:
>> Since the commit 72d3e093afae (um: random: Register random as 
>> hwrng-core
>> device), selecting the UML_RANDOM option may result in various 
>> HW_RANDOM_*
>> options becoming selected as well, which doesn't make much sense for 
>> UML
>> that obviously cannot use any of those HWRNG devices.
>> 
>> Let's have the HW_RANDOM_* options selected by default only when 
>> UML_RANDOM
>> actually isn't already selected.  With that in place, selecting 
>> UML_RANDOM
>> no longer "triggers" the selection of various HW_RANDOM_* options.
>> 
>> Fixes: 72d3e093afae (um: random: Register random as hwrng-core device)
>> Reported-by: Diederik de Haas <didi.debian@cknow.org>
>> Signed-off-by: Dragan Simic <dsimic@manjaro.org>
>> ---
>>  drivers/char/hw_random/Kconfig | 76 
>> +++++++++++++++++-----------------
>>  1 file changed, 38 insertions(+), 38 deletions(-)
>> 
>> diff --git a/drivers/char/hw_random/Kconfig 
>> b/drivers/char/hw_random/Kconfig
>> index e84c7f431840..283aba711af5 100644
>> --- a/drivers/char/hw_random/Kconfig
>> +++ b/drivers/char/hw_random/Kconfig
>> @@ -38,47 +38,47 @@ config HW_RANDOM_TIMERIOMEM
>>  config HW_RANDOM_INTEL
>>  	tristate "Intel HW Random Number Generator support"
>>  	depends on (X86 || COMPILE_TEST) && PCI
>> -	default HW_RANDOM
>> +	default HW_RANDOM if !UML_RANDOM
>>  	help
>>  	  This driver provides kernel-side support for the Random Number
>>  	  Generator hardware found on Intel i8xx-based motherboards.
>> 
>>  	  To compile this driver as a module, choose M here: the
>>  	  module will be called intel-rng.
>> 
>>  	  If unsure, say Y.
>> 
>>  config HW_RANDOM_AMD
>>  	tristate "AMD HW Random Number Generator support"
>>  	depends on (X86 || COMPILE_TEST)
>>  	depends on PCI && HAS_IOPORT_MAP
>> -	default HW_RANDOM
>> +	default HW_RANDOM if !UML_RANDOM
>>  	help
>>  	  This driver provides kernel-side support for the Random Number
>>  	  Generator hardware found on AMD 76x-based motherboards.
>> 
>>  	  To compile this driver as a module, choose M here: the
>>  	  module will be called amd-rng.
>> 
>>  	  If unsure, say Y.
>> 
>>  config HW_RANDOM_AIROHA
>> ...
>> @@ -603,7 +603,7 @@ config HW_RANDOM_ROCKCHIP
>>  	tristate "Rockchip True Random Number Generator"
>>  	depends on HW_RANDOM && (ARCH_ROCKCHIP || COMPILE_TEST)
>>  	depends on HAS_IOMEM
>> -	default HW_RANDOM
>> +	default HW_RANDOM if !UML_RANDOM
>>  	help
>>  	  This driver provides kernel-side support for the True Random 
>> Number
>>  	  Generator hardware found on some Rockchip SoC like RK3566 or 
>> RK3568.
> 
> Context:
> I wanted to enable the HW_RANDOM_ROCKCHIP module in the Debian kernel
> so I send a MR to enable it as module. One of the reviewers remarked
> that this would *change* the module config from ``=y`` to ``=m`` as
> ``HW_RANDOM`` is configured ``=y`` due to Debian bug #1041007 [1].
> IOW: if you don't say you want a HWRNG module, it will be built-in to
> the Debian kernel, while Debian normally uses ``=m`` if possible.
> 
> So that's when I realized almost all modules have ``default HW_RANDOM``
> and then found that UML_RANDOM selects HW_RANDOM which in turn would
> enable (almost) all HWRNG modules unless you specify otherwise.
> It's actually the depends which would mostly 'prevent' that.
> This to me looks excessive, discussed the problem with Dragan which
> resulted in this patch set.

Thanks a lot for providing a detailed description of the series
of events that have led to this patch!

> But why not just remove (most of) the ``default HW_RANDOM`` lines
> whereby a HWRNG module thus becomes opt-in instead of opt-out?
> 
> For ``HW_RANDOM_ROCKCHIP`` it's for the SoC found in *only* the rk3566
> and rk3568 SoCs, but none of the others, and it's (currently) effective
> only on rk3568 based devices (due to deliberate DT config).
> In the help text of other modules I see mention of specific (series of)
> motherboards, so also there it may not be useful for all.

Removing the defaults from the Kconfig would be a much better
solution, but I'm afraid it would actually be quite disruptive,
requiring changes to various kernel configurations.

> I did a partial ``git blame`` to get an idea as to why those defaults
> were there and found the following:
> 
> fed806f4072b ("[PATCH] allow hwrandom core to be a module")
> from 2006-12-06 with the goal to have them modular
> 
> 2d9cab5194c8 ("hwrng: Fix a few driver dependencies and defaults")
> from 2014-04-08 which added several ... for consistency sake
> 
> e53ca8efcc5e ("hwrng: airoha - add support for Airoha EN7581 TRNG")
> from 2024-10-17 with no explicit mention why it was done, so that was
> most likely as that was used elsewhere (thus consistency)
> 
> So while this patch does prevent accidental enablement due to 
> UML_RANDOM
> enablement, it does seem to me to be needlessly complex and making it
> opt-in, which was the assumption of my MR to begin with, much simpler.
> 
> I can be missing other considerations why the current solution would be
> better, but I figured I'd mention my perspective.

The only upside of the current solution is that it represents
the least disruptive approach.

I'd suggest that this patch is kept as-is, and I'd add another
patch on top of it, which would remove the defaults from the
Kconfig and update the relevant default configs, of course if
the maintainers are fine with such an approach, and if there
is general agreement toward getting rid of the defaults.

Having two patches, as proposed above, would make the bisecting
later much easier, in case some unforeseen issues are discovered
in the future.

> [1] https://bugs.debian.org/1041007
