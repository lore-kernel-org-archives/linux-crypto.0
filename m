Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6C93537E5;
	Fri, 11 Sep 2026 04:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789101980; cv=none; b=hIzemdx3O2YBqLv7Mr6gaBeOXbLm3zFAdp23rSK6GWDfovUkVYy2WZjcm9QV9mLy4/W+kHo1L/KInifBNUACFGOO6/6AjUj1VgZQ7NMEs9uwkmz9/t1WNKmnBxu3jk1qnRQNMA3mVAgrj6sDEOH2igDYYMEEyvvB0KsZJnpBWK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789101980; c=relaxed/simple;
	bh=ipcLaD8MKdmQXC/QLjg8ecHAuYJyPwlpFQRl4T8CrH4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WxV1DTDUfQqu56K9v8fVK/D6WzW0j1GxSGyX0l7NLttJZuMmmXg2HMHvb/60MKtlTbENcVubuypOdYP+9c3I30OgFffvIruQg3DTvHqZ23LBkwS+jyyJZkqkj/b8OFwDokvTMe4CIZzF9aFLsPFbHq+gapouNya8vZLTryHKrFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=cB3F7/V3; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="cB3F7/V3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=cf5NGoxDu/IJpFOZEULswgGz/EeFrCyL55ZL43yhOkE=; 
	b=cB3F7/V306Dsu5f8nU5itXCl1s4vGQD7TsNdZekuhqBlVOr68Av4r43c9HixbhevKInErjDf33n
	k78QPH0EGZN0gjuSRm2dq/rj1P1jRvE/nFyVsNLSf/CjDqWOYmNrL/Cl5zXTtWCLB6oZdd1iUK8O1
	onAqrysjdYHKkt9YoVHuvQ3QQcxJUUiBxjdcE1qXWh4GocoxGFDA2NuEXujA3OcQLemZZ+KmjvxwT
	RQ+8i0GhkJK0vaU13KENEf9XMYq2d6kipXfQAfRxIHFmot4wyKWi5JTCqOAQuBe79HON1pd5H6AAu
	/tm47oAZq6M2JfmFhz7dPRZiR+hQpTiFwOmQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x4t9O-0000000CtXn-3hqg;
	Fri, 11 Sep 2026 12:46:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Sep 2026 14:46:10 +1000
Date: Fri, 11 Sep 2026 14:46:10 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, liulongfang@huawei.com,
	qianweili@huawei.com, wangzhou1@hisilicon.com, lizhi206@huawei.com
Subject: Re: [PATCH] crypto: hisilicon/zip - enable auto clock gating for DAE
Message-ID: <aqOHkkEoXOJ8N5Lf@gondor.apana.org.au>
References: <20260829094924.2191402-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260829094924.2191402-1-huangchenghai2@huawei.com>

On Sat, Aug 29, 2026 at 05:49:24PM +0800, Chenghai Huang wrote:
> From: lizhi <lizhi206@huawei.com>
> 
> Enable auto clock gating for the DAE module. The clock gating
> is enabled after DAE initialization is completed, so the device
> can reduce power consumption when idle.
> 
> Signed-off-by: lizhi <lizhi206@huawei.com>
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> ---
>  drivers/crypto/hisilicon/zip/dae_main.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)

Please review the Sashiko comments:

https://sashiko.dev/#/patchset/20260829094924.2191402-1-huangchenghai2%40huawei.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
