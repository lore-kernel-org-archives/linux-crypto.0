Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E36EAF1;
	Sun, 22 Dec 2024 04:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734841183; cv=none; b=juO62NsnPps1BSDrC9XZxt/D9q4dYRWr/SicyMSYEAedDC+8ZpPgElKQvHtM3P2dyQ/eQ4yr6ZaQ0q30/20E2fKLMh/dVLPqbV5frJP9a5IfIMt9eP3nG++7qUvtt78tiAOpxe0Ob84jx9C4so5fxbwVvLoWQfugt3+ufZ9U6Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734841183; c=relaxed/simple;
	bh=M6pUWsTSrXeB2cLhqlCFMrTteKHGHd4xzC/rdZViR+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f0q8gi7qr8hknTVJW2a+LY9guqsXAU7iOI9bTSJB5hz1pM2sLMbYK87Hf5G1X9ghKTXUNy5ub0Qxl6jtYTl/DSWiNQQJUMX915Z85ExpwhWc68xmURs/cZc2s04HTeQx/VfiCzYa39RPmuowaqoEV4VdQ0AnNh+y9HoqrFDWhjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=PeeM46hL; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="PeeM46hL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+etBx0MAOXkrewr7yfKsGVGbz6odjFq1grubDQRJMFg=; b=PeeM46hLgU3e6eczmL6NKJ6KR2
	3ldXYy9gat7LooXZN+QDzZnfjrY5AXFes7S5/nsyBb4Zu1eGZEI7NbKueunrPL5EraUZgLHZguKzj
	ucqKAaIA/J0IqfAGxHz5cM7hYqj9IR3XGXxEszsJxJLgClXmC8QiQv4JEaeUtp1ciuayiuzDBQlET
	P9BgpOPqBQl1XwN4BQzsDmfSure+msTro1ADVZ3TqFNHJj8F9llamd6VYqOZm27WbU7wC4Aa5bY3p
	ghGZIhfL2xrF0761qmJL3p8Usgk+tDxjHCpZJNO83ufhqD7+JZbY75xhmp4Ppjmm0CHLjTy0GsS13
	aJlC2UGQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tPDEO-002Uec-0f;
	Sun, 22 Dec 2024 12:19:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 22 Dec 2024 12:19:36 +0800
Date: Sun, 22 Dec 2024 12:19:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, qianweili@huawei.com,
	wangzhou1@hisilicon.com
Subject: Re: [PATCH v5 0/2] crypto: hisilicon - fix the authsize and icv
 problems of aead in sec
Message-ID: <Z2eTWI07jIauzJP1@gondor.apana.org.au>
References: <20241213091335.4190437-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213091335.4190437-1-huangchenghai2@huawei.com>

On Fri, Dec 13, 2024 at 05:13:33PM +0800, Chenghai Huang wrote:
> 1. Fix for aead invalid authsize.
> 2. Fix for aead icv error.
> 
> ---
> Changes in v5:
> - Delete the 'fallback' that is not used.
> - Link to v4: https://lore.kernel.org/all/20241115102139.3793659-1-huangchenghai2@huawei.com/
> 
> Changes in v4:
> - Add a switching flag (fallback) for soft-calculation in req.
> - Link to v3: https://lore.kernel.org/all/20241102025559.2256734-1-huangchenghai2@huawei.com/
> 
> Changes in v3:
> - Call crypto_aead_authsize to obtain authsize instead of
> actx->authsize.
> - Link to v2: https://lore.kernel.org/all/20241018105830.169212-1-huangchenghai2@huawei.com/
> 
> Changes in v2:
> - Restored authsize to the tfm.
> - Link to v1: https://lore.kernel.org/all/20240929112630.863282-1-huangchenghai2@huawei.com/
> ---
> 
> Wenkai Lin (2):
>   crypto: hisilicon/sec2 - fix for aead icv error
>   crypto: hisilicon/sec2 - fix for aead invalid authsize
> 
>  drivers/crypto/hisilicon/sec2/sec.h        |   3 +-
>  drivers/crypto/hisilicon/sec2/sec_crypto.c | 161 ++++++++++-----------
>  drivers/crypto/hisilicon/sec2/sec_crypto.h |  11 --
>  3 files changed, 76 insertions(+), 99 deletions(-)
> 
> -- 
> 2.33.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
