Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BCA34B43D;
	Fri, 16 Jan 2026 06:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768543514; cv=none; b=MiRpChnZiaZBI44ydY5WUapdN9T/Ud5KC3+cOqb2+Ejf7GP6zEkUCATHb6ld8oWs7uGubwB/xypYBTaI6IxZiW4bNR7h+BGkRrecpPaVQAk0eTO1/4z6VOlIgdVKyPv1LW/vSBuqhO8V+aeZok67A3TTdZeq6b0dSZzLWNI72Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768543514; c=relaxed/simple;
	bh=w9YHMMReakv3voMCJBRaEuF83JlvmT1L7+W61rgTqpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PE69gn2fRGW3gcTfYddK8/VtAmtTLhMnn818Wbv9P2y3TX6jGejddqTnW0/tgnORy+bfrG3lMhpSOc3Yq0R+q/6jpWI7osewZ9lHve2zrHvodfKbqORzd0RqGmKrgj9XBuJDN7qfqyiQR4WkzhwtRX8tfqhq+vLx74wJPfpvZRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=DX/0AXHy; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="DX/0AXHy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=IFnTCpErq0U+aAIb6GYoLM2sA3SadlqlBBtbHp8xpps=; 
	b=DX/0AXHyYPrp9R9xSy6s150GF9CIZYA7RPFBYgUZM8hgAZr+cfZ4vpOh1HTtXMxdFf9vMuF2mrR
	NIK77IdUJXxdtvprPmIPkenBr8OHjnEz9zPv0hCSCMDHcHsQNW4VJsAN7jfbL1hSEA3iyOlk90yMU
	I0d+3RWoHzNIF9qLs8ycUD5sU8jN3CSn+dLiJlG+b1RYxbOXb7VQve4XdDyv7uJ0OqdXyZvC8jTGq
	OIztfqIUCwLKaSvHfikmbtbOPMZDCj5v+LAVjZSZ81xC4vXCaOBMfHqooXLmDXow+jS8oIP+4+M86
	iBRvhUmjkX9WWZfHk/uaF+bOdVIfbh7/kiMA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vgcxE-00HDN8-1L;
	Fri, 16 Jan 2026 14:05:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 Jan 2026 14:05:04 +0800
Date: Fri, 16 Jan 2026 14:05:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, fanghao11@huawei.com,
	liulongfang@huawei.com, qianweili@huawei.com,
	linwenkai6@hisilicon.com, wangzhou1@hisilicon.com,
	lizhi206@huawei.com, taoqi10@huawei.com
Subject: Re: [PATCH v4 00/11] crypto: hisilicon - add fallback function for
 hisilicon accelerater driver
Message-ID: <aWnVENZPxOM5d5SP@gondor.apana.org.au>
References: <20251218134452.1125469-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218134452.1125469-1-huangchenghai2@huawei.com>

On Thu, Dec 18, 2025 at 09:44:41PM +0800, Chenghai Huang wrote:
> 1.Supports multiple tfms sharing the same device queue to avoid tfm
> creation failure.
> 2.Support fallback for zip/sec2/hpre when queue allocation fails or
> when processing unsupported specifications.
> 
> When pf_q_num is less than the number of tfms, queues will be
> obtained from devices with fewer references and closer NUMA
> distances(priority: ref counts -> NUMA distances).
> 
> We can test by zswap:
> modprobe hisi_zip uacce_mode=1 pf_q_num=2
> cat /sys/class/uacce/hisi_zip-?/available_instances
> echo hisi-deflate-acomp > /sys/module/zswap/parameters/compressor
> 
> ---
> V3: https://lore.kernel.org/all/20251122074916.2793717-1-huangchenghai2@huawei.com/
> Updates:
> - In patch 7, fix the issue of skipping qp enablement due to incorrect
>   reference count judgment.
> - In patch 6, Supplement the device power wake-up operation before
>   applying for the qp.
> 
> V2: https://lore.kernel.org/all/20250818065714.1916898-1-huangchenghai2@huawei.com/
> Updates:
> - According to crypto framework, support shared queues to address
>   the hardware resource limitation on tfm.
> - Remove the fallback modification for x25519.
> 
> V1: https://lore.kernel.org/all/20250809070829.47204-1-huangchenghai2@huawei.com/
> Updates:
> - Remove unnecessary callback completions.
> - Add CRYPTO_ALG_NEED_FALLBACK to hisi_zip's cra_flags.
> 
> ---
> Chenghai Huang (8):
>   crypto: hisilicon/zip - adjust the way to obtain the req in the
>     callback function
>   crypto: hisilicon/sec - move backlog management to qp and store sqe in
>     qp for callback
>   crypto: hisilicon/qm - enhance the configuration of req_type in queue
>     attributes
>   crypto: hisilicon/qm - centralize the sending locks of each module
>     into qm
>   crypto: hisilicon - consolidate qp creation and start in
>     hisi_qm_alloc_qps_node
>   crypto: hisilicon/qm - add reference counting to queues for tfm kernel
>     reuse
>   crypto: hisilicon/qm - optimize device selection priority based on
>     queue ref count and NUMA distance
>   crypto: hisilicon/zip - support fallback for zip
> 
> Qi Tao (1):
>   crypto: hisilicon/sec2 - support skcipher/aead fallback for hardware
>     queue unavailable
> 
> Weili Qian (1):
>   crypto: hisilicon/hpre - support the hpre algorithm fallback
> 
> lizhi (1):
>   crypto: hisilicon/hpre: extend tag field to 64 bits for better
>     performance
> 
>  drivers/crypto/hisilicon/Kconfig            |   1 +
>  drivers/crypto/hisilicon/hpre/hpre.h        |   5 +-
>  drivers/crypto/hisilicon/hpre/hpre_crypto.c | 416 +++++++++++---------
>  drivers/crypto/hisilicon/hpre/hpre_main.c   |   2 +-
>  drivers/crypto/hisilicon/qm.c               | 206 +++++++---
>  drivers/crypto/hisilicon/sec2/sec.h         |   7 -
>  drivers/crypto/hisilicon/sec2/sec_crypto.c  | 159 ++++----
>  drivers/crypto/hisilicon/sec2/sec_main.c    |  21 +-
>  drivers/crypto/hisilicon/zip/zip.h          |   2 +-
>  drivers/crypto/hisilicon/zip/zip_crypto.c   | 133 ++++---
>  drivers/crypto/hisilicon/zip/zip_main.c     |   4 +-
>  include/linux/hisi_acc_qm.h                 |  14 +-
>  12 files changed, 574 insertions(+), 396 deletions(-)
> 
> -- 
> 2.33.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
