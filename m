Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C26E21D3F5;
	Sat, 28 Feb 2026 08:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772268222; cv=none; b=gd8cfZGH7o83/FZvf79ZEb8CobEn+8yAIdTKtDbtvZhGRjzG5ufbksqOQEL9/ntyoV3l3wIGQiMS0f2kTJex3X2W9yNxRB7Dw/TcATtjhTNYaafVx2335AEvlzzwLeq2hMCpGmwgMR7fUL0w5VatuoGCmeNWCT5gZSWt4IR69bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772268222; c=relaxed/simple;
	bh=y0pX70tY+98nHEDFPbYG8sciHF3TpgPxs6f1lxYF74U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=inGAAcISTnAGtXKxS+L1o69EaiVi5GOZq8Py5Cnz9Ekp5Qejlk8rSBAHji1N+Luh0MY/AtJ41DjzkYQU47LqVptB+zUKPHW0uP3pT6QFmzfSDGEoyECkBSNWX7L01pj3ndNl5nUueTkUawu7jjR+ee8dUZMkTuN3yykmzN9GDyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=c9HFGsth; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="c9HFGsth"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=abaIb10iDB6NF7tAQUd32QGleOqS2dd0O5vuEuVPE0w=; 
	b=c9HFGsthx6EFu8NYjq+6D+Z0OdybzWWpQZXudRKUen3uq86jbPdg1/7PLhSGaSLsjRGBSdaDW4d
	2bZ+tNodpEqpRy2Yund1REAoHDaE6KoRu3ER+WvbhkvcKEJ3+lhelzrOyee1CMvfTPd3TlsE/lqP4
	C4Acv926SUtUI3/9FwPXfnNs8+njK8XYTuhZhMovv8xbs3qW0NUGRhXrCG9eHD0RdnkLOSRpCE/Zw
	pAmJi13TVtBECQ6nB54+HI7N9TktoYTRmBJYjXsd9DmNthitmi+KEKxuikBLoB99FX7YU+trOfwnS
	gBVJWd5lwM/KB0kPysYR9wxMhXuJLAhtJIww==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vwFv3-00ADmk-0n;
	Sat, 28 Feb 2026 16:43:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 28 Feb 2026 17:43:25 +0900
Date: Sat, 28 Feb 2026 17:43:25 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: davem@davemloft.net, mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com, linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: testmgr - Add test vectors for
 authenc(hmac(md5),cbc(des))
Message-ID: <aaKqrWujFR27Ss3d@gondor.apana.org.au>
References: <20260207145113.375192-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260207145113.375192-1-olek2@wp.pl>

On Sat, Feb 07, 2026 at 03:51:03PM +0100, Aleksander Jan Bajkowski wrote:
> Test vector was generated using a software implementation and then double
> checked on Mediatek MT7981 (safexcel) and NXP P2020 (talitos). Both
> platforms pass self-tests.
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>  crypto/testmgr.c |  7 ++++++
>  crypto/testmgr.h | 57 ++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 64 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
