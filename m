Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F5C152166;
	Fri, 31 May 2024 10:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717151112; cv=none; b=ZoqB06n2OkfibiEPJLalzQAc2TreH/mgBg8ra/tIJgqw5SidM2AxsF487SYTYauVq1v0ruGXX9w/eDKbfoqVKQYKKNSfM6qmJ8WKh1JRFESOZH/pd3/RHCB6RcIo9ti6GNVbHBr/93+jZ6uHOh2WaevPbFH1QHGu4D/DYDuIn1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717151112; c=relaxed/simple;
	bh=SpVb3zXMO4QqG/nwzrQQk/Z4Nf2OeOEBLKzG1FZZsHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PHxWngAmyJC9RyecljdiZMrltF3ngyrqg8OZMkpmodpapyudPEKf3t3exSyddbfGvusxwWpHwfDkLa+pij7PPDphIVEsgFMMD89qxn9Ws2ZuA+hPwWLFef2wHjM0+O3GPLSloNWnL4euVjsHka0QJyTTT+jv+NLYX8SHvouY810=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sCzRM-004ApZ-2M;
	Fri, 31 May 2024 18:24:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 May 2024 18:24:54 +0800
Date: Fri, 31 May 2024 18:24:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lothar Rubusch <l.rubusch@gmail.com>
Cc: davem@davemloft.net, dan.carpenter@linaro.org,
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-sha204a - fix negated return value
Message-ID: <ZlmldrSVt0CWVlzX@gondor.apana.org.au>
References: <20240526103128.14703-1-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240526103128.14703-1-l.rubusch@gmail.com>

On Sun, May 26, 2024 at 10:31:28AM +0000, Lothar Rubusch wrote:
> Fix negated variable return value.
> 
> Fixes: e05ce444e9e5 ("crypto: atmel-sha204a - add reading from otp zone")
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/linux-crypto/34cd4179-090e-479d-b459-8d0d35dd327d@moroto.mountain/
> Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
> ---
>  drivers/crypto/atmel-sha204a.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
