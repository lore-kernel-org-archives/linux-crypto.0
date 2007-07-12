From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC 0/2] AES ablkcipher driver for SPUs
Date: Thu, 12 Jul 2007 15:50:49 +0800
Message-ID: <20070712075049.GA19868@gondor.apana.org.au>
References: <20070626225952.GA4571@Chamillionaire.breakpoint.cc> <20070712043333.GB18292@gondor.apana.org.au> <20070712071833.GA23840@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1728 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755001AbXGLHuw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Jul 2007 03:50:52 -0400
Content-Disposition: inline
In-Reply-To: <20070712071833.GA23840@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jul 12, 2007 at 09:18:33AM +0200, Sebastian Siewior wrote:
>
> If there is a new IV on *every* request and I don't have to write the IV back
> than I put it in my request struct next to the source address :). This indeed
> solves my problem. What about jumbo frames in IPsec? Do I get 16 contiguous

You mean not writing back the final IV is good enough for you?
If so we can probably add a request flag for that.

> pages (16 * 4KiB for almost 64KiB which may be encrypted) or is this what you
> mean with "the IV is going to change for almost every request" ?

They won't be contiguous so yes caching would help here.  However
this case is exceedingly rare in the wild.

> Oh Oh. Where do I get random numbers from? When do you expect me to do
> this (aftee request received, request completed or in callback) and what
> is this useful for (or how random must the number really be)? I could

Well I was hoping that you had a built-in RNG or some such :)

> The only thing I'm scared is that I can't use the updated IV for
> following requests since it is not updated on enqueue time (my
> assumption was that I need this for requests like jumbo frames where the
> whole 64k frame is spitted into multiple 8k (smaller) requests and the IV from
> previous 8k is required for the following 8k).

If your hardware can't chain them up for you then yes you'd
have to wait for each chunk to finish before processing the
next one.  But as I said before this isn't that common at all.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
