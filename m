Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CAF15C12D
	for <linux-crypto@vger.kernel.org>; Fri, 30 Aug 2024 10:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725014861; cv=none; b=TG5zRRxn6KimszZOiwSqBCEFFI4UP19TyuJWMySHeJt3R987zK/5Chuvb+38N6MdXfaJdGOARYM6+IQQNtOOXz4fEeKalx4OkOTi5L5cssqOw6Rf6mrZZbk+fN3AlBz6CkPXJjdlJAx70VA3MQ1Nni7kIG2wapSo9XVR1ekI1g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725014861; c=relaxed/simple;
	bh=yOhZz45OQv24LwqQ2+uxsnjhyNr5vj6+AwBfU+HclYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gd3RbpoJr3aMfkdwj5aMkoChAqDB6lwDYed/RUBErkOflz/ikXXKpxK8IqkRjA+sELYihDdYslBBGQMksmzM/ygUk1Y5C2ptHyuSQr4lHWvZICDrm31byvDvhjhuMjykNxgE64GxxB4/As0ZMGI9Z4pUa9SzsCIXCg2gHrnIxag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sjz1j-008UxY-2j;
	Fri, 30 Aug 2024 18:47:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Aug 2024 18:47:32 +0800
Date: Fri, 30 Aug 2024 18:47:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chunhai Guo <guochunhai@vivo.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: img-hash - use devm_clk_get_enabled() helpers
Message-ID: <ZtGjRJSGqI6jYf-8@gondor.apana.org.au>
References: <20240823095212.2174370-1-guochunhai@vivo.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823095212.2174370-1-guochunhai@vivo.com>

On Fri, Aug 23, 2024 at 03:52:12AM -0600, Chunhai Guo wrote:
> Simplify the code by replacing devm_clk_get() and clk_prepare_enable()
> with devm_clk_get_enabled(), which also avoids the call to
> clk_disable_unprepare().
> 
> Signed-off-by: Chunhai Guo <guochunhai@vivo.com>
> ---
>  drivers/crypto/img-hash.c | 21 +++------------------
>  1 file changed, 3 insertions(+), 18 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
