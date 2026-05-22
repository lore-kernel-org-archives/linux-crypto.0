Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE84037FF5B
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 12:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779452941; cv=none; b=IVgUO11rPDp7FJRYePgvGECojBsBKo+F67E7ppjx1T3y/X+wyFWx81lMWufm78LQjumR4aOrYlqJBeZuivlPG2d2UJ/mtsvWmv+xcYfWPHRIEbmLUacNGot1dTwmL79P76blUc5/z50KgSWOvMo0f2oPBVxNx7L4AvH2wjPQUSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779452941; c=relaxed/simple;
	bh=T+nCUANsmFak+eJf0FtIpOAzMU3R1alFwnTdPbwwwu4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XaAs58ToUgY+DLc6gNZ39e4NJUEc3LNKFvXlwqVp8rSGKp+aNTZB+lUNLM0L2vOy3CkKZtuMcIDeT0+Rk1URgLJU3Mg7vs3g3fSsnFFCSJZMLchfgw2y6seuBlRuhwUCiaDJLed2qFjlURl4YRU4gwvJOutDem/lHj7ToJyiHVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=K0o120yz; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="K0o120yz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=D5KOvLqdclCuO7oAdxlJxvP31AitgmlFaoO84+okCZY=; 
	b=K0o120yzWdMEW9c3RgeSKmi/9hlWJQEnG8ktJYrp/Uru9F617MLupCVOmkNdKt63ysCdksKyb0F
	VF/LvgRmwd6wbs1jMXxVF7wD1kq39q9X8JqAEuqxJkaiplLVx5ZtdnQC2QQPdODOqrUfhpBWDGdFv
	D0GHBptPoSGKc+NmvJ5mVWgVhSYGpLGyA6PdXYuxAn19Kpp42Vx5J8jimYtcrCkLsmGSruXHsz1Eq
	eIffGTukht2BHO1atbVTPXOg2c7rgFH0y74k7EeTG5IezcY2tin3fG9HaDtO0veHnABliwhFRSuJW
	0ig8iL+DsTV0M5su64Ox17DIABsn5TIOJEVw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wQOzo-00GSKd-1B;
	Fri, 22 May 2026 20:28:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 May 2026 20:28:56 +0800
Date: Fri, 22 May 2026 20:28:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>
Subject: Re: [PATCH] crypto: qat - remove MODULE_VERSION
Message-ID: <ahBMCK27Tp1Mo6st@gondor.apana.org.au>
References: <20260513085808.626413-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513085808.626413-1-giovanni.cabiddu@intel.com>

On Wed, May 13, 2026 at 09:57:45AM +0100, Giovanni Cabiddu wrote:
> In-tree drivers do not need MODULE_VERSION as the kernel release
> identifies the version of their code. The static version "0.6.0", which
> the QAT drivers currently report, can be misleading as it might suggest
> the drivers are outdated.
> 
> Remove MODULE_VERSION() from all QAT driver modules and the related
> ADF_DRV_VERSION, ADF_MAJOR_VERSION, ADF_MINOR_VERSION and
> ADF_BUILD_VERSION macros from adf_common_drv.h.
> 
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_420xx/adf_drv.c         | 1 -
>  drivers/crypto/intel/qat/qat_4xxx/adf_drv.c          | 1 -
>  drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c         | 1 -
>  drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c       | 1 -
>  drivers/crypto/intel/qat/qat_c62x/adf_drv.c          | 1 -
>  drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c        | 1 -
>  drivers/crypto/intel/qat/qat_common/adf_common_drv.h | 7 -------
>  drivers/crypto/intel/qat/qat_common/adf_module.c     | 1 -
>  drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c      | 1 -
>  drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c    | 1 -
>  10 files changed, 16 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
