Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2165F2C11D6;
	Mon, 15 Dec 2025 12:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765800456; cv=none; b=SyXaWMTTbsrn6d+esuntZXfNI2V/V73KfayOlHwHB1WWaKmdRwrdc2SPh3rwUp86v9xzraA62H37Pi5TpzesRXz2+/Z3iGWXKMei0/fBisPfKMR39krz4sC7FbuhzEF3FH4IpN139zbtLDcOei0UjF+YkAuu1kxUK/TxseaG5bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765800456; c=relaxed/simple;
	bh=vLEWVfKLtmQUDQXh5LNe5VEgxga3gDzPx9b9mWr7qUw=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=RYg5q0ua4F1fGzNZauxN9Qm749XDI06N1+l1ZU/sfLNBWKi5aOfmRcRZwYbWG4vUsdvNYQvz4RFUN8QZt36LTdTDAdrjz8/I4nqfQGdCOQzTMQR2zHr7R1SIa+4lRrFOeLVjD+SvIfeaNdn89OzNcbSklwxxsnWKQYnr6bD9vag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TfJr05lu; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TfJr05lu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765800454; x=1797336454;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=vLEWVfKLtmQUDQXh5LNe5VEgxga3gDzPx9b9mWr7qUw=;
  b=TfJr05luzl+1igo7aY8yht3NMf99tTDdM/iSB2eixYcg1fSJbxKzMurz
   HqjggAfq97DmEJek/nZzg01VGuMOEW56FpQ/to3Q5Txxy++OvOO5tTzbD
   feiYOQl9Zu6AmYYpcpHodras1+VlvrNKn2qUk9nVK84H+hjbN9eEibv/z
   aG/PuZoGW1WRoB+ciQZZB4VCstfHOd1LBUij2/BrvuLI8gwZO5YpiwGeL
   yjc0HjzWPrA67fBR4suaHceYVOL0L/6dyJjDcE8tnv42duNiEVF2OnUds
   Hj1JnJzTDFG5dUR2iT84VS9ae2AY7k/aOnrJHcHuksAvPXWkpJUkccWPe
   g==;
X-CSE-ConnectionGUID: n09jkLn7RrmLy51m7xh+8g==
X-CSE-MsgGUID: fAZHwYkhQ5i7nyKFY0DjjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11642"; a="85111003"
X-IronPort-AV: E=Sophos;i="6.21,150,1763452800"; 
   d="scan'208";a="85111003"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2025 04:07:33 -0800
X-CSE-ConnectionGUID: vGeR8/tWSW221l/ISwCtGA==
X-CSE-MsgGUID: TM14KxG0Rmi3sRo0ZnMXCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,150,1763452800"; 
   d="scan'208";a="198224214"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.115])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2025 04:07:29 -0800
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Mon, 15 Dec 2025 14:07:25 +0200 (EET)
To: "Mario Limonciello (AMD)" <superm1@kernel.org>
cc: Tom Lendacky <thomas.lendacky@amd.com>, 
    Herbert Xu <herbert@gondor.apana.org.au>, 
    Shyam Sundar S K <Shyam-sundar.S-k@amd.com>, 
    Rijo Thomas <Rijo-john.Thomas@amd.com>, John Allen <john.allen@amd.com>, 
    "David S . Miller" <davem@davemloft.net>, Hans de Goede <hansg@kernel.org>, 
    "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER" <linux-crypto@vger.kernel.org>, 
    "open list:AMD PMF DRIVER" <platform-driver-x86@vger.kernel.org>, 
    Lars Francke <lars.francke@gmail.com>, Yijun Shen <Yijun.Shen@dell.com>
Subject: Re: [PATCH v3 3/5] crypto: ccp - Add an S4 restore flow
In-Reply-To: <20251214191213.154021-4-superm1@kernel.org>
Message-ID: <970a5caf-e9ba-93b9-3086-356a2048bbd2@linux.intel.com>
References: <20251214191213.154021-1-superm1@kernel.org> <20251214191213.154021-4-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Sun, 14 Dec 2025, Mario Limonciello (AMD) wrote:

> The system will have lost power during S4.  The ring used for TEE
> communications needs to be initialized before use.
> 
> Fixes: f892a21f51162 ("crypto: ccp - use generic power management")
> Reported-by: Lars Francke <lars.francke@gmail.com>
> Closes: https://lore.kernel.org/platform-driver-x86/CAD-Ua_gfJnQSo8ucS_7ZwzuhoBRJ14zXP7s8b-zX3ZcxcyWePw@mail.gmail.com/
> Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
> ---
> v3:
>  * Adjust to Tom's suggested flow
> ---
>  drivers/crypto/ccp/psp-dev.c | 15 +++++++++++++++
>  drivers/crypto/ccp/sp-dev.h  |  2 ++
>  drivers/crypto/ccp/sp-pci.c  | 24 +++++++++++++++++++++++-
>  drivers/crypto/ccp/tee-dev.c |  5 +++++
>  drivers/crypto/ccp/tee-dev.h |  1 +
>  5 files changed, 46 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index 9e21da0e298ad..e1da4f1a5db99 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -351,6 +351,21 @@ struct psp_device *psp_get_master_device(void)
>  	return sp ? sp->psp_data : NULL;
>  }
>  
> +

