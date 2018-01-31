From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH v2 0/4] crypto: aesni - Use zero-copy for gcm(aes)
 buffers that are partially contiguous
Date: Wed, 31 Jan 2018 09:13:16 +0100
Message-ID: <20180131081316.kzkj65hljugdahfl@gauss3.secunet.de>
References: <20180123201916.102134-1-junaids@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
        <andreslc@google.com>, <davem@davemloft.net>, <gthelen@google.com>,
        <ebiggers3@gmail.com>, <smueller@chronox.de>
To: Junaid Shahid <junaids@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([62.96.220.36]:57760 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753502AbeAaINT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jan 2018 03:13:19 -0500
Content-Disposition: inline
In-Reply-To: <20180123201916.102134-1-junaids@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Junaid.

On Tue, Jan 23, 2018 at 12:19:12PM -0800, Junaid Shahid wrote:
> Changes in v2:
> - Integrated https://patchwork.kernel.org/patch/10173981
> 
> Currently, the AESNI gcm(aes) implementation uses zero-copy only when the
> entire src and dest request buffers, including the AAD, the data and the
> Auth Tag are contiguous. This series enables the use of zero-copy even if the
> AAD and/or Auth Tag are in different buffers than the actual data, as long as
> each of them individually satisfies the zero-copy conditions (i.e. the entire
> buffer is either in low-mem or within a single high-mem page). Furthermore,
> it also enables the use of zero-copy even if only one of src and dest satisfies
> these conditions rather than only when both of them do.

I wonder which special usecase you have in mind that will be improved
by your patches.

For IPsec, the crypto layer either gets a contiguous buffer because
networking already linearized the packet data, or the packet data
and IPsec trailer are scattered over multiple page fragments.
So in the first case, it is OK already without your patches. In
the second case, your zero-copy conditions are not satisfied.

This looks a bit like a workaround of the real problem, that is
that the gcm-aesni implementation does not support SG operations.

Maybe it would be better to investigate in the direction to
support SG operations with gcm-aesni instead of trying to
find all corner cases where the existing implementation can
do zero-copy.
