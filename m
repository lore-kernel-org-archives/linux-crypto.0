Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC95355F5A;
	Sat,  7 Mar 2026 05:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772861274; cv=none; b=CZIUhA1UpVrGXGIgCU8dkNPFM+W81yAQW3/TU55OZmItvv3aHCAIitUdKf1LnAKPx4lBtD5k6RF3EAX8RFG6TDkv2T/sFio2j9vjeVLlTtJiaJK6hjPiL5WzgMuMiRpwZ0MTA94vWRPZbZrJXU6OKipbSrHPpMebnEUFYUsaY0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772861274; c=relaxed/simple;
	bh=7iZfZDarBfCMcwydrKF1yJQ0cqnOEOfNE4Lta1UB7iE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BsJch62121zY3cIkreBHt6CQ6tz3MUCqV5m78svbUR86uyXer8ndxSnRiNZDvTM3wJnNQD3mZvj1yAdTzMuWwaOueuAuK5osTKxEqYtshGu3jrYOu6JCWsx164AjRrKI7E8u8ASDXIsFKdNbGSmgTx1kkk1t8U4dQmGm/G1M+lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=puOBay21; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="puOBay21"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ncEAcVoiDcL3iA7lBgrDArbDOB8Q2IyQEoXbd7dWsmQ=; 
	b=puOBay21/q5TPhksr5OQX0h7vxxmjPUpnnXzfHf0+EvhUDaqf13zsw2/nNJcPI1R915lhqtSe7n
	dk/KgN4HIXGzQdFl7M9HIpFWZmgu8tjs+lC1WfDnsK+08nPnqyd3q9oLqW38obtDXQDnyBIKYnkxX
	eARqN402dh0YmrrDzL/TEAByhH28zeuI/hbHVWY6DZDfb/jT8I0uDFrNexlzR2I17G1LgKoZ9TG2c
	QQJWlyOxeVAiX5SYqswsL5ZgAfDV3fhnKvj7NG7Ampf4j/JhDSp+FB8XD0eCGrludO8NRPHpvy0bi
	tHlUGAqmYNlukyWP1gd3al2ORjS9DN5t61bA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vykCM-00CJSZ-1x;
	Sat, 07 Mar 2026 13:27:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 07 Mar 2026 14:27:34 +0900
Date: Sat, 7 Mar 2026 14:27:34 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Tudor Ambarus <tudor.ambarus@linaro.org>, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-ecc - Release client on allocation failure
Message-ID: <aau3RlbxzA1PHZvc@gondor.apana.org.au>
References: <20260220140313.1123405-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260220140313.1123405-2-thorsten.blum@linux.dev>

On Fri, Feb 20, 2026 at 03:03:13PM +0100, Thorsten Blum wrote:
> Call atmel_ecc_i2c_client_free() to release the I2C client reserved by
> atmel_ecc_i2c_client_alloc() when crypto_alloc_kpp() fails. Otherwise
> ->tfm_count will be out of sync.
> 
> Fixes: 11105693fa05 ("crypto: atmel-ecc - introduce Microchip / Atmel ECC driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
> Compile-tested only.
> ---
>  drivers/crypto/atmel-ecc.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
