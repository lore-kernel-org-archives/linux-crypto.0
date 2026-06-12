Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B654E33F8D4;
	Fri, 12 Jun 2026 01:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781229532; cv=none; b=sXygZ8lqI4rBs3LnbweNbpDbqkNC+ncE//d0vCJDL12xjHuCMBVo6hMpN007cH9CfieuKOfIy/Okhq8J7Q9zaS9QlDOHMA4OEDZXOdNLn+LCBuA8FtG974JsiVFmZuPA8SaRO4hbguXI27X5+ZrTMTMk4zTMevGHYr0z1BtD4oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781229532; c=relaxed/simple;
	bh=rUFsyyiIFR/J/Q53eLpa8N9wKQTpR0W/M2FbfgGdYsA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aiWo1S9g/aVtnK3OQMZiFCe7kcJwGgwgmd0wUiw+dmku8VfvTb3F2+z7bATbbzyciSGZrKlrN9iCVO4Xo5HTJMTuJdTLImWzX1lHAqb8fk/7rh7vPJTH096i/d90zHDAy3hbV9XAsfG0wLx0mjxhCueJp01aj4OqV5sH8zETf1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=pOLn7EKJ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="pOLn7EKJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=NnN6UHZy9R4p3IMdheElLYZmIksWWOtLpEfuDmsxZRU=; 
	b=pOLn7EKJHStcwWNuifLZbdBAWCwzvuPPN/vPB8Zp4Pu8aFBSMYgoubkxIzlIroh1hVw8j8A+qsU
	8suFeL5toZq3pOD3kQVls5dwyxls0pkGeyuT3aY8uqjwIgFk+/vJWOQp1MJtE5g+TNc6YisfRoBBI
	Un7PHCUFM6Zwww4V0ieFEYigDpQL2Nwoqk2wewN0TCv3nRtJroo5M31HvobrBrjDR2ZNMjkz2xiDo
	/y/GGxvgjjuTXb2Dfb0NmVVpM+nOX/u24EVpnwvyB/0cStH0vs/jvTt/za6xiG0yIcAOa5JfeWcV+
	eSwE+2HEnN7UPh/QhgMpHmIaaHBOem8FPwDw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wXrAJ-00000004ljD-1R4u;
	Fri, 12 Jun 2026 09:58:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 12 Jun 2026 09:58:35 +0800
Date: Fri, 12 Jun 2026 09:58:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mounika Botcha <mounika.botcha@amd.com>,
	Harsh Jain <h.jain@amd.com>, Olivia Mackall <olivia@selenic.com>,
	Michal Simek <michal.simek@amd.com>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] Xilinx TRNG fix and simplification
Message-ID: <aitnyyvnfU2ysMYj@gondor.apana.org.au>
References: <20260531191738.55843-1-ebiggers@kernel.org>
 <aip2l1pwMY4UDBdA@gondor.apana.org.au>
 <20260611204702.GB1747@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611204702.GB1747@quark>

On Thu, Jun 11, 2026 at 01:47:02PM -0700, Eric Biggers wrote:
>
> Can you re-add the following to "hwrng: xilinx - Move xilinx-rng into
> drivers/char/hw_random/"?  It seems you applied this before the qcom-rng
> series, then dropped the drivers/char/hw_random/Makefile change rather
> than resolve it.
> 
> diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
> index 3e655d6e116b..95b5adb49560 100644
> --- a/drivers/char/hw_random/Makefile
> +++ b/drivers/char/hw_random/Makefile
> @@ -51,5 +51,6 @@ obj-$(CONFIG_HW_RANDOM_XIPHERA) += xiphera-trng.o
>  obj-$(CONFIG_HW_RANDOM_ARM_SMCCC_TRNG) += arm_smccc_trng.o
>  obj-$(CONFIG_HW_RANDOM_CN10K) += cn10k-rng.o
>  obj-$(CONFIG_HW_RANDOM_POLARFIRE_SOC) += mpfs-rng.o
>  obj-$(CONFIG_HW_RANDOM_ROCKCHIP) += rockchip-rng.o
>  obj-$(CONFIG_HW_RANDOM_JH7110) += jh7110-trng.o
> +obj-$(CONFIG_HW_RANDOM_XILINX) += xilinx-trng.o

Thanks for checking.  It should be fixed now.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
