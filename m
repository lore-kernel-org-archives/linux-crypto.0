From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] DRBG: which shall be default?
Date: Wed, 8 Jun 2016 17:15:00 +0800
Message-ID: <20160608091500.GA14329@gondor.apana.org.au>
References: <1664837.3VbqQRUZed@positron.chronox.de>
 <16106560.DqOinPzzUs@positron.chronox.de>
 <20160608090354.GA14241@gondor.apana.org.au>
 <2066130.uIxle5Vnoa@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43162 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbcFHJPG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jun 2016 05:15:06 -0400
Content-Disposition: inline
In-Reply-To: <2066130.uIxle5Vnoa@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 08, 2016 at 11:07:42AM +0200, Stephan Mueller wrote:
>
> No, it does not:
> 
> #ifdef CONFIG_X86_64

Well there is no fundamental reason why we can't do it on 32-bit.
Even if we just did the counter increment in C this would still
beat ctr(aes-aesni) by many orders of magnitude.

So if you really care about the performance on x86-32 then perhaps
you should send a patch to implement ctr-aes-aesni for it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
