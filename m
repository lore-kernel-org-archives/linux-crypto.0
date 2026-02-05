Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF332DECBA;
	Thu,  5 Feb 2026 11:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770290697; cv=none; b=r6ztML/XnQCFUBPRuno+yO9viJKaw4bBtAd8fK+P/y/Gtb5xem6SBPnkest0Jx2YuPbbUbgaRR/kH6puYpAW7ER6sEMoGGTHJSIc4npQW6dPug77FZ0YVlxsAo41Fr9pNE7/BM7M0tbCZTKpntcbyVCkSYNdZgV9rfdPCu9jCcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770290697; c=relaxed/simple;
	bh=RP9knd9zSX2JAIs659+W5o/dC9K4wTQXWG+rnTYiOmo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HCy+75s26DKS9as+6mzBRlBhMw7u7xBITZzvGTIt6gjv1n2N2d1sMRbGhNYcPxI8XSHpstpnkWQ3Jem12sDbshrsXJTsznVfFBY/ul2lc73JvshubY/nTfmoQq566L80OGufMCCg50x7UKVdTCyIyS/EHGHXx95F7gfNLg9uU2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R3RE1kRZ; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R3RE1kRZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770290696; x=1801826696;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RP9knd9zSX2JAIs659+W5o/dC9K4wTQXWG+rnTYiOmo=;
  b=R3RE1kRZ8rQODIPILR2FRT+S1GXzBrUIo0RBmTDnSKJBDXS4WaJaYHsN
   SkgxVhHgJC5xB3LDsFqn8EC4RPOuzuv2d7ohjHLxSB+G7vSaeYDtmCBai
   xwaMIxFULj/9FaM5CAzleKQYImQDL0uY2HhaSbEPXJCUz38PV+dEERIec
   TSNwCLwH4RwAe8I9jegOwLhsc2jWjg8ddpFV9yrK9oQemkkbXASNn5F9z
   iiUgjlTPFNAnK+om2r3niI8lAF9kgw/wWTtaVJWBUpqzpsMtqusEIvIMe
   JL9IdaDzC3mZp6fuXWT2AkKic6P4LXrT/7Z7T4Tfk53qygqcjWpLEodne
   g==;
X-CSE-ConnectionGUID: S41xPsFLRMmQoijjTtUAfg==
X-CSE-MsgGUID: Yh7Te6NVQ/y+BXtIR+rB8g==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="82926597"
X-IronPort-AV: E=Sophos;i="6.21,274,1763452800"; 
   d="scan'208";a="82926597"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 03:24:56 -0800
X-CSE-ConnectionGUID: seo9ZN/4SAWUD9WMECvqkw==
X-CSE-MsgGUID: AZffPS4XS5G5/6egn3q4Mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,274,1763452800"; 
   d="scan'208";a="209841174"
Received: from black.igk.intel.com ([10.91.253.5])
  by fmviesa007.fm.intel.com with ESMTP; 05 Feb 2026 03:24:52 -0800
Received: by black.igk.intel.com (Postfix, from userid 1001)
	id 432ED95; Thu, 05 Feb 2026 12:24:51 +0100 (CET)
Date: Thu, 5 Feb 2026 12:24:51 +0100
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: WangYuli <wangyuli@aosc.io>
Cc: mario.limonciello@amd.com, thomas.lendacky@amd.com, john.allen@amd.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	andriy.shevchenko@linux.intel.com, jsd@semihalf.com,
	andi.shyti@kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
	bp@alien8.de, ashish.kalra@amd.com, markhas@chromium.org,
	jarkko.nikula@linux.intel.com, wsa@kernel.org,
	WangYuli <wangyl5933@chinaunicom.cn>, stable@vger.kernel.org
Subject: Re: [PATCH] i2c: designware: Enable PSP semaphore for AMDI0010 and
 fix probe deferral
Message-ID: <20260205112451.GX2275908@black.igk.intel.com>
References: <20260205103047.19127-1-wangyuli@aosc.io>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260205103047.19127-1-wangyuli@aosc.io>

