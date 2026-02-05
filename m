Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916B4332ED7;
	Thu,  5 Feb 2026 16:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770307917; cv=none; b=HQPQfCConvz9r43E8vJjWNoYB1TdsHFTNgv48pJ48XjuIDE2CsAZHPIMeo7pmjW8q9/Bs0XQ7cN9TOOnS304cIA9BJTroVPvM1mtLOYNe+ymskjDVPmfNbLdtZpttojCOy4ga0FGeyVGwW2egessCaFQfjEfqpWkbyRY4aAlE/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770307917; c=relaxed/simple;
	bh=HvhUK5xEygbMvaSMIxihgEmri6gWlx1DNlFyIrDNiD0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hgH8qHhzCcpPwZEg7TT/5Ddnf1U4ij8DQIKJqzDd9TNqJkIYiNfkCxoXqBkSkdgfqzY0nMnBTC0WwY/zge4D5LUvvnoR5AUVvC9ylTFS6fiLQ/ERAz6mMZ5supXGeQ4iJk2G87ML1tID799ZDGbkZB0SRy/T0sjZkFUbUp/k8uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DUPkmlNy; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DUPkmlNy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770307917; x=1801843917;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HvhUK5xEygbMvaSMIxihgEmri6gWlx1DNlFyIrDNiD0=;
  b=DUPkmlNyZ+9EpwrqS4CXRjEBrWAFiNEOo8SpaPArxI0zafoh8KkFES0S
   EEbWigdvnKAePhAfvN8QpNYORVt9KyLfhw5vhp6qSNuXS7In4jVa3PJZO
   FXzYxLx+LrAbbF+Q1zB1Bt29ZauM6O1zSlouBy2LYi2vJoSrJ/uSdpF4z
   5BGB/EUzklbHq5ZCWISWdEAC+UIceNSBNjZ58f/hptdJkhvko7Crjs7W+
   HUIfGRlupZgqcQ3jnSDrCohdY3MYtJqfuO/wEysjzij/ej+MByZqRncIC
   x+rjh5YUJGFkh4JryrGxZXo14jMPlXtryI7QkIsSTb92NOhvGMJeKXWCg
   A==;
X-CSE-ConnectionGUID: N/y6B3T5QmCN5Nb3nbAdmQ==
X-CSE-MsgGUID: IyNPEdZySWmhkvZWXv5iKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11692"; a="74109976"
X-IronPort-AV: E=Sophos;i="6.21,274,1763452800"; 
   d="scan'208";a="74109976"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 08:11:56 -0800
X-CSE-ConnectionGUID: yWtr/tgTTXKWCiqqLOxPeA==
X-CSE-MsgGUID: XFWHKgSaTIOxeB3uP2IJ2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,274,1763452800"; 
   d="scan'208";a="248175267"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.244.142])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 08:11:51 -0800
Date: Thu, 5 Feb 2026 18:11:49 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: WangYuli <wangyuli@aosc.io>
Cc: mario.limonciello@amd.com, thomas.lendacky@amd.com, john.allen@amd.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	mika.westerberg@linux.intel.com, jsd@semihalf.com,
	andi.shyti@kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
	bp@alien8.de, ashish.kalra@amd.com, markhas@chromium.org,
	jarkko.nikula@linux.intel.com, wsa@kernel.org,
	WangYuli <wangyl5933@chinaunicom.cn>, stable@vger.kernel.org
Subject: Re: [PATCH] i2c: designware: Enable PSP semaphore for AMDI0010 and
 fix probe deferral
Message-ID: <aYTBRVtpUA6xavV7@smile.fi.intel.com>
References: <20260205103047.19127-1-wangyuli@aosc.io>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205103047.19127-1-wangyuli@aosc.io>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Thu, Feb 05, 2026 at 06:30:47PM +0800, WangYuli wrote:

> AMD Strix Point platforms use the AMDI0010 ACPI HID for their I2C
> controllers, but this entry was missing the ARBITRATION_SEMAPHORE flag
> that enables PSP-based bus arbitration.
> 
> Without proper arbitration, when both the x86 host and AMD PSP
> (Platform Security Processor) attempt to access the shared I2C bus
> simultaneously, the DesignWare controller loses arbitration and reports:
> 
>   i2c_designware AMDI0010:01: i2c_dw_handle_tx_abort: lost arbitration
> 
> This causes communication failures with I2C devices such as touchpads
> (e.g., BLTP7853 HID-over-I2C).
> 
> Add the ARBITRATION_SEMAPHORE flag to the AMDI0010 entry to enable PSP
> mailbox-based I2C bus arbitration, consistent with how AMDI0019 was
> handled for AMD Cezanne platforms.
> 
> However, simply enabling this flag exposes a latent bug introduced by
> commit 440da737cf8d ("i2c: designware: Use PCI PSP driver for
> communication"): the driver unconditionally returns -EPROBE_DEFER when
> psp_check_platform_access_status() fails, causing an infinite probe
> deferral loop on platforms that lack PSP platform access support.
> 
> The problem is that psp_check_platform_access_status() returned -ENODEV
> for all failure cases, but there are two distinct scenarios:
> 
>   1. PSP is still initializing (psp pointer exists but platform_access_data
>      is not yet ready, while vdata->platform_access indicates support) -
>      this is a transient condition that warrants probe deferral.
> 
>   2. The platform genuinely lacks PSP platform access support (either no
>      psp pointer, or vdata->platform_access is not set) - this is a
>      permanent condition where probe deferral would loop indefinitely.
> 
> Fix this by updating psp_check_platform_access_status() to return:
> 
>   - -EPROBE_DEFER: when PSP exists with platform_access capability but
>     platform_access_data is not yet initialized (transient)
>   - -ENODEV: when the platform lacks PSP platform access support (permanent)
> 
> Then update the I2C driver to pass through the actual return code from
> psp_check_platform_access_status() instead of forcing -EPROBE_DEFER,
> allowing the driver to fail gracefully on unsupported platforms.
> 
> Tested on MECHREVO XINGYAO 14 with AMD Ryzen AI 9 H 365.

...

> +++ b/drivers/crypto/ccp/platform-access.c

> int psp_check_platform_access_status(void)
>  {
>  	struct psp_device *psp = psp_get_master_device();
>  
> -	if (!psp || !psp->platform_access_data)
> +	/* PSP driver not loaded yet, caller should defer */
> +	if ((!psp) || (!psp->platform_access_data && psp->vdata->platform_access))

Too many parentheses (it's not a macro).

> +		return -EPROBE_DEFER;
> +
> +	/* PSP loaded but platform_access not supported by hardware */
> +	if (!psp->platform_access_data && !psp->vdata->platform_access)
>  		return -ENODEV;

This can be refactored.

>  	return 0;
>  }

	/* PSP driver not loaded yet, caller should defer */
	if (!psp)
		return -EPROBE_DEFER;

	if (!psp->platform_access_data) {
		if (psp->vdata->platform_access)
			/* ...missing comment... */
			return -EPROBE_DEFER;
		else
			/* PSP loaded but platform_access not supported by hardware */
			return -ENODEV;
	}

...

>   * Returns:
> - * 0          platform features is ready
> - * -%ENODEV   platform features is not ready or present
> + *  0:            platform features is ready
> + *  -%ENODEV:     platform_access is not supported by hardware
> + *  -%EPROBE_DEFER: PSP driver not ready or platform features not yet initialized

Run kernel-doc and render this.

You need "* *" for each item in the list.

-- 
With Best Regards,
Andy Shevchenko


