Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C026A94D;
	Tue, 10 Dec 2024 05:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733809558; cv=none; b=iXdYAvvnRQ77D11PtBMxtAeLivLYbde7kji1Ffa2ljgZyO6XUQe5exqHpMblR2LcJf88K3iOy9MgJUhXDvE6ZYh8dAz3mx1mCOd4aHrxSsGJktVwbeq3nmo+CJTvklBcMPOHstYQnsM4rtMGvTz56Eg+lIElRrD9GB0dXLVXxGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733809558; c=relaxed/simple;
	bh=37cypYB4FQDgDatJ4K9c73h7B0ezOBp9SQ9lPV/uMlk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MChy/S/D2FgsKbNT4kNeS2/IZ5L9agknwUerev5qwKLSzyiw0u0mpH+QRrT8JZp+y/uLNjWkpfFWAnTsWARyLlTYtyogv0feMBA76S2p3T7rTK/xsbLugIgHNXFkBjteyhrk9Xixdkx5omQqLPXyBopCzyc7WDz4AdUf8LFa3YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ZMP0ihDa; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ZMP0ihDa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Akx0gjk8V+FXVq1+msYkBd1kwsokqKtFe/MONphsUzc=; b=ZMP0ihDahhgypBYAB8HsOXZVtj
	yVZu0cJRYeM11dYIxpbw7t86i3VgTe9Cx8HKaRA/V59EAr4a9xJfgPEoS6BiNtplI8ysYbNdo0FwG
	uAa3hM1cLhs/cbopzx0cYLpr5c0ptr+d9gRRdh3qvFeqvQ1nwMNys/FdbrBgPnmMmJ+qmA4fgtxEG
	ybUljPs/yLrb0yyybRiphRSAFTxXrUXYTqfAMedoN7XfBdeAEhJjyyD+Xyzc68ygonI75zPjaqgk+
	IV6G1mLr8+QNLouY6sNstnslu3MtK3wgU8W+dZD5p3omK5eW3SSVztzdbaVue+3oQfYn/2gqdcVRY
	b6RWE9CQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tKsr5-000OAh-0e;
	Tue, 10 Dec 2024 13:45:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 10 Dec 2024 13:45:39 +0800
Date: Tue, 10 Dec 2024 13:45:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: akhilrajeev@nvidia.com, davem@davemloft.net, thierry.reding@gmail.com,
	jonathanh@nvidia.com, linux-crypto@vger.kernel.org,
	linux-tegra@vger.kernel.org, chenridong@huawei.com,
	wangweiyang2@huawei.com
Subject: Re: [PATCH v2] crypto: tegra - do not transfer req when tegra init
 fails
Message-ID: <Z1fVg7l9MyRgtdKI@gondor.apana.org.au>
References: <20241111012827.1788341-1-chenridong@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241111012827.1788341-1-chenridong@huaweicloud.com>

On Mon, Nov 11, 2024 at 01:28:27AM +0000, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> The tegra_cmac_init or tegra_sha_init function may return an error when
> memory is exhausted. It should not transfer the request when they return
> an error.
> 
> Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> Acked-by: Akhil R <akhilrajeev@nvidia.com>
> ---
>  drivers/crypto/tegra/tegra-se-aes.c  | 7 +++++--
>  drivers/crypto/tegra/tegra-se-hash.c | 7 +++++--
>  2 files changed, 10 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
