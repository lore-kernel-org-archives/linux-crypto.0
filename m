Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A061BC23
	for <linux-crypto@vger.kernel.org>; Tue, 23 Apr 2024 15:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713887906; cv=none; b=nxuiPuiMQByEo2myrT2l3oU0NPu7LChbnvivQNQLCjy0kHcSiyLF7IlJyfKRU6NBO8TR/tJNeZQ/zfImr1lx7Mk0Ab9bKW8QkVtG4kZNkdkSeAzokyoUlMAGHJLYPv5ctHibs1itGfJKdVTRz/y4RPGaLU7ctxux12pwM19tykM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713887906; c=relaxed/simple;
	bh=TG1xu07oOJCkKY/sPT2Q5iJLW4Z8NGwCN6sv2WM7eLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CVeRTgtdQJajOaReYnDD9Mym038R+nbw6YI81AqXAD1uEOSmt4vbTjj/rCkgkfmzV20BDScKZETBXcnIeGs8rTBKVLCjYOe24+Sg/YVcj2TotSBYgEBEpk5rei9iggNOvdd8Fg4SkvyPyjdhyfGk8GrWKJ/meXrHlgus62/CUwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=fail smtp.mailfrom=kernel.org; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.org
X-CSE-ConnectionGUID: Gtj46e3sSjCpfwY8wQyFAg==
X-CSE-MsgGUID: K5BGc2aoTOaCpz4RtHF2zA==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="9311519"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="9311519"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 08:58:25 -0700
X-CSE-ConnectionGUID: jb5PWMliRAyzLdwsje6RGQ==
X-CSE-MsgGUID: x+L3d3BNQmiNpWsuwaQtOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="29054596"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 08:58:23 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.97)
	(envelope-from <andy@kernel.org>)
	id 1rzIXD-00000000Nra-3Tyz;
	Tue, 23 Apr 2024 18:58:19 +0300
Date: Tue, 23 Apr 2024 18:58:19 +0300
From: Andy Shevchenko <andy@kernel.org>
To: Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc: Gregory CLEMENT <gregory.clement@bootlin.com>,
	Arnd Bergmann <arnd@arndb.de>, soc@kernel.org,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-crypto@vger.kernel.org, arm@kernel.org
Subject: Re: [PATCH v6 07/11] platform: cznic: turris-omnia-mcu: Add support
 for MCU provided TRNG
Message-ID: <Zifamxfa18yjD_VS@smile.fi.intel.com>
References: <20240418121116.22184-1-kabel@kernel.org>
 <20240418121116.22184-8-kabel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240418121116.22184-8-kabel@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Thu, Apr 18, 2024 at 02:11:12PM +0200, Marek Behún wrote:
> Add support for true random number generator provided by the MCU.
> New Omnia boards come without the Atmel SHA204-A chip. Instead the
> crypto functionality is provided by new microcontroller, which has
> a TRNG peripheral.

...

> +int omnia_mcu_register_trng(struct omnia_mcu *mcu)
> +{
> +	struct device *dev = &mcu->client->dev;
> +	int irq, err;
> +	u8 irq_idx;
> +
> +	if (!(mcu->features & FEAT_TRNG))
> +		return 0;

> +	irq_idx = omnia_int_to_gpio_idx[__bf_shf(INT_TRNG)];
> +	irq = devm_irq_create_mapping(dev, mcu->gc.irq.domain, irq_idx);
> +	if (irq < 0)
> +		return dev_err_probe(dev, irq, "Cannot map TRNG IRQ\n");

This looks like some workaround against existing gpiod_to_irq(). Why do you
need this?

> +	init_completion(&mcu->trng_completion);
> +
> +	err = devm_request_threaded_irq(dev, irq, NULL, omnia_trng_irq_handler,
> +					IRQF_ONESHOT, "turris-omnia-mcu-trng",
> +					mcu);
> +	if (err)
> +		return dev_err_probe(dev, err, "Cannot request TRNG IRQ\n");
> +
> +	mcu->trng.name = "turris-omnia-mcu-trng";
> +	mcu->trng.read = omnia_trng_read;
> +	mcu->trng.priv = (unsigned long)mcu;
> +
> +	err = devm_hwrng_register(dev, &mcu->trng);
> +	if (err)
> +		return dev_err_probe(dev, err, "Cannot register TRNG\n");
> +
> +	return 0;
> +}

-- 
With Best Regards,
Andy Shevchenko


