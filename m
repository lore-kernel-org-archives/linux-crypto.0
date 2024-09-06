Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2F44437A;
	Fri,  6 Sep 2024 07:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725606621; cv=none; b=pobSDe0dcCc13iV2XDWMvCqZA7fPIrnJcj03V9yKawE0dKFv1LNLbPD/AD8E32eUpR3WbOVJbyLRT0rQGeDUPcHfp3w0GBBGv4ZzA1dj6xFb9y4YnwBWO5PkyN2PJQTl0bZ4URojIYhyCsZ3n+hFMpjck9kNOZWaWurHcE1JZps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725606621; c=relaxed/simple;
	bh=ZPWejjUfLOBL4P2yTgZa8jIPOjryLDqCct+jCLfFmAs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ulCgKdttsF1c2UQXVqMq9qprjqoQStAtFoC4+9Caogi0+Rx3f8ZshUU4QIQ+HwFx+L4b/VVY2nX39PS0vx6rQR6Vw79FlaZAe0AlBGxyEqY5F5PmvOoS/2EKkKzvQdME+KtufS4yKH6b0xpCMO43RGM/IuVDGWvVzmVfaNFGPC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=FwaiXxjb; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="FwaiXxjb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KC27/6VhR/yC6MJNycAq5ZmHqIxxF4Si4/UtOBwtPdY=; b=FwaiXxjbaXOcaNSnXgqYV9zsUR
	HO6YlzSs2T4Mh0x4yrta5rWoNKSwrjUwNrTRkQkRQ74ldUjt0bNE5IWwu4PQeDb5MRfjsRNySTYA4
	y9Cpd0cX8da/pQLmTykX9/xk9IULMAzQvoG5psTzFnAfxOPeUwtBU/uP3HP4aecz9QiLCz2H5gq5q
	MO9751F+kc5z8MWItjZQrM43qVBZBXqSpItbb5qObanXTTY9GrB4ammWrsbR2IffGEi/GC1NHGng1
	x+WG1ZxCDzflXVliaxAM4r1GiwC0soywBGR28y2p7SYIJLtWyvUQPlA6aHgdcrBgSBxHdXkrzJtwd
	6kuatCRg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1smSwr-000WYP-2Z;
	Fri, 06 Sep 2024 15:10:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Sep 2024 15:10:15 +0800
Date: Fri, 6 Sep 2024 15:10:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Weili Qian <qianweili@huawei.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	liulongfang@huawei.com, shenyang39@huawei.com
Subject: Re: [PATCH 0/3] crypto: hisilicon - fix issues related to device
 reset
Message-ID: <Ztqq12iIS7fudcoL@gondor.apana.org.au>
References: <20240831114831.21987-1-qianweili@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240831114831.21987-1-qianweili@huawei.com>

On Sat, Aug 31, 2024 at 07:48:28PM +0800, Weili Qian wrote:
> This set fixes some issues related to device reset:
> 1. Before enabling the device, reset the device to ensure that
> the device is in the initial state.
> 2. Mask device task timeout error because the current device
> timeout threshold is too short.
> 3. Memory error is injected to close master ooo to prevent the
> device write the released memory.
> 
> Weili Qian (3):
>   crypto: hisilicon/qm - reset device before enabling it
>   crypto: hisilicon/hpre - mask cluster timeout error
>   crypto: hisilicon/qm - inject error before stopping queue
> 
>  drivers/crypto/hisilicon/hpre/hpre_main.c |  54 ++++----
>  drivers/crypto/hisilicon/qm.c             | 151 ++++++++++++++--------
>  drivers/crypto/hisilicon/sec2/sec_main.c  |  16 +--
>  drivers/crypto/hisilicon/zip/zip_main.c   |  23 ++--
>  4 files changed, 146 insertions(+), 98 deletions(-)
> 
> -- 
> 2.33.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
