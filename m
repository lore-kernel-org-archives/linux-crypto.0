Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A961849
	for <linux-crypto@vger.kernel.org>; Sun, 16 Jun 2024 05:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718516637; cv=none; b=Io3LF6tFuM+qtU9Poif9kw77/mBJCxlKctA5aZxiITRiIjj0dMyS7FSZ3smlKCo8oplDys+MLtLMvrbrKytCrKds6V9p7wSuoFoYlGqXQj3kx3WMuwG25sIFylFMWHnq/bG7nhPDJjADL67FZP1xTQcRIxxmRiF9xbL3dntZuIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718516637; c=relaxed/simple;
	bh=nv0C7cAMy4mXWUd9aEYw1l//aBgVLKSITF8mLgLlksQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HT0syguPgZwGrBBvjoNF/1ZhcBdkCvIvcNBY8cuPhaQfzv5g8VplbQ+aOoacaQmWD8ZowWp1AKD1oWF8Ymkol5Na/kDWpmwvubyV9tFay5uHWP2XWLoC5zoHejImRVFcK8mNwDiUrzDR1xvk5s4K7dZK+5Bii1Q/Unr2fLTMVPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sIiZ7-000aHO-0Q;
	Sun, 16 Jun 2024 13:36:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Jun 2024 13:36:33 +0800
Date: Sun, 16 Jun 2024 13:36:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Portnoy <sergey.portnoy@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH v3] crypto: tcrypt - add skcipher speed for given alg
Message-ID: <Zm554XxuZpQbtx-k@gondor.apana.org.au>
References: <20240607143128.2740633-1-sergey.portnoy@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240607143128.2740633-1-sergey.portnoy@intel.com>

On Fri, Jun 07, 2024 at 03:30:48PM +0100, Sergey Portnoy wrote:
>
> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
> index 8aea416f6480..880d427bdb3f 100644
> --- a/crypto/tcrypt.c
> +++ b/crypto/tcrypt.c
> @@ -1454,6 +1454,8 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
>  	int i;
>  	int ret = 0;
>  
> +	u8 speed_template[2] = {klen, 0};

Please move this inside the if block in case 600.

>  	switch (m) {
>  	case 0:
>  		if (alg) {
> @@ -2613,6 +2615,14 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
>  		break;
>  
>  	case 600:
> +		if (alg) {

It should go here.

> +			test_mb_skcipher_speed(alg, ENCRYPT, sec, NULL, 0,
> +					       speed_template, num_mb);
> +			test_mb_skcipher_speed(alg, DECRYPT, sec, NULL, 0,
> +					       speed_template, num_mb);
> +			break;
> +		}
> +

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
