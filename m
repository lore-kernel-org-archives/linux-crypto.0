From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCHv2 4/6] crypto: table driven multiplications in GF(2^128), needed by LRW (and in the future ABL)
Date: Wed, 29 Nov 2006 08:13:40 +1100
Message-ID: <E1GpAGq-00041C-00@gondolin.me.apana.org.au>
References: <20061128200232.GA401@cube.dyndns.org>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:29715 "EHLO
	arnor.apana.org.au") by vger.kernel.org with ESMTP id S1755714AbWK1VNn
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Nov 2006 16:13:43 -0500
To: rsnel@cube.dyndns.org
In-Reply-To: <20061128200232.GA401@cube.dyndns.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Rik:

rsnel@cube.dyndns.org wrote:
> 
> It's OK. The source will be more maintainable, but constantly converting
> between big and little-endian (on little endian machines) may have a
> significant performance impact (I will just test when your gf128 hits
> cryptodev-2.6, and complain if it is the case).

BTW, the tcrypt speed test for lrw doesn't work for me.

> Two more remarks (errors in v2 of my patch): b128ops.h and gf128mul.h
> should be in include/ (so they can be used in modules) and the inline
> functions in b128ops.h should also be static.

Yep they're in include/crypto with all the functions being static inline.
 
> This seems to be the problem, the table is constructed wrongly. 
> All the calculations take place as if we are on a big endian machine, so
> the table entries should never be swapped, so the above line should read
> 
> +#define xx(p, q)       0x##p##q

Yes you're quite right.  That was the problem.  I'll push this into mm
as soon as I get the speed tests fixed.

Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
