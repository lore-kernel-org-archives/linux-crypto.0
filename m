From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] linux/kernel.h, linux/mm.h, linux/slab.h are not
	needed in crypto/*.c
Date: Sat, 22 Aug 2009 13:38:18 +1000
Message-ID: <20090822033818.GA16795@gondor.apana.org.au>
References: <alpine.LRH.2.00.0908201313210.12141@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: squadette@gmail.com, linux-crypto@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:58414 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933219AbZHVDiY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Aug 2009 23:38:24 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0908201313210.12141@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> 
> Have you compile-tested this on (all?) architectures (note I didn't).
> But usually some of the includes you removed may be included indirectly on some
> platforms, but not on all of them.

Indeed, this patch looks completely broken.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
