From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] DRBG: which shall be default?
Date: Wed, 8 Jun 2016 17:03:54 +0800
Message-ID: <20160608090354.GA14241@gondor.apana.org.au>
References: <1664837.3VbqQRUZed@positron.chronox.de>
 <7330387.0ZS018HYJD@positron.chronox.de>
 <20160608080055.GA13686@gondor.apana.org.au>
 <16106560.DqOinPzzUs@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51230 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbcFHJEA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jun 2016 05:04:00 -0400
Content-Disposition: inline
In-Reply-To: <16106560.DqOinPzzUs@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 08, 2016 at 10:58:37AM +0200, Stephan Mueller wrote:
>
> Indeed, I used ctr(aes-aesni) instead of ctr-aes-aesni according to the refcnt 
> in /proc/crypto. The reason was that I used the sync skcipher API which 
> naturally excludes the ctr-aes-aesni.
> 
> When changing it to really use ctr-aes-aesni, I get: between 450% performance 
> gains (for 4096 bytes -- 780 MB/s(!)) and 4% gain (for 16 bytes).
> 
> Though, on 32 bit with ctr(aes-aesni) -- which is a blkcipher -- I get a 
> performance degradation of 10% (4096 bytes) and 20% (16 bytes).
> 
> Any ideas on how to handle the blkcipher in a better way?

You should always use ctr-aes-aesni, ctr(aes-aesni) makes no sense.

So I don't quite understand why you need to handle blkcipher, does
ctr-aes-aesni not work on 32-bit?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
