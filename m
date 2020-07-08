Return-Path: <SRS0=WqbL=AT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EB56C433DF
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 07:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1568020656
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 07:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729727AbgGHHC3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jul 2020 03:02:29 -0400
Received: from sitav-80046.hsr.ch ([152.96.80.46]:50930 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729667AbgGHHC3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jul 2020 03:02:29 -0400
X-Greylist: delayed 479 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jul 2020 03:02:28 EDT
Received: from obook.home (unknown [IPv6:2a02:1205:507f:2dd0:218b:aeae:d903:4d0b])
        by mail.strongswan.org (Postfix) with ESMTPSA id DD444401B3;
        Wed,  8 Jul 2020 08:54:27 +0200 (CEST)
Message-ID: <29a9c7669048dfcf6e6b52f55bd70fa4d9c29523.camel@strongswan.org>
Subject: Re: [v3 PATCH] crypto: chacha - Add DEFINE_CHACHA_STATE macro
From:   Martin Willi <martin@strongswan.org>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Date:   Wed, 08 Jul 2020 08:54:27 +0200
In-Reply-To: <CAMj1kXGT065Q1NmUFVqMD-WO-JETMLP-CUeSfTvsw7qrY6AqWg@mail.gmail.com>
References: <20200706133733.GA6479@gondor.apana.org.au>
         <20200706190717.GB736284@gmail.com>
         <20200706223716.GA10958@gondor.apana.org.au>
         <20200708023108.GK839@sol.localdomain>
         <20200708024402.GA10648@gondor.apana.org.au>
         <CAMj1kXEgd61L08k9S0xbvYnAT+bg4cZT-p1JsxtWfGhFOttEPw@mail.gmail.com>
         <CAMj1kXGT065Q1NmUFVqMD-WO-JETMLP-CUeSfTvsw7qrY6AqWg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> > Also, I wonder if we shouldn't simply change the chacha code to use
> > unaligned loads for the state array, as it likely makes very little
> > difference in practice (the state is not accessed from inside the
> > round processing loop)
> 
> I am seeing a 0.25% slowdown on 1k blocks in the SSE3 code with the
> change below: [...]
> 
> AVX2 and AVX512 uses vbroadcasti128 with memory operands to load the
> state, so they don't require any changes afaik.

I agree. Moving SSE to use unaligned loads is certainly acceptable
these days. 

Some AVX functions use vpbroadcastd with u32 load granularity anyway.
Some use vbroadcasti128 that theoretically could (?) suffer somewhat
when operating on unaligned data, but it I guess it won't justify all
that alignment cruft.

Regards,
Martin

