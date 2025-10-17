Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A91187332
	for <linux-crypto@vger.kernel.org>; Fri, 17 Oct 2025 08:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760688959; cv=none; b=TfLE3j0gEe66nyIvodGvnQf9HskXUfcGYD2h3cmqpjRaU/YO8PKQnKXY64GYS5sGwqkhoJXmSOn8Z9JElg+5LY9OHETsou+t72c+c2Pv0F5VeV+jrxUp4iBY/hc9irD8hDbfAs67fe5nyqdwIWmba+hzGTN/rzlp13iouL/L8Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760688959; c=relaxed/simple;
	bh=n/ZG3TqMNc6JulqL+AARaddXoWSC3CmM7jBAqGrmX1E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uT0CvqPy2wns52HAgvKFj1pgjk1DyZfSTcEECexgtkT5UYYYpQ2mm+fWHW9EbeLv/qubC6DqNwjWQyDIaAvud+nG20ASa9a3PEFIUClMIzOjIxr+g2CkdB851tITxmzkECZQt9eH9iZ/o1ImK6tVNWxfDc3vgjf0oatBiJOVLoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Tcbj1OJF; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Tcbj1OJF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=gHJJEFng9Lbsd6nMJgdE7Ji8Tgk80ATWEKPnYCE3B3A=; 
	b=Tcbj1OJFunTOljf3mSawEwZF1NMSGOUDxmnr6MGp1fp+lz/HcHKBwwUaYMH1TgdjP6Vlrd3foEJ
	SXnbnIg7t2zTi1viJD+1NST0Of1gBNutfm0Ud8OXSJ+iGWK0fpufzEwEhzw6AYF8kGum8IhSB8uzj
	EravldMbQmoUwoigbJQvDlCmfiYcfhLhOYcwuAKyrfohH1ax8vHs8fmKvCN9TbKBcSnQZHUPYmz3b
	toHFylTyB+vhrbW7uoKMRWj8b79RRC+YAMlkNuXuyRJO8znffcwFaFmXwpwAj1mPaR/CvuA0AR09z
	geThMIpxTfgyaE/ZJgjYbOHjB8RXiTo5AREQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v9fct-00DMxt-2T;
	Fri, 17 Oct 2025 16:15:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Oct 2025 16:15:51 +0800
Date: Fri, 17 Oct 2025 16:15:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harsh Jain <h.jain@amd.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	mounika.botcha@amd.com, sarat.chand.savitala@amd.com,
	michal.simek@amd.com
Subject: Re: [PATCH 0/3]  crypto: Use drbg CTR DF function in xilinx-trng
Message-ID: <aPH7N4gofFl3zWsP@gondor.apana.org.au>
References: <20250915133027.2100914-1-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915133027.2100914-1-h.jain@amd.com>

On Mon, Sep 15, 2025 at 07:00:24PM +0530, Harsh Jain wrote:
> Export CTR DRBG DF function available in drbg module to use
> it in xilinx-trng driver.
> 
> Testing
> 
> Compile tests done
> 
> * CONFIG_CRYPTO_DRBG_CTR = n and CONFIG_CRYPTO_DEV_XILINX_TRNG = n
> * CONFIG_CRYPTO_DRBG_CTR = y and CONFIG_CRYPTO_DEV_XILINX_TRNG = n
> * CONFIG_CRYPTO_DRBG_CTR = n and CONFIG_CRYPTO_DEV_XILINX_TRNG = m
> * CONFIG_CRYPTO_DRBG_CTR = y and CONFIG_CRYPTO_DEV_XILINX_TRNG = m
> 
> Runtime testing
> * Boot with CONFIG_CRYPTO_USER_API_RNG_CAVP and CONFIG_CRYPTO_DRBG_CTR enabled.
> * Run kcapi-rng -b <15, 16, 17, 31, 32, 33> --hex
> 
> Harsh Jain (3):
>   crypto: drbg: Export CTR DRBG DF functions
>   crypto: drbg: Replace AES cipher calls with library calls
>   crypto: xilinx-trng: Add CTR_DRBG DF processing of seed
> 
>  crypto/Kconfig                      |   8 +-
>  crypto/Makefile                     |   2 +
>  crypto/df_sp80090a.c                | 248 ++++++++++++++++++++++++++
>  crypto/drbg.c                       | 265 ++--------------------------
>  drivers/crypto/Kconfig              |   1 +
>  drivers/crypto/xilinx/xilinx-trng.c |  37 +++-
>  include/crypto/df_sp80090a.h        |  28 +++
>  include/crypto/drbg.h               |  25 +--
>  include/crypto/internal/drbg.h      |  54 ++++++
>  9 files changed, 384 insertions(+), 284 deletions(-)
>  create mode 100644 crypto/df_sp80090a.c
>  create mode 100644 include/crypto/df_sp80090a.h
>  create mode 100644 include/crypto/internal/drbg.h
> 
> -- 
> 2.34.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