Extra empty line.

> +int psp_restore(struct sp_device *sp)
> +{
> +	struct psp_device *psp = sp->psp_data;
> +
> +	if (psp->tee_data) {
> +		int r = tee_restore(psp);
> +
> +		if (r)

No extra lines in between call and it's error handling. I suggest you 
put int r separately at the top of the function, and not in this block.

The variables should be named ret, no (similar to what the other case in 
this file already do)?

> +			return r;
> +	}
> +
> +	return 0;
> +}
> +
>  void psp_pci_init(void)
>  {
>  	psp_master = psp_get_master_device();
> diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
> index 1335a83fe052e..0deea1a399e47 100644
> --- a/drivers/crypto/ccp/sp-dev.h
> +++ b/drivers/crypto/ccp/sp-dev.h
> @@ -174,6 +174,7 @@ int psp_dev_init(struct sp_device *sp);
>  void psp_pci_init(void);
>  void psp_dev_destroy(struct sp_device *sp);
>  void psp_pci_exit(void);
> +int psp_restore(struct sp_device *sp);
>  
>  #else /* !CONFIG_CRYPTO_DEV_SP_PSP */
>  
> @@ -181,6 +182,7 @@ static inline int psp_dev_init(struct sp_device *sp) { return 0; }
>  static inline void psp_pci_init(void) { }
>  static inline void psp_dev_destroy(struct sp_device *sp) { }
>  static inline void psp_pci_exit(void) { }
> +static inline int psp_restore(struct sp_device *sp) { return 0; }
>  
>  #endif /* CONFIG_CRYPTO_DEV_SP_PSP */
>  
> diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
> index 8891ceee1d7d0..931ec6bf2cec6 100644
> --- a/drivers/crypto/ccp/sp-pci.c
> +++ b/drivers/crypto/ccp/sp-pci.c
> @@ -353,6 +353,21 @@ static int __maybe_unused sp_pci_resume(struct device *dev)
>  	return sp_resume(sp);
>  }
>  
> +static int __maybe_unused sp_pci_restore(struct device *dev)
> +{
> +	struct sp_device *sp = dev_get_drvdata(dev);
> +
> +#ifdef CONFIG_CRYPTO_DEV_SP_PSP
> +	if (sp->psp_data) {
> +		int ret = psp_restore(sp);
> +
> +		if (ret)

		int ret;

		ret = psp_restore(sp);
		if (ret)

> +			return ret;
> +	}
> +#endif
> +	return sp_resume(sp);
> +}
> +
>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>  static const struct sev_vdata sevv1 = {
>  	.cmdresp_reg		= 0x10580,	/* C2PMSG_32 */
> @@ -563,7 +578,14 @@ static const struct pci_device_id sp_pci_table[] = {
>  };
>  MODULE_DEVICE_TABLE(pci, sp_pci_table);
>  
> -static SIMPLE_DEV_PM_OPS(sp_pci_pm_ops, sp_pci_suspend, sp_pci_resume);
> +static const struct dev_pm_ops sp_pci_pm_ops = {
> +	.suspend = pm_sleep_ptr(sp_pci_suspend),
> +	.resume = pm_sleep_ptr(sp_pci_resume),
> +	.freeze = pm_sleep_ptr(sp_pci_suspend),
> +	.thaw = pm_sleep_ptr(sp_pci_resume),
> +	.poweroff = pm_sleep_ptr(sp_pci_suspend),
> +	.restore_early = pm_sleep_ptr(sp_pci_restore),
> +};
>  
>  static struct pci_driver sp_pci_driver = {
>  	.name = "ccp",
> diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
> index af881daa5855b..11c4b05e2f3a2 100644
> --- a/drivers/crypto/ccp/tee-dev.c
> +++ b/drivers/crypto/ccp/tee-dev.c
> @@ -366,3 +366,8 @@ int psp_check_tee_status(void)
>  	return 0;
>  }
>  EXPORT_SYMBOL(psp_check_tee_status);
> +
> +int tee_restore(struct psp_device *psp)
> +{
> +	return tee_init_ring(psp->tee_data);
> +}
> diff --git a/drivers/crypto/ccp/tee-dev.h b/drivers/crypto/ccp/tee-dev.h
> index ea9a2b7c05f57..c23416cb7bb37 100644
> --- a/drivers/crypto/ccp/tee-dev.h
> +++ b/drivers/crypto/ccp/tee-dev.h
> @@ -111,5 +111,6 @@ struct tee_ring_cmd {
>  
>  int tee_dev_init(struct psp_device *psp);
>  void tee_dev_destroy(struct psp_device *psp);
> +int tee_restore(struct psp_device *psp);
>  
>  #endif /* __TEE_DEV_H__ */
> 

-- 
 i.

