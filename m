Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA917175D34;
	Fri, 30 Aug 2024 10:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725014215; cv=none; b=T7U56YN/PFtVhghxZgdb0kSddRjY2rcjP5Vsv+UCJuT5aiCKJNvF1DMY4QY1adaYvFfeXOYoCzYpqyHV8oAfBkMpxXtQuBJ3RJUGq4yDc8iADWruULKU3oeAaIn/yMNySxpo7Mteegd2+lMz2J8V4rg5YDX1TyOUWR9d57u9V4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725014215; c=relaxed/simple;
	bh=E1WdfCvlI/aTa780Ydvt3ulJ3p7eoeSZLszJBUoQbQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NPwDf3JWSk4f4GRkK2WreNtEtMDlgdr64wiJvkEJHNi+AcSlEcYBzQlLTUDv6kyhwNrPYpFrubXHNPOxoT22TJO1bHvFrDfrQ9acBCCezeKBbcsLSa+oFAQMzUCwqrvnt74OGwsU0rndKr45Uikqy65D/lTuA161On/P5+TVvX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sjyrD-008Uop-2c;
	Fri, 30 Aug 2024 18:36:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Aug 2024 18:36:40 +0800
Date: Fri, 30 Aug 2024 18:36:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huan Yang <link@vivo.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	opensource.kernel@vivo.com
Subject: Re: [PATCH] char: mxc-rnga: Use devm_clk_get_enabled() helpers
Message-ID: <ZtGguPBIxNCVcQ0M@gondor.apana.org.au>
References: <20240820094715.104998-1-link@vivo.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240820094715.104998-1-link@vivo.com>

On Tue, Aug 20, 2024 at 05:47:11PM +0800, Huan Yang wrote:
> The devm_clk_get_enabled() helpers:
>     - call devm_clk_get()
>     - call clk_prepare_enable() and register what is needed in order to
>      call clk_disable_unprepare() when needed, as a managed resource.
> 
> This simplifies the code and avoids the calls to clk_disable_unprepare().
> 
> Signed-off-by: Huan Yang <link@vivo.com>
> ---
>  drivers/char/hw_random/mxc-rnga.c | 16 +++-------------
>  1 file changed, 3 insertions(+), 13 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
