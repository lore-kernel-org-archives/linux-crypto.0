Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FD24028DF;
	Fri, 22 May 2026 12:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779453380; cv=none; b=HEfxGGDKlOqIPj+K05LTxQhYmo7YqZKa+iTN/JZEwDiyOuBZjYU7KFdyzcXeU3BFwLYTdDjR+4brjeDOhLtRvMCyWIq2Y3ePz7NbmDpUyZL+BVWbJdOARq+Cbg7ADHA9/wlDktPO3O/mwJ/YyNppkVvB4mEeIFJOPq+PZYyUAvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779453380; c=relaxed/simple;
	bh=wa62xhsoOcqBSktmPakIAKGxAgNV08sjgIAWpgHc6+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rkdrsO/hapKNd1ixBNdpYEjJ9A9kHGuAO6Zd3NffzC7YjBA8jra0FpkPDt817UbZagl5XAuitBFXyYU6UZdEhsP73pIYoFP2R/0A68gX71f4fCf6UGByJFw+/Hzm5GwM5sQaVY9Z0jEFdvEKShGNr0XeGF6++TGT1qR7LLAmUwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=TM5rct7q; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="TM5rct7q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=pUl6Di85zdywTCtLZDpUxTZGF7q2HknhseYIwing12s=; 
	b=TM5rct7q+wnyPz8c5pmc5+lfFejfF/vDcb2eDm+l83qnc5HpuwUOHbJueYj4/wIwgGolEyCXKbI
	+aSbZ3rakFzZzSeM3LIS5Bo0hHaCvM5GlUo3d6I7QaECes7eGYbqB9gy5a6jlDeWHskxe8dQtp7bg
	mpNbRMsVu/XPsWqXg4QUnsODKsMsNd+mo038qOrgeB3LW5ELUWRbMju82RK8w0Jgy/E04QAktk9Mr
	Qd0sfGxNcKSX9lHs+uHbqLznmOHgvPjrjKtlf9CeUkw4vc9H09OKVAO66K/9LJzrEyTdTW4L+RQGD
	y9OXTQUgFXjHei+shivkt5+0uM3XcxfJnVFQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wQP6k-00GSXH-2I;
	Fri, 22 May 2026 20:36:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 May 2026 20:36:06 +0800
Date: Fri, 22 May 2026 20:36:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Lothar Rubusch <l.rubusch@gmail.com>, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-sha204a - fail on hwrng registration error
 in probe path
Message-ID: <ahBNtvwCCWlqRLSR@gondor.apana.org.au>
References: <20260517162740.1250-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260517162740.1250-2-thorsten.blum@linux.dev>

On Sun, May 17, 2026 at 06:27:40PM +0200, Thorsten Blum wrote:
> Commit 13909a0c8897 ("crypto: atmel-sha204a - provide the otp content")
> overwrote the hwrng registration return value when creating the sysfs
> group, which allowed atmel_sha204a_probe() to succeed even if
> devm_hwrng_register() failed.
> 
> Return immediately when devm_hwrng_register() fails, and report both
> hwrng and sysfs registration errors with dev_err(). Adjust the sysfs
> error log message for consistency.
> 
> Fixes: 13909a0c8897 ("crypto: atmel-sha204a - provide the otp content")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/atmel-sha204a.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
