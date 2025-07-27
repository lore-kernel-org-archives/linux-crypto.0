Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175FD26ADD;
	Sun, 27 Jul 2025 12:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753620376; cv=none; b=mcuYytXO2G6+XPNGNgmshNGxo1ktJVh2kCIl4qnd3u8fCniUQ3L8fHSc3pE9OnSOt36Z4BSfEOb2E/aCIGlPgHBN/jbm+y2Tv4GWNLdtjLupVIo3E77FXmN0WPN1X+lZLO3Ca/TQNDMKLX3nbS+T/u/EwP90BIkW5+RvbQhN6eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753620376; c=relaxed/simple;
	bh=lqxKySr4HGNDC5cPYk13QRS+Yt3nxpb7ewY6dbZBvA8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s4wswUVy7DFvFSe3EhfHOUNx59K+FqtfmJz//KN7D5IzgbPZPOX5U76Cj1tMGlVxKt7RGsnZYA9G/atcsJoKnLv0tjvoyVkXO0DNozfDaxyw45Dx6h1c5ip7Iz4iST1m5NOnf4BcZvZuekoiol46kisF/CEAzV6vRBxL4OfSLuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=jA6byJEV; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="jA6byJEV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kaU3qNPjzkaGKu4iy5fPglG1ICwxZWvNTmm2yQMC2Pw=; b=jA6byJEVq2BGVo2nK3+Zg5Qz3f
	n66FUjo7PyxNvLykJ4sB2zrJ4K0nLNNQco2/sOOPRKV53wttEnAs9pFzCLIrCCNWUgk9HRpHb2yUf
	gbWCrp2HTOlpyqP0aww0BmMvsVTaVP8r8seLX0w+UxRQEJ2o25kFIhlXb1Z2VPbexnImZsIPa+w/N
	AjzGN/PeS6crn7ikCUPUfndcCQ6T5iRVAkTwRZVP55ESb8ZdnAQz38icp5mMm2RmiMeo4do3qYt1X
	4SouPlJPn4hzWTC/zai7MIlBUMBqJdrAiOrvSQiYKzNmOrrBK+5+aUHX5qDthMFCW/Q3dLC/INapa
	ZOcRw7oA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ug0W5-00A4un-2X;
	Sun, 27 Jul 2025 20:46:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 27 Jul 2025 20:46:10 +0800
Date: Sun, 27 Jul 2025 20:46:10 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, liulongfang@huawei.com,
	qianweili@huawei.com, linwenkai6@hisilicon.com,
	wangzhou1@hisilicon.com, songzhiqi1@huawei.com
Subject: Re: [PATCH] crypto: hisilicon/hpre - fix dma unmap sequence
Message-ID: <aIYfkv1RqP6MR9-j@gondor.apana.org.au>
References: <20250718100501.3281345-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250718100501.3281345-1-huangchenghai2@huawei.com>

On Fri, Jul 18, 2025 at 06:05:01PM +0800, Chenghai Huang wrote:
> From: Zhiqi Song <songzhiqi1@huawei.com>
> 
> Perform DMA unmapping operations before processing data.
> Otherwise, there may be unsynchronized data accessed by
> the CPU when the SWIOTLB is enabled.
> 
> Signed-off-by: Zhiqi Song <songzhiqi1@huawei.com>
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> ---
>  drivers/crypto/hisilicon/hpre/hpre_crypto.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
