Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0165634A3BF;
	Tue, 11 Aug 2026 10:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786445641; cv=none; b=CVwTGh7moXcWcIrmbNC89gJFsE3jWxAGJYUKnAfEBhpabciuKoeReSVwR3HSnfw6QbeANXJdN9XC5OHQeQgLIeM8LKJLsjbMluNGimggtknJYsGoP2dqWT4d2CGo+OwS1mYDCQNbytn3KQ0gdUPucY8FLrNR9vZPvYLsts92woU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786445641; c=relaxed/simple;
	bh=Jfp/Nd+41qkFAW+YNp0hXQOIWAf/BDIR8Y2UrrdZjvA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TmaqvIR0VL4bmLUHOcObZJwsHEPYPqDESw0k4S1W0K5NDY3IwanL6VX6eRjvZDTwByc4g+0G03umqXjOfK5ZCNzqXlGpICrram/Petj0jW/tcJ7Sju61hPqf3Fb1sj7a2thFQ6sVUlj235Ssr6EjsYtD78SWYY25UNXZU0vCpt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QmtW2b55; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QmtW2b55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5151F000E9;
	Tue, 11 Aug 2026 10:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786445639;
	bh=p84j6vNUdfWQLML+rVOLy0aQPHO9hPxgm9Ft4y7d8Bg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QmtW2b55hgO29VKv2qGxjfcfyioIEezWf3Megxtpk4um+hNPQq6DJFl9r+8N8IgHy
	 qPvYPBNkg10jIoVMaoi/pus4HFohFKEy9sWGXqY/zjh5GFVCrRBQBTlKo17ZbvPwY3
	 YFOiA2w/9TVK1IGzdsqU9Zz0ulb7kAAJC3BH35uAaaczo2be21Ao6cMKSTrkwc09kT
	 AzihCcy6L9QmzxwWk4L+sRF5XVjXQ6cVRbrLhnk4qw31p8g5FE5+u1nJlaXDJGKcZj
	 bm4Pr7CA/VqmN91Jw9VvY5ClXD1L+h9pNQOUT2loGes9jn/puoReglt/iOsHmdW0+r
	 NLXJFrtqM+OlQ==
Date: Tue, 11 Aug 2026 11:53:54 +0100
From: Daniel Thompson <danielt@kernel.org>
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Linus Walleij <linusw@kernel.org>, linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] hwrng: stm32: fix usage_count leak when
 autosuspend_delay is negative
Message-ID: <anr_Qu1GncWBDwCf@aspen.lan>
References: <20260811063442.3058074-1-lgs201920130244@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811063442.3058074-1-lgs201920130244@gmail.com>

On Tue, Aug 11, 2026 at 02:34:42PM +0800, Guangshuo Li wrote:
> stm32_rng_probe() calls pm_runtime_use_autosuspend(), but runtime PM is
> enabled with pm_runtime_enable() and the matching
> pm_runtime_dont_use_autosuspend() is not called on driver teardown.
>
> If the autosuspend delay is set to a negative value while autosuspend
> is enabled, the runtime PM core increments usage_count to prevent
> runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
> during teardown, this reference is not dropped and usage_count remains
> unbalanced.
>
> Use devm_pm_runtime_enable() so that pm_runtime_dont_use_autosuspend()
> and pm_runtime_disable() are automatically called on probe failure and
> driver teardown. With runtime PM cleanup handled by devres,
> stm32_rng_remove() is no longer needed.
>
> This issue was found by manual code inspection.
>
> Fixes: c6a97c42e399 ("hwrng: stm32 - add support for STM32 HW RNG")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
> v2:
>   - Replace pm_runtime_enable() with devm_pm_runtime_enable() to handle
>     runtime PM cleanup through devres.
>   - Remove stm32_rng_remove() and the manual cleanup on the probe failure
>     path.

devres changes look great!

Reviewed-by: Daniel Thompson (RISCstar) <danielt@kernel.org>


Daniel.
