Return-Path: <SRS0=sLqA=CY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89467C43461
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 10:05:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 464D621D24
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 10:05:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgIOKFS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Sep 2020 06:05:18 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:46416 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726095AbgIOKFQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Sep 2020 06:05:16 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kI7pi-0003Es-DJ; Tue, 15 Sep 2020 20:05:07 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 15 Sep 2020 20:05:06 +1000
Date:   Tue, 15 Sep 2020 20:05:06 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: lib/chacha20poly1305 - Set SG_MITER_ATOMIC
 unconditionally
Message-ID: <20200915100506.GA27268@gondor.apana.org.au>
References: <CAHk-=win80rdof8Pb=5k6gT9j_v+hz-TQzKPVastZDvBe9RimQ@mail.gmail.com>
 <871rj4owfn.fsf@nanos.tec.linutronix.de>
 <CAHk-=wj0eUuVQ=hRFZv_nY7g5ZLt7Fy3K7SMJL0ZCzniPtsbbg@mail.gmail.com>
 <CAHk-=wjOV6f_ddg+QVCF6RUe+pXPhSR2WevnNyOs9oT+q2ihEA@mail.gmail.com>
 <20200915033024.GB25789@gondor.apana.org.au>
 <CAHk-=wgX=ynJAXYYOAM7J8Tee8acERrGOopNu6ZcLN=SEXdGKA@mail.gmail.com>
 <CAHk-=wie0Kb-+XOZNasoay7AKCaQ8Ew8=LyvWTBeiPXC3v2GSA@mail.gmail.com>
 <20200915070523.GA26629@gondor.apana.org.au>
 <878sdb5qp5.fsf@nanos.tec.linutronix.de>
 <CAMj1kXHsqZzfJ2qmsrUWEU_XWxmR1PhY3zo-yz9Vau90-WphXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHsqZzfJ2qmsrUWEU_XWxmR1PhY3zo-yz9Vau90-WphXg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 15, 2020 at 01:02:10PM +0300, Ard Biesheuvel wrote:
>
> > I'd rather go for a preemptible/sleepable version of highmem mapping
> > which is in itself consistent for both highmen and not highmem.
> 
> I don't think we need to obsess about highmem, although we should
> obviously take care not to regress its performance unnecessarily. What
> I want to avoid is to burden a brand new subsystem with legacy highmem
> baggage simply because we could not agree on how to avoid that.

I think what Thomas is proposing should address your concerns Ard.
As long as nobody objects to the slight performance degradation on
legacy highmem platforms it should make kmap_atomic just go away on
modern platforms.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
