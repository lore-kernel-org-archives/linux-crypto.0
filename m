From: Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v2 0/4] crypto: aesni - Use zero-copy for gcm(aes) buffers
 that are partially contiguous
Date: Wed, 31 Jan 2018 10:54:57 -0800
Message-ID: <CAL-GctGUvZ=D8CDWMyKzfj2L++6HCOWNS82joRhdi8G0Q8i_hQ@mail.gmail.com>
References: <20180123201916.102134-1-junaids@google.com> <20180131081316.kzkj65hljugdahfl@gauss3.secunet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org,
        Andres Lagar-Cavilla <andreslc@google.com>,
        davem@davemloft.net, Greg Thelen <gthelen@google.com>,
        Eric Biggers <ebiggers3@gmail.com>,
        Stephan Mueller <smueller@chronox.de>
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:42034 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751326AbeAaSzi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jan 2018 13:55:38 -0500
Received: by mail-qt0-f196.google.com with SMTP id c2so23173998qtn.9
        for <linux-crypto@vger.kernel.org>; Wed, 31 Jan 2018 10:55:38 -0800 (PST)
In-Reply-To: <20180131081316.kzkj65hljugdahfl@gauss3.secunet.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Steffen,

On Wed, Jan 31, 2018 at 12:13 AM, Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> I wonder which special usecase you have in mind that will be improved
> by your patches.
>

This is not related to IPsec. We have an internal use case where the
data buffer itself is a single memory page but the authentication tag
needs to be in a separate buffer. This patch set allows us to have
zero copy in that case.

>
> Maybe it would be better to investigate in the direction to
> support SG operations with gcm-aesni instead of trying to
> find all corner cases where the existing implementation can
> do zero-copy.
>

Yes, if gcm-aesni could be implemented to handle arbitrarily
fragmented buffers, that would be better, but it would likely be a
much bigger and more complicated change. Just handling the case where
the AAD/data/authtag are separate contiguous buffers is relatively
simpler but still useful.

Thanks,
Junaid
