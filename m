From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Bogus sha1 implementation in crypto4xx
Date: Fri, 31 Jul 2009 11:27:59 +0800
Message-ID: <20090731032759.GB26814@gondor.apana.org.au>
References: <20090714130600.GA11081@gondor.apana.org.au> <DB599F406D04E34389140B7D99C71B1B0825B963@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Loc Ho <lho@amcc.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Shasi Pulijala <spulijala@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:60365 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750896AbZGaD2E (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Jul 2009 23:28:04 -0400
Content-Disposition: inline
In-Reply-To: <DB599F406D04E34389140B7D99C71B1B0825B963@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 29, 2009 at 03:58:10PM -0700, Shasi Pulijala wrote:
>
> I am assuming you are talking about the final hash result being stored in the ctx of the tfm and not the intermediate hash state. 

No I mean the intermediate hash state.

All crypto hash implementations must support

	crypto_ahash_init(req1)
	crypto_ahash_init(req2)

	crypto_ahash_update(req1)
	crypto_ahash_update(req2)

	crypto_ahash_final(req1)
	crypto_ahash_final(req2)

Of course there may be an unlimited number of requests and these
may be invoked from different CPUs.  Therefore you must store the
intermediate hash result in the request itself.

If your particular device does not support the export of the
intermediate state, then you must fall back to using a software
hash for everything up until the last finup/final request.  See
drivers/crypto/padlock-sha.c for an example.  It's shash but the
same principle applies to ahash.

Only the old hash/digest interface is limited to one request per
tfm at any time.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
