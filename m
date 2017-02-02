From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH -stable] crypto: ccm - deal with CTR ciphers that honour iv_out
Date: Thu, 2 Feb 2017 11:39:27 +0000
Message-ID: <CAKv+Gu-SF1c0GZv08EG2B2vT6xcGOV7sK-NAruO6WF=BD8494w@mail.gmail.com>
References: <1485636005-5192-1-git-send-email-ard.biesheuvel@linaro.org>
 <CAKv+Gu9Em15JVQOo9civMMWOtwBR0R_a+K0P1Y-JOZJU5zPtnw@mail.gmail.com>
 <20170202051300.GA4349@gondor.apana.org.au> <CAKv+Gu-fUAofB+_Td=bq=m2KsMoc7V3N+NffW5GTuo4fdCwRTw@mail.gmail.com>
 <20170202095352.GA4818@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:33991 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751019AbdBBLj2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2017 06:39:28 -0500
Received: by mail-io0-f169.google.com with SMTP id l66so179591001ioi.1
        for <linux-crypto@vger.kernel.org>; Thu, 02 Feb 2017 03:39:28 -0800 (PST)
In-Reply-To: <20170202095352.GA4818@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2 February 2017 at 09:53, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Thu, Feb 02, 2017 at 08:01:47AM +0000, Ard Biesheuvel wrote:
>>
>> You are right: due to its construction, the CCM mode does not care
>> about the incremented counter because it clears the counter part of
>> the IV before encrypting the MAC. So this is caused by an optimization
>> in my code rather than the CCM code being incorrect.
>
> OK so you will send me an update for the ARM64 code, right?
>

Yes, on their way

Thanks,
Ard.
