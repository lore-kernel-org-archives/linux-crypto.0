From: =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Subject: Re: AEAD: Having separate underlying cipher handle for each request
Date: Wed, 6 Jul 2016 15:10:00 +0200
Message-ID: <CAAUqJDstRjwNYqxAJpkF1HpbpzuTNXgubRtUYaPWiqa6WrhUbQ@mail.gmail.com>
References: <CAAUqJDvY9x+iOkH_vNQS9+qV+ONkbfgprOKFGcRXNe2788JnBA@mail.gmail.com>
 <20160706063149.GA14106@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:33833 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbcGFNKB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 Jul 2016 09:10:01 -0400
Received: by mail-oi0-f42.google.com with SMTP id s66so269383096oif.1
        for <linux-crypto@vger.kernel.org>; Wed, 06 Jul 2016 06:10:01 -0700 (PDT)
In-Reply-To: <20160706063149.GA14106@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

2016-07-06 8:31 GMT+02:00, Herbert Xu <herbert@gondor.apana.org.au>:
> Well you're pretty much screwed as far as performance is concerned.
> So just postpone all processing to process context and allocate a new
> tfm for each request.

Yeah, I guess that's the only way then...

Thanks,
Ondrej

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>
