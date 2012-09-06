From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/3] [v2] crypto: twofish-avx - tune assembler code for
 more performance
Date: Thu, 6 Sep 2012 13:21:54 -0700
Message-ID: <20120906202154.GG24269@gondor.apana.org.au>
References: <20120828112443.22504.68633.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Johannes Goetzfried
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
	Borislav Petkov <bp@alien8.de>,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:50316 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759760Ab2IFUV7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Sep 2012 16:21:59 -0400
Content-Disposition: inline
In-Reply-To: <20120828112443.22504.68633.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 28, 2012 at 02:24:43PM +0300, Jussi Kivilinna wrote:
> Patch replaces 'movb' instructions with 'movzbl' to break false register
> dependencies and interleaves instructions better for out-of-order scheduling.
> 
> Tested on Intel Core i5-2450M and AMD FX-8100.
> 
> tcrypt ECB results:
> 
> Intel Core i5-2450M:
> 
> size    old-vs-new      new-vs-3way     old-vs-3way
>         enc     dec     enc     dec     enc     dec
> 256     1.12x   1.13x   1.36x   1.37x   1.21x   1.22x
> 1k      1.14x   1.14x   1.48x   1.49x   1.29x   1.31x
> 8k      1.14x   1.14x   1.50x   1.52x   1.32x   1.33x
> 
> AMD FX-8100:
> 
> size    old-vs-new      new-vs-3way     old-vs-3way
>         enc     dec     enc     dec     enc     dec
> 256     1.10x   1.11x   1.01x   1.01x   0.92x   0.91x
> 1k      1.11x   1.12x   1.08x   1.07x   0.97x   0.96x
> 8k      1.11x   1.13x   1.10x   1.08x   0.99x   0.97x
> 
> [v2]
>  - Do instruction interleaving another way to avoid adding new FPU<=>CPU
>    register moves as these cause performance drop on Bulldozer.
>  - Further interleaving improvements for better out-of-order scheduling.

All three patches applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
