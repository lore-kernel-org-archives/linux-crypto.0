Return-Path: <SRS0=1iZj=N3=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37548 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727353AbeKPQNj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Nov 2018 11:13:39 -0500
Date: Fri, 16 Nov 2018 14:02:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Crowley <paulcrowley@google.com>,
        Greg Kaiser <gkaiser@google.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <samuel.c.p.neves@gmail.com>,
        Tomer Ashur <tomer.ashur@esat.kuleuven.be>
Subject: Re: [RFC PATCH v3 10/15] crypto: poly1305 - use structures for key
 and accumulator
Message-ID: <20181116060227.hwu4igi6bp26ddpi@gondor.apana.org.au>
References: <20181105232526.173947-1-ebiggers@kernel.org>
 <20181105232526.173947-11-ebiggers@kernel.org>
 <CAKv+Gu-o0khD5=0EOkv2PiczMs5uZ=XP9V=G2ogBNMK8Kb93sw@mail.gmail.com>
 <20181112185816.GA8663@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181112185816.GA8663@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Eric:

On Mon, Nov 12, 2018 at 10:58:17AM -0800, Eric Biggers wrote:
>
> I prefer separate types so that the type system enforces that a key is never
> accidentally used as an accumulator, and vice versa.  Then the poly1305_core_*
> functions will be harder to misuse, and the Poly1305 MAC implementations harder
> to get wrong.
> 
> The key also has certain bits clear whereas the accumulator does not.  In the
> future, the Poly1305 C implementation might use base 2^32 and take advantage of
> this.  In that case, the two inputs to each multiplication won't be
> interchangeable, so using the same type for both would be extra confusing.
> 
> Having a poly1305_val nested inside poly1305_key and poly1305_state would work,
> but seemed excessive.

So it looks like there are no more unresolved issues with this
patch series.  Please let me know when you want it to go in.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
