From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH v2 0/4] crypto: aesni - Use zero-copy for gcm(aes)
 buffers that are partially contiguous
Date: Thu, 1 Feb 2018 10:03:55 +0100
Message-ID: <20180201090355.ovcovbnnp4c7a4et@gauss3.secunet.de>
References: <20180123201916.102134-1-junaids@google.com>
 <20180131081316.kzkj65hljugdahfl@gauss3.secunet.de>
 <CAL-GctGUvZ=D8CDWMyKzfj2L++6HCOWNS82joRhdi8G0Q8i_hQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>,
        Andres Lagar-Cavilla <andreslc@google.com>,
        <davem@davemloft.net>, "Greg Thelen" <gthelen@google.com>,
        Eric Biggers <ebiggers3@gmail.com>,
        "Stephan Mueller" <smueller@chronox.de>
To: Junaid Shahid <junaids@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([62.96.220.36]:40254 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751245AbeBAJEH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Feb 2018 04:04:07 -0500
Content-Disposition: inline
In-Reply-To: <CAL-GctGUvZ=D8CDWMyKzfj2L++6HCOWNS82joRhdi8G0Q8i_hQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 31, 2018 at 10:54:57AM -0800, Junaid Shahid wrote:
> On Wed, Jan 31, 2018 at 12:13 AM, Steffen Klassert
> <steffen.klassert@secunet.com> wrote:
> >
> > I wonder which special usecase you have in mind that will be improved
> > by your patches.
> >
> 
> This is not related to IPsec. We have an internal use case where the
> data buffer itself is a single memory page but the authentication tag
> needs to be in a separate buffer. This patch set allows us to have
> zero copy in that case.

We usually don't add code for 'internal use cases' to the mainline
kernel. If you need a SG version of gcm-aesni, then please implement
the generic version so that everybody can benefit from it.

Think about how this will look like if everybody would add
a workaround for its very special use case.
