Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A1E2B9A6;
	Sun, 10 Nov 2024 03:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731209810; cv=none; b=SDJ/j3eylfzqwoj8kCv8Z/huUVdzc3AaGkfoWwo0Bug5lD+pQhyFQ9aLzEfFjz58QFPJmVMYu9cfoVUA4drlLUWcW9BVPLH/QZ2hTrp4ruYkOqGHmrqq4uHR/B9G4Uz/ATpGhpmWPgwByogmpvxtMkKXqQnkK8S/mt70gR2V9e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731209810; c=relaxed/simple;
	bh=u/FJSJdgAPmS7XVwKbf5k9uDBlnL7cl4j08pWjwznwk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rCMqNvDKNgGs2eM8/8sLfv2uoc7msZOFLljIC/ScomkMMTTBrvbMuEp9UwjP9ajLfuEK4IQ31q83f0OKUG7lLfprfi3Hg+nfQiksO58umFG0nJng6a+0c7wC/7BNVl8PbAFPCmcH6kQFxjjRmPiYVzi7539WLKtdxV3jQSzcVdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=fk6Rp3Fr; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="fk6Rp3Fr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Ee07EOuQqAWbcv/0faB3qojBvFs6wd/Zge6T4CdmmJ8=; b=fk6Rp3Fr6cjYlSIrhAgf+L26Sr
	Sz0XUtM9Lfx2MxJxOqSyz252czf7Snl0Fxetnss/TBtJGLQ8b06eruoDDLbuNDjojNoNdr33dZ+gm
	/lzHF58LCUFGg1jADYiiDlo79Hp47LN0Ej0d/Edk+eCC7gLQeh9HwFQwmNVoW+sSwlFYVSTJe+cVE
	FBVvhGoA1n7lgNQAR4sAfMS61y54eIQwIsNlwuBtgWHDb3jPzQlpslZ7IphS0wpe/K8mM6M/h0fkq
	dfn2AMZa0NSiXOMJJKtXGj67kifmVAfZA8YKDnAOuvgPe6dTA97jIu9J8TWM6fAmre0gRfJBA+RZh
	1lBfm2Pw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t9ykc-00Fk6n-0y;
	Sun, 10 Nov 2024 11:36:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 10 Nov 2024 11:36:34 +0800
Date: Sun, 10 Nov 2024 11:36:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, liulongfang@huawei.com,
	qianweili@huawei.com, linwenkai6@hisilicon.com,
	wangzhou1@hisilicon.com
Subject: Re: [PATCH v3 2/2] crypto: hisilicon/sec2 - fix for aead invalid
 authsize
Message-ID: <ZzAqQhiebKSuRzOm@gondor.apana.org.au>
References: <20241102025559.2256734-1-huangchenghai2@huawei.com>
 <20241102025559.2256734-3-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241102025559.2256734-3-huangchenghai2@huawei.com>

On Sat, Nov 02, 2024 at 10:55:59AM +0800, Chenghai Huang wrote:
>
> @@ -2226,15 +2236,15 @@ static int sec_aead_spec_check(struct sec_ctx *ctx, struct sec_req *sreq)
>  	struct device *dev = ctx->dev;
>  	int ret;
>  
> -	if (unlikely(req->cryptlen + req->assoclen > MAX_INPUT_DATA_LEN ||
> -	    req->assoclen > SEC_MAX_AAD_LEN)) {
> -		dev_err(dev, "aead input spec error!\n");
> +	/* Hardware does not handle cases where authsize is less than 4 bytes */
> +	if (unlikely(sz < MIN_MAC_LEN)) {
> +		ctx->a_ctx.fallback = true;

This is broken.  sec_aead_spec_check is a per-request function,
called without any locking.  Therefore it must not modify any
field in the tfm context (at least not without additional locking),
because multiple requests can be issued on the same tfm at any time.

I suppose for this field in particular you could move it to
set_authsize and there it would be safe to change the tfm context.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
