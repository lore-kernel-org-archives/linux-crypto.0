From: =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Subject: Re: [RFC PATCH 0/6] Add bulk skcipher requests to crypto API and dm-crypt
Date: Tue, 17 Jan 2017 12:20:02 +0100
Message-ID: <CAAUqJDsrFp2CczN5Gyy=rYLSDKi7=vQTQoyh=pE1kWue=c=fvw@mail.gmail.com>
References: <cover.1484215956.git.omosnacek@gmail.com> <20170113104128.GA23497@gondor.apana.org.au>
 <CAAUqJDtqN-ugcaz4VhuW0fzLbmKt4db8ggrRmaAq_zFvO+9Lvw@mail.gmail.com> <20170113142959.GA24258@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        Mike Snitzer <snitzer@redhat.com>,
        Milan Broz <gmazyland@gmail.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Binoy Jayan <binoy.jayan@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:36121 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750747AbdAQLUZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Jan 2017 06:20:25 -0500
Received: by mail-lf0-f67.google.com with SMTP id h65so15754869lfi.3
        for <linux-crypto@vger.kernel.org>; Tue, 17 Jan 2017 03:20:24 -0800 (PST)
In-Reply-To: <20170113142959.GA24258@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

2017-01-13 15:29 GMT+01:00 Herbert Xu <herbert@gondor.apana.org.au>:
> What if the driver had hardware support for generating these IVs?
> With your scheme this cannot be supported at all.

That's true... I'm starting to think that this isn't really a good
idea. I was mainly trying to keep the door open for the random IV
support and also to keep the multi-key stuff (which was really only
intended for loop-AES partition support) out of the crypto API, but
both of these can be probably solved in a better way...

> Getting the IVs back is not actually that hard.  We could simply
> change the algorithm definition for the IV generator so that
> the IVs are embedded in the plaintext and ciphertext.  For
> example, you could declare it so that the for n sectors the
> first n*ivsize bytes would be the IV, and the actual plaintext
> or ciphertext would follow.
>
> With such a definition you could either generate the IVs in dm-crypt
> or have them generated in the IV generator.

That seems kind of hacky to me... but if that's what you prefer, then so be it.

Cheers,
Ondrej

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
