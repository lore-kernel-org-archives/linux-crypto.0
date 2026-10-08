Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B173F4DE2;
	Thu,  8 Oct 2026 08:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791447745; cv=none; b=jdC/uSQ1hzR+anr4/iOzbnC6T5QReRUO7pOB2LR3785N3e/a+nlXeHmRJus65t5aYUZithmP0Mmt4oD5nvM3/cXGyE126mrb1bELSN2l2wKDo42Wc+I6QYMTrfgKo8f4L23TIygu3hECMScAc12Dt04G9tHLhdePyEexaqWe7ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791447745; c=relaxed/simple;
	bh=4XFseh4rG49PPJ7Tkjh23HHKp84I/l9BUHVF0mpBsXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LQ9fptrnaqb0rTtL+QPflRC2q61dvNgSa4Ix6VXbV1PP24GhC1sLFXVtRZMvWPHVo8r+6XP4/9Lsj/sthTQ6GXC7j/WG24Gsg63JSKVDnvsPTY1oQmA/F/oBnqIFwRx4LfzefbD9LpSjfeGOXZ8Gx+Pj919QssaWB5Bgd4r9h6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=swhPSRh0; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="swhPSRh0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Z5htwdDNdovSl8zMRcQaZ0+OenMBudJKvhypafkwFKY=; 
	b=swhPSRh0w9EZYoBvCUPkd14LSNI+XqOt1+Ydqkle4SIwUmdFAjA+1Ni7UnTW4NsHXXKSsLIc02K
	X4HtfKN9bPKjLC9nae2A3GYaJftzNvBqAVSdgZRjjR9nBnzRO5D5vQW6hH34TeXDsazjeyn+Waud0
	DTcGM4zGOjL+71Wj3OjZ4yFjQUPOVbUjVHu9/L8B/ozHj7apvvz2Sx6r+AoQpqOZYuqBgbnJQ7vBH
	UzcI0nx4H127FEM9IeAk+EuTVKfUKhZQLY7cv+rnDKKmiaYe5heGiJBt2SUL3Ls4RRTJBoQzL+aDZ
	85jx11bGxggifSsweq94nrSBlremog4IEsQA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xEjOA-00000001nl9-3Qvs;
	Thu, 08 Oct 2026 16:22:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Oct 2026 19:22:06 +1100
Date: Thu, 8 Oct 2026 19:22:06 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Danilo Krummrich <dakr@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: atmel - use HZ_PER_MHZ in atmel_trng_init()
Message-ID: <asdSrhaiSvqtc6vv@gondor.apana.org.au>
References: <20260929213751.103658-3-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929213751.103658-3-blum@kernel.org>

On Tue, Sep 29, 2026 at 11:37:50PM +0200, Thorsten Blum wrote:
> Combine and inline the rate check to simplify the code. Drop the local
> rate variable and use HZ_PER_MHZ instead of the hard-coded frequency.
> 
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/char/hw_random/atmel-rng.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
