Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8652C15A5;
	Fri, 17 Jul 2026 08:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784276245; cv=none; b=Ki0HoLpFQKlJf1R0Jyjv54dFx8FYS84GGisCuGEzSCYjM2fGD0v446dyKhLSwDvURmTOewSOQRTzB7CDCVMiv2/PnW8QdOBstzteDYWzQOxu2K9Q/F6Uog/r1Rz6aWHkDCMVXnPYv9y/NZf6C+6Nn0gEwsVSZVruvzdTAvjLwAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784276245; c=relaxed/simple;
	bh=DT80NaJxrB/qXdT7/bBY0l71QAjKyXmTlVN4b2pk3M8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Si0iPKz2LN8Gs94D1F95SdQcx6ZpeHozD5UuKaqr7UdT1V4g//tBIteO0eNgP/t+58LAovR6dP2yN/z5AjCWXp/JZ/eIt9cdDqQ22WoFf8duozXQyNdXtobz3cwziSJMq1POTU1PiUs+ZS11P5wpPiHMVxJm9qywrn1xOZERF6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ehmHWhUC; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ehmHWhUC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=HdyH+mHN8a2J7OlMEjFJZq3VZYV32+BYv7pNQsjlN00=; 
	b=ehmHWhUC43YfLnCGY64zhfR4L6qL2mTGmKkzRDJqIJ8bFUn6kOsN/ySdcXtqp7kLhViBRo7v3dE
	hGuY2ZwGabcpaBtZ4nM2Dh2lPa7HQmPZJHzb351k8M4qHqWVtaPbFq4iexT0zddwYwP7TzvnJ/TLO
	xDrwLJ+YuGYItrq7phyJZtj4ttL2tmvZRzWKm1I9RnzToU1HVC39HhadshyrVq44xdtJse1K/fkzj
	puBpRVteH5z955KPaSm0fsjXZ2auHx2Mozkcgka6KVlBxx8YYmiqfwblHY2S12DUi3jQDxCNDCMr6
	NdNat+wdSXAuzUnDOtGmWTi+G9WC6HCPRA8Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wkdkr-0000000EOC7-0wH2;
	Fri, 17 Jul 2026 16:17:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Jul 2026 18:17:09 +1000
Date: Fri, 17 Jul 2026 18:17:09 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Narasimharao Vadlamudi <ahmisaranrao@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Neal Liu <neal_liu@aspeedtech.com>, Joel Stanley <joel@jms.id.au>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	YueHaibing <yuehaibing@huawei.com>, linux-aspeed@lists.ozlabs.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: aspeed: Propagate platform_get_irq() errors
Message-ID: <alnlBV1PwFkfpPfr@gondor.apana.org.au>
References: <20260710110729.224090-1-ahmisaranrao@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710110729.224090-1-ahmisaranrao@gmail.com>

On Fri, Jul 10, 2026 at 04:37:29PM +0530, Narasimharao Vadlamudi wrote:
> platform_get_irq() returns a positive IRQ number on success and a negative
> error code on failure. aspeed_acry_probe() and aspeed_hace_probe()
> already detect negative returns, but both convert every failure to -ENXIO.
> 
> Return the original error code so callers can handle errors such as
> -EPROBE_DEFER correctly.
> 
> Fixes: 2f1cf4e50c95 ("crypto: aspeed - Add ACRY RSA driver")
> Fixes: 70513e1d6559 ("crypto: aspeed - Fix check for platform_get_irq() errors")
> Signed-off-by: Narasimharao Vadlamudi <ahmisaranrao@gmail.com>
> ---
>  drivers/crypto/aspeed/aspeed-acry.c | 2 +-
>  drivers/crypto/aspeed/aspeed-hace.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
