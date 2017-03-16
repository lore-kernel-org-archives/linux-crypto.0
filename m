From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 1/4] crypto: powerpc - Factor out the core CRC vpmsum algorithm
Date: Thu, 16 Mar 2017 21:45:49 +1100
Message-ID: <87y3w5jy8y.fsf@concordia.ellerman.id.au>
References: <20170315123737.20234-1-dja@axtens.net>
Mime-Version: 1.0
Content-Type: text/plain
Cc: anton@samba.org, Daniel Axtens <dja@axtens.net>
To: Daniel Axtens <dja@axtens.net>, linuxppc-dev@lists.ozlabs.org,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:50293 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751137AbdCPKpz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Mar 2017 06:45:55 -0400
In-Reply-To: <20170315123737.20234-1-dja@axtens.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Daniel Axtens <dja@axtens.net> writes:

> The core nuts and bolts of the crc32c vpmsum algorithm will
> also work for a number of other CRC algorithms with different
> polynomials. Factor out the function into a new asm file.
>
> To handle multiple users of the function, a user simply
> provides constants, defines the name of their CRC function,
> and then #includes the core algorithm file.
>
> Cc: Anton Blanchard <anton@samba.org>
> Signed-off-by: Daniel Axtens <dja@axtens.net>
>
> --
>
> It's possible at this point to argue that the address
> of the constant tables should be passed in to the function,
> rather than doing this somewhat unconventional #include.
>
> However, we're about to add further #ifdef's back into the core
> that will be provided by the encapsulaing code, and which couldn't
> be done as a variable without performance loss.
> ---
>  arch/powerpc/crypto/crc32-vpmsum_core.S | 726 ++++++++++++++++++++++++++++++++
>  arch/powerpc/crypto/crc32c-vpmsum_asm.S | 714 +------------------------------
>  2 files changed, 729 insertions(+), 711 deletions(-)
>  create mode 100644 arch/powerpc/crypto/crc32-vpmsum_core.S

So although this sits in arch/powerpc, it's heavy on the crypto which is
not my area of expertise (to say the least!), so I think it should
probably go via Herbert and the crypto tree?

cheers
