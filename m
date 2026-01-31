Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853AD334685;
	Sat, 31 Jan 2026 02:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769828387; cv=none; b=GttNCaTI/CahdWu1aGjycd/QQ33uDWhbpUElmvKLUlIemWso4KnfTR9SbKl04Pa3bZ6Fui6d+jNXRyqaTx5kG1BeokVn3O0sBuA7s/kR5wf/YO3Eoi+72O3Axb82V0JRWKrwWL2y3A1LXN8cgc7Fe/Lv3sburSMtkNKpYOFv8/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769828387; c=relaxed/simple;
	bh=Eb4shFWJjr9LhVdHxFF+XZmsV2z6pBmt8QF8UIbLth4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HTU+FVxXGcngIiZbT/J4NUIeRKE0dpC5FVYH8Zp/6IRB6ASeqcKcdV2R8HE7xOcNI2yskwXoJDPtHin8PzRImUtDBAu7JLCeEJXvMbhk3FIceUEOoDAVecccCV/P8jk6pFj5U2cleUJTBfvA018SPT/UAo9oPXJ3u/lbWwn2PfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=JyViUGvV; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="JyViUGvV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=+QmJ2GqR/1olnQQYjEwpaNyqv77UJ5XHL8AcSNCoFlo=; 
	b=JyViUGvVz1E09GB3U5/XLYbXI49A++vzbZ/JDYLpCSmWIFyUVjoccgheNBcSVoNnueOB6aiPFEW
	8lPIoFvKrzrGR/Uh0KyZ3zM4G3PhbawPOe1DA+0dbnFc1K9WfjBVooJYVnziIMFdWKxxbGHlapMt3
	V7/vq6e5oxY5YMbfbJhpD8nUJ3oMdiV3jDD6ZgvjMSTI+xanXA35w1wudalHN/tlIdPI3K/SaHPUD
	3nwgazXntJk2tldHdtVqnUbDhQJTY0vLuUj2LQFENMyG3TVhDLBbs+KN5QQJJo4jOaZkJ1/emltAG
	qh6Yzqnn8kmRTUUBRqYNOwI2Yha4TI1alezQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vm1D3-003S3K-2q;
	Sat, 31 Jan 2026 10:59:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 31 Jan 2026 10:59:41 +0800
Date: Sat, 31 Jan 2026 10:59:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, fanghao11@huawei.com,
	liulongfang@huawei.com, qianweili@huawei.com,
	wangzhou1@hisilicon.com
Subject: Re: [PATCH V2] crypto: hisilicon/trng - support tfms sharing the
 device
Message-ID: <aX1wHQVReC4g55vH@gondor.apana.org.au>
References: <20260117071821.1786428-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260117071821.1786428-1-huangchenghai2@huawei.com>

On Sat, Jan 17, 2026 at 03:18:21PM +0800, Chenghai Huang wrote:
> From: Weili Qian <qianweili@huawei.com>
> 
> Since the number of devices is limited, and the number
> of tfms may exceed the number of devices, to ensure that
> tfms can be successfully allocated, support tfms
> sharing the same device.
> 
> Fixes: e4d9d10ef4be ("crypto: hisilicon/trng - add support for PRNG")
> Signed-off-by: Weili Qian <qianweili@huawei.com>
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> ---
> Changes in v2:
> - Move the device lock to the hisi_trng_generate(), unlock after
>   generating a block of random numbers, to prevent one thread from
>   hogging the lock.
> ---
>  drivers/crypto/hisilicon/trng/trng.c | 121 +++++++++++++++++++--------
>  1 file changed, 86 insertions(+), 35 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
