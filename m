From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH resend 4.9] hw_random: Don't use a stack buffer in add_early_randomness()
Date: Mon, 17 Oct 2016 19:17:31 +0200
Message-ID: <2711337.nAU4qxUyQs@tauon.atsec.com>
References: <4169224b6858d1cf149f1a73f8a03603fa19076d.1476638125.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jens Axboe <axboe@fb.com>, Matt Mullins <mmullins@mmlx.us>
To: Andy Lutomirski <luto@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:53580 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935881AbcJQRRi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Oct 2016 13:17:38 -0400
In-Reply-To: <4169224b6858d1cf149f1a73f8a03603fa19076d.1476638125.git.luto@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 17. Oktober 2016, 10:06:27 CEST schrieb Andy Lutomirski:

Hi Andy,

> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index 9203f2d130c0..340f96e44642 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -84,14 +84,14 @@ static size_t rng_buffer_size(void)
> 
>  static void add_early_randomness(struct hwrng *rng)
>  {
> -	unsigned char bytes[16];
>  	int bytes_read;
> +	size_t size = min_t(size_t, 16, rng_buffer_size());
> 
>  	mutex_lock(&reading_mutex);
> -	bytes_read = rng_get_data(rng, bytes, sizeof(bytes), 1);
> +	bytes_read = rng_get_data(rng, rng_buffer, size, 1);
>  	mutex_unlock(&reading_mutex);
>  	if (bytes_read > 0)
> -		add_device_randomness(bytes, bytes_read);
> +		add_device_randomness(rng_buffer, bytes_read);

Shouldn't there be a memset(0) of the rng_buffer at this point to avoid having 
such data lingering in memory?


Ciao
Stephan
