Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B459B2580D7;
	Thu, 23 Oct 2025 04:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761195588; cv=none; b=A3sNy2bN7QmKg+NscV9qmoNBoXyt2BLLR6tFqG6VXxyMLqv//t1C3phXJz7LlSGj63G0ZbeGkIUGdrAQJudSTmMzVeQp8ePI2okzR6P6RxB5R45Vf92n65SPEq8SzFD4YW0QvpkJ4P5S9oY8WSZIfaJsSwFrjoSztzxEFTj0g9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761195588; c=relaxed/simple;
	bh=yUtJa9J+iAKFCacuxLUjI7XtOhvTtfIXk4wiNwNJSLA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jdqBJYu+i4K83u6XuQwyEzgjt+I2luzXqWAxLGuw8WnVldzUZymfsAW9rOa796myRCN4jehHsxyXooETwQ/AfwwEStWPZaH8PhEY4JN4P+Tg/FQVbLsISRtPT23fb0JSYZ/XvYRQEd0aPamcZh94nC+F8qBkvc108exNUYxS7sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=h+8l1HiE; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="h+8l1HiE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=A72o7N8NjVe4EGBy1kaF5HJSNHze6xL+XVFhul1Nafc=; 
	b=h+8l1HiEYA8+ONxCX995YVectXdrZoeogEYJ++ycml7ZdJY3ev6mOu+pGlDuqdQ1/MfvPiffcRD
	/IMt01nGAdTSR/7gF8wr568d0Ni1SuEo697gWfNTmBVfMIVH6205bOBQvR5k3ycwK73KRSbww4qb/
	FhnpX0bheUMkJdY1EvtDuXo4j/XXpLZVSlKyhvaolkK3///1bl5+4Gb4DRjFEiUsO+lZxEgtSgtiY
	gDaoJTAMa7ZurgUszU7VwSJTd72YfMDHn7U7UEk2cCobEg9Nku6y9S3Br5UFRmVCpEaRwq1ECy3VA
	4zEWCm7P+dW9nc/tEBGz/hE2hBOJZ9tiDXrg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vBnQL-00EsHm-0y;
	Thu, 23 Oct 2025 12:59:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 23 Oct 2025 12:59:41 +0800
Date: Thu, 23 Oct 2025 12:59:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linuxarm@openeuler.org,
	liulongfang@huawei.com, qianweili@huawei.com,
	wangzhou1@hisilicon.com, fanghao11@huawei.com,
	nieweiqiang@huawei.com
Subject: Re: [PATCH] crypto: hisilicon/qm - restore original qos values
Message-ID: <aPm2PZ9BoEpjzi_t@gondor.apana.org.au>
References: <20251018112739.3220154-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251018112739.3220154-1-huangchenghai2@huawei.com>

On Sat, Oct 18, 2025 at 07:27:39PM +0800, Chenghai Huang wrote:
> From: nieweiqiang <nieweiqiang@huawei.com>
> 
> When the new qos valus setting fails, restore to
> the original qos values.
> 
> Fixes: 72b010dc33b9 ("crypto: hisilicon/qm - supports writing QoS int the host")
> Signed-off-by: nieweiqiang <nieweiqiang@huawei.com>
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> ---
>  drivers/crypto/hisilicon/qm.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
