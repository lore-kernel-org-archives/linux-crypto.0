From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: IV copy strategy
Date: Fri, 16 Nov 2007 10:08:51 +0800
Message-ID: <20071116020851.GC32509@gondor.apana.org.au>
References: <20071113231132.GA10680@Chamillionaire.breakpoint.cc> <20071114142253.GA15201@gondor.apana.org.au> <20071115211005.GA21159@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1784 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756951AbXKPCI4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Nov 2007 21:08:56 -0500
Content-Disposition: inline
In-Reply-To: <20071115211005.GA21159@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 15, 2007 at 10:10:05PM +0100, Sebastian Siewior wrote:
>
> In this case, the s390 has the same bug (they copy the IV back after
> blkcipher_walk_done()). Howevere it will probably never get triggered
> because they have an aligment of 0 (what gets pushed to 3 by the crypto
> API if I remenber correcrtly). 

It only gets pushed to 3 if you use the generic CBC template, they
don't so they will stay at 0.  In their case I also see why they
can't just use walk->iv directly.

> So a general question: Is it a must (requirement by the crypto API) to
> copy the IV back or not? I guess not if we move completely to async (one
> day) :)

You must copy it back to allow chaining.  Even when we go async
someone may wish to chain.  So in that sense you've just found a
bug in the hifn driver :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
