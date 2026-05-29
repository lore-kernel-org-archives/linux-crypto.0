Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708253A1692
	for <linux-crypto@vger.kernel.org>; Fri, 29 May 2026 06:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780034828; cv=none; b=uF3xy5iJ5GtSZ6oBjcCEY6P3SzpRLOlhtuRbnSWJ/su+qpqUSYUuEFdlAgxRItSDawJHKLPR5Q8ZCzr1efYD8ehOo9ZDDv1Umn0hyVys3w/OqnZOq1CPfJOa9AXSQUGWF2w8nrZAwn3GSZGZl71QTglJUQHwi7bkqBL9q+WvBE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780034828; c=relaxed/simple;
	bh=gsR2JiAVCWnF5Dz0cU1V5Q6UE4JZemi6qWUrwLY8fGo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jUwF7q6Wlzx0zFmjXwjvBL+jDpLJCcoz98zMKY5kI3/wucmqwOnuR6KTvQGU2D1oG2Hz6IMHf0yRdEi/vNwq0/2kgq3a+8X464KK+qWFG1+Yn+i1HKYKr0IOf0Hcug6tKqkh8dtQUNm8YHnUJP02tTjFhKcC4ra4Haodmsv2lQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=VvG8ZeXp; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="VvG8ZeXp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=wvgqx+ivMonODUxFwZIcwCspMbs6tKE5Nh4sqqVgtQc=; 
	b=VvG8ZeXp2IOgM4twDTdRUJvIEhvmrsSddsxnAkdVDCKXH6tClroXPkEofNMsdTxl3xXHgMUfdSt
	FVJgOnZLR+5LlC9vre6Mu+eploHpcMQ0ooJw1IOaumuzEV7WaCesUvK76Tk5dwfYk5jN3USCKIlS1
	9GTlwTXUOkZO1JaPVcm+KTyhCpZZA6SqRP9vbb0ERGETSL0XUxtj3zeImP6wTU1vSIHrIsb79zY4v
	fomazL1N9vMnTvBoUh7l7mTz4cibr/kHzMljXiWWhjAgPekUM4gcdr+7adRPA+f3NTj7P9IX7o0Dh
	RTGHZDVVG2gO7kIQJultu/xjw4YKLnXV2qRA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wSqN6-000dIA-0J;
	Fri, 29 May 2026 14:07:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 May 2026 14:07:04 +0800
Date: Fri, 29 May 2026 14:07:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ahsan Atta <ahsan.atta@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - use pci logging variants for PCI-specific
 messages
Message-ID: <ahktCHfKjOnCcwpw@gondor.apana.org.au>
References: <20260520125150.211802-1-ahsan.atta@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520125150.211802-1-ahsan.atta@intel.com>

On Wed, May 20, 2026 at 01:51:50PM +0100, Ahsan Atta wrote:
> Replace dev_err(&pdev->dev, ...), dev_info(&pdev->dev, ...) and
> dev_dbg(&pdev->dev, ...) with pci_err(), pci_info() and pci_dbg()
> where the log message relates to a PCI subsystem operation such as
> device enable, BAR mapping, PCI region requests, PCI state
> save/restore, and SR-IOV management.
> 
> Messages about driver-level logic (NUMA topology, device matching,
> accelerator units, capabilities, configuration, DMA) are intentionally
> left as dev_err() even when a struct pci_dev pointer is in scope,
> since those concern the device or driver rather than the PCI bus.
> 
> No functional change.
> 
> Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
> Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_420xx/adf_drv.c  |  8 +++----
>  drivers/crypto/intel/qat/qat_4xxx/adf_drv.c   |  8 +++----
>  drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c  |  4 ++--
>  .../crypto/intel/qat/qat_c3xxxvf/adf_drv.c    |  2 +-
>  drivers/crypto/intel/qat/qat_c62x/adf_drv.c   |  4 ++--
>  drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c |  2 +-
>  drivers/crypto/intel/qat/qat_common/adf_aer.c | 21 +++++++++----------
>  .../crypto/intel/qat/qat_common/adf_sriov.c   |  2 +-
>  .../crypto/intel/qat/qat_dh895xcc/adf_drv.c   |  4 ++--
>  .../crypto/intel/qat/qat_dh895xccvf/adf_drv.c |  2 +-
>  10 files changed, 28 insertions(+), 29 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
