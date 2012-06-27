From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/11] crypto: x86 - split common glue code into helper
 modules
Date: Wed, 27 Jun 2012 14:49:32 +0800
Message-ID: <20120627064932.GC22920@gondor.apana.org.au>
References: <20120618110652.28985.70075.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:44924 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754030Ab2F0Gtf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jun 2012 02:49:35 -0400
Content-Disposition: inline
In-Reply-To: <20120618110652.28985.70075.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 18, 2012 at 02:06:53PM +0300, Jussi Kivilinna wrote:
> Currently several block-ciphers in arch/x86/crypto duplicate glue code for using
> assembler implementations that process multiple blocks parallel. This patchset
> adds shared glue_helper module for these 128bit cipher modules to use.
> 
> Downside of generalisation of glue code is slightly increased overhead. Tcrypt
> test results of camellia-x86_64, twofish-x86_64-3way and serpent-sse2 (new/old
> ratio, average of ecb, cbc, ctr):
> 
>             camellia  twofish   serpent
>   16 bytes: 0.926x    0.945x    0.980x
>   64 bytes: 0.977x    0.968x    0.982x
>  256 bytes: 0.980x    0.984x    0.982x
> 1024 bytes: 0.987x    0.992x    0.985x
> 4096 bytes: 0.988x    0.993x    0.985x
> 
> For ciphers utilising SSE/AVX instructions, shared ablk_helper module is added
> for registering async-ciphers.

OK, I think the consolidation is worth it.

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
