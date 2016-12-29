From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] crypto: arm/aes-neonbs - process 8 blocks in parallel if
 we can
Date: Thu, 29 Dec 2016 12:13:25 +0000
Message-ID: <CAKv+Gu_jUfq2j1oYhHBZsM2NZrCK4VS-WmwEK9ozy8bZGJxszw@mail.gmail.com>
References: <1481291246-20216-1-git-send-email-ard.biesheuvel@linaro.org>
 <20161227085745.GA10121@gondor.apana.org.au> <CAKv+Gu8OkOR3Xzx=XEOWyFpo6sLiq=WQrq0SauaY0V57uYetCQ@mail.gmail.com>
 <20161228091020.GE11904@gondor.apana.org.au> <B32240B5-953F-42A2-A010-6FF64AC45859@linaro.org>
 <20161228092328.GA12494@gondor.apana.org.au> <CAKv+Gu__722s0JkpTzqDu7MmrzSMQ9jJQn=RYnxgSyV+P6MZRQ@mail.gmail.com>
 <20161229022348.GA13402@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:33812 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752654AbcL2MNc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Dec 2016 07:13:32 -0500
Received: by mail-io0-f181.google.com with SMTP id p42so351837608ioo.1
        for <linux-crypto@vger.kernel.org>; Thu, 29 Dec 2016 04:13:32 -0800 (PST)
In-Reply-To: <20161229022348.GA13402@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 29 December 2016 at 02:23, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, Dec 28, 2016 at 07:50:44PM +0000, Ard Biesheuvel wrote:
>>
>> So about this chunksize, is it ever expected to assume other values
>> than 1 (for stream ciphers) or the block size (for block ciphers)?
>> Having block size, IV size *and* chunk size fields may be confusing to
>> some already, so if the purpose of chunk size can be fulfilled by a
>> single 'stream cipher' flag, perhaps we should change that first.
>
> For users (such as algif) it's much more convenient to have a size
> rather than a flag because that's what they need to determine the
> minimum size for partial updates.
>
> For implementors you don't need to specify the chunksize at all
> unless you're a stream cipher (or some other case in future where
> the minimum partial update size is not equal to your block size).
>

OK, fair enough. So I will add a field 'walksize' to the skcipher_alg
struct in my proposal. I think the walk logic itself needs to change
very little, though: we can simply set the walk's chunksize to the
skcipher's walksize if it exceeds its chunksize (and walksize %
chunksize should be 0 in any case, and walksize should default to the
chunksize if not supplied)

If this sounds reasonable to you, I will hack something up next week.
