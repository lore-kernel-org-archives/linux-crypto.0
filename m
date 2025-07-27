Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBA128FD;
	Sun, 27 Jul 2025 12:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753621073; cv=none; b=aoiGynfOfKuPD+MNcieJ7KYRR2YtTvbVtjyEJ5RXRVCnDKBlNa1EHcm4g621/wQaXWoaTlSv63edIo0+GexzKZIpVGtDenl8p7Fb//71ezDEuE3EK8seFGiVkUT3gWeQ+hhMFPpLmuIKSl02RfIl+3Werb620+sjbnyRp+ukKXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753621073; c=relaxed/simple;
	bh=IvCizYcDwHiDsFf04piNnMA55p2aNJsLUQESwW6MTsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O9VW9tzdhNG5wA8rV15rsOwvQqn2pyCRdSSunnQQEQFNE5xEPRrzQtaxcCM/PFZAu9ZGEu3jYyO4KH3Xjdhb86PEvgaJItbt7oTYwxxMS+1/0AXLGxLPF/Q/rIcCmvnN6zM9UwljOLLlqtdMbieN4AIQHOfrS5GTi9ZebZ4g6/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=fy44x/Zk; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="fy44x/Zk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TIbSLMVsIGlR8EeqqJMWrLX9fXRrDkNrAXFBaye/Mso=; b=fy44x/ZkjDjKcYQ5WN7MwZe0bQ
	hLDru8+bUuKthHCMyaUInsVW1pWwjBlt7Boh6NHBYq7uFDaL2RMAXcrbW3VcmelKf53iCEDyo4NLo
	Cn2Yn36eyRfC4Nt4Z3LiVYc8VoWXyRyRhxTeqzpIJZoV14oqx26GSehIGbP95Tol6VAg2hXvHfkoK
	nvzpiIwSCnbjCSUdMS8A2asBQp5gDjeOguJcCR+88A2YeHpdWmLFMQNSZnyZfPrzvOwoGg2TdqhoT
	7edvDPuvlCwWhAwKXz41DWfCou+L/+sTLnzQWQIZjCdnV6H3PTlWiBh+USRAdnofJ/0UBXukWUXLK
	bG+slKMQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ug0NY-00A4o1-2J;
	Sun, 27 Jul 2025 20:37:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 27 Jul 2025 22:37:21 +1000
Date: Sun, 27 Jul 2025 22:37:21 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
	Declan Murphy <declan.murphy@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Mark Gross <mgross@linux.intel.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: keembay - Add missing check after
 sg_nents_for_len()
Message-ID: <aIYdgavU9NwSZY72@gondor.apana.org.au>
References: <20250716122023.67129-2-fourier.thomas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250716122023.67129-2-fourier.thomas@gmail.com>

On Wed, Jul 16, 2025 at 02:20:19PM +0200, Thomas Fourier wrote:
> sg_nents_for_len() returns an int which is negative in case of error.
> 
> Fixes: 472b04444cd3 ("crypto: keembay - Add Keem Bay OCS HCU driver")
> Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
> ---
>  drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
> index 8f9e21ced0fe..c75fd7c68fd7 100644
> --- a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
> +++ b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
> @@ -232,7 +232,7 @@ static int kmb_ocs_dma_prepare(struct ahash_request *req)
>  	struct device *dev = rctx->hcu_dev->dev;
>  	unsigned int remainder = 0;
>  	unsigned int total;
> -	size_t nents;
> +	int nents;
>  	size_t count;
>  	int rc;
>  	int i;
> @@ -253,6 +253,9 @@ static int kmb_ocs_dma_prepare(struct ahash_request *req)
>  	/* Determine the number of scatter gather list entries to process. */
>  	nents = sg_nents_for_len(req->src, rctx->sg_data_total - remainder);
>  
> +	if (nents < 0)
> +		return -nents;
> +

Why are you return -nents as the error? That makes no sense.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
