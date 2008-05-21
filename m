From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH v2] crypto: rmd128: make it work on my prefered
	architecture
Date: Wed, 21 May 2008 09:09:54 +0200
Message-ID: <20080521070954.GA5290@Chamillionaire.breakpoint.cc>
References: <20080517.020122.229980431.davem@davemloft.net> <20080517091451.GE19540@Chamillionaire.breakpoint.cc> <20080517095625.GA17878@gondor.apana.org.au> <20080520.194723.268247612.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	rueegsegger@swiss-it.ch
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:40061 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755306AbYEUHJ7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 May 2008 03:09:59 -0400
Content-Disposition: inline
In-Reply-To: <20080520.194723.268247612.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* David Miller | 2008-05-20 19:47:23 [-0700]:

>From: Herbert Xu <herbert@gondor.apana.org.au>
I though you and Herbert are two different persons.

>Performance is significantly increased on Niagara2 by using
>the little-endian loads inside of the transformation loop, as
>expected.   The numbers below are first before, then after,
>the patch at the very end of this email is applied.
That was, what I expected as well but the numbers were different. I
checked the assembly code and I had the le loads but more code. I will
check with different compiler maybe it will get better here as well.

>And this is what I suggested in the first place.  Was was not
>suggesting that the endian converting preparation loop be retained.
>Rather, I was suggesting that the in[] array be accessed with the
>special loads.
This was what I did. The only difference between now and my patch is
that I haven't put the le load into the macro.

Sebastian
