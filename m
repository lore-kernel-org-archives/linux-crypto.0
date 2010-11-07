From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4/4] crypto: algif_skcipher - User-space interface for
	skcipher operations
Date: Sun, 7 Nov 2010 09:08:13 +0800
Message-ID: <20101107010813.GA20538@gondor.apana.org.au>
References: <1289046214.24626.63.camel@martin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Martin Willi <martin@strongswan.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:44428 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab0KGBIR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 6 Nov 2010 21:08:17 -0400
Content-Disposition: inline
In-Reply-To: <1289046214.24626.63.camel@martin>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Martin Willi <martin@strongswan.org> wrote:
> Hi Herbert,
> 
> I did a proof-of-concept implementation for our crypto library, the
> interface looks good so far. All our hash, hmac, xcbc and cipher test
> vectors matched.
> 
>> +                     sg_assign_page(sg + i, alloc_page(GFP_KERNEL));
> 
> Every skcipher operation leaks memory on my box (this page?). Should be
> reproducible by doing encryption with any cipher.

Hmm, can you show me your test program and how you determined
that it was leaking pages?

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
