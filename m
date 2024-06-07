Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC5A13FD7D;
	Fri,  7 Jun 2024 11:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717760479; cv=none; b=adXrXJzZqb9uSInX6vOHJyCQGbaZev4g4F/0VZdu7/XbZDhI2ZbgLbv4bpA1iCf6koybT+VR9O8Bt23IzWy8n+nfF5Q54VWRZoIOxES9dsT6Z6b3lVjVNuaZ1MGYUZVzOzdL/IFWdT4Lmtz781zYFkL9vaSiunabJHQink9Xjy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717760479; c=relaxed/simple;
	bh=AAWjgMiw1Sd7/hpwH478qQeRVmACDzM90AWney62dOc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LB9ynZ6/Sxqz1rCbw9kdGohNFEVL7Y+LlpZLLIpGjxR100L98lwM08azR10rEv3dvz0sitGG+vdw9qDkAYx6XB0W+UfYL1OeVcz85IQciNdXgwe/IViHlngdX1ph3+NbSYkO3XA7riBQZFg5Lmq7nqqB0lVhqvq1L9eAjy9/M2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sFXy1-006ori-1f;
	Fri, 07 Jun 2024 19:41:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 07 Jun 2024 19:41:12 +0800
Date: Fri, 7 Jun 2024 19:41:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Alexander Sapozhnikov <alsp705@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH] crypto: algif_aead: deref after NULL
Message-ID: <ZmLx2K53e2XRJPfa@gondor.apana.org.au>
References: <20240606183401.11-1-alsp705@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240606183401.11-1-alsp705@gmail.com>

On Thu, Jun 06, 2024 at 09:34:00PM +0300, Alexander Sapozhnikov wrote:
> From: Alexandr Sapozhnikov <alsp705@gmail.com>
> 
> After having been compared to a NULL value at algif_aead.c:191, 
> pointer 'tsgl_src' is passed as 2nd parameter in call to function 
> 'crypto_aead_copy_sgl' at algif_aead.c:244, where it is
> dereferenced at algif_aead.c:85.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Alexandr Sapozhnikov <alsp705@gmail.com>
> ---
>  crypto/algif_aead.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
> index 42493b4..f757907 100644
> --- a/crypto/algif_aead.c
> +++ b/crypto/algif_aead.c
> @@ -191,7 +191,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
>  		if (tsgl_src)
>  			break;
>  	}
> -	if (processed && !tsgl_src) {
> +	if (processed || !tsgl_src) {

I think this is a false positive.  If processed is zero (which can
only happen for encryption, i.e., a null message), tsgl_src won't
be dereferenced by the Crypto API.  For decryption processed is
never zero as it always contains the authentication tag.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
