Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5AE1940B9;
	Fri,  7 Jun 2024 12:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717761692; cv=none; b=BnL89OtcN36bn457SiVLa54CWO/enzm1HxROSKh5nbypa4COQH0MCCax3n/4sYalcA5JiAxvkJO5k4SHLpdr/j3Csox2O9TMRO0yhvIRaPW0e4SONtjJab0OsJkIosDcQP4rI2zc4qgSn86oSfX9FvThEEGRiLklcP+hdHYOvgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717761692; c=relaxed/simple;
	bh=eRUTZl2yY7gyNOytL3ka55tRZqlncrkaUkDeKneoA6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VyflpRsBqeUZ9+QMqJTKALMp2LQ1Ge7M23nH7tTGYG2F5UNAtB72Z9LIqNMiJYt4HtSHHLWvfoA3U82cMkYFLkDj/oMZ4fOaB2oXSt0nPoDt7pdb9MjXH23bk2w0dBv+2XEQpqK7RP13COeRkKyojoccKLMatpFM04NSvtO+UAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sFYHX-006pNJ-0q;
	Fri, 07 Jun 2024 20:01:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 07 Jun 2024 20:01:21 +0800
Date: Fri, 7 Jun 2024 20:01:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Deepak Saxena <dsaxena@plexity.net>,
	Olivia Mackall <olivia@selenic.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] hwrng: omap - add missing MODULE_DESCRIPTION() macro
Message-ID: <ZmL2kb6Wb5OK99Ws@gondor.apana.org.au>
References: <20240603-md-hw_random-omap-v1-1-89400f524bbe@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240603-md-hw_random-omap-v1-1-89400f524bbe@quicinc.com>

On Mon, Jun 03, 2024 at 07:55:39AM -0700, Jeff Johnson wrote:
> make allmodconfig && make W=1 C=1 reports:
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/hw_random/omap-rng.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/hw_random/omap3-rom-rng.o
> 
> Add the missing invocation of the MODULE_DESCRIPTION() macro.
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> ---
>  drivers/char/hw_random/omap-rng.c      | 1 +
>  drivers/char/hw_random/omap3-rom-rng.c | 1 +
>  2 files changed, 2 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
