Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C9C3A8758;
	Wed, 23 Sep 2026 05:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790142706; cv=none; b=nqnDuyZ0dDJ/IxgLr20Ph+8yr8+YBkvLtvEbQULoHRtj8/wYgMuxMUNood1Cnc+kJyQ/XYHxei5ymc70rMrLe1nSsJ8JigOUrMR0y5cC4bBbfhIwJOfoa+DRZ0tcrY/en1+MRhYJ7kp56yYbj4PRjEBTkcC0TyQruueaoQk5iIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790142706; c=relaxed/simple;
	bh=cQGIwF3oyOH8whujBqkj49Yt5aSxsBKx2mzeATqLpyA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N768II2h2QubZlR3SqjPLQYJgDD6xZOZs7CsGoZiLGPZ6tr97LGu3N6gGQVP4VE6t/09VuRGtUDsUTIHIOZ4r7M5NIb03iXWMFzUmnoDNrqUew492ichEEFqUWoGrI4cgcUIyNL1Lp4k76IB9EvLvkVbyqTmlz2MmP8uXui1T/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=IDnCAQSG; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="IDnCAQSG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=S7JNK+tUJn0aTzQjrBzWjtxF01WxTfKhalyJo4u0hY4=; 
	b=IDnCAQSGb99ku0dhuQTzsUaivQX+CnccVceO1cBmXc5/5/varpefMqLYhzdJVaWiwVqp9vOXEVN
	837O7HJCyyi/lXirG9ArZfFGuZTr+RKoqNpzWbGMjFZBszudxDaHWFgG836yvhSMgqT9+nij9CWzQ
	LxmP0QhnDGYWydFFjhWo2DzagHoegZDu0rkiETH/cMTIBaE0VNBkpzzQ8kyt3DZIDUqIn4h5kyAcF
	AlXBcmIUwIENqaKP6dvSefj+Z6LajzIcMU4IdzcGePd9L/4kvNl2woid6Sc866SwQES/RPDEBLe43
	+cCJAyU8dC9b+Iu1JRU6tqNuyB7E7lsznBiw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x9FtL-0000000GutI-0eCd;
	Wed, 23 Sep 2026 13:51:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Sep 2026 15:51:39 +1000
Date: Wed, 23 Sep 2026 15:51:39 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Sebin Francis <sebin.francis@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 04/15] crypto: ti - Fix use-after-free of dev_data on
 DTHEv2 driver removal
Message-ID: <arNo63c8NOHkc5CH@gondor.apana.org.au>
References: <20260918102245.2784000-1-t-pratham@ti.com>
 <20260918102245.2784000-5-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918102245.2784000-5-t-pratham@ti.com>

On Fri, Sep 18, 2026 at 03:52:34PM +0530, T Pratham wrote:
> Each *_init_tfm() caches a pointer to the per-instance struct dthe_data
> in its transform context (ctx->dev_data), but never takes a reference on
> it. If there are tfms in progress when dthe_remove() is called, the devm
> allocated dev_data gets freed. Then ctx->dev_data will point to a memory
> that has been freed.
> 
> Move dthe_data to req_ctx structs of algorithms, and store the device
> pointer in tfm_ctx. Add a refcnt to struct dthe_data, which atomically
> counts the number of requests enqueued in the crypto engine queue which
> reference the dthe_data object.
> 
> A waitqueue waits on this atomic counter to get back to zero in
> dthe_remove() before doing the driver teardown.
> 
> Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
> Signed-off-by: T Pratham <t-pratham@ti.com>
> ---
>  drivers/crypto/ti/dthev2-aes.c    | 74 +++++++++++++++++++++----------
>  drivers/crypto/ti/dthev2-common.c | 40 ++++++++++++++---
>  drivers/crypto/ti/dthev2-common.h | 52 ++++++++++++++++++++--
>  3 files changed, 134 insertions(+), 32 deletions(-)

Please check the Sashiko comments:

https://sashiko.dev/#/patchset/20260918102245.2784000-1-t-pratham%40ti.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
