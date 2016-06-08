From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] DRBG: which shall be default?
Date: Wed, 8 Jun 2016 16:00:55 +0800
Message-ID: <20160608080055.GA13686@gondor.apana.org.au>
References: <1664837.3VbqQRUZed@positron.chronox.de>
 <1580741.tpUX5Z7OKy@tauon.atsec.com>
 <20160608024140.GA12283@gondor.apana.org.au>
 <7330387.0ZS018HYJD@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33717 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999AbcFHIA7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jun 2016 04:00:59 -0400
Content-Disposition: inline
In-Reply-To: <7330387.0ZS018HYJD@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 08, 2016 at 09:56:42AM +0200, Stephan Mueller wrote:
>
> The performance with ctr-aes-aesni on 64 bit is as follows -- I used my LRNG 
> implementation for testing for which I already have performance measurements:
> 
> - generating smaller lengths (I tested up to 128 bytes) of random numbers 
> (which is the vast majority of random numbers to be generated), the 
> performance is even worse by 10 to 15%
> 
> - generating larger lengths (tested with 4096 bytes) of random numbers, the 
> performance increases by 3%
> 
> Using ctr(aes-aesni) on 32 bit, the numbers are generally worse by 5 to 10%.

ctr(aes-aesni) is not the same thing as ctr-aes-aesni, the former
being just another way of doing what you were doing.  So did you
actually test the real optimised version which is ctr-aes-aesni?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
