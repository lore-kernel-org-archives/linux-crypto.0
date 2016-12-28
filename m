From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] crypto: arm/aes-neonbs - process 8 blocks in parallel if we can
Date: Wed, 28 Dec 2016 09:19:32 +0000
Message-ID: <B32240B5-953F-42A2-A010-6FF64AC45859@linaro.org>
References: <1481291246-20216-1-git-send-email-ard.biesheuvel@linaro.org> <20161227085745.GA10121@gondor.apana.org.au> <CAKv+Gu8OkOR3Xzx=XEOWyFpo6sLiq=WQrq0SauaY0V57uYetCQ@mail.gmail.com> <20161228091020.GE11904@gondor.apana.org.au>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wj0-f176.google.com ([209.85.210.176]:32919 "EHLO
        mail-wj0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750758AbcL1JUR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Dec 2016 04:20:17 -0500
Received: by mail-wj0-f176.google.com with SMTP id tq7so96104412wjb.0
        for <linux-crypto@vger.kernel.org>; Wed, 28 Dec 2016 01:19:45 -0800 (PST)
In-Reply-To: <20161228091020.GE11904@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


> On 28 Dec 2016, at 09:10, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>=20
>> On Tue, Dec 27, 2016 at 06:35:46PM +0000, Ard Biesheuvel wrote:
>>=20
>> OK, I will try to hack something up.
>>=20
>> One thing to keep in mind though is that stacked chaining modes should
>> present the data with the same granularity for optimal performance.
>> E.g., xts(ecb(aes)) should pass 8 blocks at a time. How should this
>> requirement be incorporated according to you?
>=20
> xts tries to do a page at a time, which should be good enough, no?
>=20

Yes, if the xts chaining mode driver invokes the ecb transform with that gra=
nularity, it should be fine. Note that this is a theoretical
concern for this mode in particular, given that the bit sliced aes code impl=
ements the xts bits as well

> In general this parameter should be visible to internal API users
> such as xts so they could use it to determine how it wants to
> structure its walks.
>=20

Ok, so that implies a field in the skcipher algo struct then, rather than so=
me definition internal to the driver?

> Cheers,
> --=20
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
