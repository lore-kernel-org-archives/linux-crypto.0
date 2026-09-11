Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A5230568B;
	Fri, 11 Sep 2026 05:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789104553; cv=none; b=HxmCwrQRYlKO5bSQSTSM8RG5pMS0+PAAUO1f/ApmB7guRjPlVxTiMze8qfJ6VtUKDYJrOIqAYVrGnn9Otqi5WOMlH+ZHDuZIkar4DYRTBk8SDaxAetVdKc/n1QPcB3jxlKvJVVHn2BUpGTDMaJF+xjs5wjRw2WuLa7hAh4s4f9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789104553; c=relaxed/simple;
	bh=rfrNpKUYbzYS7IwoD4XAYIrdcbAI/9C7NA/5jshBnr8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qVlmPiznOlxd0YcVGDz8O1elX2rBSFFkycTjw74QzN0y0IWFj3Y29/lYFiEKzkgCSw497HMNoZhnheuE+H6X0kYU9ASFsqtqImd52VVaiQKsPAhBmziq01BtZCRl6jVokCaf4PULnaom9GDu27k/6S+SycZaNj3o5W5tqnmJ3Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=MwKHQWjt; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="MwKHQWjt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=r/kpvgt06+Pjpn+SeyFEb08MN3NDfZr5FTUrPxAEqJU=; 
	b=MwKHQWjtSmAmtLsCV+pOlLRvujKGPRJqWSYS3TsDKFHliLe9UyGsWAxOF2G/eD6P95ftohY7/xJ
	v4cQYfRSCVOM3zmDYWAUjokBedtHABTpb7xEvohu69z7u5eahcNj60tZgOA5acVojJw6ZTF3utfkQ
	DcAgIbIFOTmw3tFbJP6t1fATq4PGkMgxwmjOJGUgAyRasC1xzPmZabTwU1DTYHqTqz71Df1LeP9oR
	mBSvTZkhOa4JJRkW9mky1TrZooh/m57iDms4XG//hl6LEEMkU7KxnYoidXVTdzrGil17/owt+CFa1
	w48HFYUixlskpTNHY/zS0dk+Q2vnB3zAzl3A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x4tow-0000000Cu82-3erJ;
	Fri, 11 Sep 2026 13:29:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Sep 2026 15:29:06 +1000
Date: Fri, 11 Sep 2026 15:29:06 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Li Youhong <dayou5941@163.com>
Cc: olivia@selenic.com, linux-crypto@vger.kernel.org, imx@lists.linux.dev,
	Li Youhong <liyouhong@kylinos.cn>
Subject: Re: [PATCH] hwrng: imx-rngc: check clk_prepare_enable() return value
Message-ID: <aqORonlmX7cTyz9m@gondor.apana.org.au>
References: <20260828025423.2149304-1-dayou5941@163.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828025423.2149304-1-dayou5941@163.com>

On Fri, Aug 28, 2026 at 10:54:23AM +0800, Li Youhong wrote:
> From: Li Youhong <liyouhong@kylinos.cn>
> 
> The driver ignored clk_prepare_enable() failures during probe and
> resume.  If enabling the RNG clock fails, subsequent register accesses
> or resume after system sleep may not work while the driver still reports
> success.
> 
> Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
> ---
>  drivers/char/hw_random/imx-rngc.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
