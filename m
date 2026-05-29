Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8073890F7;
	Fri, 29 May 2026 06:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780034403; cv=none; b=YK+OfnqMSWU0DN6viW/cp9U/+C/YaeUaUv30hic39+2yIyZ26VzM+u/PY2IY8rrWJXr3qd3FWS1pgqdMXr45gBkD0McDkAziWlYsE31zruLAoNWtRqtNktFeryZELSugsPkqzFDZ367beVl4tvOiwOIfTe76AP2NfDG0UvEj5Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780034403; c=relaxed/simple;
	bh=dtzljhNUCo3BdZjaGKQacLmczSMsQ96gupK0NwYJnPM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rQGHHG5Ke7dlHXFJgCnzeonY+FoX+pOjy9AO8M5W/lDbDwtIeRKRHhl4ybslY9ACs11IX54Fev+6PL+95o96+Ru1B4jb2+LsO7qUv2Wl6qY92xbXHf/oNsge1uVnLbvMPg3pnIaxU91q5iPazT6c0WZ0JySKyUjQNBvRDx71Qjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=k3QLkEKo; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="k3QLkEKo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=XxtbcpdHtFhQgGvAfQ6+bP4R+k0B0PdH1dJ9ntvJF48=; 
	b=k3QLkEKokvqLp+3SXvAPZfFZeChrg5+1yLQk/2IA0b6YgbjJaVBoxZIKYffkGtzLBafzo1/4lHm
	nk6IFcapW6v+pDf6ik0Im0UG2yPv+nUWdqja7nJb3hhs9E7vkFUXjurHXmAM/mE1Fuo0SHY+5gqhH
	SR1un0JGduUjGjNB7she3F7gpj79bX+Tal+Ogj6XKYgyzV5OYPFlYutCsVKhtXe4kQSaIwrP4/7N/
	igixApm21JWB4rOoaKIFz7+0McqrjUBDM1tBE8LdhyUI/8VVI3GYEimJIKKfzBM8xiCzoIlLLs7c9
	qAZoUmBXEdQ7hOYXBYhZEk2ijMMauRpGP/1Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wSqGC-000d8e-09;
	Fri, 29 May 2026 13:59:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 May 2026 13:59:56 +0800
Date: Fri, 29 May 2026 13:59:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: ZongYu Wu <wuzongyu1@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, fanghao11@huawei.com,
	liulongfang@huawei.com, qianweili@huawei.com,
	wangzhou1@hisilicon.com, huangchenghai2@huawei.com
Subject: Re: [PATCH 0/6] crypto: hisilicon/qm - support function reset and VF
 isolation
Message-ID: <ahkrXEKyuQ0vxLZ9@gondor.apana.org.au>
References: <20260518142956.3593934-1-wuzongyu1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518142956.3593934-1-wuzongyu1@huawei.com>

On Mon, May 18, 2026 at 10:29:50PM +0800, ZongYu Wu wrote:
> This patch set adds function reset and function isolation capabilities,
> and fixes issues related to reset operations.
> 
> 1.Currently, the device only supports global reset when an error occurs.
> However, some errors only affect a single function's operation without
> affecting other functions. Therefore, the PF can notify the VF driver
> to perform a reset, rather than using a global reset that affects all
> task.
> 2.When device reset fails or the reset frequency exceeds the
> user-configured threshold, the device on the physical machine will
> be isolated. Add functionality for devices in virtual machines to
> obtain the isolation status of the PF.
> 3.Support for doorbell enable control, which disables doorbell before
> reset and enables doorbell after device initialization.
> 
> Weili Qian (2):
>   crypto: hisilicon/qm - disable error report before flr
>   crypto: hisilicon - mask all error type when removing driver
> 
> Zhushuai Yin (3):
>   crypto: hisilicon/qm - allow VF devices to query hardware isolation
>     status
>   crypto: hisilicon/qm - place the interrupt status interface after the
>     PM usage counter
>   crypto: hisilicon/qm - support function-level error reset
> 
> Zongyu Wu (1):
>   crypto: hisilicon/qm - support doorbell enable control
> 
>  drivers/crypto/hisilicon/hpre/hpre_main.c |  19 +-
>  drivers/crypto/hisilicon/qm.c             | 334 ++++++++++++++++++----
>  drivers/crypto/hisilicon/sec2/sec_main.c  |  13 +-
>  drivers/crypto/hisilicon/zip/zip_main.c   |  20 +-
>  include/linux/hisi_acc_qm.h               |  15 +-
>  5 files changed, 308 insertions(+), 93 deletions(-)
> 
> -- 
> 2.33.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
