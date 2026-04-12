Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F0B339A8;
	Sun, 12 Apr 2026 08:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775983847; cv=none; b=GH2ioDlcLCMSKdAhL0LpOqo7QltJjkHuO26qv7fMkAc9j0PbewjwXSv9NYmx+SCA76KrdpQMtxXAd58dbPThqfnbfKIcnTZARTpQecCL4nPzy1JO+RhfYAytRwm/SsaFVtZzGylnHbxUtZAWYYDSFw0cDLD/kgIFYHz9rl8F/rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775983847; c=relaxed/simple;
	bh=KtNwlP/JGUElW7AHjkUMdkOeCVq+hTQ9PCYGkBjibbs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HpVPTBt7tynIhfFYuTnggiM6LCcW63PNFMJRkxdjxoGG2MVEtSWKTyL0ObT/6I0eSjYbz540cmGIDsjsdjhxsNP7Tp6G0yc166Bkp2DzZGoGYqbVNUlvkZcqBbmPrCENzaehjTBica3MPKW/BFtsLlOpIXgQ6qEdNrPI5RfBWaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Wdmf0Y4J; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Wdmf0Y4J"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=G3SgEWiSUFM4n/Wbv/0cAL9oVLgOLjSdedAzpcqIh1g=; 
	b=Wdmf0Y4JidAM84SoyOWi+aD+FwxpKVXsibFlmeDPDO/AcMo23pel7t6tROOnX/tbBfyTDCNnDae
	0PEaQ7z+ZoCllm9808462MuUf0oM49jOFl0jky/zBmKIHEpgCkaRKGBsgknxXczdGttP8AAV/VB+t
	enaz6xWur7z6E7RcJclhGXhhZ51aQ+6TIXcqd66kUQRyEArBQWqlzNuG9kT/X/QQPYruLEFD555Ju
	mqWqs9BUt3FW8wHVPpDBUOz0p2SNfof6/0HWlTMUD0+OHgc8yGLVN63UFSdXUtcfVZOKDB/RaaoQG
	KmrvMh9nrnQ/iUvu3csHEXilVw9P0fYjc5iQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wBq7C-005UEm-1U;
	Sun, 12 Apr 2026 16:50:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 12 Apr 2026 16:50:41 +0800
Date: Sun, 12 Apr 2026 16:50:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, fanghao11@huawei.com,
	liulongfang@huawei.com, qianweili@huawei.com,
	wangzhou1@hisilicon.com, yinzhushuai@huawei.com
Subject: Re: [PATCH 0/5] crypto: hisilicon - series of cleanups and format
 fixes for hisilicon driver
Message-ID: <adtc4QQ3HcvruE7s@gondor.apana.org.au>
References: <20260330062531.2976138-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330062531.2976138-1-huangchenghai2@huawei.com>

On Mon, Mar 30, 2026 at 02:25:26PM +0800, Chenghai Huang wrote:
> 1.Fixed a format string type mismatch issue identified through static
> analysis and code review, which could have caused display errors.
> 2.A const qualifier addition to improve type safety.
> 3.Removing unnecessary else statements after a return.
> 4.Removal of redundant variable initializations that are overwritten
> before their first use.
> 5.A cleanup of unused and non-public APIs to shrink the public interface
> and remove dead code.
> 
> Chenghai Huang (4):
>   crypto: hisilicon/qm - add const qualifier to info_name in struct
>     qm_cmd_dump_item
>   crypto: hisilicon/qm - remove else after return
>   crypto: hisilicon/qm - drop redundant variable initialization
>   crypto: hisilicon - remove unused and non-public APIs for qm and sec
> 
> Zhushuai Yin (1):
>   crypto: hisilicon - fix the format string type error
> 
>  drivers/crypto/hisilicon/debugfs.c       | 22 +++++++++++-----------
>  drivers/crypto/hisilicon/qm.c            | 16 ++++++++--------
>  drivers/crypto/hisilicon/sec2/sec.h      |  2 --
>  drivers/crypto/hisilicon/sec2/sec_main.c |  2 +-
>  include/linux/hisi_acc_qm.h              |  2 --
>  5 files changed, 20 insertions(+), 24 deletions(-)
> 
> -- 
> 2.33.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
