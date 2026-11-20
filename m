Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795168262;
	b=RnfLNhaPBM7AkTJGyOMfxiFPdLYv5JeggZOxO+SaQbbBG8OQ8YF6PoRYBM7I3jiScPpA
	 v62MSdEJSemPcXBWB7b8FaCXdFFNZVWm3FRbz2kcozHPTRrRp5X0eYEcVpc/ZlZ5gMBmB
	 z+wp9pUavx5lMmVXEKdEpKYhHaF7A/9oSjI9RNMgASsyhjgH18NG8Jvm8OPK2FW8O6Ssa
	 ULhKdLE6kKmR+a/RevEhnNXbU93jzBI9bRwqvK0D0LZAotA1f00u3u1KG9ruo3hMCioHV
	 Tfk5To/kbVLYHIUzXPfoG19Q2wzw2G114eOiDfGB1fUJsOwUukCucVTXjjnbUEQ2UrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795168262;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=kw4MOGGN2fTnqLv0+xMKyAPUpCIl+a10zWs3ZqFeU9w=;
	b=iuzUlMC+nb1V8SGDTOg4k3Z1BwAlLOFr1LMhUy7F6acpTGk64+FJTuhJDf4gaJ33eaq/
	 5/bn5qYXUXXbA0EVFjBFnz4sGg6RYHuxtcbnsiRx0bMrKpSI3qEKp96nCjX2R4iHOUGRt
	 iDsexrEEXlobBaI05RxZalqGZvn4+Hy9Uto8uXETXgDiqhtjOI+6kHqIJmhSwrdRQhCio
	 aqgcF+N8/D/nXXJx2oMFveveWIG67zxE5/JGwiBfz7vQKu7ciEZ/+jGibkreAHAvDviJl
	 4YVvh5IbP7AIaCJxFQPvS0x6Y4iDpQiDxoUXsXwaumVYZOFQv5K7qYWaDZ9neqoLb1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=FfA1GaUs;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18BB606A320;
	Fri, 20 Nov 2026 09:51:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D18BB606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=FfA1GaUs
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=kw4MOGGN2fTnqLv0+xMKyAPUpCIl+a10zWs3ZqFeU9w=; 
	b=FfA1GaUsfGWKYGO3uW7mRiS9xgjl1K3n5FPRfkyLRG5O/JEsUopAEyMK9dMfC4wP9ldXOs3wpId
	d3b0Pi7ozbsiftZK08R2AEpLBcAI4ntDGTLkmSfM9EIZxalLGh7wJ7u15HeH861qmOVBtbaXR/23V
	++2r0ULUMlg8s2EE11BfIPu4utI89cKa5IfINYeHKP1GPbCw3y1dhVyTwj4QYlyMaToF96S4+kPdT
	gdwQYCbrjK2b4ZLa5Qu9IbJbnn0XWdZy7xjLsV4Ld4V7f6s/Oj5Do8e7q4EaVJ3miNOr5C7lglXAF
	3HkXQLkljdcMtQjKhgfdtJSxzxe91VerhnPA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xULGj-0000000HYZu-3UHb;
	Fri, 20 Nov 2026 17:50:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Nov 2026 17:50:57 +0800
Date: Fri, 20 Nov 2026 17:50:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Gu Bin <gubin@cmss.chinamobile.com>
Cc: andrew@codeconstruct.com.au, avifishman70@gmail.com,
	tmaimon77@gmail.com, tali.perry1@gmail.com, venture@google.com,
	yuenn@google.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: npcm - use pm_runtime_resume_and_get() in
 npcm_rng_read()
Message-ID: <awAYAa1OY4_kk_Bg@gondor.apana.org.au>
References: <20261111073309.1659-1-gubin@cmss.chinamobile.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111073309.1659-1-gubin@cmss.chinamobile.com>

On Wed, Nov 11, 2026 at 03:33:08PM +0800, Gu Bin wrote:
> npcm_rng_read() calls pm_runtime_get_sync() without checking the return
> value and then polls and reads the RNG registers: when resuming the
> device fails (negative return), the loop reads a device that never
> resumed and the failure is lost - the function returns the (zero) byte
> count instead of an error.
> 
> Use pm_runtime_resume_and_get() instead and bail out on the error: the
> helper reports the resume failure and drops the usage counter reference
> it took, which a failed pm_runtime_get_sync() leaves behind (the usage
> counter is incremented before the resume attempt, so returning
> directly after a failed get_sync() would leak the reference and the
> device could never autosuspend again). The tail
> pm_runtime_put_sync_autosuspend() must not be used for this bailout:
> the device never resumed, so balancing the counter is all that is
> needed. On success the helper returns 0, which is exactly what the
> read counter expects at that point.
> 
> Fixes: c98429297d8b ("hwrng: npcm - add NPCM RNG driver")
> Signed-off-by: Gu Bin <gubin@cmss.chinamobile.com>
> ---
>  drivers/char/hw_random/npcm-rng.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
