Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E9C3B5306;
	Fri, 22 May 2026 12:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779453375; cv=none; b=S/zlPzAbdwQutvJxpf0y9D3q4pF0hzJeznzlWy8ipO4Z5xCis8UyfAR2cI7KQAEGJckFjOTCPaL0uv/0p4CX9kLxyhbsJ/bz02xYxibWFD1f0uLddTKC6UcWiUMbKphdM8P3t3u+3z4pghKh+M/D6PSorlo5JnFlUq72glMQDC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779453375; c=relaxed/simple;
	bh=DJGZejg2D4rBVBK8zu7G/OyOEDd5064SUtiScz1T9TY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TkyPnqJLXIPhrdLHq9a3azji/4rparFmXzQXv7SvHbaCVHOmGZxpwSwGH1uozZNxavv+6y2P4B5vhIMTxY7iyf+0hehK6wFyl1Iag2r/PacceYTewCm8BeFknM5jfIMx8sjck4xr2EKj0Is9/dJiEi/W/YGAUbgQqzLxGu8+HdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=sgAX1blR; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="sgAX1blR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=TNsT1TAS43uWKM1Y2XB0KoME7o52ict7JXgRPit0hts=; 
	b=sgAX1blRqiIrRAghvzrcYJejWi1O/5c63TxFH/XmkmIeNvdlyVm4I/E6ZCjkPKF6YJn7UzHGe/g
	zaS4dNxFtpS+jJllBtMS9/03vtKkDmHxzyeWGjFiEYx9EqKYgzNEGU0zHY0YUZgmyn/cXeyvZcZkx
	k2JQ4utsyUt99NKSj3PH9kiNtatStonxYTH7N+q2qdkxn5EVRXtlkQzaoe/i5SFihPae00jirkOK8
	aORCRWVQ6sHCZpnpik1+e+Hj/4VdpVDRIV0Mt4Sp2Xzt1b9Eymu94buccfru/TEV+qW+xPmNjynO1
	Tq11Q2mpHRD5ond6OeIR89jknpFLZufVgoeg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wQP6e-00GSWn-06;
	Fri, 22 May 2026 20:36:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 May 2026 20:36:00 +0800
Date: Fri, 22 May 2026 20:36:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-sha204a - remove sysfs group before hwrng
Message-ID: <ahBNsH0Z_mtR_sDZ@gondor.apana.org.au>
References: <20260517123706.1182427-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260517123706.1182427-2-thorsten.blum@linux.dev>

On Sun, May 17, 2026 at 02:37:07PM +0200, Thorsten Blum wrote:
> atmel_sha204a_probe() registers the hwrng before creating the sysfs
> group. Mirror this order in atmel_sha204a_remove() by removing the sysfs
> group before unregistering the hwrng.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/atmel-sha204a.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
