Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB59274B5F
	for <linux-crypto@vger.kernel.org>; Sun, 26 Apr 2026 16:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777221801; cv=none; b=CnJEXPsBTllaYEcNDbY0bDvZS72hRkXaRHZvXA13gdTI/+wr4I2bTfZavAXdhiKyoxPlGZM+EqWSaS+bOrbRgV7N12I85kNtyapZJ3HkOvAHeTRw40JDrjByUxS38ZUdhpo0fXXLXy+OB0pC0uKqTebOwhdElW5kUWzp8IS1C3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777221801; c=relaxed/simple;
	bh=38ObDU904X/EUjxm5edCJZIVYhBc+QFo9KE+isTwwVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RT9QXwuX3Bqhf/deqgyPjNUFQ79+kcUkyClkC8e1JOv0FoNnmoW3ui08I/uQGOajJL1crzGBKxSXA6pbhnZgstTl9d36J2IkWDcIoi5NHVf6FcXKqbyUoCgfqqtp1lpwXLTspmOv6zDlVZ+52O7HFEKAJTV+phMld17AVhsf/zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=L8h3twjJ; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="L8h3twjJ"
Date: Sun, 26 Apr 2026 18:43:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777221787;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ObaiCAI4T+PEU1s+O8KM5vkukZXBFwC8gCTPrznuofU=;
	b=L8h3twjJ6tUkR6vF4n5uyVtZhtRZ+BxXpb/mpeLTCB5U+seZQCWKxwHONIPj+04lAxsG8B
	d1/iN1GL1jZcZ+iGy3L6W1ZJMk/VsMkbnsIlXyp+LgWolm5t948KS5OmAUzIcPfWW/A+DK
	ojusRegmltAmkc8xDc9FmwBeNtNywWs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Lothar Rubusch <l.rubusch@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev, ardb@kernel.org, linusw@kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/1] crypto: atmel-sha204a - fix non-blocking read
 logic
Message-ID: <ae5AlBP3EvS-Fe6w@linux.dev>
References: <20260426154940.24375-1-l.rubusch@gmail.com>
 <20260426154940.24375-2-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260426154940.24375-2-l.rubusch@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Apr 26, 2026 at 03:49:40PM +0000, Lothar Rubusch wrote:
> The blocking and non-blocking paths were failing to provide valid entropy
> due to improper buffer management. Read the buffer starting from bit 1,
> only fetch the 32 bytes of random data of the return message.
> 
> Tested on a Atmel SHA204a device.
> 
> Before (here for blocking) tests showed repeadetly reading reduced bytes of

s/repeadetly/repeatedly/

> entropy:
> $ head -c 32 /dev/hwrng | hexdump -C
> 00000000  02 28 85 b3 47 40 f2 ee  00 00 00 00 00 00 00 00  |.(..G@..........|
> 00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> 00000020
> 
> After, the result will be similar to the following:
> $ head -c 32 /dev/hwrng | hexdump -C
> 00000000  5a fc 3f 13 14 68 fe 06  68 0a bd 04 83 6e 09 69  |Z.?..h..h....n.i|
> 00000010  75 ff cf 87 10 84 3b c9  c1 df ae eb 45 53 4c c3  |u.....;.....ESL.|
> 00000020
> 
> Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
> Suggested-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
> ---
>  drivers/crypto/atmel-sha204a.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
> index dbb39ed0cea1..39a229086a84 100644
> --- a/drivers/crypto/atmel-sha204a.c
> +++ b/drivers/crypto/atmel-sha204a.c
> @@ -48,8 +48,8 @@ static int atmel_sha204a_rng_read_nonblocking(struct hwrng *rng, void *data,
>  
>  	if (rng->priv) {
>  		work_data = (struct atmel_i2c_work_data *)rng->priv;
> -		max = min(sizeof(work_data->cmd.data), max);
> -		memcpy(data, &work_data->cmd.data, max);
> +		max = min(RANDOM_RSP_SIZE - CMD_OVERHEAD_SIZE, max);
> +		memcpy(data, &work_data->cmd.data[1], max);

Please use RSP_DATA_IDX instead of 1 as the index.

>  		rng->priv = 0;
>  	} else {
>  		work_data = kmalloc_obj(*work_data, GFP_ATOMIC);
> @@ -87,8 +87,8 @@ static int atmel_sha204a_rng_read(struct hwrng *rng, void *data, size_t max,
>  	if (ret)
>  		return ret;
>  
> -	max = min(sizeof(cmd.data), max);
> -	memcpy(data, cmd.data, max);
> +	max = min(RANDOM_RSP_SIZE - CMD_OVERHEAD_SIZE, max);
> +	memcpy(data, &cmd.data[1], max);

Same here.

Thanks,
Thorsten
