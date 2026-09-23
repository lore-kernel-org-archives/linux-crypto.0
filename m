Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3DA3FFF94;
	Wed, 23 Sep 2026 08:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153281; cv=none; b=g4Ml5YiTPI414iRUnYZAtJTLq+6BFlvRhS+cvo69aLLSvc6uGFI2iHIuwyMK9qM4q8MyKakeonUtYXXfzJwKo4s3Wusu7fgdx39jIzzUkXp9Ha49JC0bUQc7AQcKapEhYAaf/Y6aVOOewzr9KMRQi1rQ9IQupgAPZdMI9qjdgi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153281; c=relaxed/simple;
	bh=gOCrfM1ZgB3A30nhF2vhNDrTIz6510YJeMwBpqVFw2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fegA1QXnefQ2OJra8+omrvpjYiUFVRxe9u8RPRdjW7hPKKgm48GNLgudUKGzTDhfK/67YrdpH6Q9WbkKN4w7uTXLM017YWXfdS5uebekJDLUgxK+tbPvbu4ru3Xr71DTnML/gLVZ7D3PfuK2n3QdyFx+gp6Zl3iNLam7fgK/2Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=AigEOVZZ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="AigEOVZZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=fzOjKS8XrMIrowClrcHFVe4+hqchnAhPz+nCX2EULNg=; 
	b=AigEOVZZvsyU7sopPZdcbJnWb4W3LzSzGl3HIH2lnN8p4e00UwE9SKzx8EChxM/GFFHVvtKOVrJ
	T4pw0wO3UgAFWMPvsQkyQrjaR7QwKXbHvxedKZp66Y5JkSESxvVWwvMZOFIQZKqdMtaGL1t//OB2W
	MyYJz5sfEcx0pWk8FUSy6do4MHJ1BBdYrFpwhIqpVvhGx7tqgVkz4yD8Wu6cYdS2/+HCDciCkeche
	y+h7de7TXCWBxXiHHIxTAZO8BkPV2sGT8Q5zQ4dsHS7KuLl8VGLQ3isY6k0B9qEPXHhr0H7yOyOk4
	mR/b7yNASKzJgzmvGpjEc2QXucV0kiD6ggTA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x9Idu-0000000GyAI-3Drb;
	Wed, 23 Sep 2026 16:47:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Sep 2026 18:47:54 +1000
Date: Wed, 23 Sep 2026 18:47:54 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: sahil.malhotra@oss.nxp.com
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Varun Sethi <v.sethi@nxp.com>,
	Sahil Malhotra <sahil.malhotra@nxp.com>
Subject: Re: [PATCH] MAINTAINERS: update caam crypto driver maintainers list
Message-ID: <arOSOlAyfJv4wJ2n@gondor.apana.org.au>
References: <20260914041436.3910000-1-sahil.malhotra@oss.nxp.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914041436.3910000-1-sahil.malhotra@oss.nxp.com>

On Mon, Sep 14, 2026 at 06:14:36AM +0200, sahil.malhotra@oss.nxp.com wrote:
> From: Sahil Malhotra <sahil.malhotra@nxp.com>
> 
> Adding Sahil Malhotra as caam maintainer and removing Gaurav Jain.
> 
> Signed-off-by: Sahil Malhotra <sahil.malhotra@nxp.com>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
