From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Fixing gave up waiting for init of module libcrc32c.
Date: Sat, 20 Mar 2010 12:24:34 +0800
Message-ID: <20100320042434.GA32294@gondor.apana.org.au>
References: <20100319234044.GA5127@jenkins> <20100320010115.GA30561@gondor.apana.org.au> <20100320010849.GA30654@gondor.apana.org.au> <20100320042103.GB5127@jenkins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	Rusty Russell <rusty@rustcorp.com.au>
To: Brandon Philips <brandon@ifup.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39309 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751007Ab0CTEYj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 20 Mar 2010 00:24:39 -0400
Content-Disposition: inline
In-Reply-To: <20100320042103.GB5127@jenkins>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 19, 2010 at 09:21:03PM -0700, Brandon Philips wrote:
>
> Do you see how it is getting stuck though with modprobe bnx2 and
> modprobe libcrc32c going at the same time though?

Yes I agree that's a bug.  Something in those paths should simply
fail instead of waiting around.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
