Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AF18C64E90
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 23:48:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 376B522261
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 23:48:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbgLAXs4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Dec 2020 18:48:56 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:51560 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbgLAXs4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Dec 2020 18:48:56 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kkFNU-0003Tb-Gc; Wed, 02 Dec 2020 10:48:13 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 02 Dec 2020 10:48:12 +1100
Date:   Wed, 2 Dec 2020 10:48:12 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ben Greear <greearb@candelatech.com>,
        Steve deRosier <derosier@cal-sierra.com>
Subject: Re: [PATCH v2] crypto: aesni - add ccm(aes) algorithm implementation
Message-ID: <20201201234812.GA32538@gondor.apana.org.au>
References: <20201201215722.GA31941@gondor.apana.org.au>
 <CAMj1kXHb27ugTWuQZhPD0DvjtgYC8t_pj+igqK7dNfh+WsUS4w@mail.gmail.com>
 <20201201220431.GA32072@gondor.apana.org.au>
 <CAMj1kXGO+kbZ+2VmUQKxLYos2nR5vqZKjengxPxPjSXudG-zLw@mail.gmail.com>
 <20201201221628.GA32130@gondor.apana.org.au>
 <CAMj1kXFrLiHfv1S1AM=5pc1J9gWwZVuoGvmFoTT0-+oREoojTA@mail.gmail.com>
 <20201201231158.GA32274@gondor.apana.org.au>
 <CAMj1kXE2RULwwxAGRTeACQVCpYoeuY3LmMK0hw4BOQo1gH5d8Q@mail.gmail.com>
 <20201201233024.GB32382@gondor.apana.org.au>
 <CAMj1kXEfRCNuaz_sX29CQ=JsUF6niYbYceXUjy9cq3=eF77mvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXEfRCNuaz_sX29CQ=JsUF6niYbYceXUjy9cq3=eF77mvg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 02, 2020 at 12:41:36AM +0100, Ard Biesheuvel wrote:
>
> You just explained that TX typically runs in process context, whereas
> RX is handled in softirq context. So how exactly are these going to
> end up on the same core?

When you receive a TCP packet via RX, this should wake up your user-
space thread on the same CPU as otherwise you'll pay extra cost
on pulling the data into memory again.

> Yes, but IPsec will not use the synchronous interface.

That doesn't matter when the underlying wireless code is using
the sync interface.  An async user is completely capable of making
the aesni code-path unavailable to the sync user.
 
> Fair enough. But it is unfortunate that we cannot support Ben's use
> case without a lot of additional work that serves no purpose
> otherwise.

To the contrary, I think to fully support Ben's use case you must
use the async code path.  Otherwise sure you'll see good numbers
when you do simple benchmarks like netperf, but when you really
load up the system it just falls apart.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
