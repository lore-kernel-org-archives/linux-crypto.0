Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B797C179A3;
	Sat, 14 Mar 2026 05:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773465290; cv=none; b=uOG5mbIjxJYXh5vvwMrTw5Hzrbw/omkW4V0brEnSNyDKBDAuWrUsfKWMcCuW56AuZAh+pXB/Ylcs5iRct/te3XfneEQ2hlMeXrzsNqVjCGm8uIBUsgYhxX2leHVOrnCczgDql3QHyfaTAfIT0sqUjS5duca9BPcUpgi8ETt6gjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773465290; c=relaxed/simple;
	bh=Ln9C2kBEbiddLK/RZogvdwmbNn/i54Fm898fcpP+1tQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XGa9HazP7ODiuNkz/QlJKSPKpUgiSS9rAWvufVE+mQrwKgS6tdARQzbtg2Up60mP0IVAKVFCN9yKXZLniBskEYkf2KWPDg2NjEZqrVdEorV5YqmVo+0ojqgIuGMt6r8GVYM0+HzKaEzk0jnwHfhGluASyVKew/nso2DavWfHBtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=fOHsND1C; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="fOHsND1C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Wis8Ztt02echphqiraJLVLvNhZewKrw1vXf9atZnXgs=; 
	b=fOHsND1CEQIhZXZBE7RXmXaLpWqbxgWHGC0f62NgVE8Lk1KJbmufIhlq/xEX4xFR4P2RV1PXMay
	mFjFgnpiJknmlnPd+levPMxRMdie5na8MSRka+SBG7OQscfCgHiV+yiVu5+1PMl2Sa3+/I7v/00y6
	Lt+5+XqN/gNodbxIwEeTNu1rBB690Q6ifHX3TegcAqQX0QJBAD1tIbkhEEuOa4uIEy824LbR7SfPL
	krGqxa2pjLMkGjTRrPlUcK98ncC3YljWQc1uST/55VzZe2bVTcAGcIATxINNtwFMK/jzFGpc7FXCk
	Lr/HI6CWqf2a6it8HAr6dVkvJiZ459CapcxQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w1HKc-00ELA5-0k;
	Sat, 14 Mar 2026 13:14:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 14 Mar 2026 14:14:34 +0900
Date: Sat, 14 Mar 2026 14:14:34 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-sha204a - Drop redundant I2C_FUNC_I2C check
Message-ID: <abTuusheptf3Cx_m@gondor.apana.org.au>
References: <20260304082402.89237-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304082402.89237-1-thorsten.blum@linux.dev>

On Wed, Mar 04, 2026 at 09:24:02AM +0100, Thorsten Blum wrote:
> atmel_i2c_probe() already verifies I2C_FUNC_I2C - remove the redundant
> check in atmel_sha204a_probe().
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/atmel-sha204a.c | 4 ----
>  1 file changed, 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
