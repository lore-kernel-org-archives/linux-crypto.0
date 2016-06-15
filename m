From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/4] crypto: CTR DRBG - performance improvements
Date: Wed, 15 Jun 2016 17:27:44 +0800
Message-ID: <20160615092744.GA15841@gondor.apana.org.au>
References: <1842774.dgV8IOeQEu@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54268 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbcFOJ1t (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jun 2016 05:27:49 -0400
Content-Disposition: inline
In-Reply-To: <1842774.dgV8IOeQEu@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 14, 2016 at 07:33:48AM +0200, Stephan Mueller wrote:
> Hi,
> 
> The following patch set is aimed to increase the performance of the CTR
> DRBG, especially when assembler implementations of the CTR AES mode are
> available.
> 
> The patch set increases the performance by 10% for random numbers of 16 bytes
> and reaches 450% for random numbers reaching 4096 bytes (larger random
> numbers will even have more performance gains). The performance gains were
> measured when using ctr-aes-aesni.
> 
> Note, when using the C implementation of the CTR mode (cipher/ctr.c), the
> performance of the CTR DRBG is slightly worse than it is now, but still it
> is much faster than the Hash or HMAC DRBGs.
> 
> The patch set is CAVS tested.
> 
> Changes v2:
> * the alignment patch is updated to use the alignment of the underlying TFM
> 
> Stephan Mueller (4):
>   crypto: CTR DRBG - use CTR AES instead of ECB AES
>   crypto: DRBG - use aligned buffers
>   crypto: CTR DRBG - use full CTR AES for update
>   crypto: CTR DRBG - avoid duplicate maintenance of key

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
