Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A73258CD0;
	Sun, 12 Apr 2026 08:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775984013; cv=none; b=DIkRhhTeuP9kEEC6gBeUeTvp6tTt0P8cRAnkgD257BVHK0zvlATI1aMB4u9/RksCdtSbkiR4YsMTkveahCkD6UKakBZm4TiDgQFlcBFBxEVSRnuY5AaxZJ4GYyzFHw1QQWbWABNUBnIRd+qqCee0Y7bLZnfSIQtCRp7JT90QOS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775984013; c=relaxed/simple;
	bh=Ryv+QLCznVi+RuncF+Lf2KQgNd1K2NjirDuh130bHUI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WXLPlEhsMENo/Lx34zOqEAE6xfvP4IHqpQ/rxMKmhdVUVHPBuA7DW8q6KkSIGO8yUXalYnV9+ruev35oK595G4MJKAIvkX7tjPQWtdRs2mIMptJHzrYwrUbt1t/RpwXITPm0UVeN2xxkccWFeMequHCdswYypWh3N9TWvnY6iDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=WiaDtoKu; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="WiaDtoKu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=WYpLRYkMbXSWE9ve1QFlr1Bs81ubQxWsPh6vsjodu/8=; 
	b=WiaDtoKueG88pKo90spEdcho2TG/yukRkr9zpcVeoDnmwg5XpsdBfOeyKgRYcK/otuCZDBHfOKF
	fuUrTuh/xaFTn90wMeTMBTlfFuVWztyCq9j9C9ZETVXcmC0X7Flk9ntdMwHuKYbzOPYOHAHF0Mlid
	g9CuoVhMztlO0+IW41/KAdcNVTofw7C4EEGVSGv0FlGMepfoQ8Fmbavv6mm8O2JVLrRfF1ywPqu/M
	LHnBLCl1TYZCZgqnTZVPda2A4r0N2qdp48r/moguPiiGS2CVshZ6zghicb1bz+ehF921B17gLONfR
	pbA90gysq79ZUH84NwTIyeVTyjbl/3BGKVIg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wBq9t-005UKA-1i;
	Sun, 12 Apr 2026 16:53:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 12 Apr 2026 16:53:28 +0800
Date: Sun, 12 Apr 2026 16:53:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	stable@vger.kernel.org, Ahsan Atta <ahsan.atta@intel.com>,
	Laurent M Coquerel <laurent.m.coquerel@intel.com>
Subject: Re: [PATCH] crypto: qat - fix IRQ cleanup on 6xxx probe failure
Message-ID: <adtdiPr5F0df5vga@gondor.apana.org.au>
References: <20260401093146.268157-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401093146.268157-1-giovanni.cabiddu@intel.com>

On Wed, Apr 01, 2026 at 10:31:11AM +0100, Giovanni Cabiddu wrote:
> When adf_dev_up() partially completes and then fails, the IRQ
> handlers registered during adf_isr_resource_alloc() are not detached
> before the MSI-X vectors are released.
> 
> Since the device is enabled with pcim_enable_device(), calling
> pci_alloc_irq_vectors() internally registers pcim_msi_release() as a
> devres action. On probe failure, devres runs pcim_msi_release() which
> calls pci_free_irq_vectors(), tearing down the MSI-X vectors while IRQ
> handlers (for example 'qat0-bundle0') are still attached. This causes
> remove_proc_entry() warnings:
> 
>     [   22.163964] remove_proc_entry: removing non-empty directory 'irq/143', leaking at least 'qat0-bundle0'
> 
> Moving the devm_add_action_or_reset() before adf_dev_up() does not solve
> the problem since devres runs in LIFO order and pcim_msi_release(),
> registered later inside adf_dev_up(), would still fire before
> adf_device_down().
> 
> Fix by calling adf_dev_down() explicitly when adf_dev_up() fails, to
> properly free IRQ handlers before devres releases the MSI-X vectors.
> 
> Fixes: 17fd7514ae68 ("crypto: qat - add qat_6xxx driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
> Reviewed-by: Laurent M Coquerel <laurent.m.coquerel@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_6xxx/adf_drv.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
