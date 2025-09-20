Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B76202F9C;
	Sat, 20 Sep 2025 12:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758371112; cv=none; b=MnxdP0Kksx8FWQcw/yaJ2WJfLq50uvrjUw6V+OeTlfcOnDPxGVl5+HLyV/CCcmBYj0mdb+mhxguD/iSFMVSdDJAcwOi4lOzt3ub6r4lX1ny4MvdJ4saUUZ3yHaGsYmWpy60ywI3eOZINZ02/8CmoVsgG7YkHAySgEcPij00uolM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758371112; c=relaxed/simple;
	bh=wdYw+weSYwRc8GCnloSSYi6S8/EAmnYHcBMM7HvjvBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eTQsiLsQ3IPgQDz4Yf/vMIgmGoC2DpbA9HoqrLIFrj8De0gCeVqVj1NroEzHwlZLBJ9ENw0e99EZiFErYpWEnTONNVddWIX91ba1ZUuvs7S9AVuSWFEbP5GqPpbZHX5btf5fol/XDhdRpMWlz8QjI4k521i83osdud5FD0xE/Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=oFJWCq1r; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="oFJWCq1r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:MIME-Version:References:Message-ID:Subject:Cc:To:
	From:Date:cc:to:subject:message-id:date:from:reply-to;
	bh=emOSg4qOkAZK/ThP32lyxaA3dTscAQ+11iobepnGoag=; b=oFJWCq1r4XRvXEBzsv83pJkvhi
	8iuQgfo4IObHidobdri6p3cSx1JkJB3FblrMmXbMw8TTouZNho0EfMXtThe6O0k+pFcCq9ML0oh5c
	gBPZ+8BFiZurqEEyz8aSW6lS1TphsiGj5WVKmGtoHDklydGnXXPqQBW/o+3duAdY64Lea/RzNEpCG
	FfCQmali8jPm+es3/1XYXLBtWvbeTQmtrcJXXouXJcXGUYzwfn71zWOQHek04myhPL4UHq4luarKt
	XF/tue98jaMShwa2S+E/rxcL3hocqWElCELldOT2mPsnLmzmbx7Y2uTajCvuy/e+dsNgU81d+eg1J
	x5nOCB8A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uzweH-00705P-0A;
	Sat, 20 Sep 2025 20:25:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 20 Sep 2025 20:25:05 +0800
Date: Sat, 20 Sep 2025 20:25:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linuxarm@openeuler.org,
	fanghao11@huawei.com, liulongfang@huawei.com, qianweili@huawei.com,
	wangzhou1@hisilicon.com
Subject: Re: [PATCH 0/5] crypto: hisilicon/qm - fix several minor issues
Message-ID: <aM6dIVLO9PQcZT1v@gondor.apana.org.au>
References: <20250913105754.3862444-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250913105754.3862444-1-huangchenghai2@huawei.com>

On Sat, Sep 13, 2025 at 06:57:49PM +0800, Chenghai Huang wrote:
> These patches fix several minor issues:
> 1. Address the issue of device accessing invalid addresses
> caused by the concurrency between device reset and business operations.
> 2.Clear all VF configurations when disabling SR-IOV.
> 3.Set the address to NULL after freeing the memory of
> qm->debug.qm_diff_regs.
> 
> Chenghai Huang (1):
>   crypto: hisilicon/qm - set NULL to qm->debug.qm_diff_regs
> 
> Weili Qian (4):
>   crypto: hisilicon/qm - invalidate queues in use
>   crypto: hisilicon/qm - mask axi error before memory init
>   crypto: hisilicon - enable error reporting again
>   crypto: hisilicon/qm - clear all VF configurations in the hardware
> 
>  drivers/crypto/hisilicon/debugfs.c        |   1 +
>  drivers/crypto/hisilicon/hpre/hpre_main.c | 111 ++++++++++++-----
>  drivers/crypto/hisilicon/qm.c             | 144 +++++++++++++++-------
>  drivers/crypto/hisilicon/sec2/sec_main.c  | 101 ++++++++++-----
>  drivers/crypto/hisilicon/zip/dae_main.c   |   8 ++
>  drivers/crypto/hisilicon/zip/zip_main.c   | 113 ++++++++++++-----
>  include/linux/hisi_acc_qm.h               |  21 ++--
>  7 files changed, 351 insertions(+), 148 deletions(-)
> 
> -- 
> 2.43.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
