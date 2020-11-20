Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C446FC5519F
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 10:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 758C722226
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 10:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbgKTKpf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Nov 2020 05:45:35 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:35344 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726529AbgKTKpe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Nov 2020 05:45:34 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kg3v2-0004da-3k; Fri, 20 Nov 2020 21:45:33 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Nov 2020 21:45:32 +1100
Date:   Fri, 20 Nov 2020 21:45:32 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 2/3] crypto: tcrypt - permit tcrypt.ko to be builtin
Message-ID: <20201120104532.GA22420@gondor.apana.org.au>
References: <20201109083143.2884-1-ardb@kernel.org>
 <20201109083143.2884-3-ardb@kernel.org>
 <20201120034440.GA18047@gondor.apana.org.au>
 <CAMj1kXFd1ab2uLbQ7UvL7_+ObLGbfh=p3aRm3GhAvH0tcOYQ5g@mail.gmail.com>
 <20201120100936.GA22225@gondor.apana.org.au>
 <CAMj1kXGu67h96=RvVDRM2z9-N4KcvOLnr6EurjkpbPdZQfh6qw@mail.gmail.com>
 <20201120103750.GA22319@gondor.apana.org.au>
 <CAMj1kXFdhZ8RZp6MQVJ6bgXNoLNr3pfDBkhhVvEGuLFb1xQo3g@mail.gmail.com>
 <20201120104208.GA22365@gondor.apana.org.au>
 <CAMj1kXGKRU0D=oJpLOkSoEVO49dB5xTG7phP30RmMH-=U6rmZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXGKRU0D=oJpLOkSoEVO49dB5xTG7phP30RmMH-=U6rmZQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 20, 2020 at 11:43:40AM +0100, Ard Biesheuvel wrote:
>
> That would be an option, but since we basically already have our own
> local 'EXPERT' option when it comes to crypto testing, I thought I'd
> use that instead.

Well that creates a loop and changing the select into a dependency
may confuse non-expert users who actually want to use this.

So I think using EXPERT is the way to go.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
