Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F4318A6C4;
	Mon,  7 Jul 2025 03:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751858246; cv=none; b=SBUrAPTKXxRh5dn/QxG2FgU7Ds/dY3ndi7MhsB17l1DdENkZ4m1LzwakncIBLvFjdoL6DfKEnMS1kHn+JJTKFcCV85F9mHKWDELrx6JcCAb7vuesnOSC0BVyHAY1lBrSvFwWX2IKJx5pCUnAd6YOFERTew5IrRa8C5qGe5x3la8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751858246; c=relaxed/simple;
	bh=5kLLvTJgXrsPDDnILfh2y/OayXuPpDhfIhgnZr1I8aA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DkJLPBG4/1opoHm6TkkHCUjHYDUCCy04l2RfVfBi2v1Y45QLf/1xSykfVR/fHwlHcuDGvN88REEk8V7HXc5mCGAZ2RiKj+wgVCMdsEu9fk0ye7mjPOqUc8YRHMiD775NFCpH2dXxHz8GAO7w/fEJXBsK9hOKKEQsW20dmNY3Td4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=YAiLjPng; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="YAiLjPng"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1WRz7GIjid6awbyuWqZFHHY5oO3LKChqAAaLCWJqwqg=; b=YAiLjPng+GIOCAJMCxbq30cy0Y
	32MMkVGzFM54o3g2f8GtFTbVJrUT20UAc3lFdNxbuxsVWTVHRSbFbEqKqHa1suUlsnTV6uoyr4bsV
	DxrSw/KgZ/dfyGtdTwLW68H+ulll/B0yTvlxRnhjRMGRGYUTRRpvBw668feLFODIhZk2AKFjvRMp9
	+f+3gkser3tXTm1XGi+2CO2bP0K5ydYJ/e9XjYQw2Sz+Zt15uPBKje1wlVvqMRlW3XujvL2YA5eY4
	IMhKiB884x4ag2+JDFqF79cr2jSWGas/nsEI+QcsPqPcIbgpHMIPgBZlRdO5sSonH+f+0B1Xqz8tW
	LzsKdUeA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uYc6V-004VU7-0R;
	Mon, 07 Jul 2025 11:17:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Jul 2025 15:17:11 +1200
Date: Mon, 7 Jul 2025 15:17:11 +1200
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harsh Jain <h.jain@amd.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, mounika.botcha@amd.com,
	sarat.chand.savitala@amd.com, mohan.dhanawade@amd.com,
	michal.simek@amd.com, Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v3 3/3] crypto: drbg: Export CTR DRBG DF functions
Message-ID: <aGs8N675Fe9svGTD@gondor.apana.org.au>
References: <20250612052542.2591773-1-h.jain@amd.com>
 <20250612052542.2591773-4-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612052542.2591773-4-h.jain@amd.com>

On Thu, Jun 12, 2025 at 10:55:42AM +0530, Harsh Jain wrote:
> Export drbg_ctr_df() derivative function to re-use it in xilinx trng
> driver. Changes has been tested by enabling CONFIG_CRYPTO_USER_API_RNG_CAVP
> 
> Signed-off-by: Harsh Jain <h.jain@amd.com>
> ---
>  crypto/drbg.c                       | 108 +++++++++++++++-------------
>  drivers/crypto/Kconfig              |   2 +
>  drivers/crypto/xilinx/xilinx-trng.c |  32 ++++++++-
>  include/crypto/drbg.h               |  15 ++++
>  4 files changed, 103 insertions(+), 54 deletions(-)

Please move the df function out into its own module like crypto/hkdf.c.

You should also keep the drbg changes to a minimum.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
