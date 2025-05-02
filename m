Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285F19443;
	Fri,  2 May 2025 13:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746190892; cv=none; b=WNFHe6aDjabqnjbd0xlTfQMD1GgU4AKLxDmaJgwNeHCZTlofkRY1IGfEAtSE+dmJKtuym5xY53j+FcA336u5zeSx6e5EYz/TqQSDJohjTsZRBFpmBzNWTjHmTgK3uYEcAzuOrhED9S70Wv+FuSJ4CMwmKHuEkhTnD+mbBicSTww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746190892; c=relaxed/simple;
	bh=ek4FYCAhWkyoOutNwtaGJ7BUUqCccletkMKY3K1pw3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F95pn2jdOx+e2vOrGLEDq0pscBEhUOzOT/lxOzefb1W4ZJ7F3YjNZEaBN1d7gHZVKK7bEv+InWtJVED537/YFat7s4hGdp/ivojIlRJ1BYerYFvdibFJaWDpOKDYc2VqYVBfOhVHeTvwdWYR5yK7WEcGZD6alRyTC+hAXMaf/7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=VVneC+Mv; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="VVneC+Mv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dNHJTJsLPA987js7JCVcmAoECKxJhc5CPxkSrYINjNM=; b=VVneC+MvyoCM8ht6JVraAaXi09
	xJduNxDl3OEIdC5UGRJIiw7XRFNj+A0qz858PJq9WdOCM90z9/U9UzSE78m+IkwvZVnvz/tt1kRAT
	L9BaG0KOEuI3wauuuFvJ2STpNoL6TMnQmsQa+jwOmhaZ1zR85SkkYVlITBl3xp4puTY7CLXm/LOGG
	RgA4iEJ1C9F9H0OzhWZxw0woBmRlVaRQFbjWtxnwwQhq+qvhT56jB9xDCjKC9V2EoWAEltj+IN5OW
	68knbh1w6VOVXTZmdpc9mMfcfpNARKpbwvw6rBgO53q3tftfKc4ydHn07G4coq1zj5qHoVYGYJKUO
	prSsyeow==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uAq0z-002qyO-33;
	Fri, 02 May 2025 21:01:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 May 2025 21:01:17 +0800
Date: Fri, 2 May 2025 21:01:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 2/2] crypto: ti: Add driver for DTHE V2 AES Engine
 (ECB, CBC)
Message-ID: <aBTCHeChXenAQrBH@gondor.apana.org.au>
References: <20250502121253.456974-2-t-pratham@ti.com>
 <20250502121253.456974-4-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502121253.456974-4-t-pratham@ti.com>

On Fri, May 02, 2025 at 05:21:17PM +0530, T Pratham wrote:
>
> +static int dthe_aes_crypt(struct skcipher_request *req, int enc)
> +{
> +	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
> +	struct dthe_data *dev_data = dthe_get_dev(ctx);
> +	struct crypto_engine *engine;
> +
> +	/*
> +	 * If data is not a multiple of AES_BLOCK_SIZE, need to return -EINVAL
> +	 * If data length input is zero, no need to do any operation.
> +	 */
> +	if (req->cryptlen % AES_BLOCK_SIZE)
> +		return -EINVAL;
> +
> +	if (req->cryptlen == 0)
> +		return 0;
> +
> +	ctx->ctx_info.aes_ctx->enc = enc;

You can't modify crypto_skcipher_ctx as a tfm is shared between
multiple request objects.  If you need to keep track of the operation,
it needs to go into the request context (skcipher_request_ctx).

As a general rule, crypto_skcipher_ctx should only be used to
store key-related information and it can only be modifeid by
setkey.

Anything that is per-op should go into the request context.

> +/**
> + * struct dthe_data - DTHE_V2 driver instance data
> + * @dev: Device pointer
> + * @regs: Base address of the register space
> + * @list: list node for dev
> + * @engine: Crypto engine instance
> + * @dma_aes_rx: AES Rx DMA Channel
> + * @dma_aes_tx: AES Tx DMA Channel
> + * @dma_sha_tx: SHA Tx DMA Channel
> + * @ctx: Transform context struct
> + */
> +struct dthe_data {
> +	struct device *dev;
> +	void __iomem *regs;
> +	struct list_head list;
> +	struct crypto_engine *engine;
> +
> +	struct dma_chan *dma_aes_rx;
> +	struct dma_chan *dma_aes_tx;
> +
> +	struct dma_chan *dma_sha_tx;
> +
> +	struct dthe_tfm_ctx *ctx;

What's this field for? It doesn't seem to be used at all.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
