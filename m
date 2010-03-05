From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Question about async operations
Date: Fri, 5 Mar 2010 15:33:05 +0800
Message-ID: <20100305073305.GA3794@gondor.apana.org.au>
References: <4B8FF02B.5090600@siganos.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Dimitrios Siganos <dimitris@siganos.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:52212 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751146Ab0CEHdH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Mar 2010 02:33:07 -0500
Content-Disposition: inline
In-Reply-To: <4B8FF02B.5090600@siganos.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dimitrios Siganos <dimitris@siganos.org> wrote:
> Hi,
> 
> I have a question about the asynchronous characteristics of the crypto api.
> 
> 1) crypto_alloc_hash("sha1", 0, CRYPTO_ALG_ASYNC), does this code create 
> an asynchronous sha1 transform?

crypto_alloc_hash is obsolete.  New code should either use shash
or ahash.  Only the latter supports async operations.

You can look at crypto/authenc.c for an example of how it's used.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
