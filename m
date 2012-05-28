From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH] crypto: serpent - add x86_64/avx assembler
 implementation
Date: Mon, 28 May 2012 09:37:09 +0300
Message-ID: <20120528093709.20517gw0jqzuyvbs@naisho.dyndns.info>
References: <20120527145112.GF17705@kronos.redsun>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Tilo =?iso-8859-1?b?TfxsbGVy?=
	<tilo.mueller@informatik.uni-erlangen.de>
To: Johannes Goetzfried
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:49911 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab2E1GhM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 May 2012 02:37:12 -0400
In-Reply-To: <20120527145112.GF17705@kronos.redsun>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Quoting Johannes Goetzfried  
<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>:

> This patch adds a x86_64/avx assembler implementation of the Serpent block
> cipher. The implementation is very similar to the sse2 implementation and
> processes eight blocks in parallel. Because of the new non-destructive three
> operand syntax all move-instructions can be removed and therefore a little
> performance increase is provided.

/* /me adds CPU with AVX to wishlist. */

<snip>

> diff --git a/arch/x86/crypto/serpent_avx_glue.c  
> b/arch/x86/crypto/serpent_avx_glue.c
> new file mode 100644
> index 0000000..85ef6e7
> --- /dev/null
> +++ b/arch/x86/crypto/serpent_avx_glue.c
> @@ -0,0 +1,949 @@
> +/*
> + * Glue Code for AVX assembler versions of Serpent Cipher
> + *
> + * Copyright (C) 2012 Johannes Goetzfried
> + *     <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
> + *
> + * Glue code based on twofish_avx_glue.c by:

Should be serpent_sse2_glue.c?

> + *  Copyright (C) 2011 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> + *

<snip>

> +}, {
> +	.cra_name		= "ecb(serpent)",
> +	.cra_driver_name	= "ecb-serpent-avx",
> +	.cra_priority		= 400,

serpent_sse2_glue.c has priority 400 too, so you should increase  
priority here to 500.

...

Actually about duplicating glue code.. is it really needed? On x86_64,  
both avx and sse2 versions process 8-blocks parallel and therefore  
glue code could be easily shared (as is done in SHA1 SSSE3/AVX).

-Jussi
