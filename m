Return-Path: <SRS0=4Aj0=75=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E211C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 11:35:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72D0B207DD
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 11:35:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgFPLfn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Jun 2020 07:35:43 -0400
Received: from 167-179-156-38.a7b39c.bne.nbn.aussiebb.net ([167.179.156.38]:60807
        "EHLO fornost.hmeau.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726526AbgFPLfn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jun 2020 07:35:43 -0400
X-Greylist: delayed 1851 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Jun 2020 07:35:42 EDT
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jl9OW-0006og-Ph; Tue, 16 Jun 2020 21:04:45 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 16 Jun 2020 21:04:44 +1000
Date:   Tue, 16 Jun 2020 21:04:44 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH 0/3] crypto: skcipher - Add support for no chaining
 and partial chaining
Message-ID: <20200616110444.GA31608@gondor.apana.org.au>
References: <20200612120643.GA15724@gondor.apana.org.au>
 <E1jjiTA-0005BO-9n@fornost.hmeau.com>
 <1688262.LSb4nGpegl@tauon.chronox.de>
 <20200612121651.GA15849@gondor.apana.org.au>
 <20200612122105.GA18892@gondor.apana.org.au>
 <CAMj1kXGg25JL7WCrspMwB1PVPX6vx-rOCesg08a_Fy26_ET7Sg@mail.gmail.com>
 <20200615073024.GA27015@gondor.apana.org.au>
 <CAMj1kXHQNHh4PTLmGKaL+sSyuU1AS4u5F=OyjV6XuAaD21e6yg@mail.gmail.com>
 <20200615185028.GB85413@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200615185028.GB85413@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 15, 2020 at 11:50:28AM -0700, Eric Biggers wrote:
>
> Wouldn't it make a lot more sense to make skcipher algorithms non-chainable by
> default, and only opt-in the ones where chaining is actually working?  At the
> moment we only test iv_out for CBC and CTR, so we can expect that all the others
> are broken.

Yes, I'm working through all the algorithms marking them.  If it
turns out that defaulting to off would result in a smaller patch
then I'm certainly going to do that.

> Note that wide-block modes such as Adiantum don't support chaining either.
> 
> Also, please use a better name than "fcsize".

Any suggestions?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
