From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: HMAC regression
Date: Sun, 31 May 2009 23:13:04 +1000
Message-ID: <20090531131304.GA530@gondor.apana.org.au>
References: <1243523348.30487.89.camel@martin.hsr.ch> <20090529061931.GA10003@gondor.apana.org.au> <1243591472.7473.169.camel@martin.hsr.ch> <20090530011222.GA19425@gondor.apana.org.au> <1243774879.25453.25.camel@martin.hsr.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Martin Willi <martin@strongswan.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:49448 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753736AbZEaNNE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 31 May 2009 09:13:04 -0400
Content-Disposition: inline
In-Reply-To: <1243774879.25453.25.camel@martin.hsr.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, May 31, 2009 at 03:01:19PM +0200, Martin Willi wrote:
>
> Yes, it fixes HMAC calculation with enabled SLAB debugging.

Thanks for confirming.  I'll push the fix through.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
