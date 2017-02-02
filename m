From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH -stable] crypto: ccm - deal with CTR ciphers that honour iv_out
Date: Thu, 2 Feb 2017 08:01:47 +0000
Message-ID: <CAKv+Gu-fUAofB+_Td=bq=m2KsMoc7V3N+NffW5GTuo4fdCwRTw@mail.gmail.com>
References: <1485636005-5192-1-git-send-email-ard.biesheuvel@linaro.org>
 <CAKv+Gu9Em15JVQOo9civMMWOtwBR0R_a+K0P1Y-JOZJU5zPtnw@mail.gmail.com> <20170202051300.GA4349@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:37357 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750878AbdBBIBs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2017 03:01:48 -0500
Received: by mail-it0-f49.google.com with SMTP id r185so35953122ita.0
        for <linux-crypto@vger.kernel.org>; Thu, 02 Feb 2017 00:01:48 -0800 (PST)
In-Reply-To: <20170202051300.GA4349@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2 February 2017 at 05:13, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, Feb 01, 2017 at 08:08:09PM +0000, Ard Biesheuvel wrote:
>>
>> Could you please forward this patch to Linus as well? I noticed that the patch
>
> Sure, I will do that.
>
>> crypto: arm64/aes-blk - honour iv_out requirement in CBC and CTR modes
>>
>> is now in mainline, which means CCM is now broken on arm64, given that
>> the iv_out requirement for CTR apparently isn't honored by *any*
>> implementation, and CCM wrongly assumes that req->iv retains its value
>> across the call into the CTR skcipher
>
> Hmm, I wonder why we don't see this breakage with the generic
> CTR as it seems to do exactly the same thing.
>

You are right: due to its construction, the CCM mode does not care
about the incremented counter because it clears the counter part of
the IV before encrypting the MAC. So this is caused by an optimization
in my code rather than the CCM code being incorrect.
