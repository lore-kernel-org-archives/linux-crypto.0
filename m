Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F0B155CB4;
	Fri, 31 May 2024 10:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717150979; cv=none; b=dF6uWopavHsffhBCcEZkHuxp1vXm7f905dqYVQY9kgGIaPtUfYqRzAFyzbMXouxxWp+dQITgMhfmsUJ2GJMKB06wOrITuDjJtGkqeu9dOjXPlIoQVlFaF1v/wJd2zjLYbAN+BzLNshC/FXal4OVetg/cgyzwK7RD4SqmpGdZZso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717150979; c=relaxed/simple;
	bh=xYpytp4RPEOTOfmpevCnvYlQNEgIkwZVkY/fX6ZBt0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kxKsP4X2ZNktlm6wxkjQwc36DRXL14+dK2RHVKCHILvHjElZMqlEaUCgr72FYyxC+40cDbmSZ71JvmsuBezhIVQl44Z0WXTvSfbZWNXG1lmqr35IYEyBpxscDAXu49WWeAZ4fbBAI8THrO2bSMOUeNQWlFanOvLoJAYCjk2fMBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sCzPH-004Akv-2z;
	Fri, 31 May 2024 18:22:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 May 2024 18:22:46 +0800
Date: Fri, 31 May 2024 18:22:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mark Brown <broonie@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64/crypto: Raise priority of NEON crct10dif
 implementation
Message-ID: <Zlmk9ty7gPmlL6vq@gondor.apana.org.au>
References: <20240521-arm64-crct10dif-neon-prio-v1-1-e2975754b8f3@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240521-arm64-crct10dif-neon-prio-v1-1-e2975754b8f3@kernel.org>

On Tue, May 21, 2024 at 09:22:49PM +0100, Mark Brown wrote:
> The NEON implementation of crctd10dif is registered with a priority of 100
> which is identical to that used by the generic C implementation. Raise the
> priority to 150, half way between the PMULL based implementation and the
> NEON one, so that it will be preferred over the generic implementation.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/crypto/crct10dif-ce-glue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/crypto/crct10dif-ce-glue.c b/arch/arm64/crypto/crct10dif-ce-glue.c
> index 09eb1456aed4..59016518f44d 100644
> --- a/arch/arm64/crypto/crct10dif-ce-glue.c
> +++ b/arch/arm64/crypto/crct10dif-ce-glue.c
> @@ -98,7 +98,7 @@ static struct shash_alg crc_t10dif_alg[] = {{
>  
>  	.base.cra_name		= "crct10dif",
>  	.base.cra_driver_name	= "crct10dif-arm64-neon",
> -	.base.cra_priority	= 100,
> +	.base.cra_priority	= 150,
>  	.base.cra_blocksize	= CRC_T10DIF_BLOCK_SIZE,
>  	.base.cra_module	= THIS_MODULE,
>  }, {
> 
> ---
> base-commit: a38297e3fb012ddfa7ce0321a7e5a8daeb1872b6
> change-id: 20240521-arm64-crct10dif-neon-prio-894a9350ec1e
> 
> Best regards,
> -- 
> Mark Brown <broonie@kernel.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
