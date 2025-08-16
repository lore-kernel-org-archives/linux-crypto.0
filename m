Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8803F32C8B;
	Sat, 16 Aug 2025 09:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755335666; cv=none; b=BALNukElkKL33UAQK7Z+fV+W38rQeQXZh/m+77kabxyBTuo1Mxg1qj2U+HMvshhE5Tp+VhTlWMhW6bGfkj7kiupSD2sDdO1beyOw91z0yybGNDZ2fOgZZ0R4T38pnR1eobrC5CUvRuKaVxdsvDkbnxfRwspjtSWhBpTqlThFRo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755335666; c=relaxed/simple;
	bh=gQHw5eoMyDs5N7j3Pwa5C/OHvLTlTFVdX4u0gzAhBbY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dM8cVb2K1sVN1dQSMPX+SpxvX9sw35D3YicjCEQu+jvSgOY3AXZb0pbPzJHU/2fGZ33Lqz3yhHTNJUlOfw8dsPRIvqHQ2H1/GaoV7g/hugroMXNh4hCYwZVBbF4fcqwzM4JD/dspo/XHM6PunvfGlEM7nABaeOZ75GgiTYNmDm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=GZmoBS/G; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="GZmoBS/G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=I8mQERM0DZJtc8jkiwyX1EYdkXnAqDEsDUK64Z66OT8=; b=GZmoBS/Gf8jNXjAj0DmzDR4mSE
	AYm+f4Ga/o4tO3CDMgifX9bpLs7MTQun2y2nlvTwYEAwH2Wj1C/+iFzyk0IZpAkkuTbTlFWFhqAMe
	c+WOC2IWXU686laYegD+aESEITWxGySRJPzJXmUZMFGyt+9V3Mm8P0ycl7KWTcfV49/atwpppUL+/
	fC9hcrPfhGmONZpl33NDr9mOPIGynBoBf1njGdcn9vUku/i9SkBcm59mVQ6Xfv6dDgS/SaQESaEbv
	J8MzV+CJJACvMfp4uTYtNaL5g25s7VFO915qat2vbCom34f4zKkHYQyOE/yObYnTQu6bwgxN6fFQB
	qUPbpaUQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1unCk4-00EmCH-01;
	Sat, 16 Aug 2025 17:14:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 16 Aug 2025 17:14:20 +0800
Date: Sat, 16 Aug 2025 17:14:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, liulongfang@huawei.com,
	taoqi10@huawei.com, qianweili@huawei.com, wangzhou1@hisilicon.com
Subject: Re: [PATCH 1/3] crypto: hisilicon/zip - support fallback for zip
Message-ID: <aKBL7MF2_NRUc9so@gondor.apana.org.au>
References: <20250809070829.47204-1-huangchenghai2@huawei.com>
 <20250809070829.47204-2-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250809070829.47204-2-huangchenghai2@huawei.com>

On Sat, Aug 09, 2025 at 03:08:27PM +0800, Chenghai Huang wrote:
>
> +err_out:
> +	if (acomp_req->base.complete)
> +		acomp_request_complete(acomp_req, ret);

First of all you should never check acomp_req->base.complete.
It must be non-NULL for an async driver.

More importantly, you shouldn't even be invoking the callback
function here.  The callback is only to be called after an async
return with -EINPROGRESS.  Since this code path never returned an
-EINPROGRESS in the first place, it must not call the callback.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
