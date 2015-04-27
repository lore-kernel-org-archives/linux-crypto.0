From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: add key wrapping block chaining mode
Date: Mon, 27 Apr 2015 16:26:07 +0800
Message-ID: <20150427082607.GA21590@gondor.apana.org.au>
References: <1515730.LIeS5qas5m@myon.chronox.de>
 <3407264.GJDOVGtEDe@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44204 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbbD0I0P (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Apr 2015 04:26:15 -0400
Content-Disposition: inline
In-Reply-To: <3407264.GJDOVGtEDe@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Apr 26, 2015 at 12:08:20AM +0200, Stephan Mueller wrote:
>
> +		/*
> +		 * Point to the end of the scatterlists to walk them backwards.
> +		 */
> +		src_walk.offset += src_nbytes;
> +		dst_walk.offset += dst_nbytes;

This doesn't work.  Our primitives don't support walking backwards
over an SG list and what you have simply doesn't work except for the
trivial case of a completely linear buffer.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
