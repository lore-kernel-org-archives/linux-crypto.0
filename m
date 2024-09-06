Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE9E4437A;
	Fri,  6 Sep 2024 07:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725606612; cv=none; b=o2CVKAWmfh9vGYXhNMtBITO9uRd3pFT78CyMlT3V/2/l57BJY+sDxxKWJk9/dH17LLBIv0NsRcOD//ZqvPhSSHbfbespPIEPMVHi3RS26j30mhykpl9zLtbzHVbTdmJxqoBLvOMoxbyVmezlX9y6CreGXLmdGFYcjdcuxU2T5p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725606612; c=relaxed/simple;
	bh=5AOp+r8d6IpO4B+QVvedZvQY1oloPBYMMbrA31+8RzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HusEF7NTeug5CxUlQVyiUQceY4CtBRz3Acy2aS6HYF120vgclfOqByV7lietKRyf/8+apd6ilpUPORlfap8vkEO9/3yDHmCpH9BsfPvGVKm1cTiVQ3hsj7NGK8cW3f+NlkTZZANpVErip5yMDdyvjU0zoDwc1gr7v0fcVnZyW0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=UzlKytTz; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="UzlKytTz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2jxPq7jP7KmyFBnb+jNJiSpLtScoDkNi4M333PLaaQQ=; b=UzlKytTzd3SoXpGExIppclNaVj
	fn4b7VIXgldZQwW2yenzkji5iJxT5i9ByLh4tguZrluyt7EbkeTbKrVMqfmoy4UT5VFhWJHWHWLds
	Noxl5H1FvmiR+nmZWZU8bs5evEVJEP90UBvikeVcjNXAhjdeLhmynuEToYBvUk3U8hr5vDo/1/6Tv
	ZOahAz8W6/RgllLcEhn4nSc+BpEyhFjr43F1wBQPlmRUJr0zFQSqBPikqP0T1eRRBMKEUkO3lHf9X
	kp0hpPlZa78Ltapg08IaWu64ePwonxK6iT+ROga1m6BQr8CU/Ii4ayRfu0lrr7p4kxSDWUuu5CwT3
	gxj0wcvw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1smSwj-000WYI-1Z;
	Fri, 06 Sep 2024 15:10:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Sep 2024 15:10:07 +0800
Date: Fri, 6 Sep 2024 15:10:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, fanghao11@huawei.com,
	liulongfang@huawei.com, shenyang39@huawei.com,
	songzhiqi1@huawei.com, qianweili@huawei.com,
	linwenkai6@hisilicon.com, taoqi10@huawei.com,
	wangzhou1@hisilicon.com
Subject: Re: [PATCH v2 0/3] crypto: hisilicon - fix resource contention and
 abnormal branch processing issues
Message-ID: <Ztqqz2iL0mBIV7c2@gondor.apana.org.au>
References: <20240831095009.446780-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240831095009.446780-1-huangchenghai2@huawei.com>

On Sat, Aug 31, 2024 at 05:50:06PM +0800, Chenghai Huang wrote:
> 1. Fix the queue resource competition issue in hpre and zip.
> 2. Fix the abnormal branch processing problem in sgl.
> 3. Adjust the header file and printing format problems in trng.
> 
> ---
> Changes in v2:
> - Rebased on top of the merged spin_lock type for zip_crypto.
> 
> ---
> Chenghai Huang (2):
>   crypto: hisilicon - add a lock for the qp send operation
>   crypto: hisilicon/trng - modifying the order of header files
> 
> Yang Shen (1):
>   crypto: hisilicon - fix missed error branch
> 
>  drivers/crypto/hisilicon/hpre/hpre_crypto.c |  2 ++
>  drivers/crypto/hisilicon/sgl.c              | 14 ++++++++++----
>  drivers/crypto/hisilicon/trng/trng.c        |  4 ++--
>  drivers/crypto/hisilicon/zip/zip_crypto.c   |  3 +++
>  4 files changed, 17 insertions(+), 6 deletions(-)
> 
> -- 
> 2.33.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
