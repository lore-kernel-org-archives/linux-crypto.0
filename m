From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] crypto: arm/aes-neonbs - process 8 blocks in parallel if
 we can
Date: Wed, 28 Dec 2016 19:50:44 +0000
Message-ID: <CAKv+Gu__722s0JkpTzqDu7MmrzSMQ9jJQn=RYnxgSyV+P6MZRQ@mail.gmail.com>
References: <1481291246-20216-1-git-send-email-ard.biesheuvel@linaro.org>
 <20161227085745.GA10121@gondor.apana.org.au> <CAKv+Gu8OkOR3Xzx=XEOWyFpo6sLiq=WQrq0SauaY0V57uYetCQ@mail.gmail.com>
 <20161228091020.GE11904@gondor.apana.org.au> <B32240B5-953F-42A2-A010-6FF64AC45859@linaro.org>
 <20161228092328.GA12494@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:35147 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751967AbcL1TvH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Dec 2016 14:51:07 -0500
Received: by mail-io0-f174.google.com with SMTP id n85so105698533ioi.2
        for <linux-crypto@vger.kernel.org>; Wed, 28 Dec 2016 11:50:45 -0800 (PST)
In-Reply-To: <20161228092328.GA12494@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 28 December 2016 at 09:23, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, Dec 28, 2016 at 09:19:32AM +0000, Ard Biesheuvel wrote:
>>
>> Ok, so that implies a field in the skcipher algo struct then, rather than some definition internal to the driver?
>
> Oh yes it should definitely be visible to other crypto API drivers
> and algorithms.  It's just that we don't want to export it outside
> of the crypto API, e.g., to IPsec or algif.
>

Understood.

So about this chunksize, is it ever expected to assume other values
than 1 (for stream ciphers) or the block size (for block ciphers)?
Having block size, IV size *and* chunk size fields may be confusing to
some already, so if the purpose of chunk size can be fulfilled by a
single 'stream cipher' flag, perhaps we should change that first.
