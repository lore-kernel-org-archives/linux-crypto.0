From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: aead: driver side documentation
Date: Fri, 8 Apr 2011 15:44:01 -0500
Message-ID: <20110408154401.4cbb989b.kim.phillips@freescale.com>
References: <20110405192129.d2778dec.kim.phillips@freescale.com>
	<20110408005533.GA14581@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <phil@nwl.cc>, <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:10222
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757841Ab1DHUoH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Apr 2011 16:44:07 -0400
In-Reply-To: <20110408005533.GA14581@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 8 Apr 2011 08:55:33 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> Kim Phillips <kim.phillips@freescale.com> wrote:
> >
> > I started to add test vectors from [1] to crypto/testmgr.c, but it
> > required that drivers not assume associated data, iv, and cipher data
> > were contiguous in memory, and since some of them do, I don't know if
> > such a contribution would be acceptable upstream.
> 
> Such drivers are broken and should be fixed.

ok.

> > then there's the rtnetlink dependencies I mention in [2] that
> > also make drivers fail AEAD testmgr tests in their setkey()
> > implementations, IIRC, because testmgr keys aren't RTA_OK.
> 
> Can you elaborate on this problem?

the following conditions in a driver setkey fail:

        if (!RTA_OK(rta, keylen))
                goto badkey;

        if (rta->rta_type != CRYPTO_AUTHENC_KEYA_PARAM)
                goto badkey;

because testmgr keys are plain strings, not rtattr structs.

Kim
