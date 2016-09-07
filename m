From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hwrng: core - Allocate memory during module init
Date: Wed, 7 Sep 2016 20:53:50 +0800
Message-ID: <20160907125350.GB17176@gondor.apana.org.au>
References: <1472977778-23996-1-git-send-email-prasannatsmkumar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mpm@selenic.com, jslaby@suse.cz, peter@korsgaard.com,
        lee.jones@linaro.org, linux-crypto@vger.kernel.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46451 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932898AbcIGMyM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2016 08:54:12 -0400
Content-Disposition: inline
In-Reply-To: <1472977778-23996-1-git-send-email-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Sep 04, 2016 at 01:59:38PM +0530, PrasannaKumar Muralidharan wrote:
>
> @@ -573,6 +557,17 @@ EXPORT_SYMBOL_GPL(devm_hwrng_unregister);
>  
>  static int __init hwrng_modinit(void)
>  {
> +	/* kmalloc makes this safe for virt_to_page() in virtio_rng.c */
> +	rng_buffer = kmalloc(rng_buffer_size(), GFP_KERNEL);
> +	if (!rng_buffer)
> +		return -ENOMEM;
> +
> +	rng_fillbuf = kmalloc(rng_buffer_size(), GFP_KERNEL);
> +	if (!rng_fillbuf) {
> +		kfree(rng_buffer);
> +		return -ENOMEM;
> +	}
> +
>  	return register_miscdev();

You're leaking memory if register_miscdev fails.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
