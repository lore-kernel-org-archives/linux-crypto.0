Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B5FAC433ED
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 11:51:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E848761006
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 11:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352567AbhESLxI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 May 2021 07:53:08 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54256 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229508AbhESLxI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 May 2021 07:53:08 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1ljKjr-0003hD-T1; Wed, 19 May 2021 19:51:47 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ljKjq-0007AF-Ki; Wed, 19 May 2021 19:51:46 +0800
Date:   Wed, 19 May 2021 19:51:46 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Will Deacon <will@kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH v4 2/7] crypto: aead - disallow en/decrypt for non-task
 or non-softirq context
Message-ID: <20210519115146.bmrlfrchmz5tt2e2@gondor.apana.org.au>
References: <20210519112239.33664-1-ardb@kernel.org>
 <20210519112239.33664-3-ardb@kernel.org>
 <20210519112930.sgy3trqczyfok7mn@gondor.apana.org.au>
 <CAMj1kXGsxFzx8XTwhBRma_eSmnAHDZHox9X+SYDn0JYfPBVbYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXGsxFzx8XTwhBRma_eSmnAHDZHox9X+SYDn0JYfPBVbYg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 19, 2021 at 01:36:37PM +0200, Ard Biesheuvel wrote:
> 
> So if we do need to check this, we should check it here. If we don't,
> then we can drop these patches.

Historically other things would break in nasty ways if you tried
to do crypto in hard IRQ contexts, e.g., overwritten kmap slots
back when we had individual slots for each context, but I don't
think we've ever found anyone crazy enough to do that to warrant
a run-time check.

I'd just leave it out for now.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
