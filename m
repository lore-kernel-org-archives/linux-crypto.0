Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B6886331
	for <linux-crypto@vger.kernel.org>; Sat, 25 Apr 2026 13:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777124794; cv=none; b=HnDpXoBNPrCRMM822l/EcNXtxIzVjXewmB+imTDsUjiO2XsKOdFMcfuTy5+aeec+LdRj6doM3Owr4MewYYrW2guER3nnJctYpQ6so981bzpmxKKwTZRxhxZPwpmE+PbbcnKdwsWpUtsN6GRy0fRO+dGIq6qYySLV+KI5moq1xqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777124794; c=relaxed/simple;
	bh=wjmNPZrjNPjSBIohUB5+hMiZZBzteSK9XQA3ipCuFlo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BbSEyLh0kXknIAGOsnz2OgoF28qkOsoQXjGoyji16rLZhLYo5/rnrtHXvuOw3YSBDWksJ1xjd6jz7l6/qatmr5xWtGxRzrjCBlnvrMmAekVEscurAcG8TskQ8Fe1dmuAT8Ix8059A5oTS06Xq6u7wEM/6ZmcIC0dWppuAB8DCH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rFpU0CSL; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rFpU0CSL"
Date: Sat, 25 Apr 2026 15:46:24 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777124790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H0hqEuCjufidz3WpMiDJQn1B0N1f62LrlXp0GvFTQv8=;
	b=rFpU0CSL8Civ9upF9vM7HOZJ37ehLH88cCWIyTFhdB6cJXPgIGkUAGyM1/1ZydD+9MRhJG
	qTvDAo+RhgCQXLjBi3zqNDAf3NPzoNTr1NTzYLwefauyngMAJH3qIlkDCeH8db0oHNAuuu
	c07hVKzE7pLBiwnOz9k8HASdCKYPlTQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Lothar Rubusch <l.rubusch@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev, ardb@kernel.org, linusw@kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] crypto: atmel-sha204a - fix truncated 32-byte
 blocking read
Message-ID: <aezFsF8gLkABZZ1O@linux.dev>
References: <20260422210936.20095-1-l.rubusch@gmail.com>
 <20260422210936.20095-3-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422210936.20095-3-l.rubusch@gmail.com>
X-Migadu-Flow: FLOW_OUT

Hi Lothar,

On Wed, Apr 22, 2026 at 09:09:35PM +0000, Lothar Rubusch wrote:
> The ATSHA204A returns a 35-byte packet consisting of a 1-byte count,
> 32 bytes of entropy, and a 2-byte CRC. The current blocking read
> implementation was incorrectly copying data starting from the
> count byte, leading to offset data and truncated entropy.
> 
> Additionally, the chip requires significant execution time to
> generate random numbers, going by the datasheet. Reading the I2C bus
> too early results in the chip NACK-ing or returning a partial buffer
> followed by zeros.
> 
> Verification:
> Tests before showed repeadetly reading only 8 bytes of entropy:
> $ head -c 32 /dev/hwrng | hexdump -C
> 00000000  02 28 85 b3 47 40 f2 ee  00 00 00 00 00 00 00 00  |.(..G@..........|
> 00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> 00000020
> 
> After this patch applied, the result will be as follows:
> $ head -c 32 /dev/hwrng | hexdump -C
> 00000000  5a fc 3f 13 14 68 fe 06  68 0a bd 04 83 6e 09 69  |Z.?..h..h....n.i|
> 00000010  75 ff cf 87 10 84 3b c9  c1 df ae eb 45 53 4c c3  |u.....;.....ESL.|
> 00000020
> 
> Fix these issues by:
> Increase cmd.msecs to 30ms to provide sufficient execution time. Then
> set cmd.rxsize to RANDOM_RSP_SIZE (35 bytes) to capture the entire
> hardware response. Eventually, correct the memcpy() offset to index 1 of
> the data buffer to skip the count byte and retrieve exactly 32 bytes of
> entropy.
> 
> Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
> Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>

Thank you for your patches. I tested patch 2/3 on real hardware and it
fixes rngtest for me. However, I have a few comments below.

> ---
>  drivers/crypto/atmel-sha204a.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
> index 19720bdd446d..f7dc00d0f4cd 100644
> --- a/drivers/crypto/atmel-sha204a.c
> +++ b/drivers/crypto/atmel-sha204a.c
> @@ -19,6 +19,9 @@
>  #include <linux/workqueue.h>
>  #include "atmel-i2c.h"
>  
> +#define ATMEL_RNG_BLOCK_SIZE 32
> +#define ATMEL_RNG_EXEC_TIME 30
> +
>  static void atmel_sha204a_rng_done(struct atmel_i2c_work_data *work_data,
>  				   void *areq, int status)
>  {
> @@ -91,13 +94,15 @@ static int atmel_sha204a_rng_read(struct hwrng *rng, void *data, size_t max,
>  	i2c_priv = container_of(rng, struct atmel_i2c_client_priv, hwrng);
>  
>  	atmel_i2c_init_random_cmd(&cmd);
> +	cmd.msecs = ATMEL_RNG_EXEC_TIME;
> +	cmd.rxsize = RANDOM_RSP_SIZE;

atmel_i2c_init_random_cmd() already sets cmd.rxsize to RANDOM_RSP_SIZE.

Changing cmd.msecs does not appear to be strictly necessary for the fix.
The only difference I observe is that rngtest runs faster with the new
value.

Here are my test results without changing cmd.msecs:

$ sudo head -c 300000 /dev/hwrng | rngtest -c 100
[...]
rngtest: starting FIPS tests...
rngtest: bits received from input: 2000032
rngtest: FIPS 140-2 successes: 100
rngtest: FIPS 140-2 failures: 0
[...]
rngtest: input channel speed: (min=1.118; avg=3.746; max=6510416.667)Kibits/s
rngtest: FIPS tests speed: (min=26.272; avg=27.471; max=32.829)Mibits/s
rngtest: Program run time: 538942640 microseconds

and with 'cmd.msecs = ATMEL_RNG_EXEC_TIME':

$ sudo head -c 300000 /dev/hwrng | rngtest -c 100
[...]
rngtest: starting FIPS tests...
rngtest: bits received from input: 2000032
rngtest: FIPS 140-2 successes: 100
rngtest: FIPS 140-2 failures: 0
[...]
rngtest: input channel speed: (min=1.584; avg=5.295; max=6510416.667)Kibits/s
rngtest: FIPS tests speed: (min=26.602; avg=27.321; max=28.257)Mibits/s
rngtest: Program run time: 381309284 microseconds

>  	ret = atmel_i2c_send_receive(i2c_priv->client, &cmd);
>  	if (ret)
>  		return ret;
>  
> -	max = min(sizeof(cmd.data), max);
> -	memcpy(data, cmd.data, max);
> +	max = min_t(size_t, ATMEL_RNG_BLOCK_SIZE, max);
> +	memcpy(data, &cmd.data[1], max);

This works and fixes rngtest for me on real hardware.

min_t() is not strictly necessary here, since the types are compatible
and min() is sufficient.

I agree with Ard that patch 2/3 should be a separate patch for easier
stable backporting.

Thanks,
Thorsten
