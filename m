Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD1639FF3
	for <linux-crypto@vger.kernel.org>; Fri, 31 May 2024 04:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717131401; cv=none; b=Y5BlfIzMBvKIUt63Elc1uJfMZb3siXCOHD9mSELi9hDfS/TyZLxpiJbS/7JMLPSlqS9riPrUtwODyh85mTTzcl5667iEVRCq0+dTO8v2HGhY/6iVJwxOyueB245QvkRRdtFByHySfFWByEdmrYzy5nz1/TVU/jIGhzMka7S+79c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717131401; c=relaxed/simple;
	bh=oUSfH7BB8Ba8OjqDBI4dXXmeWzEOuf3JoL26+Yptlxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FzeD8DJHRPYsU9rDN6ZEL+omwPlaOYjP3A1nva/qgcEFwQtcXQhkVI/7OoD3UEv4w6rsb4Rnr0PRIUhh78/Jy150t4l3T6wE6SSnCjkIFe41eN1JjfZCAoSymud8f4dor/OLKjMZdqmcScxBcsI42fetdiLBdUWp7MfrtPTVtW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sCuJd-0044Tm-1E;
	Fri, 31 May 2024 12:56:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 May 2024 12:56:35 +0800
Date: Fri, 31 May 2024 12:56:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Portnoy <sergey.portnoy@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH v2] crypto: tcrypt - add skcipher speed for given alg
Message-ID: <ZllYg8fCd3dWpnq5@gondor.apana.org.au>
References: <20240510154405.664598-1-sergey.portnoy@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240510154405.664598-1-sergey.portnoy@intel.com>

On Fri, May 10, 2024 at 04:33:15PM +0100, Sergey Portnoy wrote:
>
> @@ -2807,6 +2809,16 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
>  				       speed_template_16_32, num_mb);
>  		break;
>  
> +	case 611:

This should be case 600 and it should do both encryption and
decryption.  See the existing case 400.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
