Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0B752F9B;
	Mon, 28 Oct 2024 10:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730111731; cv=none; b=IveSlhEtR7tCz37A227kRQH2VZvlHRwLa/rLD/Ax1oG+7J9SOBef2EPa1lIDJ8hSfCi5WqlSZ6yvIyEs3ZkDxtaNy+Fs5c9DwGD7vSJ+Cvl6klgfohYKkTFeUx39zgWtDxrzfnJHP5m2JmMCSaQuugXu1p/oRVvOclV78uye+/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730111731; c=relaxed/simple;
	bh=yekcCoQjuc41kkKrduUzOHb05UL54KMf0+LReoy561U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nOSK0zE8GXlWngt9uc7J4OiEUDjKyZhxZIGWhuBDdVJuJieNDqt15YJOSXmBbtGeozVXs3S0YglbVZYB069tr5Kx7kMYBLnYPu83dJ3pgCR1KWFzzKcOe9QHCiS/AxtxPX9gjVcTTG/P+3MFlNhXY6Zo6pD0bk5IehxcLf2CVSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=GI67VBeN; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="GI67VBeN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=C7ThfUeMMfCEPky81APrV3AF0vwWcNosOQ3cn9ozLgY=; b=GI67VBeN4bt4+0+Ao6jZ71NpBd
	u0DVAuvABcqwQxxBI5d9Ma6bOXCRd/H1fC+X2ya/f2RCxV0bDt/92qhvyOvkbK9iwenSmViNaiinQ
	HWaYm5VKzjxRngv9gz8jMY6f4EsrsPpvDD4VHTh4RwpQfJAULMq55Sa0l1gtAjk77XKWa9nXUUFae
	AxxmWvI0oMCxnup6xkg7Blw5EKEt40T81PE8T8p//zlxsl0wjgEn8PgF7kSPhmCeLNOqPRgT85MAd
	ATDKt/nxprNi68X0ILrBQV/4ISJdZVzJXKMofFPQ/PB+Rh2XpmdIcs7TQ25B3wvMT++BX3oYf2509
	A/aVhLbw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t5N5f-00Ce9Y-32;
	Mon, 28 Oct 2024 18:35:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 28 Oct 2024 18:35:15 +0800
Date: Mon, 28 Oct 2024 18:35:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "linwenkai (C)" <linwenkai6@hisilicon.com>
Cc: Chenghai Huang <huangchenghai2@huawei.com>, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	liulongfang@huawei.com, shenyang39@huawei.com, qianweili@huawei.com,
	wangzhou1@hisilicon.com
Subject: Re: [PATCH v2 1/2] crypto: hisilicon/sec2 - fix for aead icv error
Message-ID: <Zx9o4zaq11gPhhE8@gondor.apana.org.au>
References: <20241018105830.169212-1-huangchenghai2@huawei.com>
 <20241018105830.169212-2-huangchenghai2@huawei.com>
 <ZxyMnWbTkf7JEnT7@gondor.apana.org.au>
 <02e70357-1a3a-44f4-b25d-0e8e7f430cb6@hisilicon.com>
 <ZxyvT1PnY83Ilvyb@gondor.apana.org.au>
 <aef8c5ec-4dba-4ec0-9157-6c0e02608d57@hisilicon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aef8c5ec-4dba-4ec0-9157-6c0e02608d57@hisilicon.com>

On Mon, Oct 28, 2024 at 10:03:40AM +0800, linwenkai (C) wrote:
>
> Finally If you think the variable is not needed, I can delete it and use
> crypto_aead_authsize to get it every time.

Just call crypto_aead_authsize from the places where you need it.
There is no point in making another copy of authsize.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
