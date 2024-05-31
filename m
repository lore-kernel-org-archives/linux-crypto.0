Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CB214F9DB
	for <linux-crypto@vger.kernel.org>; Fri, 31 May 2024 08:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717144339; cv=none; b=utiPnDt70ZePSYjikA16cu6r7BpGHPMDhJgGQIPFBkXUmsKBI5D+Ay8wzC1vjaCWGh8FUI9y3VBQy06CcapRUNjxUcwFiSRXu0HI3FtPdYwBmq53Sn8qKFtkG5tLJ+IlGedIAIuGUeQg9g3wSU38xN9sCYnF1rZNRfXX2FGgjnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717144339; c=relaxed/simple;
	bh=BboyfwJDeUAKA9w3vli/v5AwG6loPmv2SYPqJBBashk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ug9Q0b1nKoySh2gUo1K8YOHl0L6rO8e1QFhgT7FZzl3KwerOgyPu1qfebh0qt5Uvsq0+L1qre901WuGC0UzOn+W5NCfVRlABVrYOHvgzmtWn97AVWMREfJcPFLxgnyQ3VYb/pzu09VJ2AzlAQDPtI7/wXjGdarBZj6j0PltW2xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sCxgK-0048Bv-0e;
	Fri, 31 May 2024 16:32:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 May 2024 16:32:14 +0800
Date: Fri, 31 May 2024 16:32:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 3/3] crypto: acomp - Add comp_params helpers
Message-ID: <ZlmLDgri4QMo6WSd@gondor.apana.org.au>
References: <cover.1716202860.git.herbert@gondor.apana.org.au>
 <7b5e647f760c4deacf81d3b782f1beee54de3bbc.1716202860.git.herbert@gondor.apana.org.au>
 <20240531054933.GF8400@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240531054933.GF8400@google.com>

On Fri, May 31, 2024 at 02:49:33PM +0900, Sergey Senozhatsky wrote:
> On (24/05/20 19:04), Herbert Xu wrote:
> [..]
> > +
> > +	params->dict = kvmemdup(dict, len, GFP_KERNEL);
> > +	if (!params->dict)
> > +		return -ENOMEM;
> > +	params->dict_sz = len;
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(crypto_comp_getparams);
> > +
> > +void crypto_comp_putparams(struct crypto_comp_params *params)
> > +{
> > +	kfree(params->dict);
> 
> kvfree()?

Thanks.  I'll fix this in the next update.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
