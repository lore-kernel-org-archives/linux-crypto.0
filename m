From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3] crypto: AF_ALG - remove locking in async callback
Date: Sat, 25 Nov 2017 11:17:35 +1100
Message-ID: <20171125001735.GC20780@gondor.apana.org.au>
References: <CAGkQfmNKbSwue13zPh2K1F_kLkpm1_AhsAHK4spRFA0xMvU5PA@mail.gmail.com>
 <1966139.WIlnTlQG5u@positron.chronox.de>
 <20171124073739.GB15597@gondor.apana.org.au>
 <12422115.UWn9hbrTTi@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Romain Izard <romain.izard.pro@gmail.com>,
        linux-crypto@vger.kernel.org,
        Cyrille Pitchen <cyrille.pitchen@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:39180 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750955AbdKYASI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Nov 2017 19:18:08 -0500
Content-Disposition: inline
In-Reply-To: <12422115.UWn9hbrTTi@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 24, 2017 at 05:04:19PM +0100, Stephan Mueller wrote:
>
> Would it make sense to feed it to stable?

I already added stable Cc's so it should go in automatically once
it's pushed to Linus.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
