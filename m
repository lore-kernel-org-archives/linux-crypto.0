Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7113B2D38;
	Fri, 22 May 2026 12:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779453348; cv=none; b=YQ7FkMIwWnTSjwOg4D+LhFGmY1iOeb/nPT147zxtNYsX2sM1GvyVgF8fxJyi3VXrp9BfLWPiDGDKjf8OXHm7v3lf0bYm9GA/beS6UzehRCkbmV+la2o403ADrOq2VAVIZ79WVzhIoxeFEB0YBbbKthjTxaYvkCZsJh9BEoKt5W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779453348; c=relaxed/simple;
	bh=kw9uZ9m6tF+Ji0vprBuUH9Dc67gYn9D9OZqiM2HIUjo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iqHTrOib2H0Qvzm9EeFkEiDJmp9gnkKj4dooqp1t5yl06x0uHkj3JLn09xn5DpMvxMw8wfuOm6luTzQ24Zn3BDay7rIdE1D5gjcO2xTbakPWpZ1ceDdMrj6U9NDjjbwGPvhRm3T/SvCLjZyv1nYi02M3O83JdIeKZaNG2wuz4n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=DFJf8q8t; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="DFJf8q8t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=40x3YMkXHB7EIKE+6w8LG+ZZYMkKriai3kE5XhMZBHQ=; 
	b=DFJf8q8tvPFS8QaSC7xoSUX2JLEpfeZj5AfHBf7FwycZcnwumo/li0/cRmQxJmIPDe5rcAIjqso
	AUzDWDfYT98kVHyiXX6PXI0kJI3B7HvB2uKJk/V30Jk0ygLxRIl4ZxKsSZYzjsheDy3Gyk5UZLa4A
	zc/CCqT9jetTfEIZHhqzCk7Cpn38oYibNxNG1Ex8T+yOKCYH+N6ehUE76NIsEFMhUbYKXucxNmFFl
	g/zqEAI0Zt14eYaSTASWbJZt6MNYAdrGnZKvoayPW9ZrTK137UAi6VeJV8LCAu1kQCSrqluGDJuXb
	mw1L7uDHa505m5/jKHbZGm9mAVxextO5zh6w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wQP6L-00GSWI-1O;
	Fri, 22 May 2026 20:35:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 May 2026 20:35:41 +0800
Date: Fri, 22 May 2026 20:35:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] crypto: omap-des - drop of_match_ptr from OF match
 table
Message-ID: <ahBNnVekxpR1uH6J@gondor.apana.org.au>
References: <20260517103651.1135679-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260517103651.1135679-2-thorsten.blum@linux.dev>

On Sun, May 17, 2026 at 12:36:52PM +0200, Thorsten Blum wrote:
> Drop of_match_ptr() because OF matching is stubbed out when CONFIG_OF=n.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/omap-des.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
