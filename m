From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: PadLock XSHA
Date: Mon, 1 Sep 2008 13:44:13 +1000
Message-ID: <20080901034412.GA20270@gondor.apana.org.au>
References: <20080830084316.GA19371@gondor.apana.org.au> <48B918F4.9030604@logix.cz> <20080831020941.GA25048@gondor.apana.org.au> <48BB4640.1040407@logix.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Michal Ludvig <michal@logix.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:49599 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750983AbYIADoP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 31 Aug 2008 23:44:15 -0400
Content-Disposition: inline
In-Reply-To: <48BB4640.1040407@logix.cz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 01, 2008 at 01:32:48PM +1200, Michal Ludvig wrote:
>
> That's right, I confused SHA with AES in PadLock, sorry. With AES the 
> first versions required 16-byte alignment on input and output data as 
> well as on the control word and there's a flag in newer PadLocks that 
> allow doing AES on unaligned data.

Excellent.  We can use this to avoid copying for IPsec then.
 
> I can't find any PadLock guide newer than 2005-05-03 (probably the same 
> one that you have). I'll check with VIA what the status of this is.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
