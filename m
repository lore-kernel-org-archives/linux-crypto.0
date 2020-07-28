Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 911F8C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 22:13:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 729CD20672
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 22:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729657AbgG1WNE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 18:13:04 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56824 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729567AbgG1WND (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 18:13:03 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k0XqC-0006aE-B0; Wed, 29 Jul 2020 08:12:57 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 29 Jul 2020 08:12:56 +1000
Date:   Wed, 29 Jul 2020 08:12:56 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v3 PATCH 1/31] crypto: skcipher - Add final chunk size field
 for chaining
Message-ID: <20200728221256.GA4298@gondor.apana.org.au>
References: <20200728071746.GA22352@gondor.apana.org.au>
 <E1k0Jsl-0006Ho-Gf@fornost.hmeau.com>
 <20200728171512.GB4053562@gmail.com>
 <20200728172239.GA3539@gondor.apana.org.au>
 <CAMj1kXEGPFeqW2LYCAPHBkR_ruUTnV7AbX7yHgytkRoTfj5Msw@mail.gmail.com>
 <20200728173009.GA3620@gondor.apana.org.au>
 <CAMj1kXE+GsPUfQ0zd9Lc_eb-AQBUVu=OGR4nJsWZ6myOVVT+Ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXE+GsPUfQ0zd9Lc_eb-AQBUVu=OGR4nJsWZ6myOVVT+Ng@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 28, 2020 at 08:46:42PM +0300, Ard Biesheuvel wrote:
>
> > Yes we could add a flag for it.  However, for the two users that
> > I'm looking at right now (algif_skcipher and sunrpc) this is not
> > required.  For algif_skcipher it'll simply fall back to the current
> > behaviour if chaining is not supported, while sunrpc would only
> > use chaining with cts where it is always supported.
> 
> Ok, now I'm confused again: if falling back to the current behavior is
> acceptable for algif_skcipher, why do we need all these changes?

The current behaviour isn't quite the right phrase.  What happens
now is that algif_skcipher will try to chain everything which
would obviously fail with such a driver.  With the patch-set
it won't try to chain and will instead return -EINVAL.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
