From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/10] crypto: x86_64 - Add SSE/AVX2 ChaCha20/Poly1305
 ciphers
Date: Mon, 13 Jul 2015 15:01:48 +0800
Message-ID: <20150713070148.GA8430@gondor.apana.org.au>
References: <1436297816-16414-1-git-send-email-martin@strongswan.org>
 <20150707221301.GB7655@gondor.apana.org.au>
 <1436387783.2879.11.camel@martin>
 <20150708204127.GA27011@gondor.apana.org.au>
 <1436602552.2882.16.camel@martin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, x86@kernel.org
To: Martin Willi <martin@strongswan.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54927 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbbGMHBy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jul 2015 03:01:54 -0400
Content-Disposition: inline
In-Reply-To: <1436602552.2882.16.camel@martin>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jul 11, 2015 at 10:15:52AM +0200, Martin Willi wrote:
> 
> > If you're going to use sec you need to use at least 10 in order
> > for it to be meaningful as shorter values often result in bogus
> > numbers.
> 
> Ok, I'll use sec=10 in v2. There is no fundamental difference compared
> to sec=1 (except for very short blocks):

Thanks.

> Yes, another extreme:
> 
> testing speed of cbc(aes) (cbc(aes-aesni)) decryption
> test 0 (128 bit key, 16 byte blocks): 1 operation in 593 cycles (16 bytes)
> test 1 (128 bit key, 64 byte blocks): 1 operation in 1589 cycles (64 bytes)
> test 2 (128 bit key, 256 byte blocks): 1 operation in 5311 cycles (256 bytes)
> test 3 (128 bit key, 1024 byte blocks): 1 operation in 20666 cycles (1024 bytes)
> test 4 (128 bit key, 8192 byte blocks): 1 operation in 161483 cycles (8192 bytes)
> test 5 (192 bit key, 16 byte blocks): 1 operation in 593 cycles (16 bytes)
> test 6 (192 bit key, 64 byte blocks): 1 operation in 1659 cycles (64 bytes)
> test 7 (192 bit key, 256 byte blocks): 1 operation in 5609 cycles (256 bytes)
> test 8 (192 bit key, 1024 byte blocks): 1 operation in 21568 cycles (1024 bytes)
> test 9 (192 bit key, 8192 byte blocks): 1 operation in 172484 cycles (8192 bytes)
> test 10 (256 bit key, 16 byte blocks): 1 operation in 612 cycles (16 bytes)
> test 11 (256 bit key, 64 byte blocks): 1 operation in 1687 cycles (64 bytes)
> test 12 (256 bit key, 256 byte blocks): 1 operation in 5836 cycles (256 bytes)
> test 13 (256 bit key, 1024 byte blocks): 1 operation in 22400 cycles (1024 bytes)
> test 14 (256 bit key, 8192 byte blocks): 1 operation in 177799 cycles (8192 bytes)
> 
> testing speed of cbc(aes) (cbc(aes-aesni)) decryption
> test 0 (128 bit key, 16 byte blocks): 1 operation in 1130 cycles (16 bytes)
> test 1 (128 bit key, 64 byte blocks): 1 operation in 3002 cycles (64 bytes)
> test 2 (128 bit key, 256 byte blocks): 1 operation in 10135 cycles (256 bytes)
> test 3 (128 bit key, 1024 byte blocks): 1 operation in 39911 cycles (1024 bytes)
> test 4 (128 bit key, 8192 byte blocks): 1 operation in 308130 cycles (8192 bytes)
> test 5 (192 bit key, 16 byte blocks): 1 operation in 1151 cycles (16 bytes)
> test 6 (192 bit key, 64 byte blocks): 1 operation in 3096 cycles (64 bytes)
> test 7 (192 bit key, 256 byte blocks): 1 operation in 11486 cycles (256 bytes)
> test 8 (192 bit key, 1024 byte blocks): 1 operation in 42155 cycles (1024 bytes)
> test 9 (192 bit key, 8192 byte blocks): 1 operation in 328148 cycles (8192 bytes)
> test 10 (256 bit key, 16 byte blocks): 1 operation in 1186 cycles (16 bytes)
> test 11 (256 bit key, 64 byte blocks): 1 operation in 3260 cycles (64 bytes)
> test 12 (256 bit key, 256 byte blocks): 1 operation in 11909 cycles (256 bytes)
> test 13 (256 bit key, 1024 byte blocks): 1 operation in 44794 cycles (1024 bytes)
> test 14 (256 bit key, 8192 byte blocks): 1 operation in 325349 cycles (8192 bytes)

Weird.  I don't see this variance with tcrypt mode=200 at all.
I do however see it with mode=500 but that's probably just telling
us that the async tcrypt code path is buggy.

It'd be good if we can figure out what's going on here.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
