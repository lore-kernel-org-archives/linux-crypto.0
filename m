Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A30F1C64E90
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 23:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57FC8221E2
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 23:31:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgLAXbN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Dec 2020 18:31:13 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:51512 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726066AbgLAXbN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Dec 2020 18:31:13 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kkF6G-0003FC-Fy; Wed, 02 Dec 2020 10:30:25 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 02 Dec 2020 10:30:24 +1100
Date:   Wed, 2 Dec 2020 10:30:24 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ben Greear <greearb@candelatech.com>,
        Steve deRosier <derosier@cal-sierra.com>
Subject: Re: [PATCH v2] crypto: aesni - add ccm(aes) algorithm implementation
Message-ID: <20201201233024.GB32382@gondor.apana.org.au>
References: <20201201194556.5220-1-ardb@kernel.org>
 <20201201215722.GA31941@gondor.apana.org.au>
 <CAMj1kXHb27ugTWuQZhPD0DvjtgYC8t_pj+igqK7dNfh+WsUS4w@mail.gmail.com>
 <20201201220431.GA32072@gondor.apana.org.au>
 <CAMj1kXGO+kbZ+2VmUQKxLYos2nR5vqZKjengxPxPjSXudG-zLw@mail.gmail.com>
 <20201201221628.GA32130@gondor.apana.org.au>
 <CAMj1kXFrLiHfv1S1AM=5pc1J9gWwZVuoGvmFoTT0-+oREoojTA@mail.gmail.com>
 <20201201231158.GA32274@gondor.apana.org.au>
 <CAMj1kXE2RULwwxAGRTeACQVCpYoeuY3LmMK0hw4BOQo1gH5d8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXE2RULwwxAGRTeACQVCpYoeuY3LmMK0hw4BOQo1gH5d8Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 02, 2020 at 12:24:47AM +0100, Ard Biesheuvel wrote:
>
> True. But the fallback only gets executed if the scheduler is stupid
> enough to schedule the TX task onto the core that is overloaded doing
> RX softirqs. So in the general case, both TX and RX will be using
> AES-NI instructions (unless the CCMP is done in hardware which is the
> most common case by far)

I don't think this makes sense.  TX is typically done in response
to RX so the natural alignment is for it to be on the same CPU.
 
> Wireless is very different. Wifi uses a medium that is fundamentally
> shared, and so the load it can induce is bounded. There is no way a
> wifi interface is going to saturate a 64-bit AES-NI core doing CCMP in
> software.

This sounds pretty tenuous.  In any case, even if wireless itself
doesn't get you, there could be loads running on top of it, for
example, IPsec.

> Given the above, can't we be pragmatic here? This code addresses a
> niche use case, which is not affected by the general concerns
> regarding async crypto.

We already have a framework for acceleration that works properly
in aesni, I don't want to see us introduce another broken model
within the same driver.

So either just leave the whole thing along or do it properly by
making wireless async.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
