Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44C92BD030;
	Fri, 18 Jul 2025 10:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752836212; cv=none; b=h3oY3gDMppLO03K+x5iOAeLAD8gPpj2Fi2DIC+0DOiGKMWcOM86y1+grr6/V0sd0LtNrYzkWHIt1jZKrRgO4/L1GUb0NuA3YJ5ld9aUSzAUQYx+MyHIUsBJ5RF7N7K8he4p04xK8PyJyt9k6Q+mg2i3+wQsxuzXlUd2Mi3vvopI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752836212; c=relaxed/simple;
	bh=cWyNBmZBUvg+UEuS9SkMevXaT0YIyT7SuHl9Qo3gw+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FGSO6VxH9dT98sefpOEBlfMMs7RstsnrS0W000NF+Rr7fc1wSd0Pn8oECJ7PDTFD2rnV+DJbOwfVSp7/2HNlKZcWkIDZDswmh1+LcIKglK36csTsUPJr2Mq7OgO6r2NHh++HFyJXThJATe6dK0vKjfDajID6/d5j96ECjlhu4NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=XNAO9B2Z; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="XNAO9B2Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uWsYpvvkHknkEvSH/krRFPXv4OFYUiVyo4NMAy6ZJco=; b=XNAO9B2Zg/3hYEWgmg3IWyblxV
	5G9w5q23yBq9Y2WY7rH9kPhvd9uNdLqg8oFYmw7yU80dSIWboTefpO6MzXiIINRCUt6WxthOzNEpe
	9ltT7Mar5+nnaBIw/R+zEX5uqXsvoCV+DB/BANPIKFV+bagUGIikX1i5kxhhadxTf73XikrjgpYof
	/Au+9dH3m5bybR4bsO/jw6DbK855G6PPJpsUmX3lAJIZiPtN+4YRrPz5uYUlvwLb6H1DFOnpzEKxX
	fOqo47FhavMpPXbyKDbpzn0ExIdWS+jvfZ7WCXZ/KQCYvMaozcbrZT0wCGokC2nrVoZqGhZJ+xV6E
	DbtmWuPw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uciWD-007yWb-2i;
	Fri, 18 Jul 2025 18:56:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Jul 2025 20:56:42 +1000
Date: Fri, 18 Jul 2025 20:56:42 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andrew Bresticker <abrestic@chromium.org>,
	James Hartley <james.hartley@imgtec.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: img-hash: Fix dma_unmap_sg() nents value
Message-ID: <aHooajz6jhWjXrpf@gondor.apana.org.au>
References: <20250630091623.75655-2-fourier.thomas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250630091623.75655-2-fourier.thomas@gmail.com>

On Mon, Jun 30, 2025 at 11:16:22AM +0200, Thomas Fourier wrote:
> The dma_unmap_sg() functions should be called with the same nents as the
> dma_map_sg(), not the value the map function returned.
> 
> Fixes: d358f1abbf71 ("crypto: img-hash - Add Imagination Technologies hw hash accelerator")
> Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
> ---
>  drivers/crypto/img-hash.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
