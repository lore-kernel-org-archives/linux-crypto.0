From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: AF_ALG - remove locking in async callback
Date: Tue, 7 Nov 2017 14:32:12 +0800
Message-ID: <20171107063212.GA25491@gondor.apana.org.au>
References: <CAGkQfmNKbSwue13zPh2K1F_kLkpm1_AhsAHK4spRFA0xMvU5PA@mail.gmail.com>
 <1977235.9AvJZzduGj@tauon.chronox.de>
 <20171107052235.GA20803@gondor.apana.org.au>
 <4677171.2qOLUIFS1s@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Romain Izard <romain.izard.pro@gmail.com>,
        linux-crypto@vger.kernel.org,
        Cyrille Pitchen <cyrille.pitchen@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:54308 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754019AbdKGGcs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Nov 2017 01:32:48 -0500
Content-Disposition: inline
In-Reply-To: <4677171.2qOLUIFS1s@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 07, 2017 at 07:19:32AM +0100, Stephan Müller wrote:
> 
> Where I am not fully sure is whether af_alg_async_cb is called in any case. 
> I.e. when we invoke an AIO operation with a cipher that completes 
> synchronously (e.g. AES-NI), is this callback triggered?

It's the same with any other callback in the crypto API.  The
completion function is called if the return value is EINPROGRESS
or EBUSY.

In fact the algif_aead/algif_skcipher code already frees the SG lists
and areq on a sync return.  So perhaps you can merge this with the
completion function.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
