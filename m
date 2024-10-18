Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B51192D80;
	Fri, 18 Oct 2024 09:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729242738; cv=none; b=P0SWPnaAZjreEPnX3kQBdCU88mGlNehFDqKlYk40i5wQSndY2OIlIhDfhvzp9pvpqLL23WtM8eBOULv70eQZjAUYSIPSQmWtcWXhFj8gy4OXmFuhOhQblhxlzRhy0eBje1YVGCIDPW+ZOhfhVxdPCxaLSst7MPTUnGHEOL1Am8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729242738; c=relaxed/simple;
	bh=zE4UJX0DQg5iLNO8vUisZmynRQin3yWBZdnm958yxVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oasg1BeGD+LcDyA9TCELU/L1r5mIXwyIbNqo+SSh/u7F5w4feyOW60v/HVMvVuzL1NluUODZ+A1xClaeRsN8vulQjqDNPgGb7FZmEYK+rLH8Vk0FWkRDv09H/upQfHWT4iruMiKkzFWk3xx4NV0g8D/Uys2dHfDK5JPesBDcUhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=an0Y0ORr; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="an0Y0ORr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=J5iQwSXj0fx9ssO/n28CCScHI4RHA/e3Aaym5mPbBFc=; b=an0Y0ORrRtT+ode6i3VgxYT2mV
	2LUB3/7A4ToFcotvwyHhDcB+WrWqjuegdYAH1ppPNTSdXYK+94gIjviiXmhqQa0IyXPe5TEYBxg0W
	QaH9hzERMHv7Qh9MmFSD4eI8h//2aPEdGG9P70kMvEI2VQvdsah9NOXmRMjoAN4DUIbk0PvF/PErk
	Uec8ItlePmXbG6cebeMM35v9cAXXdeWKAllGgC9u7y1mlr/3GBzHA5bolD2F5Sn5D0p/OwtMxkRNP
	x1xxEORbqnEOOKvNJ/Km4hYDGBeS6iLMsjuFQ3sgrz+8o89ygNzLfnrfpIBT5bzx0+X2au4jA2gOe
	yF1xAiKQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t1j1b-00AKvO-1Z;
	Fri, 18 Oct 2024 17:12:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Oct 2024 17:11:59 +0800
Date: Fri, 18 Oct 2024 17:11:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, Boris Brezillon <bbrezillon@kernel.org>,
	Arnaud Ebalard <arno@natisbad.org>,
	Srujana Challa <schalla@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 4/5] crypto: cesa: move loop to mv_cesa_put_sram
Message-ID: <ZxImX3HsbFHD7vSl@gondor.apana.org.au>
References: <20241010194517.18635-1-rosenp@gmail.com>
 <20241010194517.18635-5-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241010194517.18635-5-rosenp@gmail.com>

On Thu, Oct 10, 2024 at 12:45:16PM -0700, Rosen Penev wrote:
>
> @@ -566,21 +572,16 @@ static int mv_cesa_probe(struct platform_device *pdev)
>  	return 0;
>  
>  err_cleanup:
> -	for (i = 0; i < caps->nengines; i++)
> -		mv_cesa_put_sram(pdev, i);
> -
> +	mv_cesa_put_sram(pdev);

I think it'd be cleaner if you introduced a new function that
did the loop and kept mv_cesa_put_sram as is.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
