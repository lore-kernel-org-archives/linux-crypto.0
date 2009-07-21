From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: authenc - convert to ahash
Date: Tue, 21 Jul 2009 21:07:25 +0800
Message-ID: <20090721130725.GA19550@gondor.apana.org.au>
References: <20090721090217.GF20288@secunet.com> <20090721122509.GG20288@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:57241 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753081AbZGUNH1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jul 2009 09:07:27 -0400
Content-Disposition: inline
In-Reply-To: <20090721122509.GG20288@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 21, 2009 at 02:25:09PM +0200, Steffen Klassert wrote:
> I just noticed that your shash version of hmac keeps the paded keys
> on the transform. I assumed the hashing to be reentrant, so I
> removed the locks arround the hash functions here.

The padded keys are in the transform because they never change
unless you call setkey.  The assumption has always been that
you should use one tfm per key.

> Is there a plan to move the paded keys to the request soon, 
> or should we keep the locks for now and remove them later?

You don't need to lock it since the same assumption applies to
AEAD.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
