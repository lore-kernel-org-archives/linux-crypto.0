Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F55333453;
	Sat, 31 Jan 2026 02:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769828378; cv=none; b=u+2kq3+QqO1ZQcFCtfWad/q9Yhtw8LbXiNC24YFQ1ZXhDAIcHU11c49hbXzTP5H5gCK8BNbtCA4s/TUI5KYPBTTieNCi4ReuqzCMeX/JoOZqUZm3b27F2crJVDAZ5uMulDpgGwO2DsTsTMMPn5ayvAP8ii08Ox+zvXNHEmZStDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769828378; c=relaxed/simple;
	bh=UV6vOBe/s9ZrXQMStEx+nP2hT+BESNBDA/Q3R8F8peU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OXr1k3Ia8nZIXHONA9uP32lc/wIkMkzkWcH1jCXtVT7zluzh//WsEJBAAlFcA5LsmNbmVdxTpovF6RaUNtKHA9HyRIdKy8d5OEqzundbc56JePfSkZ8INqkDYde+I+ZB7hAJvkHe0ign7vex4wJRGa33Vg0wKsvJN70OWdnt++A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Bi3B47Bm; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Bi3B47Bm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=D/pBD1MfcKddevA/EFILQS/eLKn70N9zPy7scR8Hzaw=; 
	b=Bi3B47BmC4DPfz/znFs8ZoxQBFGC26z0G7dxhgNFUexwgMyX90ftx1PQPDm59j/+48+QPQlsKE0
	YIjKOZcULZxS3Jq4DJM06NQve25pU2mJLPvHSRLlrKTUhDYhLhP7BM9DY/y1GtgQlHiNewkGvTbQ9
	LhfF4c40BUGsnNdBvDlxTbECPAXVVrG255RJgtCavwm8H4ScIhxrX8vQApWLoMGA+Ihq7djIiC/Hg
	v1yN48Qc6FSUTkbwDZz9QXRRTpWf0RT4clLlVq2cepD//03WXhpNXZZb3H7PufTz87V2cxhP90TBR
	8z5jgDkKzip88F/F0l37m9/uZJYIUEsBd+fg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vm1Cu-003S3D-34;
	Sat, 31 Jan 2026 10:59:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 31 Jan 2026 10:59:32 +0800
Date: Sat, 31 Jan 2026 10:59:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, fanghao11@huawei.com,
	liulongfang@huawei.com, qianweili@huawei.com,
	wangzhou1@hisilicon.com
Subject: Re: [PATCH] crypto: hisilicon/zip - add lz4 algorithm for hisi_zip
Message-ID: <aX1wFPCXgJpYk2AY@gondor.apana.org.au>
References: <20260117023435.1616703-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260117023435.1616703-1-huangchenghai2@huawei.com>

On Sat, Jan 17, 2026 at 10:34:35AM +0800, Chenghai Huang wrote:
> Add the "hisi-lz4-acomp" algorithm by the crypto acomp. When the
> 8th bit of the capability register is 1, the lz4 algorithm will
> register to crypto acomp, and the window length is configured to
> 16K by default.
> 
> Since the "hisi-lz4-acomp" currently only support compression
> direction, decompression is completed by the soft lz4 algorithm.
> 
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> ---
>  drivers/crypto/hisilicon/Kconfig          |  1 +
>  drivers/crypto/hisilicon/zip/zip_crypto.c | 91 +++++++++++++++++++++--
>  2 files changed, 84 insertions(+), 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
