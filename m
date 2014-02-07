From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [RFC PATCH 0/3] support for interleaving in generic chaining modes
Date: Fri, 7 Feb 2014 10:42:14 +0100
Message-ID: <CAKv+Gu_kQFA26Ntc1p1yNRpxfJd8xgk27OnS7LG4V5qzH5NBjg@mail.gmail.com>
References: <1391689504-28160-1-git-send-email-ard.biesheuvel@linaro.org>
	<20140207022335.GA27694@gondor.apana.org.au>
	<CAKv+Gu-4J6jO135QgNrLrEX96U7aS7k4BE82j9ZLzwe60HfTTQ@mail.gmail.com>
	<20140207092304.GA2573@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:54239 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbaBGJmQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Feb 2014 04:42:16 -0500
Received: by mail-la0-f50.google.com with SMTP id ec20so2426257lab.37
        for <linux-crypto@vger.kernel.org>; Fri, 07 Feb 2014 01:42:14 -0800 (PST)
In-Reply-To: <20140207092304.GA2573@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 7 February 2014 10:23, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Fri, Feb 07, 2014 at 08:30:26AM +0100, Ard Biesheuvel wrote:
>>
>> I agree that it would be trivial for cbc(%s) to probe for ecb(%s)
>> before settling on using plain '%s.
>> But how to probe for an /accelerated/ ecb(%s), i.e., how to avoid
>> using the generic ecb(%s) which adds nothing but overhead?
>> The other issue is how to find out what the optimal chunk size is for
>> the accelerated ecb(%s) implementation, which would involve adding a
>> struct member that holds the preferred number of blocks presented in a
>> single invocation.
>> In fact, that would solve both issues, as the probe could check this
>> struct member for a >1 value (as my current series does but in against
>> a cipher_alg instance)
>
> I'd like to see some numbers on the actual overhead of ecb before
> we get too deeply into optimising it away.
>

Naturally.

> In any case, one easy solution is to change the driver name of
> generic ecb to ecb_generic (cf. ccm.c) which you could then
> check for in cbc and elsewhere.
>
> Also, how are you determining the optimal number of blocks? For
> the in-place case you're bound by how much memory you can find
> for the temporary buffer.  For the not-in-place case wouldn't you
> just go for as much as you can?
>

Well, the thing with dedicated instructions is that the relation
between chunk size and speedup is not a smooth curve.
Of course, it is always beneficial to amortize e.g. loading of the
round keys over as many blocks as possible, but what is especially
wasteful are the pipeline stalls due to data dependencies between
subsequent rounds.
For instance, on arm64

// round 1
aese   v0.16b, v16.16b
aesmc  v0.16b, v0.16b

// round 2
aese   v0.16b, v17.16b
aesmc  v0.16b, v0.16b

//etc

Putting all these instructions back to back makes it difficult for the
pipeline to reach its full speed. However, replacing it by

// round 1a
aese   v0.16b, v16.16b
aesmc  v0.16b, v0.16b

// round 1b
aese   v1.16b, v16.16b
aesmc  v1.16b, v1.16b

// round 2a
aese   v0.16b, v17.16b
aesmc  v0.16b, v0.16b

// round 2b
aese   v1.16b, v17.16b
aesmc  v1.16b, v1.16b

for a 2-way interleave may easily result in a significant speedup,
while further interleaving brings little additional benefit (if the
pipeline stalls have all been eliminated)

Another example is bit sliced AES like the implementation in
arch/arm/crypto. It is 45% faster than the ordinary ARM asm
implementation, but its natural chunk size is 8 blocks. Passing fewer
blocks hurts performance, while passing more blocks does not give any
additional benefit at all.

So in many cases, it would be good to know the preferred chunk size of
an algorithm.

Regards,
Ard.
