Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B52E7F7CE
	for <linux-crypto@vger.kernel.org>; Fri, 19 Apr 2024 11:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713524528; cv=none; b=cipgm6WJoAn9AUvrNHuQqq3SDJ9iBS6ZUryrgV48BerqIw8e8FzFFqYdNq1BL8PkPtCT7nMcFZPw+8L3jvRSLZ3o04BF+N5XYNrZgbbzx0p50BpZETz3gu5O6pedhphFxTl5U1lHCjdJOJSKbE6DbzEH4pRVQYg6FQk/C03D9RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713524528; c=relaxed/simple;
	bh=e8AX63ebVKuiPaOCnK2ptT99hRvv/uHbs9WMn8doyY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZN+DRQG5kVtOFmX2NbTMK/Uvo//aaQ6m2jWiTIfMZm5GVxadfCNvK6R2veuT+P+VXJgJotpa8T7BvB7ZKFk41o+yI0bPwLImMJ1MAXlZjOJxNIQyZJjUfVUMg1BYPXGGG6Ftmac0a9Yp42MF4mznKT5UXfAosFakG61o8rrtcpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rxm0J-003sXY-19; Fri, 19 Apr 2024 19:02:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Apr 2024 19:02:20 +0800
Date: Fri, 19 Apr 2024 19:02:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Adam Guerin <adam.guerin@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH v2 0/2] Improve error logging in the qat driver
Message-ID: <ZiJPPC9/tL2qyZUG@gondor.apana.org.au>
References: <20240412122401.243378-1-adam.guerin@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412122401.243378-1-adam.guerin@intel.com>

On Fri, Apr 12, 2024 at 01:24:00PM +0100, Adam Guerin wrote:
> This set simply improves error logging in the driver, making error logging
> consistent between rate limiting and telemetry and improve readability
> of logging in adf_get_arbiter_mapping().
> 
> v1 -> v2:
>  -fixed commit id in fixes tag of both patches to be 12 char long.
> 
> Adam Guerin (2):
>   crypto: qat - improve error message in adf_get_arbiter_mapping()
>   crypto: qat - improve error logging to be consistent across features
> 
>  drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c | 2 +-
>  drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c   | 2 +-
>  drivers/crypto/intel/qat/qat_common/adf_rl.c           | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> 
> base-commit: 0419fa6732b2b98ea185ac05f2a3c430b7de2abb
> -- 
> 2.40.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
