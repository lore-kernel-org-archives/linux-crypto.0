Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0469517D2;
	Thu, 23 Oct 2025 05:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761195623; cv=none; b=q4eRy9Ro8UOdQqqHHA5yo9lRSFg53z0Eqx8Re1UfBm+V0nNZ7KnQVJZjjzKQasAcuZFbfUAE66ns9A6bLy0jww6rTbQhR1acN2iL+TajI/ZBWjn2XvTqJkMRDaztW8hLvDZ7JWflDA2GLnOd7KsaRpEvKBPrdkw9PIX1HI9DlLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761195623; c=relaxed/simple;
	bh=bCUsfrvnl5tzAdLqAh/Q8jAN8SGBg3IcsNEzAV9w1yg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=em4QKPt9bQknIqgTJa1G2KQnBEpgEUJ0n2Tm81AB2Tcj+8YNr0c115TRWi1RoNmd5yBgmd9VMXzKTxEpP6EgGTSvgkzxIiwVwdj0uJIoAHNAKwFdVEqt5tG8IWO/0fI+aacrKuD2tZAMHambPlngDYEmKSzeUU73PdCH422ePzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=EsA98BBU; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="EsA98BBU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=rF34TyMXjGlqnz4VoV+LRea+gcOnSTSfnchR0MLkbZU=; 
	b=EsA98BBUcYgv90WePfYVkp5iIZthfKbwWg4eggacbq4SONi8muRl+YN9cltdyaMsUCQFz3jPol+
	pUvs7UBgJTm7cP59uCeX0R9wqsbW7lErcPvdDGfLeqv6HY7/YizAQ93zSqD44H6lN/aGillTp8eYd
	/frAHlzZYM2jbV5PSE+1JGJUKVWMpSSw5EEsswH3uK7mQzCaS+YWROb2+ORckfbbhSxq0w8kq/tAQ
	qYZG8PdNpz8vOvqFapaoAS6c5o7D4MQILJu41yJbChb3EfeIdnTUmYxvoxsNKnO1vrvo4vrPn4OfH
	/4wEe+7SCUm5FQmrEz8Xj1DWqls8gRo/thGQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vBnQc-00EsHx-0p;
	Thu, 23 Oct 2025 12:59:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 23 Oct 2025 12:59:58 +0800
Date: Thu, 23 Oct 2025 12:59:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Haotian Zhang <vulab@iscas.ac.cn>
Cc: neal_liu@aspeedtech.com, davem@davemloft.net, joel@jms.id.au,
	andrew@codeconstruct.com.au, linux-aspeed@lists.ozlabs.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: aspeed - fix double free caused by devm
Message-ID: <aPm2Tql4npKIokVY@gondor.apana.org.au>
References: <20251020101109.1030-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251020101109.1030-1-vulab@iscas.ac.cn>

On Mon, Oct 20, 2025 at 06:11:09PM +0800, Haotian Zhang wrote:
> The clock obtained via devm_clk_get_enabled() is automatically managed
> by devres and will be disabled and freed on driver detach. Manually
> calling clk_disable_unprepare() in error path and remove function
> causes double free.
> 
> Remove the manual clock cleanup in both aspeed_acry_probe()'s error
> path and aspeed_acry_remove().
> 
> Fixes: 2f1cf4e50c95 ("crypto: aspeed - Add ACRY RSA driver")
> Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
> ---
>  drivers/crypto/aspeed/aspeed-acry.c | 2 --
>  1 file changed, 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
