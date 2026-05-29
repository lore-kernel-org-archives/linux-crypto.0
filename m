Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD5232B13A;
	Fri, 29 May 2026 06:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780034566; cv=none; b=CtYrW0CvbLyAibqOOQq+pmQpWvjhWiJhm2isX1et+zipXN4q2VZ5HE2TmA+5c9f2jEaf5nKqvTgaKPc4/EhYplzuhP4mJgfVzFnQbyl5H6tbFl6Fy2PGXCapzFvsCdswPP+LsNKY/0notxxjtrhWH0/AJUCety3KzeqshFPyR9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780034566; c=relaxed/simple;
	bh=m1HAI/OMsNf0t+IsU/E9Fhn0HzJrniPIeG0OQgQQ4Qs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oVqfaqMwWGSNgVgyF46m/Ccfzws7oOdXr1MNaRfvQC7bdEqCkWpyszN96RwHhEdz4ycjDYUWHGcfUinVXBrbmLCnxYqixvoS2dIJLz5Q31VFD98kKoKs3ogKSskO7nES0UqlVcCysTtI+YIFu+JFp0rRJx0MWwIAH21+oAEmEO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=tE1pRzbw; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="tE1pRzbw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=9aDRMTxnR6Mm1U94jCDGU0V927R383PJOnDTvtv5pw0=; 
	b=tE1pRzbwOMATB+HfPb68vg2JmBumOrfqfLZn6BSr5RDywD3Vp47l06iMVa7VFC8lnpBr1htRKv2
	QETcKYiuZv5rOU+HlOZkvWzk5IYDSRLgfyW5gBfDpUTqAr08zf7HCptjdr9R75klQ3MO2mVqxLaFx
	OeyEoimC45zsZrwkAURiTpXbL8oSPu/jGzUHoMfn0CwjHbaYpu1Fj+JXNxKYiaOXrGIqJ0g/Dwx4d
	TrhuLRKj335qb88Q69LAwZcmdVRyoyIcCTtDr13uwQzuxFMeXb9uNL2e6Nk3fhnViLZ3OCe43GqZ2
	Q8+ayRFvm+gtbs+YJaHbb9Lyl21pVqznwEIQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wSqIQ-000dAN-1r;
	Fri, 29 May 2026 14:02:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 May 2026 14:02:14 +0800
Date: Fri, 29 May 2026 14:02:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] crypto - Rework i2c_device_id initialisation
Message-ID: <ahkr5rVYm83b4bBM@gondor.apana.org.au>
References: <cover.1779260113.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1779260113.git.u.kleine-koenig@baylibre.com>

On Wed, May 20, 2026 at 09:01:27AM +0200, Uwe Kleine-König (The Capable Hub) wrote:
> Hello,
> 
> this is v2 of the patch available at
> https://lore.kernel.org/linux-crypto/20260519141033.1586036-2-u.kleine-koenig@baylibre.com.
> 
> Changes since v1 are:
> 
>  - Rebase to next-20260519 to account for changes since v7.1-rc1 (= the
>    previous base)
>  - Patch #1 is new
>  - The adaption to atmel-sha204a is a bit less trivial, so split into a
>    separate patch (#2)
> 
> Best regards
> Uwe
> 
> Uwe Kleine-König (The Capable Hub) (3):
>   crypto: atmel-sha204a - Drop of_device_id data
>   crypto: atmel-sha204a - Use named initializers for struct
>     i2c_device_id
>   crypto: atmel-ecc - Use named initializers for struct i2c_device_id
> 
>  drivers/crypto/atmel-ecc.c     | 4 ++--
>  drivers/crypto/atmel-sha204a.c | 8 ++++----
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> 
> base-commit: 6a50ba100ace43f43c87384367eb2d2605fcc16c
> -- 
> 2.47.3

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
