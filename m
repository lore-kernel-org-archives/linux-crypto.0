From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: linux-4.6/drivers/crypto/ux500/hash/hash_core.c: 2 * possible
 bad size ?
Date: Wed, 18 May 2016 15:46:50 +0800
Message-ID: <20160518074650.GA6097@gondor.apana.org.au>
References: <CAMzoamabHQ0SaMmkTfwDGGZBpOxSE6Qci4TwEUAEMbtWO3X-Ew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, dcb314@hotmail.com,
	Andreas Westin <andreas.westin@stericsson.com>,
	Linus Walleij <linus.walleij@linaro.org>
To: David Binderman <linuxdev.baldrick@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38075 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbcERHrT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 May 2016 03:47:19 -0400
Content-Disposition: inline
In-Reply-To: <CAMzoamabHQ0SaMmkTfwDGGZBpOxSE6Qci4TwEUAEMbtWO3X-Ew@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 16, 2016 at 07:13:12PM +0100, David Binderman wrote:
> Hello there,
> 
> 1.
> 
> linux-4.6/drivers/crypto/ux500/hash/hash_core.c:784]: (warning) Division by
> result of sizeof(). memmove() expects a size in bytes, did you intend to
> multiply instead?
> 
> Source code is
> 
>                 memmove(req_ctx->state.buffer,
>                     device_data->state.buffer,
>                     HASH_BLOCK_SIZE / sizeof(u32));
> 
> Maybe better code
> 
>                 memmove(req_ctx->state.buffer,
>                     device_data->state.buffer,
>                     HASH_BLOCK_SIZE);
> 
> 2.
> 
> linux-4.6/drivers/crypto/ux500/hash/hash_core.c:835]: (warning) Division by
> result of sizeof(). memmove() expects a size in bytes, did you intend to
> multiply instead?
> 
> Duplicate.

Thanks for noticing these bugs.  This driver hasn't been maintained
since 2012, so unless someone steps up I'm going to just delete it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
