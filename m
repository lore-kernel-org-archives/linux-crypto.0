From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4/4] crypto: algif_skcipher - User-space interface for
	skcipher operations
Date: Fri, 19 Nov 2010 17:51:36 +0800
Message-ID: <20101119095136.GA22665@gondor.apana.org.au>
References: <20101115115120.GA3797@gondor.apana.org.au> <E1PHxca-00011N-As@gondolin.me.apana.org.au> <1289832949.1979.71.camel@martin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Martin Willi <martin@strongswan.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:58076 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab0KSJvl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Nov 2010 04:51:41 -0500
Content-Disposition: inline
In-Reply-To: <1289832949.1979.71.camel@martin>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 15, 2010 at 03:55:49PM +0100, Martin Willi wrote:
> 
> > This patch adds the af_alg plugin for symmetric key ciphers,
> > corresponding to the ablkcipher kernel operation type.
> 
> I can confirm that the newest patch fixes the page leak.
> 
> Tested-by: Martin Willi <martin@strongswan.org>

Thanks Martin!

Miroslave found quite a few more problems with the patch-set
so here is another revision with those problems resolved:

* cmsg_len check fixed.
* Added missing locking to af_alg setsockopt/accept.
* Error path memory leak in alg_setkey.
* Bogus module aliases deleted.
* Bogus semilcon after if in skcipher_data_wakeup.
* Fixed broken wait logic in algif_skcipher.
* Fixed a couple of bugs with the SG merging in algif_skcipher.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
