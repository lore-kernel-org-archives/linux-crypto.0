Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DFA15CD41;
	Fri,  7 Jun 2024 11:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717759030; cv=none; b=KhpvKrNHajBJNAD95/i4NBrkPSQNhoC+hF27OIhNnrGboAPtNdMg4RlXYp5iZKAahZ3u1oDU03jsnvGD4HQ6CSIvlQ9O1ZG2c+RJ02owkkNWGxp6j40VtVzzohmCkoARLPBJDBxMMEVxwfhmftQ1RIALLGfvkNDLWKWDplGxdZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717759030; c=relaxed/simple;
	bh=/frmM6mD7/qvXSmcyd3JtyOkH85T/WmSsWCjL0CjS98=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eLJjgnIobzbGs7MrgTAOwNtYt2yYVB7O5hAiLYy9f/1lW1RiI4j0Vj1TTIY2kGKSllb7DGxtMB6N8yfoenlTbUJe2cHf/VCIKss2K++qyJ6hEiBN1LoHirTTGt4Hdo9KishydPIRr0r6Eaq/Dyf16NfVhHAwXJM6OSp8e43fi+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sFXab-006oBW-0W;
	Fri, 07 Jun 2024 19:16:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 07 Jun 2024 19:16:59 +0800
Date: Fri, 7 Jun 2024 19:16:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jia Jie Ho <jiajie.ho@starfivetech.com>
Cc: "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: starfive - Align rsa input data to 32-bit
Message-ID: <ZmLsK9Apy9NwNEQi@gondor.apana.org.au>
References: <20240529002553.1372257-1-jiajie.ho@starfivetech.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240529002553.1372257-1-jiajie.ho@starfivetech.com>

On Wed, May 29, 2024 at 08:25:53AM +0800, Jia Jie Ho wrote:
> Hardware expects RSA input plain/ciphertext to be 32-bit aligned.
> Allocate aligned buffer and shift data accordingly.
> 
> Signed-off-by: Jia Jie Ho <jiajie.ho@starfivetech.com>
> ---
>  drivers/crypto/starfive/jh7110-cryp.h |  3 +--
>  drivers/crypto/starfive/jh7110-rsa.c  | 17 ++++++++++-------
>  2 files changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/crypto/starfive/jh7110-cryp.h b/drivers/crypto/starfive/jh7110-cryp.h
> index 494a74f52706..eeb4e2b9655f 100644
> --- a/drivers/crypto/starfive/jh7110-cryp.h
> +++ b/drivers/crypto/starfive/jh7110-cryp.h
> @@ -217,12 +217,11 @@ struct starfive_cryp_request_ctx {
>  	struct scatterlist			*out_sg;
>  	struct ahash_request			ahash_fbk_req;
>  	size_t					total;
> -	size_t					nents;
>  	unsigned int				blksize;
>  	unsigned int				digsize;
>  	unsigned long				in_sg_len;
>  	unsigned char				*adata;
> -	u8 rsa_data[] __aligned(sizeof(u32));
> +	u8					*rsa_data;

You didn't explain why this is moving from a pre-allocated buffer
to one that's allocated on the run.  It would appear that there is
no reason why you can't build the extra space used for shifting
into reqsize.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
