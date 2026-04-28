Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEB13F54A5;
	Tue, 28 Apr 2026 11:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777375094; cv=none; b=cvfH2j137clcHIZDs7FuZXNVgeZa+HPmCWNLkriYOogJSxh9GYiapc+kFDpqENMXLo1sBsatL5sBmAv6fPpEXQvaEtmaWWyuzZ+h1oZwPAHXbi0lWpgsw2Zb0q8cuw2iU0MBYO2fkEFc/MalSp4p3ROMEJVlvc92bJ/vJ/7yDeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777375094; c=relaxed/simple;
	bh=kl1dtBcXZUypjlYinHTCFdSRIBt2o8pBWhIdwaUq4lo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N92cB2jl6m4jgExiVgnt0AD3/PSGFH/hhoapIRznw1JJMyVkqFh3A1DZuCG7R7CWlxHhVv2DVg/NFUGDa0EoJ2uj1q24RuTebuYdPiYJFREQywXkK9NdGhu4/BQatUbp32GQbCF0tHz6ydSEkA1FSNC0i+DGKw5Pz+03KU8NsIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p8mRc9En; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p8mRc9En"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102C7C2BCAF;
	Tue, 28 Apr 2026 11:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777375093;
	bh=kl1dtBcXZUypjlYinHTCFdSRIBt2o8pBWhIdwaUq4lo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p8mRc9EnIq7kjjgLQcgx4IR70p6nFpY7kbCeOvQBsT/xmYT7slx7pUK8dFz8ZE/ge
	 4ieWaGmlf9a01oHAyJiYp4U+m03iqKNyXrRURGh5y6flZvHQ9M6EROLASGkfZfwlnG
	 fpG8nNdqdDFfdoYq3VK9gSwgfqA+Vn82xL7ZaUOgQ3cy0BprDk+xcWgJo8Akem8mGC
	 7pOCvE+sau68Q01BX+i/Aw3hFoq3EOUR8MApse6xUw+QfqtACv3ATB8BH8ZCJNdu1u
	 Qx++jn+eXirfYTh7DuwWSsa4Mh4I3J+Q+uKr0UOKjwHhMIRljqNYIUo2/gxf84WLpq
	 eBGyHaxmmLkkg==
Date: Tue, 28 Apr 2026 13:18:08 +0200
From: Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
To: Bill Cox <waywardgeek@gmail.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Nicolas Ferre <nicolas.ferre@microchip.com>, Alexandre Belloni <alexandre.belloni@bootlin.com>, 
	Claudiu Beznea <claudiu.beznea@tuxon.dev>, Linus Walleij <linusw@kernel.org>, 
	Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: atmel-sha204a - drop hwrng quality reduction
 for ATSHA204A
Message-ID: <25ntssyy6t5uwxlwfpmrpzpcq6xv62l643hflf26hxi6lv5wqu@6vub6ysczjvd>
References: <20260428101430.514838-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428101430.514838-3-thorsten.blum@linux.dev>

Adding Bill Cox (waywardgeek) to the conversation.

In the meantime Nack from me on this patch.

From the original messages by Bill, it seems to me the part he was reviewing
was the ATSHA204A.

In subsequent reply [1] Bill states

  While there is some evidence, there is still no convincing proof that there
  is an entropy source in this device at all.  There is some evidence that
  Atmel has inserted a back-door.  My advice is to avoid this line of parts
  from Atmel for cryptographic use.

In another message Peter Gutmann asks about ATECC108 [2] and Bill replies [3]

  This part uses the same language to describe the random number generator.
  It is "high quality".  I think that's pretty funny.
  I would be interested in seeing if the new part can generate random numbers
  continuously, or if it fails after it's EEPROM wears out like their other
  parts.  The use of an EEPROM seed is for PWN-ing your RNG, not making it
  more secure.

IMO the comments from the actual reviewer are more relevant than those of the
engineer working for the company which was accused of creating low quality
/ backdoored TRNG, at least until the Atmel engineer provides some evaluation
code for the device (which they suggested they might do [4], but never did as
far as I can find).

Maybe we can instead change the ATECC quality to something like 32? Does that
even make sense?

Marek

[1] https://www.metzdowd.com/pipermail/cryptography/2014-December/023857.html
[2] https://www.metzdowd.com/pipermail/cryptography/2014-December/023870.html
[3] https://www.metzdowd.com/pipermail/cryptography/2014-December/023879.html
[4] https://www.metzdowd.com/pipermail/cryptography/2014-December/023886.html

