From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: CRYPTO_ALG_ASYNC
Date: Thu, 10 May 2012 13:31:10 +0300
Message-ID: <CALLzPKZWvFvPeA2ZKkRBPKA9WK7oDtzymDmG4Y-u=pmq8khXNA@mail.gmail.com>
References: <CALLzPKYc0wBtTiNtDGgY09D_7MJPtwBoQ1AS_U-Jsg02+hEPOA@mail.gmail.com>
	<20120510101611.GA21025@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:60087 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758818Ab2EJKbL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 May 2012 06:31:11 -0400
Received: by dano14 with SMTP id o14so5285691dan.25
        for <linux-crypto@vger.kernel.org>; Thu, 10 May 2012 03:31:10 -0700 (PDT)
In-Reply-To: <20120510101611.GA21025@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 10, 2012 at 1:16 PM, Herbert Xu <herbert@gondor.apana.org.a=
u> wrote:
> On Thu, May 10, 2012 at 12:33:40PM +0300, Kasatkin, Dmitry wrote:
>> Hello Herbert,
>>
>> CRYPTO_ALG_ASYNC is heavily used like:
>>
>> =C2=A0 =C2=A0 crypto_alloc_shash(hash_alg, 0, CRYPTO_ALG_ASYNC);
>
> Where did you see that? There is no need to specify ASYNC in the
> mask for shash since they're always synchronous.
>

Yes, that is why I wonder...

=46or example in security/keys/

But why do we need it for AHASH or ABLKCIPHER?
It is obvious without it that they can be async?

- Dmitry

> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
