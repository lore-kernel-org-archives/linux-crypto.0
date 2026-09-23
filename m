Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B455126BE1;
	Wed, 23 Sep 2026 05:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790140524; cv=none; b=XwSel4EMZkUQ3TcwTJaanP+QhKCwYQJC/fI+q66FhhMk+7NS1bjfQyxSQ/pz0EdHswvi1mhonVDyz0JKZ7x9kAgkSsZsh9TOgawzymWhLrfB271BdIkh4GmIRElOA80uojLIhHq1daHiheVXJTC1bbOmL7qIhXAXLI6G/CXGcHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790140524; c=relaxed/simple;
	bh=Kd8RKb6dMAaYXPOLBDZ00Vt78qVvgPM9mS7FWopWxpo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oUEdFaXyxSs5ARcRFatcOJ/Xs8ZBLwWiGUiyUPpE3LJGEkqzhw/doIaj+6e8gENcUcdCPxdBPpYCKKKZ6PXfNQfFd96pwTnHXozksMsEoJ3NBJx2yC0jAkUAc5jHxeteHzdYxfhxSVH/vBvnWv+1dRAI/OewVbOPazqxGe11d9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=gkWEdNm+; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="gkWEdNm+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=5j5SdMSQ+pEkika3L3VDn3qQtVQCoT7r9CoixaQ9M9A=; 
	b=gkWEdNm+7vRR9iy8yNuZANV6lnVHQr2LmFR+kYF239dX8vb/hfPsa04MpgmMDVacvLLnjUhDvgj
	ulpp2ZVSnzhbgBNTu6P0c6b1cSY4qKsII2dy52JYmbFmVBphbtpoDU3BHDYz2p/Sw+sbxHanpKwme
	tMYBujCW1zA0r3fCodU599g4rDjmjyxp8zvEAsAizke2te1Vm9A9C4nXbsYs+8D02H9beeFLrGY8y
	9wtUE90wNXKwscbdOjnaue9Q0QBGCV/HVGe3xIRLOltLiUvRUdTzw2iXAN4AukgXWyt8uCvGf8GD0
	ZVaBeWdH/lHg7ljQevUf3xcNJwGGGHGHUGlg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x9FK6-0000000GuPg-3l9W;
	Wed, 23 Sep 2026 13:15:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Sep 2026 15:15:14 +1000
Date: Wed, 23 Sep 2026 15:15:14 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: jenny.zhang@starfivetech.com, jiajie.ho@starfivetech.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	olivia@selenic.com, lkml@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3/4] hwrng: starfive - Fix runtime PM leak in
 starfive_trng_read()
Message-ID: <arNgYk8hFDdlJqD9@gondor.apana.org.au>
References: <20260915035448.1724327-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915035448.1724327-1-vulab@iscas.ac.cn>

On Tue, Sep 15, 2026 at 03:54:48AM +0000, Wentao Liang wrote:
> starfive_trng_read() takes a runtime PM reference with
> pm_runtime_get_sync(trng->dev), which leaves the device's usage
> count incremented even when it fails, and balances it with
> pm_runtime_put_sync_autosuspend() on the success path only.  If
> starfive_trng_wait_idle() times out or starfive_trng_cmd() fails,
> the function returns early without dropping the reference, leaking
> it on every failed read.
> 
> Convert the pm_runtime_get_sync() call to
> pm_runtime_resume_and_get(), which drops the reference again on
> failure, and release the reference with
> pm_runtime_put_sync_autosuspend() before the two early returns.
> 
> Fixes: c388f458bc34 ("hwrng: starfive - Add TRNG driver for StarFive SoC")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/char/hw_random/jh7110-trng.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)

Your patch series is incomplete and cannot be reviewed:

https://sashiko.dev/#/patchset/74190

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
