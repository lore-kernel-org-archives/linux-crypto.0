From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: drbg: use memzero_explicit() for clearing
 sensitive data
Date: Wed, 26 Nov 2014 20:03:36 +0800
Message-ID: <20141126120336.GA16375@gondor.apana.org.au>
References: <20141124152116.GA31106@nick-ThinkPad-T430s>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org
To: Nickolaus Woodruff <nickolauswoodruff@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:50102 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaKZMDk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 26 Nov 2014 07:03:40 -0500
Content-Disposition: inline
In-Reply-To: <20141124152116.GA31106@nick-ThinkPad-T430s>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 24, 2014 at 10:21:16AM -0500, Nickolaus Woodruff wrote:
> diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
> index 5186f75..13471a2 100644
> --- a/include/crypto/drbg.h
> +++ b/include/crypto/drbg.h
> @@ -45,6 +45,7 @@
>  #include <crypto/hash.h>
>  #include <linux/module.h>
>  #include <linux/crypto.h>
> +#include <linux/string.h>

Why are you adding the inclusion to drbg.h? This file is for
users of drbg.  Please add it to drbg.c instead.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
