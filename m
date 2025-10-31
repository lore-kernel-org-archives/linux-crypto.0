Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BF63370EF;
	Fri, 31 Oct 2025 09:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761904315; cv=none; b=KLShdFYn0zEkhK4KAq5/6YK81s+lQ51GFB2qst5bM/5Rwog65WEx9jDD4Xo+DQdjcaoCBWUKvLyNDq09I+zziRb7vC58zCaBKsdal+Q0f4IN9wAPfrhyiWymeo8kMk6dvb3nvSdgD0Lw3k4wyxNAKrf+VwqqGFrWB2KaHzUUgPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761904315; c=relaxed/simple;
	bh=PDFuBlu8oOxRIhVXSqK9xLuC4ljEIXqwOKBWQgrEYOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VEooDU9aymwk9pXqSBu6PnQaRnSlTyx+3BlO2WB1OdAEeZydhAcPoMtysH0be75FlutEDann8xiHzuzpOb2qTH5nUDLyqw0jj9tNocr0tRth330D7L1f4Dj95kJN0Po00GUCMndRVniupi5IfYhoul7qYl83BnOQZfKy2ILOKQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=j3Z82cKC; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="j3Z82cKC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=A229h7fmdP3j/E0BqPjEArCuwvdpxEJ5MbsR4jiXiU8=; 
	b=j3Z82cKCXehYLTRbdgMfnYkQnRwoS5X1bLHjuwqJVsyZO/5ltBy4dE3e7YIVRQNTud3+jTj2c4X
	DKsqH4aZ4cI+kfHkrxdJEnFTHsF7o5sAeq2Sktiq7H6q1qvtDucWumpGWefgeEPwlY6dlTik+pzjv
	A2JIu9LJVL2t8Oh1zluFyQZnfePyADyQe8V23hGwpM7PKZ4QDlcAZx6hzXe3BSMjQ5REb3OMkkTyh
	Lhq3PE6Bqfg2XYqOPQahawpxjLFSBpAvAH/OgCkrO3Kahoco7ATBRJ475D64lkeEEiM1oH3Cs4vMg
	DRVTToGUMv20a/whkWXwMd5CLrT3unuN5c6g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vElnR-00H1h7-0u;
	Fri, 31 Oct 2025 17:51:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 Oct 2025 17:51:49 +0800
Date: Fri, 31 Oct 2025 17:51:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linuxarm@openeuler.org,
	liulongfang@huawei.com, qianweili@huawei.com,
	wangzhou1@hisilicon.com, fanghao11@huawei.com,
	nieweiqiang@huawei.com
Subject: Re: [PATCH 0/4] crypto: hisilicon - various cleanup for QM and SGL
Message-ID: <aQSGtcXDmT521qye@gondor.apana.org.au>
References: <20251025101258.2793179-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251025101258.2793179-1-huangchenghai2@huawei.com>

On Sat, Oct 25, 2025 at 06:12:54PM +0800, Chenghai Huang wrote:
> This patch series addresses several issues in the hisilicon crypto
> driver:
> Patch 1: ensures proper synchronization when reading eqe/aeqe
> values by saving the complete 4-byte values atomically. This
> guarantees the valid bit and queue number are read as a consistent
> pair that was written by the device.
> Patch 2: adds concurrency protection for the err_threshold variable
> to prevent race conditions between sysfs operations and hardware
> error handling functions.
> Patch 3: removes redundant error checks for curr_hw_sgl since
> acc_get_sgl() cannot fail after mem_block creation, simplifying the
> code.
> Patch 4: adds a default case to a switch statement in
> qm_vft_data_cfg to comply with coding style and prevent compiler
> warnings.
> 
> nieweiqiang (4):
>   crypto: hisilicon/qm - add concurrency protection for variable
>     err_threshold
>   crypto: hisilicon/qm - add missing default in switch in
>     qm_vft_data_cfg
>   crypto: hisilicon/qm - add the save operation of eqe and aeqe
>   crypto: hisilicon/sgl - remove unnecessary checks for curr_hw_sgl
>     error
> 
>  drivers/crypto/hisilicon/qm.c  | 41 ++++++++++++++++++++++------------
>  drivers/crypto/hisilicon/sgl.c |  5 -----
>  2 files changed, 27 insertions(+), 19 deletions(-)
> 
> -- 
> 2.33.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
