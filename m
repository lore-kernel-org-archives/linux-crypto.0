From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Clarification of allowed context for crypto routines
Date: Sat, 24 Jan 2009 09:31:50 +1100
Message-ID: <20090123223150.GA1264@gondor.apana.org.au>
References: <200901232229.47885.arvidjaar@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrey Borzenkov <arvidjaar@mail.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:36087 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757366AbZAWWb5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 23 Jan 2009 17:31:57 -0500
Content-Disposition: inline
In-Reply-To: <200901232229.47885.arvidjaar@mail.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Andrey Borzenkov <arvidjaar@mail.ru> wrote:
>
> As I can understand, user context requirement is due to potential for 
> setkey to sleep (although it appears, that currently the only module 
> that can sleep is shash which is calling kmalloc with GFP_KERNEL). Is it 
> correct?

Yep.

> But where is the difference between hard and softirq contexts? I fail to 
> see any technical reason for this requirement.

The reasons are two-fold:

1) Crypto operations are so slow in general that if you did them
in hard IRQ context it would just be wrong;

2) The highmem primitives we use are currently softirq only.  We
could make them work for hardirq as well, but because of 1) we
didn't.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
