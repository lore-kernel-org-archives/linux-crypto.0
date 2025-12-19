Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C3B4A35;
	Fri, 19 Dec 2025 03:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766115082; cv=none; b=QKq9IP5vBnHU+VGkQOA1BEXHEutzWuQSUsxdiRdYh5iXm2tQlfQ1ao09MKXUUB0HyCj/tDeGf4r1MJjnRxE5J6iJpuWBHOPBXrHFSdhiRKtoowt8g37ivz9FQkenPdFj0A8NnCAxlhGd5Mb6bs4uyyeCBJk7fPKedDxRvihm84E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766115082; c=relaxed/simple;
	bh=G3zc4oSoUFUEKJzFEBWvCqeCLoddSLgwV1P9W80ED7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CpZ8EY1Y4VKR/w9gNs7cfMgOQ9h0V0+X+ngEy6fjIjx4YFAlKyq2RdBQFkCMrtoEkfsc8cdOrtHO0ojWVSHFUcId2lH82LaoXQ3VbuVeAK1/DSWNaVmaAXQcGkS7Hm3yYnTJXNAKHzmoMbVzG2QN49urZ8N1bJNDNabiBMh9tcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=XYJd3TlR; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="XYJd3TlR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=cto7Qx3eJf8iHrTaBb/engWdgKV0d4FlbiPtmNcbcOM=; 
	b=XYJd3TlRGYonCeCeh5p6MSsquoyP+M9PJ5njhMKzZzymmN6MhoQBrFVAISqQw2e7Dm6EOKJWUar
	vGiFf83MdTvQNOiHbk+UhKmxlWtxX+pj0MeVGEEvCHTf0SwhfDZHiinirWNJvT7dxTlGxoOBdO4lx
	cUTjokE50w2fB3Gy5HWYpfILRkGnvBDeZ39bdg772+cLCVnjGFcUqiXrXnY+XTJA/9Io1csewaIqC
	n10Gv0n9+U/aQgRPuNBnwz+ZYih4+GBE/Hx4nn7H5NNxuck9At12VLkwVq/UeJvaU3MmQYlkUiSKA
	qBi2PyYqNWb7gs3KRTOcKBrWzQ/6Z4HBxmFw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vWRCs-00BCyw-25;
	Fri, 19 Dec 2025 11:31:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Dec 2025 11:31:06 +0800
Date: Fri, 19 Dec 2025 11:31:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Gongwei Li <13875017792@163.com>
Cc: horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Gongwei Li <ligongwei@kylinos.cn>
Subject: Re: [PATCH 1/1] crypto: caam - use kmalloc_array() instead of
 kmalloc()
Message-ID: <aUTG-tlRzFWdkLE2@gondor.apana.org.au>
References: <20251121024456.47381-1-13875017792@163.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121024456.47381-1-13875017792@163.com>

On Fri, Nov 21, 2025 at 10:44:56AM +0800, Gongwei Li wrote:
> From: Gongwei Li <ligongwei@kylinos.cn>
> 
> Replace kmalloc() with kmalloc_array() to prevent potential
> overflow, as recommended in Documentation/process/deprecated.rst.
> 
> Signed-off-by: Gongwei Li <ligongwei@kylinos.cn>
> ---
>  drivers/crypto/caam/ctrl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
> index 320be5d77737..81583251b1f6 100644
> --- a/drivers/crypto/caam/ctrl.c
> +++ b/drivers/crypto/caam/ctrl.c
> @@ -208,7 +208,7 @@ static int deinstantiate_rng(struct device *ctrldev, int state_handle_mask)
>  	u32 *desc, status;
>  	int sh_idx, ret = 0;
>  
> -	desc = kmalloc(CAAM_CMD_SZ * 3, GFP_KERNEL);
> +	desc = kmalloc_array(3, CAAM_CMD_SZ, GFP_KERNEL);

This is pointless because CAAM_CMD_SZ is a constant.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
