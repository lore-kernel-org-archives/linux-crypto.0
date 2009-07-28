From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Write outside array bounds
Date: Tue, 28 Jul 2009 23:29:06 +0800
Message-ID: <20090728152906.GA29970@gondor.apana.org.au>
References: <4A6F141F.5000904@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Roel Kluin <roel.kluin@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:56068 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754270AbZG1P3J (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Jul 2009 11:29:09 -0400
Content-Disposition: inline
In-Reply-To: <4A6F141F.5000904@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 28, 2009 at 05:07:11PM +0200, Roel Kluin wrote:
> In crypto_aes_expand_key() loop8(i) writes up to ctx->key_enc[8*i+15], at most
> 63. ctx->key_enc has length (15*16)/4 == 60, so the last 16 bytes of key_enc
> will overflow into ctx->key_dec.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

This is already fixed by

commit 7b4ffcf953f091a815df081911c5e75c8a38418d
Author: Phil Carmody <ext-phil.2.carmody@nokia.com>
Date:   Fri Jul 24 13:59:17 2009 +0800

    crypto: aes - Undefined behaviour in crypto_aes_expand_key

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
