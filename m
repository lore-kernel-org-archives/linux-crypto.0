From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4/4] crypto: algif_skcipher - User-space interface for
	skcipher operations
Date: Mon, 15 Nov 2010 19:51:20 +0800
Message-ID: <20101115115120.GA3797@gondor.apana.org.au>
References: <20101107010813.GA20538@gondor.apana.org.au> <1289207420.2013.16.camel@martin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Martin Willi <martin@strongswan.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:60965 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242Ab0KOLvX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Nov 2010 06:51:23 -0500
Content-Disposition: inline
In-Reply-To: <1289207420.2013.16.camel@martin>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 08, 2010 at 10:10:20AM +0100, Martin Willi wrote:
> 
> The test program below runs 1000 encryptions:
> 
> # grep nr_free /proc/vmstat 
> nr_free_pages 11031
> # ./test

Thanks, Miroslav identified a bogosity where if we're not doing
a whole page then the last sgl pointer is off by one which triggers
the leak.

With his fix I cannot reproduce this problem anymore.

Other major problems identified by him include inadequage checks
with respect to ALG_MAX_PAGES, and the use of generic SG chaining
instead of crypto SG chaining.

So here is a respin of the patches which I hope will be the last :)

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
