From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/1 take 2] HIFN 795x driver.
Date: Wed, 3 Oct 2007 12:41:19 +0400
Message-ID: <20071003084118.GA19117@2ka.mipt.ru>
References: <20071002150013.GA6023@2ka.mipt.ru> <20071002190512.GA8761@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:33288 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920AbXJCImd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Oct 2007 04:42:33 -0400
Content-Disposition: inline
In-Reply-To: <20071002190512.GA8761@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Oct 02, 2007 at 09:05:12PM +0200, Sebastian Siewior (linux-crypto@ml.breakpoint.cc) wrote:
> >DES currently does not pass tcrypt's multipage test, since HIFN adapter 
> >can not work with non-blocksize aligned chunks, although crypto alignmask 
> >is set to 3, tcrypt provides a block of size 2 in its multipage test, 
> >which fails.
> I recalled now that I forgot to point this out. You set the align mask to
> the block size of the algorithm but it is almost unused / useless.
> Let me explain:
> - it is ensured that the key you get (in the setkey function) is
>   properly aligned. This doesn't matter in your case because you
>   memcpy() the key away to your private struct.
> - your private struct is pointer aligned (if I remember correctly). You
>   memcpy() your key away so it looks like you don't need the ctx
>   aligned according to your mask (but it would be possible :))
> - the proper alignment of src, dst and the IV that you get is _not_
>   ensured. This would be the case if you would develop a blkcipher and
>   use blkcipher_walk_init(), blkcipher_walk_virt(), .... 
> 
> Now. If you pass your AES-tcrypt-test (where you need 16 bytes alignment)
> than this is pure luck. If you really need aligned src,dst or the IV
> than you have to do it by yourself :(

It has to be multiple of blocksize. I.e. it is impossible to 
crypt one byte - hardware will stall, DES test provides two bytes as
input - this will not work. If that is going to be handled in driver,
then it will relocate. I'm not sure it is the right decision.

-- 
	Evgeniy Polyakov
