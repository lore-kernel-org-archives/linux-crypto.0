From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch 2/2] remove similar aes glue code
Date: Sat, 10 Nov 2007 19:19:55 +0800
Message-ID: <20071110111955.GB5485@gondor.apana.org.au>
References: <20071102180503.712394234@ml.breakpoint.cc> <20071102181036.701800933@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1760 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751384AbXKJLT5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 10 Nov 2007 06:19:57 -0500
Content-Disposition: inline
In-Reply-To: <20071102181036.701800933@ml.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Nov 03, 2007 at 11:05:03AM +0100, Sebastian Siewior wrote:
>
>  static struct crypto_alg aes_alg = {
> -	.cra_name		=	"aes",
> -	.cra_driver_name	=	"aes-x86_64",
> +	.cra_name			=	"aes",
> +	.cra_driver_name	=	"aes-asm",

This is bad because the algorithm name no longer matches the module
name.  I suppose we could rename the modules too, or perhaps just
add an alias?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