On Tue, Apr 28, 2026 at 12:14:32PM +0200, Thorsten Blum wrote:
> Commit 8006aff15516 ("crypto: atmel-sha204a - Set hwrng quality to
> lowest possible") reduced the hwrng quality to 1 based on a review by
> Bill Cox [1]. However, despite its title, the review only tested the
> ATSHA204, not the ATSHA204A.
> 
> In the same thread, Atmel engineer Landon Cox wrote "this behavior has
> been eliminated entirely"[2] in the ATSHA204A and "this problem does not
> affect the ATECC108 or the ATECC108A (or the ATSHA204A)"[3].
> 
> According to the official ATSHA204A datasheet [4], the device contains a
> high-quality hardware RNG that combines its output with an internal seed
> value stored in EEPROM or SRAM to generate random numbers. The device
> also implements all security functions using SHA-256, and the driver
> uses the chip's Random command in seed-update mode.
> 
> Keep 'quality = 1' for ATSHA204, but drop the explicit hwrng quality
> reduction for ATSHA204A and fall back to the hwrng core default.
> 
> [1] https://www.metzdowd.com/pipermail/cryptography/2014-December/023858.html
> [2] https://www.metzdowd.com/pipermail/cryptography/2014-December/023852.html
> [3] https://www.metzdowd.com/pipermail/cryptography/2014-December/023886.html
> [4] https://ww1.microchip.com/downloads/en/DeviceDoc/ATSHA204A-Data-Sheet-40002025A.pdf
> 
> Fixes: 8006aff15516 ("crypto: atmel-sha204a - Set hwrng quality to lowest possible")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
> Changes in v2:
> - Drop the enum and dereference match data if needed as suggested by Ard
> - Keep the review comment
> - v1: https://lore.kernel.org/lkml/20260427124030.315590-3-thorsten.blum@linux.dev/
> ---
>  drivers/crypto/atmel-sha204a.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
> index dbb39ed0cea1..a8c1b00b12f5 100644
> --- a/drivers/crypto/atmel-sha204a.c
> +++ b/drivers/crypto/atmel-sha204a.c
> @@ -19,6 +19,12 @@
>  #include <linux/workqueue.h>
>  #include "atmel-i2c.h"
>  
> +/*
> + * According to review by Bill Cox [1], the ATSHA204 has very low entropy.
> + * [1] https://www.metzdowd.com/pipermail/cryptography/2014-December/023858.html
> + */
> +static const unsigned short atsha204_quality = 1;
> +
>  static void atmel_sha204a_rng_done(struct atmel_i2c_work_data *work_data,
>  				   void *areq, int status)
>  {
> @@ -158,6 +164,7 @@ static const struct attribute_group atmel_sha204a_groups = {
>  static int atmel_sha204a_probe(struct i2c_client *client)
>  {
>  	struct atmel_i2c_client_priv *i2c_priv;
> +	const unsigned short *quality;
>  	int ret;
>  
>  	ret = atmel_i2c_probe(client);
> @@ -171,11 +178,9 @@ static int atmel_sha204a_probe(struct i2c_client *client)
>  	i2c_priv->hwrng.name = dev_name(&client->dev);
>  	i2c_priv->hwrng.read = atmel_sha204a_rng_read;
>  
> -	/*
> -	 * According to review by Bill Cox [1], this HWRNG has very low entropy.
> -	 * [1] https://www.metzdowd.com/pipermail/cryptography/2014-December/023858.html
> -	 */
> -	i2c_priv->hwrng.quality = 1;
> +	quality = i2c_get_match_data(client);
> +	if (quality)
> +		i2c_priv->hwrng.quality = *quality;
>  
>  	ret = devm_hwrng_register(&client->dev, &i2c_priv->hwrng);
>  	if (ret)
> @@ -203,14 +208,14 @@ static void atmel_sha204a_remove(struct i2c_client *client)
>  }
>  
>  static const struct of_device_id atmel_sha204a_dt_ids[] __maybe_unused = {
> -	{ .compatible = "atmel,atsha204", },
> +	{ .compatible = "atmel,atsha204", .data = &atsha204_quality },
>  	{ .compatible = "atmel,atsha204a", },
>  	{ /* sentinel */ }
>  };
>  MODULE_DEVICE_TABLE(of, atmel_sha204a_dt_ids);
>  
>  static const struct i2c_device_id atmel_sha204a_id[] = {
> -	{ "atsha204" },
> +	{ "atsha204", (kernel_ulong_t)&atsha204_quality },
>  	{ "atsha204a" },
>  	{ /* sentinel */ }
>  };
> 
