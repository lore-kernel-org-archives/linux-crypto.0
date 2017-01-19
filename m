From: =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Subject: Re: [RFC PATCH 0/6] Add bulk skcipher requests to crypto API and dm-crypt
Date: Thu, 19 Jan 2017 15:21:37 +0100
Message-ID: <CAAUqJDtZNGLW-PcPKJD5vdKMZqd6+sAKrbjqVbaVTQqWwZ4cGQ@mail.gmail.com>
References: <cover.1484215956.git.omosnacek@gmail.com> <20170113104128.GA23497@gondor.apana.org.au>
 <CAAUqJDtqN-ugcaz4VhuW0fzLbmKt4db8ggrRmaAq_zFvO+9Lvw@mail.gmail.com>
 <20170113142959.GA24258@gondor.apana.org.au> <CAAUqJDsrFp2CczN5Gyy=rYLSDKi7=vQTQoyh=pE1kWue=c=fvw@mail.gmail.com>
 <20170118044828.GB4460@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        Mike Snitzer <snitzer@redhat.com>,
        Milan Broz <gmazyland@gmail.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Binoy Jayan <binoy.jayan@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34346 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752856AbdASOWK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Jan 2017 09:22:10 -0500
Received: by mail-lf0-f65.google.com with SMTP id q89so5601926lfi.1
        for <linux-crypto@vger.kernel.org>; Thu, 19 Jan 2017 06:21:58 -0800 (PST)
In-Reply-To: <20170118044828.GB4460@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

2017-01-18 5:48 GMT+01:00 Herbert Xu <herbert@gondor.apana.org.au>:
> I'm open to other proposals.  The basic requirement is to be able to
> process multiple blocks as one entity at the driver level, potentially
> generating the IVs there too.
>
> It's essentially the equivalent to full IPsec offload.

Hm, I just looked at what the IPsec IV generation is actually doing
and it seems to me that it's basically a crypto template that just
somehow transforms the IV before it is passed to the child cipher... I
thought for a while that you were implying that there already is some
facility in the crypto API that allows submitting multiple messages +
some initial sequence number that is auto-incremented and IVs are
generated from the numbers. However, I could not find anything like
that in the code, so now I think what you meant was just that I should
somehow pull the actual IV generators into the crypto layer so that
the IVs can be generated inside the hardware.

If all you had in mind is just an equivalent of the current IPsec IV
generation (as I understood it), then my bulk request scheme can in
fact support it (you'd just pass sector numbers as the IVs). Of
course, it would require additional changes over my patchset,
specifically the creation of crypto templates for the dm-crypt IV
modes, so they can be implemented by drivers. However, I wanted to
avoid this until the key management in dm-crypt is simplified...

If we also want to let the drivers process an offset+count chunk of
sectors while auto-incrementing the sector number, then something like
Binoy's approach would indeed be necessary, where the IV generators
would be just regular skciphers, taking the initial sector number as
the IV (although a disadvantage would be hard-coded sector/message
size). Note, though, that the generic implementation of such transform
could still use bulk requests on the underlying cipher so that
encryption/decryption is performed efficiently even if there are no
optimized/HW drivers for the specific IV generator templates.

I will now try to focus on the key management simplification and when
it is accepted/rejected we can discuss further about the best
approach.

Cheers,
Ondrej

>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
