Return-Path: <SRS0=pw/0=7L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23328C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 29 May 2020 13:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02C87208B8
	for <linux-crypto@archiver.kernel.org>; Fri, 29 May 2020 13:19:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgE2NT6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 May 2020 09:19:58 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:40796 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726712AbgE2NT6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 May 2020 09:19:58 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jeevR-0006hX-6C; Fri, 29 May 2020 23:19:54 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 May 2020 23:19:53 +1000
Date:   Fri, 29 May 2020 23:19:53 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Stephan Mueller <smueller@chronox.de>
Subject: Re: [RFC/RFT PATCH 0/2] crypto: add CTS output IVs for arm64 and
 testmgr
Message-ID: <20200529131953.GA9187@gondor.apana.org.au>
References: <20200519190211.76855-1-ardb@kernel.org>
 <20200528073349.GA32566@gondor.apana.org.au>
 <CAMj1kXGkvLP1YnDimdLOM6xMXSQKXPKCEBGRCGBRsWKAQR5Stg@mail.gmail.com>
 <20200529080508.GA2880@gondor.apana.org.au>
 <CAMj1kXE43VvEXyYQF=s5HybhF6Wq23wDTrvTfNV9d4fUVZZ8aw@mail.gmail.com>
 <20200529115126.GA3573@gondor.apana.org.au>
 <CAMj1kXFFPKWwwSpLnPmNa_Up1syMb7T5STG7Tw8mRuRqSzc9vw@mail.gmail.com>
 <20200529120216.GA3752@gondor.apana.org.au>
 <CAMj1kXF2-jJ6yGh9m759V2858_c45txoUBgKirvR-4z4GOHUfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXF2-jJ6yGh9m759V2858_c45txoUBgKirvR-4z4GOHUfQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 29, 2020 at 03:10:43PM +0200, Ard Biesheuvel wrote:
>
> OK, so the undocumented assumption is that algif_skcipher requests are
> delineated by ALG_SET_IV commands, and that anything that gets sent to
> the socket in between should be treated as a single request, right? I

Correct.

> think that makes sense, but do note that this deviates from Stephan's
> use case, where the ciphertext stealing block swap was applied after
> every call into af_alg, with the IV being inherited from one request
> to the next. I think that case was invalid to begin with, I just hope
> no other use cases exist where this unspecified behavior is being
> relied upon.

That does indeed sound broken.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
