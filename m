From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [v3 RFC PATCH 1/2] crypto: ecdh: fix concurrency on ecdh_ctx
Date: Wed, 19 Jul 2017 15:04:21 +0800
Message-ID: <20170719070421.GA9426@gondor.apana.org.au>
References: <1498658916-11044-1-git-send-email-tudor.ambarus@microchip.com>
 <1498658916-11044-2-git-send-email-tudor.ambarus@microchip.com>
 <20170718055015.GB4764@gondor.apana.org.au>
 <60b15bac-d295-36f4-c55f-a3ff3f8267fd@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        nicolas.ferre@microchip.com
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:48498 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751754AbdGSHEt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jul 2017 03:04:49 -0400
Content-Disposition: inline
In-Reply-To: <60b15bac-d295-36f4-c55f-a3ff3f8267fd@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 18, 2017 at 03:52:19PM +0300, Tudor Ambarus wrote:
>
> I'm replacing a per-tfm shared secret with a per-request dynamically
> allocated shared secret. The same for the public key, I'm replacing
> a per-tfm public key with a per-request dynamically allocated public
> key. No shared memory, no concurrency.

For the pre-request bits that's fine.  But in setkey you're still
allocating a per-tfm data structure instead of just putting things
into the tfm context.  This is totally pointless.

> For the private key I wanted to be sure that we don't interleave data
> from multiple setkey calls. As of now, the setkey calls can fight to
> memcopy to the same zone of memory. I'm making sure that the private key
> is valid and not a mash of multiple private keys.

As I said, if the caller is making simultaneous setkey calls then
it's broken.  You can never fix that in your driver, so don't even
try.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
