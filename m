Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516DE79945;
	Fri, 10 May 2024 09:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715332733; cv=none; b=pXSGBVilwmSbz7+ueLAXDWAHWmhQKfSlgFa/bRbJzG2XscT++oGBY05L6sDSgNwrHOLxcznw+A4keR09cyWpANgMUwQcJUo7CrZzBdUxzCYOKIonXeBKjWaZ9a4gsV2o07Xjood7UspaQP0AsKEXAr3jr+k/92+UCkeGi4B1OT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715332733; c=relaxed/simple;
	bh=lixI+BjwlLaA6e6w0KxUT+CEc2V7lTqUN0LXAN+Oc/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qPlUlbQTM/yFqAbrLEjzfUdZfQszeUBlW+PVRXikZGWl2+ViTUz7AngzgJP2tjqaClTr6m/DTFqB899bajjrMaU7FQwRmcYJlnGFuSVupC0PZ2s35G2RkBcgtYWBY5ZAhRmvhb/EZDq9RYxHbw2bNbRc0CDh2yf1yz4Q/axr9dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s5MOt-00DK99-0w;
	Fri, 10 May 2024 17:18:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 May 2024 17:18:48 +0800
Date: Fri, 10 May 2024 17:18:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pankaj Gupta <pankaj.gupta@nxp.com>
Cc: gaurav.jain@nxp.com, horia.geanta@nxp.com, V.Sethi@nxp.com,
	davem@davemloft.net, iuliana.prodan@nxp.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-imx@nxp.com
Subject: Re: [PATCH v4 0/2] caam: init-clk based on caam-page0-access
Message-ID: <Zj3meBNUj28ohpso@gondor.apana.org.au>
References: <20240429062855.923595-1-pankaj.gupta@nxp.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429062855.923595-1-pankaj.gupta@nxp.com>

On Mon, Apr 29, 2024 at 11:58:50AM +0530, Pankaj Gupta wrote:
> v4:
>  - Correct the null pointer checking
> 
> v3:
>  - Splitting the patch into two.
>  - Disposed-off comments received on v2.
> 
> v2:
>  - Considering the OPTEE enablement check too, for setting the
>    variable 'reg_access'.
> 
> Pankaj Gupta (2):
>   caam: init-clk based on caam-page0-access
>   drivers: crypto: caam: i.MX8ULP donot have CAAM page0 access
> 
>  drivers/crypto/caam/ctrl.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> -- 
> 2.34.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
