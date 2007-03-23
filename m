From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto API to compute the hash of some small kernel-memory buffer
Date: Fri, 23 Mar 2007 17:51:03 +1100
Message-ID: <20070323065103.GA17632@gondor.apana.org.au>
References: <20070322001359.GA3126@home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Nicolas Boullis <nboullis@debian.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3528 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933793AbXCWGvH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 23 Mar 2007 02:51:07 -0400
Content-Disposition: inline
In-Reply-To: <20070322001359.GA3126@home>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Mar 22, 2007 at 01:13:59AM +0100, Nicolas Boullis wrote:
> 
> First of all, sorry to bother you. I thought I'd rather ask my question 
> to a list dedicated to the crypto API, but only found 
> linux-crypto@vger.kernel.org that appears to be dead...

Actually that list is alive and well.

> I'm working on a linux driver for some hardware MPEG decompression 
> boards (see dxr3.sourceforge.net). Those cards have an on-board i2c 
> serial EEPROM, and I'd like to compute a hash of the EEPROM's content, 
> to mach different card models.
> 
> Since it's i2c-based, it can't be memory-mapped, so I think I have to 
> first read it into a buffer in kernel memory. But the I have some 
> trouble to compute the hash.
> 
> It seemed to work correctly, while I used the crypto_digest functions + 
> a direct call to the dis_update function of the underlying algorith, 
> although it was somewhat hackish...
> 
> It still seems to work allocating a crypto_hash transform and then using 
> the underlying digest algorith functions, but looks even more hackish.
> 
> 
> SO my question is: is there a non-hackish way to compute the hash of a 
> kernel buffer? (I thought I'd use md5 but a different one would be as 
> fine.)

As long as your kernel buffer is malloced, you can turn it into an
sg list with sg_set_buf.

Once the async interface is in place, it might make sense to convert
all remaining sync users to use an address-based interface instead
of scatter lists.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
