From: abed mohammad kamaluddin <abedamu@gmail.com>
Subject: Re: algif for compression?
Date: Mon, 3 Apr 2017 11:40:19 +0530
Message-ID: <CACVarEQ14ZF9LGDkaNYtX3GRD5GOH62NBiPtC4z=i6RY4MtFDA@mail.gmail.com>
References: <CACVarETuTx40WFD5TRUCwiYv5r3SEvhuJHpGjqPsz90qVZsYKA@mail.gmail.com>
 <20161210081014.GA32746@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:32932 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751141AbdDCGKl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Apr 2017 02:10:41 -0400
Received: by mail-wr0-f173.google.com with SMTP id w43so153054365wrb.0
        for <linux-crypto@vger.kernel.org>; Sun, 02 Apr 2017 23:10:40 -0700 (PDT)
In-Reply-To: <20161210081014.GA32746@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

We have implemented algif acomp interface for user space applications
to utilize the kernel compression framework and the hardware drivers
using it and have been testing it using userspace zlib library.

However, what we find lacking in the existing acomp implementation is
the ability to pass context data between the applications and the
drivers using the acomp interface. Currently the interface only allows
src/dest data  and a flag argument with each request. There are two
context pointers, one in acomp_req and another in crypto_tfm but they
are for internal use and not available to applications through the
api's. Would it be acceptable to add fields that need to be
communicated b/w the driver and applications like history,
csum/adler32, EOF, stream ctx  to acomp_req.

Or is there any other way, which I may have missed, through which we
can pass ctx data between applications and drivers while using the
kernel compression framework?

Thanks,
Abed
(Cavium Inc)


On Sat, Dec 10, 2016 at 1:40 PM, Herbert Xu <herbert@gondor.apana.org.au> w=
rote:
> abed mohammad kamaluddin <abedamu@gmail.com> wrote:
>>
>> We are also looking for user-space access to the kernel crypto layer
>> compression algorithms. I have gone through AF_ALG but couldn=E2=80=99t =
find
>> support for compression ops through it. This is required for our
>> hardware zip engines whose driver hooks up to the crypto layer.
>>
>> I was going through the lists and stumbled across this thread. Has
>> there been  any updates or efforts put up in this direction since this
>> thread is a few years old. If not, are there any alternate
>> implementations that allow user-space access to compression? I have
>> gone through cryptodev and see the same limitation there.
>>
>> Would appreciate any pointers in this regard.
>
> The compression interface is currently in a state of flux.  We
> should make it settle down first before exporting it to user-space.
>
> For a start it would be good to actually switch IPsec/IPcomp over
> to the new compression interface.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
