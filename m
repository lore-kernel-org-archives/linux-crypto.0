Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6556518FDA6
	for <linux-crypto@vger.kernel.org>; Fri, 30 Aug 2024 10:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725014867; cv=none; b=T66Lzqtk5XSbbu8V58tMthylQRmgNSqShVwHwjM0lD4iN1luo5AdQ+T7cGck7c6nIAZVAF4+tyokEsZiXsKEVy7Oij5NeRnyZotnTKY5NO61Hihl6NW4yIS7Ap20UJ731CsvXhmiNLfk9mRp+9rKo2J0XSpUNuMivYwlKRTtpMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725014867; c=relaxed/simple;
	bh=WIXNgSAvM1LNAy0wBgowC/37D2qR497JtEx9SCY/PtM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M6MeFO3XAAe7hxoxfDsWPqQIiFyqPFwipm+eX2uiIpwBzzzG+yJH7NCigDH0ilQqV5lTJzDA1sx9tLJpu06JBod+k7nWOF/U2ppLVc6++OVbo6LK+/8lUda2Gf9b+S+C2c1IF67E3yMKCHWYiExfjgxk6bXyPGwJS0FYh8Pmok8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sjz1c-008UxU-1L;
	Fri, 30 Aug 2024 18:47:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Aug 2024 18:47:25 +0800
Date: Fri, 30 Aug 2024 18:47:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chunhai Guo <guochunhai@vivo.com>
Cc: davem@davemloft.net, nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com, claudiu.beznea@tuxon.dev,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-{aes,sha} - use devm_clk_get_prepared()
 helpers
Message-ID: <ZtGjPez-NH5MU-H4@gondor.apana.org.au>
References: <20240823094249.2172979-1-guochunhai@vivo.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823094249.2172979-1-guochunhai@vivo.com>

On Fri, Aug 23, 2024 at 03:42:49AM -0600, Chunhai Guo wrote:
> Simplify the code by replacing devm_clk_get() and clk_prepare() with
> devm_clk_get_prepared(), which also avoids the call to clk_unprepare().
> 
> Signed-off-by: Chunhai Guo <guochunhai@vivo.com>
> ---
>  drivers/crypto/atmel-aes.c | 16 ++++------------
>  drivers/crypto/atmel-sha.c | 14 +++-----------
>  2 files changed, 7 insertions(+), 23 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
