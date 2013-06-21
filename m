From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: camellia-aesni-avx2 - tune assembly code for
 more performance
Date: Fri, 21 Jun 2013 15:16:49 +0800
Message-ID: <20130621071649.GB24151@gondor.apana.org.au>
References: <20130608090059.5548.67430.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:51668 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758770Ab3FUHQz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Jun 2013 03:16:55 -0400
Content-Disposition: inline
In-Reply-To: <20130608090059.5548.67430.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jun 08, 2013 at 12:00:59PM +0300, Jussi Kivilinna wrote:
> Add implementation tuned for more performance on real hardware. Changes are
> mostly around the part mixing 128-bit extract and insert instructions and
> AES-NI instructions. Also 'vpbroadcastb' instructions have been change to
> 'vpshufb with zero mask'.
> 
> Tests on Intel Core i5-4570:
> 
> tcrypt ECB results, old-AVX2 vs new-AVX2:
> 
> size    128bit key      256bit key
>         enc     dec     enc     dec
> 256     1.00x   1.00x   1.00x   1.00x
> 1k      1.08x   1.09x   1.05x   1.06x
> 8k      1.06x   1.06x   1.06x   1.06x
> 
> tcrypt ECB results, AVX vs new-AVX2:
> 
> size    128bit key      256bit key
>         enc     dec     enc     dec
> 256     1.00x   1.00x   1.00x   1.00x
> 1k      1.51x   1.50x   1.52x   1.50x
> 8k      1.47x   1.48x   1.48x   1.48x
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
