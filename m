Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A64A1BBBC6;
	Sun,  9 Feb 2025 10:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739096592; cv=none; b=r3RtNDQZhtuxvpNpw3Y2+kyFngTO5yPMR3YxLYsPctlSgPdGcW5+oS6QcxlTL83hNjbb64Npf21Vo8199zo25+2v2TJi7GWqnKW4P7Ctorhg2J32EhZfWtdbUh0D/iWmpJIEi39qq/pSfOCSM07w/ZH1d1i1o0aneO7S31EznoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739096592; c=relaxed/simple;
	bh=GMs61NIlsSl7ZKsu+qx39+iXBQrdF6EKDyeHD5Z32DI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T8mkvHmbuMEFaE8wk9n1GnKYSwqFMLDda+JhJFtKmrFRf5txohCWFPcd4NWjAHfYVC8N4UYOPYJZMHSi2cpogPLqgdQQdhRyWyvnJ285z7a0/pONrMRf1/66Ju2wPR9ufX1u1mWxZ4k376/bXGK1DfegpMqLwctdmPWKtIF4Y1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=KbeYakny; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="KbeYakny"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pNyAMdDJCojkNjgBCzHxvvImzXmaodDJXUQqHBC//lk=; b=KbeYaknyEjqG6LQ5HQuOPuZE+4
	ZhbWxkILtbW3mWyFIZSMIy4mhpCECIEJOuJmRpssgfNNrXr7P75uMI8fyqdhH3N+U1V33+rA7vpOI
	OuBiwxvKerzx8kXDyBM2xxnNfzzY4UcmvNAhcsc3udmvONEVpNjgJGXYxa25yTD6XXUb1FC9s/z3h
	6EznTU4GUiAYHHfL0i3Vk40973HeY3umEhNYqD7sLeng8Y7nZrzABPDelwLdCHW4pkSgYKHybtrwo
	j1TjH9EXEW0Ihs04ApIt8UA4dLeHrOriXkDIOD9AfnM+6pAgno4ojjmWnQUp8uT53eQju1DC4UIz6
	S2PK5/iA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1th4G2-00GImV-19;
	Sun, 09 Feb 2025 18:23:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 09 Feb 2025 18:23:07 +0800
Date: Sun, 9 Feb 2025 18:23:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, lizhi206@huawei.com,
	fanghao11@huawei.com, liulongfang@huawei.com, qianweili@huawei.com,
	wangzhou1@hisilicon.com
Subject: Re: [PATCH] crypto: hisilicon/hpre - adapt ECDH for high-performance
 cores
Message-ID: <Z6iCC6iZiRgLnK-4@gondor.apana.org.au>
References: <20250118004520.3826095-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250118004520.3826095-1-huangchenghai2@huawei.com>

On Sat, Jan 18, 2025 at 08:45:20AM +0800, Chenghai Huang wrote:
> From: lizhi <lizhi206@huawei.com>
> 
> Only the ECDH with NIST P-256 meets requirements.
> The algorithm will be scheduled first for high-performance cores.
> The key step is to config resv1 field of BD.
> 
> Signed-off-by: lizhi <lizhi206@huawei.com>
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> ---
>  drivers/crypto/hisilicon/hpre/hpre_crypto.c | 7 +++++++
>  1 file changed, 7 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
