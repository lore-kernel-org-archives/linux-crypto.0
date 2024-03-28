Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5E35223
	for <linux-crypto@vger.kernel.org>; Thu, 28 Mar 2024 10:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711621044; cv=none; b=tzDAflstCc3+5RzLyAPK8lUMk7do1JStBzb0U8zraAwAujtWqxQA68S+zS4z92oHchQrILt10cpsv9466qkqNO16uuOiNlKiHI5+hImMUWgPbJOkJNxU6KHekW7WI0pKbngjwANeoySKOMHLdEkjJ4bBdBRcLsldRqrcFdOeUZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711621044; c=relaxed/simple;
	bh=7NCOP9+2sqRClXSKEASo7Uwi3USYyilhrNI8GfJnpkk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SJZrLtPt7oKwhWUSHJ6ORgzS9yUq8K2RupCc88G5iFmu595aNkSO5woY791VuDHvV9756npqrGBbBCDwY9mZN7AXeGLeSpP+mxGxYVqEIXA04c7CCZwpCa4SfyNWCHEypCNzpRzsa/uxXu2/Ueaziaq+Z9yv57Ect+SyfbzaxeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rpmot-00C7Ww-L6; Thu, 28 Mar 2024 18:17:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 28 Mar 2024 18:17:32 +0800
Date: Thu, 28 Mar 2024 18:17:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Joachim Vandersmissen <git@jvdsn.com>
Cc: linux-crypto@vger.kernel.org,
	Salvator Benedetto <salvatore.benedetto@intel.com>
Subject: Re: [PATCH] crypto: ecdh - explicitly zeroize private_key
Message-ID: <ZgVDvHT1sIOW+ZwV@gondor.apana.org.au>
References: <20240320045106.61875-1-git@jvdsn.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240320045106.61875-1-git@jvdsn.com>

On Tue, Mar 19, 2024 at 11:51:06PM -0500, Joachim Vandersmissen wrote:
>
> diff --git a/crypto/ecdh.c b/crypto/ecdh.c
> index 80afee3234fb..ce332b39b705 100644
> --- a/crypto/ecdh.c
> +++ b/crypto/ecdh.c
> @@ -33,6 +33,8 @@ static int ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
>  	    params.key_size > sizeof(u64) * ctx->ndigits)
>  		return -EINVAL;
>  
> +	memzero_explicit(ctx->private_key, sizeof(ctx->private_key));

Please use memset instead of memzero_explicit unless it is actually
needed (which is not the case here).

I know there is another memzero_explicit in this function which should
also be memset so it's not your fault.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
