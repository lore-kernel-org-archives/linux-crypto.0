Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361E720550D
	for <linux-crypto@vger.kernel.org>; Thu, 10 Apr 2025 07:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744270988; cv=none; b=ZWBK6RmY7TOxTIK6z4eyH3uz95sGhWdIhAOuZ0utpYjzNOFdo3uGtvvtEGqyw+56V5WB9rUoyvvCmNSaKdbtp/FlP4l6+mD5C3wA/ThZGp/lY/T77llL0a703mZVp/t5n8AGmx6ecAxDeFQ5MF58o1s7UNNJiFFX/0HCNGrKG+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744270988; c=relaxed/simple;
	bh=F0Q0umxvPCEsGrrwJkU0/MUDJ2e8Ao9fo+lz1nqo4Tg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VgvzsMs2YadgRmcTQdFGHsNatuE1QGi0htnw2zr3L+jUhYPCQpXFivtknGd6+MhemeYQxv7yabfakyXVP9H+DyP9KL7T2/OW7AWqLdfAETgBXGxqOCI7OVR/2rVLTbo1JcTkuGMIpXe0sKMLlvnP+OF9PT0jQ3cH7dwZpAu3Yp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=gCiNLKM6; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="gCiNLKM6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+PIpMAWLwgP8XaU0st9wLlONfCFrdoYGt6FMJeS8v+4=; b=gCiNLKM6JXpltYkDzBoePum/5Q
	NNGKz53YHexTDwmBP3666sm6fjXb7mODxZKmzdrXB7rh3fCSavsI0pYGHqhPqY7xXthP+3K8YonYC
	nP2x0M+dr3sZkvrOaThucm4eTUHWdSJbqslO6Z2WHKonn/LetaCUfBQ3hL8du9vCbW8xrhd37nzQ6
	cUo18LZ4GB00oKVkNcsYAdmHICRPYg2AVp2lP/J7OjC7u80aIkbByWMGvTfTt1QlLSlHficnm+5uq
	KL+PWNnO6m/C5QI+XL969S3tSXhMTbuMNEQGLbeQTVMoJKlS7O8X0Dhby3k+py86iKTYR3YgFhrVE
	gczaKq4g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u2mYn-00ESnF-35;
	Thu, 10 Apr 2025 15:42:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 10 Apr 2025 15:42:53 +0800
Date: Thu, 10 Apr 2025 15:42:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-crypto@vger.kernel.org, Olivia Mackall <olivia@selenic.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Avi Fishman <avifishman70@gmail.com>,
	Tomer Maimon <tmaimon77@gmail.com>,
	Tali Perry <tali.perry1@gmail.com>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, openbmc@lists.ozlabs.org
Subject: Re: [PATCH 1/3] hwrng: atmel - Add a local variable for struct
 device pointer
Message-ID: <Z_d2fcuWPiel_OnT@gondor.apana.org.au>
References: <20250410070623.3676647-1-sakari.ailus@linux.intel.com>
 <20250410070623.3676647-2-sakari.ailus@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250410070623.3676647-2-sakari.ailus@linux.intel.com>

On Thu, Apr 10, 2025 at 10:06:21AM +0300, Sakari Ailus wrote:
> Add a local variable for a struct device pointer instead of obtaining the
> hwrng priv field and casting it as a struct device pointer whenever it's
> needed.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/char/hw_random/atmel-rng.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
> index 143406bc6939..5192c39ebaeb 100644
> --- a/drivers/char/hw_random/atmel-rng.c
> +++ b/drivers/char/hw_random/atmel-rng.c
> @@ -56,12 +56,13 @@ static int atmel_trng_read(struct hwrng *rng, void *buf, size_t max,
>  			   bool wait)
>  {
>  	struct atmel_trng *trng = container_of(rng, struct atmel_trng, rng);
> +	struct device *dev = (struct device *)trng->rng.priv;

Please stop using the priv field and instead add a struct device
pointer to struct atmel_trng.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
