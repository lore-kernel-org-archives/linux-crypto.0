From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] DRBG: which shall be default?
Date: Thu, 2 Jun 2016 16:40:12 +0800
Message-ID: <20160602084012.GC15226@gondor.apana.org.au>
References: <1664837.3VbqQRUZed@positron.chronox.de>
 <1972759.dI50hI8gdY@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54765 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbcFBIkR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jun 2016 04:40:17 -0400
Content-Disposition: inline
In-Reply-To: <1972759.dI50hI8gdY@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 31, 2016 at 01:23:21PM +0200, Stephan Mueller wrote:
>
> Hence my question: shall we leave the HMAC DRBG as default or shall we use the 
> CTR DRBG as default?

I don't really care one way or another.

BTW why did you use the crypto_cipher aes interface instead of
the crypto_skcipher ctr(aes) interface which would likely make
your code run many orders-of-magnitude faster, especially with
aesni-intel?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