On Thu, Feb 05, 2026 at 06:30:47PM +0800, WangYuli wrote:
> From: WangYuli <wangyl5933@chinaunicom.cn>
> 
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
> 
> Fixes: 440da737cf8d ("i2c: designware: Use PCI PSP driver for communication")
> Cc: stable@vger.kernel.org
> Signed-off-by: WangYuli <wangyl5933@chinaunicom.cn>
> ---
>  drivers/crypto/ccp/platform-access.c        |  7 ++++++-
>  drivers/i2c/busses/i2c-designware-amdpsp.c  | 11 +++++++++--
>  drivers/i2c/busses/i2c-designware-platdrv.c |  2 +-
>  include/linux/psp-platform-access.h         |  5 +++--
>  4 files changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/platform-access.c b/drivers/crypto/ccp/platform-access.c
> index 1b8ed3389733..3f20cf194cb6 100644
> --- a/drivers/crypto/ccp/platform-access.c
> +++ b/drivers/crypto/ccp/platform-access.c
> @@ -46,7 +46,12 @@ int psp_check_platform_access_status(void)
>  {
>  	struct psp_device *psp = psp_get_master_device();
>  
> -	if (!psp || !psp->platform_access_data)
> +	/* PSP driver not loaded yet, caller should defer */
> +	if ((!psp) || (!psp->platform_access_data && psp->vdata->platform_access))
> +		return -EPROBE_DEFER;
> +
> +	/* PSP loaded but platform_access not supported by hardware */
> +	if (!psp->platform_access_data && !psp->vdata->platform_access)
>  		return -ENODEV;
>  
>  	return 0;
> diff --git a/drivers/i2c/busses/i2c-designware-amdpsp.c b/drivers/i2c/busses/i2c-designware-amdpsp.c
> index 404571ad61a8..341232767177 100644
> --- a/drivers/i2c/busses/i2c-designware-amdpsp.c
> +++ b/drivers/i2c/busses/i2c-designware-amdpsp.c
> @@ -269,6 +269,7 @@ static const struct i2c_lock_operations i2c_dw_psp_lock_ops = {
>  int i2c_dw_amdpsp_probe_lock_support(struct dw_i2c_dev *dev)
>  {
>  	struct pci_dev *rdev;
> +	int ret;
>  
>  	if (!IS_REACHABLE(CONFIG_CRYPTO_DEV_CCP_DD))
>  		return -ENODEV;
> @@ -291,8 +292,14 @@ int i2c_dw_amdpsp_probe_lock_support(struct dw_i2c_dev *dev)
>  		_psp_send_i2c_req = psp_send_i2c_req_doorbell;
>  	pci_dev_put(rdev);
>  
> -	if (psp_check_platform_access_status())
> -		return -EPROBE_DEFER;
> +	/*
> +	 * Check if PSP platform access is available.
> +	 * Returns 0 on success, -EPROBE_DEFER if PSP driver not loaded,
> +	 * -ENODEV if platform_access is not supported by hardware.
> +	 */

This is useless comment.

> +	ret = psp_check_platform_access_status();
> +	if (ret)
> +		return ret;
>  
>  	psp_i2c_dev = dev->dev;
>  
> diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
> index 7be99656a67d..63b1c06ee111 100644
> --- a/drivers/i2c/busses/i2c-designware-platdrv.c
> +++ b/drivers/i2c/busses/i2c-designware-platdrv.c
> @@ -345,7 +345,7 @@ static const struct acpi_device_id dw_i2c_acpi_match[] = {
>  	{ "80860F41", ACCESS_NO_IRQ_SUSPEND },
>  	{ "808622C1", ACCESS_NO_IRQ_SUSPEND },
>  	{ "AMD0010", ACCESS_INTR_MASK },
> -	{ "AMDI0010", ACCESS_INTR_MASK },
> +	{ "AMDI0010", ACCESS_INTR_MASK | ARBITRATION_SEMAPHORE },
>  	{ "AMDI0019", ACCESS_INTR_MASK | ARBITRATION_SEMAPHORE },
>  	{ "AMDI0510", 0 },
>  	{ "APMC0D0F", 0 },
> diff --git a/include/linux/psp-platform-access.h b/include/linux/psp-platform-access.h
> index 540abf7de048..84dbdbeb61d6 100644
> --- a/include/linux/psp-platform-access.h
> +++ b/include/linux/psp-platform-access.h
> @@ -64,8 +64,9 @@ int psp_ring_platform_doorbell(int msg, u32 *result);
>   * if platform features has initialized.
>   *
>   * Returns:
> - * 0          platform features is ready
> - * -%ENODEV   platform features is not ready or present
> + *  0:            platform features is ready
> + *  -%ENODEV:     platform_access is not supported by hardware
> + *  -%EPROBE_DEFER: PSP driver not ready or platform features not yet initialized
>   */
>  int psp_check_platform_access_status(void);
>  
> -- 
> 2.51.0
