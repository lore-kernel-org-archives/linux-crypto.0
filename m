Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CC122068D
	for <linux-crypto@vger.kernel.org>; Fri, 21 Mar 2025 11:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742555117; cv=none; b=EQcdY/eL0dtlHGUP9nTU6ENSwww2pCwBrEPbFgt3x2/Io02FfcXIVrUFwNvyuk8tn/qRJX9I+aDsEGbME+FMVW6Nf3aC3AbV75NksPRQWYHkCIgFCaNacXOe4DVe/285noDPzJtxW/coTLLwXDfsKj8e6hO2AB4iZpB/95U5Ots=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742555117; c=relaxed/simple;
	bh=0usJ0ct3FGK46kO5h14bxL8ftyWI9Y8WGFsBmQJijIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GN+hWOIqJuWzJeP/3ajQT9HbB70tAeJb2pK72XAO+sUPbRpsg4JtwyregjtaRGRBZjPCY/kbcOpZRCEX4MDbqx/6rvHJmdSAJMnBaiBkWVzTjjiJ6CgHusLDOlQUxFZRo9+Zmu9DqxwmOL9Y4hYzFyurJWXb6jaob3h0e+8Gwyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Jgwzcbft; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Jgwzcbft"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mGJfbRueUuzvs+vGmyioVfy2OumY0BvQTMhsYKzjhvk=; b=JgwzcbftuNS92SrL7YSxd6OxOa
	ACI4E4a9Wg88guatgSX7VJ7CkxO4XlcZ9mhXeLJ1hFEcvgF6Jy/9n75MZ8MZm7ChVwr0+Ohp42grD
	PLdL43rz+sizCaokQwDsxPiQCJiDGy5MgE/ZdQ48XIFQmBCliugH2T5wv/yOIcWEkVX0Z70oSmDEz
	x6a2/3m2j2ktrh1vnDCfu/M3YD7GvpPum6xXt9BJMi4faOxHCD9jeVD6VosySkvowaHqY03amIjlb
	hCj1TXOhB/GgPqbTGGKruz6GcfXy4x/pWn95OFmSKXHD9gJiXDiVinMILMHMpN/M7Fv85wdl84VCl
	wF5wlSFw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tvaBc-0090As-05;
	Fri, 21 Mar 2025 19:05:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Mar 2025 19:05:12 +0800
Date: Fri, 21 Mar 2025 19:05:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH] crypto: qat - introduce fuse array
Message-ID: <Z91H6KjewuZT1812@gondor.apana.org.au>
References: <20250312113938.766631-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312113938.766631-1-suman.kumar.chakraborty@intel.com>

On Wed, Mar 12, 2025 at 11:39:38AM +0000, Suman Kumar Chakraborty wrote:
> Change the representation of fuses in the accelerator device
> structure from a single value to an array.
> 
> This allows the structure to accommodate additional fuses that
> are required for future generations of QAT hardware.
> 
> This does not introduce any functional changes.
> 
> Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  .../crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c   |  2 +-
>  drivers/crypto/intel/qat/qat_420xx/adf_drv.c         |  2 +-
>  drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c |  2 +-
>  drivers/crypto/intel/qat/qat_4xxx/adf_drv.c          |  2 +-
>  .../crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |  4 ++--
>  drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c         |  2 +-
>  drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c |  4 ++--
>  drivers/crypto/intel/qat/qat_c62x/adf_drv.c          |  4 ++--
>  .../crypto/intel/qat/qat_common/adf_accel_devices.h  | 12 +++++++++++-
>  .../crypto/intel/qat/qat_common/adf_gen2_hw_data.c   |  2 +-
>  .../intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c    |  6 +++---
>  drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c      |  2 +-
>  12 files changed, 27 insertions(+), 17 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
