From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [v3 RFC PATCH 1/2] crypto: ecdh: fix concurrency on ecdh_ctx
Date: Tue, 18 Jul 2017 13:50:15 +0800
Message-ID: <20170718055015.GB4764@gondor.apana.org.au>
References: <1498658916-11044-1-git-send-email-tudor.ambarus@microchip.com>
 <1498658916-11044-2-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        nicolas.ferre@microchip.com
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:50016 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751026AbdGRFun (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 01:50:43 -0400
Content-Disposition: inline
In-Reply-To: <1498658916-11044-2-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 28, 2017 at 05:08:35PM +0300, Tudor Ambarus wrote:
> ecdh_ctx contained static allocated data for the shared secret,
> for the public and private key.
> 
> When talking about shared secret and public key, they were
> doomed to concurrency issues because they could be shared by
> multiple crypto requests. The requests were generating specific
> data to the same zone of memory without any protection.
> 
> The private key was subject to concurrency problems because
> multiple setkey calls could fight to memcpy to the same zone
> of memory.
> 
> Shared secret and public key concurrency is fixed by allocating
> memory on heap for each request. In the end, the shared secret
> and public key are computed for each request, there is no reason
> to use shared memory.
> 
> Private key concurrency is fixed by allocating memory on heap
> for each setkey call, by memcopying the parsed/generated private
> key to the heap and by making the private key pointer from
> ecdh_ctx to point to the newly allocated data.
> 
> On all systems running Linux, loads from and stores to pointers
> are atomic, that is, if a store to a pointer occurs at the same
> time as a load from that same pointer, the load will return either
> the initial value or the value stored, never some bitwise mashup
> of the two.
> 
> With this, the private key will always point to a valid key,
> but to what setkey call it belongs, is the responsibility of the
> caller, as it is now in all crypto framework.

I don't get it.  You're replacing a per-tfm shared secret with
a per-tfm dynamically allocated shared secret.  As far as I can
see nothing has changed?

If the caller is making simultaneous setkey calls on the same tfm,
then it's their problem.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
