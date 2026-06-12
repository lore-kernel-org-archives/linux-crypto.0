Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B2D33BBBD;
	Fri, 12 Jun 2026 03:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781235964; cv=none; b=sn6lWvCSly/+ti5OBBkGn5sHKHCU3p0FHJh8UOuoFQcBKc1cU2PrytWk80w8r0H/kJk92+xELupmf5ykb/8r0Rzp0Upf4d5sAXN9OzNa5efCwVXL2JqMIInpNHKEvfqhw0IQX6Civ0BNcKdogIOBcDPNiog48PLXAKE0p4d+0Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781235964; c=relaxed/simple;
	bh=YmIT30wJVMHHDBOaAYxOWOsJy3qLJqGh5jo8uWSE3IM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P9asc+VXvcJFzLVJMFpuRnG6eRYx4x71VPMZKJaZAvgaTMH2lfQWZL1CcuBUjocv7ZICb9/wMVbqcRJXwmUMxEznAkwTH9UZRRmvlu06uyAhxS9GZmbnLH1Y7jKvcet4TPMm3CzBwOQsZ+1fuv2327QBIsO/ClM251Dn7SaRbaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=klgtFRZa; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="klgtFRZa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Bhaujo1ehdyWC/DbtAq8rlj792b9Kpuyl7yql8WoRa0=; 
	b=klgtFRZa0JchY1z3u9Z+TRPFlWziQRUxg4swv9VF+nu0Ikw5OIxlVGmbjZhvO0nIQ5x1eEQ48vL
	6BX28lE+RUDaX8WMtbA9h89TdQm4OmBUGin2sI/PLeSOyX0De6Hqi/7544M81NJk9wawiTRP6eSfc
	U3CS675ZqCANKS6/pu7iQpd2eczvF681faprkBoVZDCabooknz4YDj7mrtt950pkDBAtzccwNO/jN
	xkt/EhWxcBmJkV1mN0fbQgJyk4tr/V141pMWKC0tsa5uBf2Oi9FjxIs9CE3a4Be2AxaE4QGdcX2aw
	cbGaalhlrdx4U2Bz1xSzEhAAZc6RdO6PNyIg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wXsq8-00000004mdI-3Me3;
	Fri, 12 Jun 2026 11:45:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 12 Jun 2026 11:45:52 +0800
Date: Fri, 12 Jun 2026 11:45:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Thara Gopinath <thara.gopinath@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Bartosz Golaszewski <brgl@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Thara Gopinath <thara.gopinath@linaro.org>,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: qce: Fix xts-aes-qce for weak keys
Message-ID: <aiuA8CCGcfP6MdLy@gondor.apana.org.au>
References: <20260610-qce_selftest_fix-v1-0-1b0504783a46@oss.qualcomm.com>
 <20260610-qce_selftest_fix-v1-1-1b0504783a46@oss.qualcomm.com>
 <533motquixnbence674lawbnlnxevcrcnysymwncjis46j5uoq@wcemraangg63>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533motquixnbence674lawbnlnxevcrcnysymwncjis46j5uoq@wcemraangg63>

On Fri, Jun 12, 2026 at 03:40:49AM +0300, Dmitry Baryshkov wrote:
>
> > Fix xts-aes-qce behavior by using generic helper xts_verify_key() to
> > reject keys early with -EINVAL for FIPS mode active(or FORBID_WEAK_KEYS
> > set). For non-FIPS mode, since QCE hardware cannot accept the keys, use
> > software fallback mechanism to encrypt the data.
> 
> No, if it is a hardware driver, there should be no software fallback.

The driver must support everything that the software implementation
supports.  So if the hardware can't do something, it has to use a
fallback.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
