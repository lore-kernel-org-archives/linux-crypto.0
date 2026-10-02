Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393DB371889;
	Fri,  2 Oct 2026 07:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790927485; cv=none; b=nEVRv/zHYwCjLBhfEVfrGe3PMk+ZKD577jlFB5odEUscrj952ZJputAuX1sbJ7KAWYTIEBAJw6MIEqQSAI3eKBOQZi48b3wtJxtaiyDGizF/NI4EJT0hlOvYZ8+X0FKv47OcOae0yZ4bERB/jwFFqk4VMH7YaBOrKDXlIM9TD1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790927485; c=relaxed/simple;
	bh=w+7dMhaGO0oDFyV5bRHOH1sqXbOxSAvi5CXGbWtLD7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U48a4VWh/kTge1UfMjMEnhV4gc6aAZYJSr9qls4JJ/ZUtb3pKjZmyYCpZ4WTgzwBlNt/hfBlqU3UpBd+qXJsp098I+f0LwOt2SlwOGHDtqp1MIhS4wDDH0aCG8Zl0x8w9xHbnX8fmJH99C5fEiYkdbkpS4gHUS/NxS6kkftHb0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=LKJRKwku; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="LKJRKwku"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=L7E16o+8TnxV0ARhRGzXbsCwMnvf/WVHMaN8d7gW8q8=; 
	b=LKJRKwkuytZXdpdKMIJnKHV42xoCwgGT9km9yK1cXBLZS1t8BIInX5IhsX3bo3zH2eNM29CPHFF
	3PLev5vmXH9u/nTdPA1qUJmObm7ShE8C4TBTMzbXqEiPYXCNL5ujzRonlYNHRQHfLZ7GX5B/czAge
	+slrlQtFF7KxtZGW/iRf1BsqfKpiJAQ7WVIMokK9kxGnhDJ1nF+hlW6OAbaHcKNYhCHz4i7QwGaFp
	ueU/YXITP5XrnhNbeNDlK7V/fciQ+ZlKaK3sMHkL/X6LbZKNud6P9qGI4d2jLQ/AAoDq+U1TlFRrN
	1o3DwsaTziicKGdFW31OtBDguiolmPZaA6hw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xCY34-00000002m0M-3mPM;
	Fri, 02 Oct 2026 15:51:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Oct 2026 17:51:18 +1000
Date: Fri, 2 Oct 2026 17:51:18 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Weili Qian <qianweili@huawei.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	liulongfang@huawei.com
Subject: Re: [PATCH 3/4] crypto: hisilicon/qm - check queue depth read from
 hardware
Message-ID: <ar9idr-u72CMxPLR@gondor.apana.org.au>
References: <20260924113812.1110302-1-qianweili@huawei.com>
 <20260924113812.1110302-4-qianweili@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924113812.1110302-4-qianweili@huawei.com>

On Thu, Sep 24, 2026 at 07:38:11PM +0800, Weili Qian wrote:
> When hardware is abnormal, queue depth values read from registers may
> be invalid, causing array out of bounds or division by zero.
> 
> Add a QM_XQC_MIN_DEPTH check in qm_get_xqc_depth() so all callers are
> covered. The check only applies to QM_HW_V3 and later, where depth is
> read from registers.
> 
> Fixes: 129a9f340172 ("crypto: hisilicon/qm - get qp num and depth from hardware registers")
> Signed-off-by: Weili Qian <qianweili@huawei.com>
> ---
>  drivers/crypto/hisilicon/qm.c | 34 +++++++++++++++++++++++++++++-----
>  1 file changed, 29 insertions(+), 5 deletions(-)

Please check

https://sashiko.dev/#/patchset/20260924113812.1110302-1-qianweili%40huawei.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
