Return-Path: <SRS0=0bM2=3R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06B38C35240
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 03:39:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D75252173E
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 03:39:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgA1Dj6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jan 2020 22:39:58 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:36748 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbgA1Dj6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jan 2020 22:39:58 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iwHjD-0008N8-4j; Tue, 28 Jan 2020 11:39:51 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iwHho-0004n6-G3; Tue, 28 Jan 2020 11:38:24 +0800
Date:   Tue, 28 Jan 2020 11:38:24 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Miller <davem@davemloft.net>,
        Ofir Drang <Ofir.Drang@arm.com>
Subject: Re: Possible issue with new inauthentic AEAD in extended crypto tests
Message-ID: <20200128033824.p3z3jhc7mp7wlikp@gondor.apana.org.au>
References: <CAOtvUMcwLtwgigFE2mx7LVjhhEgcZsSS4WyR_SQ2gixTZxyBfg@mail.gmail.com>
 <20200128023455.GC960@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200128023455.GC960@sol.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 27, 2020 at 06:34:55PM -0800, Eric Biggers wrote:
>
> My understanding is that all crypto API functions that take scatterlists only
> forbid zero-length scatterlist elements in the part of the scatterlist that's
> actually passed to the API call.  The input to these functions is never simply a
> scatterlist, but rather a (scatterlist, length) pair.  Algorithms shouldn't look
> beyond 'length', so in the case of 'length == 0', they shouldn't look at the
> scatterlist at all -- which may be just a NULL pointer.
> 
> If that's the case, there's no problem with this test code.
> 
> I'm not sure the comment in aead.h is relevant here.  It sounds like it's
> warning about not providing an empty scatterlist element for the AAD when it's
> followed by a nonempty scatterlist element for the plaintext.  I'm not sure it's
> meant to also cover the case where both are empty.
> 
> Herbert and Stephan, any thoughts on what was intended?

I agree.  I think this is a bug in the driver.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
