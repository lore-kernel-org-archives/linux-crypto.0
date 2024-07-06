Received: from norbury.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BB153A9
	for <linux-crypto@vger.kernel.org>; Sat,  6 Jul 2024 00:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720226981; cv=none; b=Evs5uvEeTVzrvDocwLmNJG3pEx9Fw8uT1NPf5HDFI6PzG14/oBOI7dmIUiRnX9GcZzsSaXQFxlLUII8hREOWcjssxaKeBjjpdpzOoz9U8fXLKHd6+sKpBcDizRJZvlSscI7mp1KTxHz7bmrTSHawFdt/Z4RrJW3syIi0KmV8X7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720226981; c=relaxed/simple;
	bh=KQWzX/bYYhqs8/95e+lPgT4emwIUI2VPdARg3xzTsxo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bnYviSWv9hqGsMDjyg5WQ8KdMeWPjnfSqHGlml8/DCNuqQ2mCGvT3xCT2jmsnYhO4meKftMn8OvK5yXXhfSjHfoSGHQyNW+U5C5BY0VfOwUmPTP2+VLAiFKfIBgfv22S8BsOeUNI8Rv1fOwJvbWJwCy39jSMEeBhsAv5znCvRXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sPtcN-006h1q-0n;
	Sat, 06 Jul 2024 10:49:36 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 06 Jul 2024 10:49:22 +1000
Date: Sat, 6 Jul 2024 10:49:22 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Nivas Varadharajan Mugunthakumar <nivasx.varadharajan.mugunthakumar@intel.com>
Subject: Re: [PATCH] crypto: qat - extend scope of lock in
 adf_cfg_add_key_value_param()
Message-ID: <ZoiUkqFLLmm9P5yn@gondor.apana.org.au>
References: <20240625143857.5778-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240625143857.5778-1-giovanni.cabiddu@intel.com>

On Tue, Jun 25, 2024 at 03:38:50PM +0100, Giovanni Cabiddu wrote:
> From: Nivas Varadharajan Mugunthakumar <nivasx.varadharajan.mugunthakumar@intel.com>
> 
> The function adf_cfg_add_key_value_param() attempts to access and modify
> the key value store of the driver without locking.
> 
> Extend the scope of cfg->lock to avoid a potential race condition.
> 
> Fixes: 92bf269fbfe9 ("crypto: qat - change behaviour of adf_cfg_add_key_value_param()")
> Signed-off-by: Nivas Varadharajan Mugunthakumar <nivasx.varadharajan.mugunthakumar@intel.com>
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_cfg.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
