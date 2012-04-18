From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3 v5] crypto: ux500: Add driver for HASH hardware
Date: Wed, 18 Apr 2012 22:26:20 +0800
Message-ID: <20120418142620.GA23660@gondor.apana.org.au>
References: <1334059426-6806-1-git-send-email-andreas.westin@stericsson.com>
 <1334059426-6806-3-git-send-email-andreas.westin@stericsson.com>
 <20120418074945.GA20681@gondor.apana.org.au>
 <4F8EC8A7.10300@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"kim.phillips@freescale.com" <kim.phillips@freescale.com>
To: Andreas WESTIN <andreas.westin@stericsson.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:51063 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751274Ab2DRO01 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Apr 2012 10:26:27 -0400
Content-Disposition: inline
In-Reply-To: <4F8EC8A7.10300@stericsson.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 18, 2012 at 03:59:03PM +0200, Andreas WESTIN wrote:
> 
> 
> On 2012-04-18 09:49, Herbert Xu wrote:
> >
> >Hmm, if this buffer is written to by the update function, then
> >this doesn't work because the buffer resides in the tfm which
> >can be used by multiple entities simultaneously.
> >
> >All writable data must reside in the request, not the tfm.
> 
> I'm looking into it, I assume you mean "req->base.data" ?

No, have a look at the helper ahash_request_ctx.  You need to
state how much memory you need via reqsize.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
