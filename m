From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/5] crypto: x86 - add more optimized XTS-mode for
 serpent-avx
Date: Wed, 10 Apr 2013 11:32:42 +0800
Message-ID: <20130410033242.GD32360@gondor.apana.org.au>
References: <20130408185055.4107.70454.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:55724 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756379Ab3DJDco (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Apr 2013 23:32:44 -0400
Content-Disposition: inline
In-Reply-To: <20130408185055.4107.70454.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 08, 2013 at 09:50:55PM +0300, Jussi Kivilinna wrote:
> This patch adds AVX optimized XTS-mode helper functions/macros and converts
> serpent-avx to use the new facilities. Benefits are slightly improved speed
> and reduced stack usage as use of temporary IV-array is avoided.
> 
> tcrypt results, with Intel i5-2450M:
>         enc     dec
> 16B     1.00x   1.00x
> 64B     1.00x   1.00x
> 256B    1.04x   1.06x
> 1024B   1.09x   1.09x
> 8192B   1.10x   1.09x
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
