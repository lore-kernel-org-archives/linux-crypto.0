Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E42B36A36C;
	Sun,  5 Jul 2026 08:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783240098; cv=none; b=oqMQxD/f1jNTfDprWtO4KY1PGliQmgyEBIsM38FaKE+AhpF2MzrIio7Wa0rkf+44KMm/kzxNB0VjsEpQW5Sxachik+vy5+7EijCbxc3bQaT+lh3SJ0iv0NCFLRnH3huAFWxm8/UG3AsdiN1Ao+O5GtHpzYZ7ihITOXAaqh5ZogE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783240098; c=relaxed/simple;
	bh=wh6B4oCOQxzxFGtsNgRPGGqX7mJWx9ITe49etI2RNdA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X3cAFfKWfXHSZUnpObsPnK826HkvJSlgRWyjc9GbkUzsM8IiYNM7Q+1dZGiAQzRvOO+ggDOI7zE4U5A+InzP7fOgcxQE4vVq/h6pwe0lUnBxaIpupnaceJ6yZX2NBz1FVX4z7USlDrvTNoJ1Vm5dwAlnmtmIBd8X6w6RpowDtxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=NLPrEK+i; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="NLPrEK+i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Y/fEI1tsYcMeILFjsz0iVsmftEVQAz64IXLrZBObpqM=; 
	b=NLPrEK+iUe9kpSTKN60rKpZgNio6syoLNSXoFItxclsZ1QZznxT0R4tEgX5+XV7zuXEcPF2Zvj7
	0ZmRAGDFWPx9RAgg+R2uY8D1MfwKJSn9xx6UMRNWCLqDZavOqX6qn+09Sxtyrso4481czd0BgabGd
	ULMbgqRhH8rrDylCn/AjStsfvrJHkjZzWTO+ID5YAZOPBmngtyPtMAqmC8EXe+UZwF9d6UGLWAK1k
	l2+0QA3/tv4xWMP3zOccJTzlBz5MWdUGKHCQzRVl0/+5wyaxI+X9zKhfEIComPrhG8bcSFXTXdjcX
	NcqGet1EaonqHoAZPMZlCfhFCSybPX8YcfDA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wgICy-0000000AkvN-2jh6;
	Sun, 05 Jul 2026 16:28:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 05 Jul 2026 16:28:12 +0800
Date: Sun, 5 Jul 2026 16:28:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: shenyang39@huawei.com, fanghao11@huawei.com, liulongfang@huawei.com,
	qianweili@huawei.com, wangzhou1@hisilicon.com, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: update hisilicon zip driver maintainer
Message-ID: <akoVnF_cFSeDo4Ak@gondor.apana.org.au>
References: <20260610013437.1354503-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610013437.1354503-1-huangchenghai2@huawei.com>

On Wed, Jun 10, 2026 at 09:34:37AM +0800, Chenghai Huang wrote:
> Add Chenghai Huang as the maintainer of the hisilicon zip driver,
> replacing Yang Shen.
> 
> Signed-off-by: Chenghai Huang<huangchenghai2@huawei.com>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
