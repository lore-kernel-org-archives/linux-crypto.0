Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6634523D288;
	Mon, 25 Aug 2025 04:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756096590; cv=none; b=LIXI14++qV/BM8yymGx+1p+w9GipTrIL0aRpjeEWISd9dbCX9cQbvVHZ1o+mNSicOXTTX2MtL/GXaanxgYmD/YH0bETwG1DmLqLFupzZppdoNgQ4W3WQ2ZR8NLpZ393eLR4QAhwvBs3XEzjHkeMmafiO0/oPyZpS+wfOcbsO/Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756096590; c=relaxed/simple;
	bh=sTunfMCq4/E9IlV0C2VSUlNM33ne8GOa5NtUxLEAanA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BYLUHM+4T0ryby+KPjJy4gn+0RDskP25CZVj5V4K1hSK2hDw/wiLpA03qZ+97WoiE1/2glwiqa8VxHjd0eUgg2U5KnhtQyZwpuDLk6jUh9GMygRx88tP3GNobjfhu31Qppl0NbOzJwMpE/RWmTUM8m/c6utmJoUNq/gWz/3JSK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=WDEOiJz5; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="WDEOiJz5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CAAF7pgkMZz/jA5UL8kzFkhd0KBcVmgKgcH+O4+CyTM=; b=WDEOiJz581vzbKXVFX10mc6NpP
	E2f33ybgUXFgTEvInxeMlodeSZEK5LLXRZH0kBhlj+LLzMDpdxwjzSVozBt7BGTB78Kdsc0cXJM/1
	jvvjARE7nd/ddUuwRHNvh89EMIhbO4hD9p1fHpc51ICqXCqW4+y84KWDV7cGYvTdpKt+yHjKDB9fe
	o34Dge1KhGDIO5QBUU5Lv/+/a94VaZmuzOdzrYbjO/IPADJrCVjOTm5UBTFyWUJ0C+6yk3zBv1dG2
	ZkO1JIIz2qa68a5VG5I48RNlFEK53xr9QqeKFY8dzg2/Pk+V3RDRS4VEEj8KBMaIskQMdY3LzOd6g
	ZFNURwsw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uqOgs-00GzL2-26;
	Mon, 25 Aug 2025 12:36:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 25 Aug 2025 12:36:15 +0800
Date: Mon, 25 Aug 2025 12:36:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, qianweili@huawei.com,
	linwenkai6@hisilicon.com, wangzhou1@hisilicon.com,
	taoqi10@huawei.com
Subject: Re: [PATCH v2 0/3] crypto: hisilicon - add fallback function for
 hisilicon accelerater driver
Message-ID: <aKvoPwhKyoVz8Yta@gondor.apana.org.au>
References: <20250818065714.1916898-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250818065714.1916898-1-huangchenghai2@huawei.com>

On Mon, Aug 18, 2025 at 02:57:11PM +0800, Chenghai Huang wrote:
> Support fallback for zip/sec2/hpre when device is busy.
> 
> V1: https://lore.kernel.org/all/20250809070829.47204-1-huangchenghai2@huawei.com/
> Updates:
> - Remove unnecessary callback completions.
> - Add CRYPTO_ALG_NEED_FALLBACK to hisi_zip's cra_flags.
> 
> Chenghai Huang (1):
>   crypto: hisilicon/zip - support fallback for zip
> 
> Qi Tao (1):
>   crypto: hisilicon/sec2 - support skcipher/aead fallback for hardware
>     queue unavailable
> 
> Weili Qian (1):
>   crypto: hisilicon/hpre - support the hpre algorithm fallback
> 
>  drivers/crypto/hisilicon/Kconfig            |   1 +
>  drivers/crypto/hisilicon/hpre/hpre_crypto.c | 314 +++++++++++++++++---
>  drivers/crypto/hisilicon/qm.c               |   4 +-
>  drivers/crypto/hisilicon/sec2/sec_crypto.c  |  62 +++-
>  drivers/crypto/hisilicon/zip/zip_crypto.c   |  52 +++-
>  5 files changed, 360 insertions(+), 73 deletions(-)

Are you mapping one hardware queue to a single tfm object?

Hardware queues should be shared between tfm objects.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
